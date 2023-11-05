import 'package:delivery_app/common/const/colors.dart';
import 'package:delivery_app/product/model/product_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_product_model.dart';
import 'package:delivery_app/user/provider/basket_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductCard extends ConsumerWidget {
  final Image image;
  final String id;
  final String name;
  final String detail;
  final int price;
  final VoidCallback? onSubtract;
  final VoidCallback? onAdd;

  const ProductCard(
      {super.key,
      required this.image,
      required this.id,
      required this.name,
      required this.detail,
      required this.price,
      this.onSubtract,
      this.onAdd});

  factory ProductCard.fromProductModel(
          {required ProductModel model,
          VoidCallback? onSubtract,
          VoidCallback? onAdd}) =>
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
        price: model.price,
        onSubtract: onSubtract,
        onAdd: onAdd,
      );

  factory ProductCard.fromRestaurantProdcutModel(
          {required RestaurantProductModel model,
          VoidCallback? onSubtract,
          VoidCallback? onAdd}) =>
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
        price: model.price,
        onSubtract: onSubtract,
        onAdd: onAdd,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basket = ref.watch(basketProvider);
    return Column(
      children: [
        IntrinsicHeight(
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
                      style: const TextStyle(
                          fontSize: 14.0, color: BODY_TEXT_COLOR),
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
                ),
              ),
            ],
          ),
        ),
        if (onSubtract != null && onAdd != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: _Footer(
                total: (basket.firstWhere((e) => e.product.id == id).count *
                        basket
                            .firstWhere((e) => e.product.id == id)
                            .product
                            .price)
                    .toString(),
                count: basket.firstWhere((e) => e.product.id == id).count,
                onSubtract: onSubtract!,
                onAdd: onAdd!),
          )
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  final String total;
  final int count;
  final VoidCallback onSubtract;
  final VoidCallback onAdd;
  const _Footer(
      {super.key,
      required this.total,
      required this.count,
      required this.onSubtract,
      required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            '총액 : ₩$total',
            style: const TextStyle(
                color: PRIMARY_COLOR, fontWeight: FontWeight.w500),
          ),
        ),
        Row(
          children: [
            renderButton(icon: Icons.remove, onTap: onSubtract),
            const SizedBox(
              width: 8.0,
            ),
            Text(
              count.toString(),
              style: const TextStyle(
                  color: PRIMARY_COLOR, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 8.0,
            ),
            renderButton(icon: Icons.add, onTap: onAdd)
          ],
        ),
      ],
    );
  }

  Widget renderButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: PRIMARY_COLOR, width: 1.0),
      ),
      child: InkWell(
        onTap: onTap,
        child: Icon(
          icon,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
