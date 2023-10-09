import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/rating/model/rating_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_rating_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantRatingProvider = StateNotifierProvider.family<
    RestaurantRatingNotifier, CursorPaginationBase, String>((ref, id) {
  final repo = ref.watch(restaurantRatingRepositoryProvider(id));

  return RestaurantRatingNotifier(repository: repo);
});

// RatingModel은 ModelWithId를 impliment 하고 ,
// RestaurantRatingRepository는 IBasePaginationRepository를 impliment한다.
class RestaurantRatingNotifier
    extends PaginationStateNotifier<RatingModel, RestaurantRatingRepository> {
  RestaurantRatingNotifier({required super.repository});
}
