import 'package:hive/hive.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/utils/time.dart';
import '../../domain/entities/item_entity.dart';

abstract class ItemsLocalDataSource {
  Future<void> cachePage({
    required int page,
    required List<ItemEntity> items,
    required DateTime fetchedAt,
  });

  Future<CachedSnapshot<ItemEntity>?> readCachedSnapshot();

  Future<void> clearCache();

  Future<bool> hasCachedData();

  Future<List<ItemEntity>?> getCachedPage(int page);
}

class ItemsLocalDataSourceImpl implements ItemsLocalDataSource {
  static const String _snapshotKey = 'all_items_snapshot';
  static const String _pagePrefix = 'page_';

  final Box<Map> _box;

  ItemsLocalDataSourceImpl({required Box<Map> box}) : _box = box;

  @override
  Future<void> cachePage({
    required int page,
    required List<ItemEntity> items,
    required DateTime fetchedAt,
  }) async {
    try {
      final pageKey = '$_pagePrefix$page';
      final itemsJson = items.map((item) => _entityToJson(item)).toList();

      await _box.put(pageKey, {
        'items': itemsJson,
        'fetchedAt': TimeUtils.toIsoString(fetchedAt),
      });

      await _updateSnapshot(items, fetchedAt);
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache page $page: ${e.toString()}',
        code: 'CACHE_WRITE_ERROR',
      );
    }
  }

  @override
  Future<CachedSnapshot<ItemEntity>?> readCachedSnapshot() async {
    try {
      final snapshotData = _box.get(_snapshotKey);
      if (snapshotData == null) return null;

      final itemsJson = snapshotData['items'] as List<dynamic>?;
      final fetchedAtStr = snapshotData['fetchedAt'] as String?;

      if (itemsJson == null || fetchedAtStr == null) return null;

      final fetchedAt = TimeUtils.fromIsoString(fetchedAtStr);
      if (fetchedAt == null) return null;

      final items = itemsJson
          .map((json) => _jsonToEntity(Map<String, dynamic>.from(json as Map)))
          .toList();

      final isStale = TimeUtils.isCacheExpired(fetchedAt);

      return CachedSnapshot<ItemEntity>(
        data: items,
        cachedAt: fetchedAt,
        isStale: isStale,
      );
    } catch (e) {
      throw CacheException(
        message: 'Failed to read cached snapshot: ${e.toString()}',
        code: 'CACHE_READ_ERROR',
      );
    }
  }

  @override
  Future<void> clearCache() async {
    try {
      await _box.clear();
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear cache: ${e.toString()}',
        code: 'CACHE_CLEAR_ERROR',
      );
    }
  }

  @override
  Future<bool> hasCachedData() async {
    try {
      return _box.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<List<ItemEntity>?> getCachedPage(int page) async {
    try {
      final pageKey = '$_pagePrefix$page';
      final pageData = _box.get(pageKey);

      if (pageData == null) return null;

      final itemsJson = pageData['items'] as List<dynamic>?;
      if (itemsJson == null) return null;

      return itemsJson
          .map((json) => _jsonToEntity(Map<String, dynamic>.from(json as Map)))
          .toList();
    } catch (e) {
      return null;
    }
  }

  Future<void> _updateSnapshot(
    List<ItemEntity> items,
    DateTime fetchedAt,
  ) async {
    final itemsJson = items.map((item) => _entityToJson(item)).toList();

    await _box.put(_snapshotKey, {
      'items': itemsJson,
      'fetchedAt': TimeUtils.toIsoString(fetchedAt),
    });
  }

  Map<String, dynamic> _entityToJson(ItemEntity entity) {
    return {
      'id': entity.id,
      'title': entity.title,
      'description': entity.description,
      'category': entity.category,
      'price': entity.price,
      'discountPercentage': entity.discountPercentage,
      'rating': entity.rating,
      'stock': entity.stock,
      'tags': entity.tags,
      'brand': entity.brand,
      'sku': entity.sku,
      'weight': entity.weight,
      'dimensions': {
        'width': entity.dimensions.width,
        'height': entity.dimensions.height,
        'depth': entity.dimensions.depth,
      },
      'warrantyInformation': entity.warrantyInformation,
      'shippingInformation': entity.shippingInformation,
      'availabilityStatus': entity.availabilityStatus,
      'reviews': entity.reviews
          .map(
            (review) => {
              'rating': review.rating,
              'comment': review.comment,
              'date': review.date.toIso8601String(),
              'reviewerName': review.reviewerName,
              'reviewerEmail': review.reviewerEmail,
            },
          )
          .toList(),
      'returnPolicy': entity.returnPolicy,
      'minimumOrderQuantity': entity.minimumOrderQuantity,
      'meta': {
        'createdAt': entity.meta.createdAt.toIso8601String(),
        'updatedAt': entity.meta.updatedAt.toIso8601String(),
        'barcode': entity.meta.barcode,
        'qrCode': entity.meta.qrCode,
      },
      'images': entity.images,
      'thumbnail': entity.thumbnail,
    };
  }

  ItemEntity _jsonToEntity(Map<String, dynamic> json) {
    return ItemEntity(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      price: (json['price'] as num).toDouble(),
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      rating: (json['rating'] as num).toDouble(),
      stock: json['stock'] as int,
      tags: List<String>.from(json['tags'] as List),
      brand: json['brand'] as String,
      sku: json['sku'] as String,
      weight: json['weight'] as int,
      dimensions: ItemDimensions(
        width: ((json['dimensions'] as Map)['width'] as num).toDouble(),
        height: ((json['dimensions'] as Map)['height'] as num).toDouble(),
        depth: ((json['dimensions'] as Map)['depth'] as num).toDouble(),
      ),
      warrantyInformation: json['warrantyInformation'] as String,
      shippingInformation: json['shippingInformation'] as String,
      availabilityStatus: json['availabilityStatus'] as String,
      reviews: (json['reviews'] as List)
          .map(
            (review) => ItemReview(
              rating: (review as Map)['rating'] as int,
              comment: (review)['comment'] as String,
              date: DateTime.parse((review)['date'] as String),
              reviewerName: (review)['reviewerName'] as String,
              reviewerEmail: (review)['reviewerEmail'] as String,
            ),
          )
          .toList(),
      returnPolicy: json['returnPolicy'] as String,
      minimumOrderQuantity: json['minimumOrderQuantity'] as int,
      meta: ItemMeta(
        createdAt: DateTime.parse((json['meta'] as Map)['createdAt'] as String),
        updatedAt: DateTime.parse((json['meta'] as Map)['updatedAt'] as String),
        barcode: (json['meta'] as Map)['barcode'] as String,
        qrCode: (json['meta'] as Map)['qrCode'] as String,
      ),
      images: List<String>.from(json['images'] as List),
      thumbnail: json['thumbnail'] as String,
    );
  }
}
