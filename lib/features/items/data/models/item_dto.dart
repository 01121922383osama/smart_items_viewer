import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/item_entity.dart';

part 'item_dto.g.dart';

@JsonSerializable()
class ItemDTO {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  @JsonKey(name: 'discountPercentage')
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String? brand;
  final String? sku;
  final int? weight;
  final ItemDimensionsDTO? dimensions;
  @JsonKey(name: 'warrantyInformation')
  final String? warrantyInformation;
  @JsonKey(name: 'shippingInformation')
  final String? shippingInformation;
  @JsonKey(name: 'availabilityStatus')
  final String? availabilityStatus;
  final List<ItemReviewDTO> reviews;
  @JsonKey(name: 'returnPolicy')
  final String? returnPolicy;
  @JsonKey(name: 'minimumOrderQuantity')
  final int? minimumOrderQuantity;
  final ItemMetaDTO? meta;
  final List<String> images;
  final String? thumbnail;

  const ItemDTO({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    this.brand,
    this.sku,
    this.weight,
    this.dimensions,
    this.warrantyInformation,
    this.shippingInformation,
    this.availabilityStatus,
    required this.reviews,
    this.returnPolicy,
    this.minimumOrderQuantity,
    this.meta,
    required this.images,
    this.thumbnail,
  });

  factory ItemDTO.fromJson(Map<String, dynamic> json) =>
      _$ItemDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ItemDTOToJson(this);

  ItemEntity toEntity() {
    return ItemEntity(
      id: id,
      title: title,
      description: description,
      category: category,
      price: price,
      discountPercentage: discountPercentage,
      rating: rating,
      stock: stock,
      tags: tags,
      brand: brand ?? '',
      sku: sku ?? '',
      weight: weight ?? 0,
      dimensions:
          dimensions?.toEntity() ??
          const ItemDimensions(width: 0, height: 0, depth: 0),
      warrantyInformation: warrantyInformation ?? '',
      shippingInformation: shippingInformation ?? '',
      availabilityStatus: availabilityStatus ?? '',
      reviews: reviews.map((review) => review.toEntity()).toList(),
      returnPolicy: returnPolicy ?? '',
      minimumOrderQuantity: minimumOrderQuantity ?? 0,
      meta:
          meta?.toEntity() ??
          ItemMeta(
            createdAt: DateTime(1970, 1, 1),
            updatedAt: DateTime(1970, 1, 1),
            barcode: '',
            qrCode: '',
          ),
      images: images,
      thumbnail: thumbnail ?? '',
    );
  }
}

@JsonSerializable()
class ItemDimensionsDTO {
  final double? width;
  final double? height;
  final double? depth;

  const ItemDimensionsDTO({this.width, this.height, this.depth});

  factory ItemDimensionsDTO.fromJson(Map<String, dynamic> json) =>
      _$ItemDimensionsDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ItemDimensionsDTOToJson(this);

  ItemDimensions toEntity() {
    return ItemDimensions(
      width: width ?? 0.0,
      height: height ?? 0.0,
      depth: depth ?? 0.0,
    );
  }
}

@JsonSerializable()
class ItemReviewDTO {
  final int rating;
  final String comment;
  final DateTime date;
  @JsonKey(name: 'reviewerName')
  final String reviewerName;
  @JsonKey(name: 'reviewerEmail')
  final String reviewerEmail;

  const ItemReviewDTO({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  factory ItemReviewDTO.fromJson(Map<String, dynamic> json) =>
      _$ItemReviewDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ItemReviewDTOToJson(this);

  ItemReview toEntity() {
    return ItemReview(
      rating: rating,
      comment: comment,
      date: date,
      reviewerName: reviewerName,
      reviewerEmail: reviewerEmail,
    );
  }
}

@JsonSerializable()
class ItemMetaDTO {
  @JsonKey(name: 'createdAt')
  final DateTime? createdAt;
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  final String? barcode;
  @JsonKey(name: 'qrCode')
  final String? qrCode;

  const ItemMetaDTO({
    this.createdAt,
    this.updatedAt,
    this.barcode,
    this.qrCode,
  });

  factory ItemMetaDTO.fromJson(Map<String, dynamic> json) =>
      _$ItemMetaDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ItemMetaDTOToJson(this);

  ItemMeta toEntity() {
    return ItemMeta(
      createdAt: createdAt ?? DateTime(1970),
      updatedAt: updatedAt ?? DateTime(1970),
      barcode: barcode ?? '',
      qrCode: qrCode ?? '',
    );
  }
}

@JsonSerializable()
class ItemsResponseDTO {
  final List<ItemDTO> products;
  final int total;
  final int skip;
  final int limit;

  const ItemsResponseDTO({
    required this.products,
    required this.total,
    required this.skip,
    required this.limit,
  });

  factory ItemsResponseDTO.fromJson(Map<String, dynamic> json) =>
      _$ItemsResponseDTOFromJson(json);
  Map<String, dynamic> toJson() => _$ItemsResponseDTOToJson(this);

  PageResult<ItemEntity> toEntity() {
    return PageResult<ItemEntity>(
      data: products.map((product) => product.toEntity()).toList(),
      total: total,
      skip: skip,
      limit: limit,
      hasNext: skip + products.length < total,
    );
  }
}
