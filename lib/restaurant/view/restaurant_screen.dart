import 'package:delivery_app/common/component/pagination_list_view.dart';
import 'package:delivery_app/restaurant/component/restaurant_card.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/provider/restaurant_provider.dart';
import 'package:delivery_app/restaurant/view/restuarant_detail_screen.dart';
import 'package:flutter/material.dart';

class RestaurantScreen extends StatelessWidget {
  const RestaurantScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PaginationListView<RestaurantModel>(restaurantProvider,
        <RestaurantModel>(context, index, model) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => RestaurantDetailScreen(
                    id: model.id,
                  )));
        },
        child: RestaurantCard.fromModel(
          model: model,
        ),
      );
    });
  }
}
