import 'package:equatable/equatable.dart';

class ItemEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String category;
  final double price;
  final double discountPercentage;
  final double rating;
  final int stock;
  final List<String> tags;
  final String brand;
  final String sku;
  final int weight;
  final ItemDimensions dimensions;
  final String warrantyInformation;
  final String shippingInformation;
  final String availabilityStatus;
  final List<ItemReview> reviews;
  final String returnPolicy;
  final int minimumOrderQuantity;
  final ItemMeta meta;
  final List<String> images;
  final String thumbnail;

  const ItemEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.price,
    required this.discountPercentage,
    required this.rating,
    required this.stock,
    required this.tags,
    required this.brand,
    required this.sku,
    required this.weight,
    required this.dimensions,
    required this.warrantyInformation,
    required this.shippingInformation,
    required this.availabilityStatus,
    required this.reviews,
    required this.returnPolicy,
    required this.minimumOrderQuantity,
    required this.meta,
    required this.images,
    required this.thumbnail,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    category,
    price,
    discountPercentage,
    rating,
    stock,
    tags,
    brand,
    sku,
    weight,
    dimensions,
    warrantyInformation,
    shippingInformation,
    availabilityStatus,
    reviews,
    returnPolicy,
    minimumOrderQuantity,
    meta,
    images,
    thumbnail,
  ];
}

class ItemDimensions extends Equatable {
  final double width;
  final double height;
  final double depth;

  const ItemDimensions({
    required this.width,
    required this.height,
    required this.depth,
  });

  @override
  List<Object?> get props => [width, height, depth];
}

class ItemReview extends Equatable {
  final int rating;
  final String comment;
  final DateTime date;
  final String reviewerName;
  final String reviewerEmail;

  const ItemReview({
    required this.rating,
    required this.comment,
    required this.date,
    required this.reviewerName,
    required this.reviewerEmail,
  });

  @override
  List<Object?> get props => [
    rating,
    comment,
    date,
    reviewerName,
    reviewerEmail,
  ];
}

class ItemMeta extends Equatable {
  final DateTime createdAt;
  final DateTime updatedAt;
  final String barcode;
  final String qrCode;

  const ItemMeta({
    required this.createdAt,
    required this.updatedAt,
    required this.barcode,
    required this.qrCode,
  });

  @override
  List<Object?> get props => [createdAt, updatedAt, barcode, qrCode];
}

class PageResult<T> extends Equatable {
  final List<T> data;
  final int total;
  final int skip;
  final int limit;
  final bool hasNext;

  const PageResult({
    required this.data,
    required this.total,
    required this.skip,
    required this.limit,
    required this.hasNext,
  });

  @override
  List<Object?> get props => [data, total, skip, limit, hasNext];
}

class CachedSnapshot<T> extends Equatable {
  final List<T> data;
  final DateTime cachedAt;
  final bool isStale;

  const CachedSnapshot({
    required this.data,
    required this.cachedAt,
    required this.isStale,
  });

  @override
  List<Object?> get props => [data, cachedAt, isStale];
}
