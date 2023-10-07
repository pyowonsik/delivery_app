import 'package:delivery_app/common/const/data.dart';
import 'package:delivery_app/common/utils/data_utils.dart';
import 'package:json_annotation/json_annotation.dart';

part 'restaurant_model.g.dart';

enum RestaurantPriceRange { expensive, medium, cheap }

// api요청을 통해 imgUrl을 받게될경우 img/test.png 이렇게 받는다. 이렇게 온 networkImage를 사용하려면
// http://127.0.0.1:3000/img/test.png로 바꿔줘야 한다. 그렇기 때문에 fromJson을 해주게되면 DataUtils의 pathToUrl함수 호출하여 ‘http://$ip $value’ 로 변환하여 해주어야한다.
@JsonSerializable()
class RestaurantModel {
  final String id;
  final String name;
  @JsonKey(fromJson: DataUtils.pathToUrl)
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
      _$RestaurantModelFromJson(json);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}
