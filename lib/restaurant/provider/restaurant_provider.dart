import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// part 'restaurant_provider.g.dart';

// @riverpod
// class RestaurantStateNotifier extends _$RestaurantStateNotifier {
//   final RestaurantRepository respository;

//   RestaurantStateNotifier({required this.respository});

//   @override
//   List<RestaurantModel> build() {
//     return [];
//   }

//   paiginate() async {
//     final resp = await respository.paginate();

//     state = resp.data;
//   }
// }

final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, List<RestaurantModel>>(
        (ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(respository: repository);
  return notifier;
});

class RestaurantStateNotifier extends StateNotifier<List<RestaurantModel>> {
  final RestaurantRepository respository;

  RestaurantStateNotifier({required this.respository}) : super([]) {
    // class 생성시 paiginate() 실행
    paiginate();
  }
  paiginate() async {
    final resp = await respository.paginate();

    state = resp.data;
  }
}
