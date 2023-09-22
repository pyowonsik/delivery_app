import 'package:delivery_app/common/const/data.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String thumbUrl;
  final List<String> tags;
  final RestaurantPriceRange priceRange;
  final double ratings;
  final int ratingsCount;
  final int deliveryTime;
  final int deliveryFee;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.thumbUrl,
    required this.tags,
    required this.priceRange,
    required this.ratings,
    required this.ratingsCount,
    required this.deliveryTime,
    required this.deliveryFee,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) =>
      RestaurantModel(
          id: json['id'],
          name: json['name'],
          thumbUrl: 'http://$ip${json['thumbUrl']}',
          tags: List<String>.from(json['tags']),
          priceRange: RestaurantPriceRange.values
              .firstWhere((e) => e.name == json['priceRange']),
          ratings: json['ratings'],
          ratingsCount: json['ratingsCount'],
          deliveryTime: json['deliveryTime'],
          deliveryFee: json['deliveryFee']);
}

enum RestaurantPriceRange { expensive, medium, cheap }
