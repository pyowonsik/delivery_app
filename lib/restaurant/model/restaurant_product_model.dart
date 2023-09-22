import 'package:delivery_app/common/const/data.dart';
import 'package:json_annotation/json_annotation.dart';
part 'restaurant_product_model.g.dart';

@JsonSerializable()
class RestaurantProductModel {
  final String id;
  final String name;
  @JsonKey(fromJson: pathToUrl)
  final String imgUrl;
  final String detail;
  final int price;

  RestaurantProductModel(
      {required this.id,
      required this.name,
      required this.imgUrl,
      required this.detail,
      required this.price});

  factory RestaurantProductModel.fromJson(Map<String, dynamic> json) =>
      _$RestaurantProductModelFromJson(json);

  static pathToUrl(String value) {
    return 'http://$ip$value';
  }

  // factory RestaurantProductModel.fromJson(
  //     {required Map<String, dynamic> json}) {
  //   return RestaurantProductModel(
  //       id: json['id'],
  //       name: json['name'],
  //       imgUrl: 'http://$ip${json['imgUrl']}',
  //       detail: json['detail'],
  //       price: json['price']);
  // }
}
