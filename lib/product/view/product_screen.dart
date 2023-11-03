import 'package:delivery_app/common/component/pagination_list_view.dart';
import 'package:delivery_app/product/component/product_card.dart';
import 'package:delivery_app/product/model/product_model.dart';
import 'package:delivery_app/product/provider/product_provider.dart';
import 'package:delivery_app/restaurant/view/restuarant_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<ProductModel>(
      productProvider,
      <ProductModel>(_, index, model) => GestureDetector(
        child: GestureDetector(
          onTap: () {
            context.goNamed(RestaurantDetailScreen.routeName,
                pathParameters: {'rid': model.restaurant.id 
                });

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => RestaurantDetailScreen(id: model.restaurant.id),
              ),
            );
          },
          child: ProductCard.fromProductModel(
            model: model,
          ),
        ),
      ),
    );
  }
}
