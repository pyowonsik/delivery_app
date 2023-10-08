import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RestaurantRatingNotifier extends StateNotifier<CursorPaginationBase> {
  final RestaurantRatingRepository repository;
  RestaurantRatingNotifier(this.repository) : super(CursorPaginationLoading());
}
