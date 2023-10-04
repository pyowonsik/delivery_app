import 'package:delivery_app/common/const/data.dart';
import 'package:delivery_app/common/dio/dio.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/product/component/product_card.dart';
import 'package:delivery_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:delivery_app/restaurant/model/restaurant_product_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantDetailScreen extends ConsumerWidget {
  final String id;
  const RestaurantDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<RestaurantDetailModel>(
          future: ref
              .watch(restaurantRepositoryProvider)
              .getRestaurantDetail(id: id),
          builder: (_, AsyncSnapshot<RestaurantDetailModel> snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return CustomScrollView(
              slivers: [
                renderTop(model: snapshot.data!),
                renderLabel(),
                renderProduct(products: snapshot.data!.products),
                // rend
              ],
            );
          }),
    );
  }

  SliverToBoxAdapter renderTop({required RestaurantDetailModel model}) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          RestaurantCard(
            image: Image.network(
              model.thumbUrl,
              fit: BoxFit.cover,
            ),
            name: model.name,
            tags: model.tags,
            ratingsCount: model.ratingsCount,
            deliveryTime: model.deliveryTime,
            deliveryFee: model.deliveryFee,
            ratings: model.ratings,
            isDetail: true,
            detail: model.detail,
          ),
        ],
      ),
    );
  }

  renderProduct({required List<RestaurantProductModel> products}) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
        final model = products[index];
        return Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: ProductCard.fromModel(
              model: model,
            ));
      }, childCount: products.length)),
    );
  }

  renderLabel() {
    return const SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverToBoxAdapter(
        child: Text(
          '메뉴',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
