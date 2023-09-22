import 'package:delivery_app/common/const/data.dart';
import 'package:delivery_app/common/layout/default_layout.dart';
import 'package:delivery_app/product/component/product_card.dart';
import 'package:delivery_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class RestaurantDetailScreen extends StatelessWidget {
  final String id;
  const RestaurantDetailScreen({super.key, required this.id});

  Future<Map<String, dynamic>> getRestaurantDetail() async {
    final dio = Dio();

    final accessToken = await storage.read(key: ACCESS_TOKEN_KEY);

    final resp = await dio.get('http://$ip/restaurant/$id',
        options: Options(headers: {'authorization': 'Bearer $accessToken'}));
    return resp.data;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '불타는 떡볶이',
      child: FutureBuilder<Map<String, dynamic>>(
          future: getRestaurantDetail(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            final item = RestaurantDetailModel.fromJson(json: snapshot.data!);

            return CustomScrollView(
              slivers: [
                renderTop(model: item),
                renderLabel(),
                renderProduct(products: item.products),
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
