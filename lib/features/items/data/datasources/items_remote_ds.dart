import 'package:dio/dio.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/network/connectivity_guard.dart';
import '../../../../core/utils/pagination_utils.dart';
import '../models/item_dto.dart';

abstract class ItemsRemoteDataSource {
  Future<ItemsResponseDTO> getItemsPage({
    required int page,
    required int limit,
  });
}

class ItemsRemoteDataSourceImpl implements ItemsRemoteDataSource {
  final Dio _dio;
  final ConnectivityGuard _connectivityGuard;

  ItemsRemoteDataSourceImpl({
    required Dio dio,
    required ConnectivityGuard connectivityGuard,
  }) : _dio = dio,
       _connectivityGuard = connectivityGuard;

  @override
  Future<ItemsResponseDTO> getItemsPage({
    required int page,
    required int limit,
  }) async {
    try {
      await _connectivityGuard.ensureConnectivity();

      final skip = PaginationUtils.calculateSkip(page, limit);

      final response = await _dio.get(
        'https://dummyjson.com/products',
        queryParameters: {'limit': limit, 'skip': skip},
        options: Options(responseType: ResponseType.json),
      );

      if (response.statusCode == 200) {
        return ItemsResponseDTO.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Failed to fetch items: ${response.statusCode}',
          code: response.statusCode.toString(),
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw NetworkException(
          message: 'Connection timeout. Please check your internet connection.',
          code: 'TIMEOUT',
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw NetworkException(
          message: 'No internet connection available.',
          code: 'NO_CONNECTION',
        );
      } else if (e.response?.statusCode != null) {
        throw ServerException(
          message: 'Server error: ${e.response?.statusCode}',
          code: e.response?.statusCode.toString(),
        );
      } else {
        throw NetworkException(
          message: 'Network error: ${e.message}',
          code: 'NETWORK_ERROR',
        );
      }
    } catch (e) {
      if (e is ServerException || e is NetworkException) {
        rethrow;
      } else {
        throw ServerException(
          message: 'Unexpected error: ${e.toString()}',
          code: 'UNEXPECTED',
        );
      }
    }
  }
}
