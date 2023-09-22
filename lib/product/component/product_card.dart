import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_product_model.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Image image;
  final String id;
  final String name;
  final String detail;
  final int price;

  const ProductCard(
      {super.key,
      required this.image,
      required this.id,
      required this.name,
      required this.detail,
      required this.price});

  factory ProductCard.fromModel({required RestaurantProductModel model}) =>
      ProductCard(
          image: Image.network(
            model.imgUrl,
            width: 110,
            height: 110,
            fit: BoxFit.cover,
          ),
          id: model.id,
          name: model.name,
          detail: model.detail,
          price: model.price);

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(8.0), child: image),
          const SizedBox(width: 16.0),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              Text(
                detail,
                style: const TextStyle(fontSize: 14.0, color: BODY_TEXT_COLOR),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                '₩ $price',
                style: const TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: PRIMARY_COLOR),
              ),
            ],
          )),
        ],
      ),
    );
  }
}
