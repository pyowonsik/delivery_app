import 'package:json_annotation/json_annotation.dart';

part 'patch_basket_body.g.dart';

@JsonSerializable()
class PatchBasketBody {
  final List<PatchBasketBodyBasket> basket;
  PatchBasketBody({required this.basket});

  Map<String, dynamic> toJson() => _$PatchBasketBodyToJson(this);
}

@JsonSerializable()
class PatchBasketBodyBasket {
  final String productId;
  final int count;
  PatchBasketBodyBasket({required this.productId, required this.count});

  factory PatchBasketBodyBasket.fromJson(Map<String, dynamic> json) =>
      _$PatchBasketBodyBasketFromJson(json);

  // api로 부터 데이터를 받을경우 fromJson (Get)
  // api로 데이터를 전달할 경우 toJson (Post,Fetch )
  Map<String, dynamic> toJson() => _$PatchBasketBodyBasketToJson(this);
}
