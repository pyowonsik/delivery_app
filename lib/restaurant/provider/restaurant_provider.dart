import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/model/pagination_params.dart';
import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final restaurantDetailProvier =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhere((e) => e.id == id);
});

// repository에서 api통신을 해서 db와 통신 (요청을 보내거나 받으면서 데이터를 저장하거나 전송)
// providerd에서는 repository를 통해 받은 데이터를 provider에 저장 하거나
// 요청을 보내기 위해 repository에 데이터 전송
// view에서 provider를 생성해서 ui그림.
final restaurantProvider =
    StateNotifierProvider<RestaurantStateNotifier, CursorPaginationBase>((ref) {
  final repository = ref.watch(restaurantRepositoryProvider);
  final notifier = RestaurantStateNotifier(repository: repository);
  return notifier;
});

class RestaurantStateNotifier
    extends PaginationStateNotifier<RestaurantModel, RestaurantRepository> {
  RestaurantStateNotifier({required super.repository});

  // RestaurantModel -> RestaurantDetailModel
  void getDetail({required String id}) async {
    // 만약 데이터가 하나도 없는 상태
    if (state is! CursorPagination) {
      await paiginate();
    }

    // state가 CursorPagination이 아닐때
    if (state is! CursorPagination) {
      return;
    }

    final pState = state as CursorPagination;

    final resp = await repository.getRestaurantDetail(id: id);

    // pState.data = pagination() 결과값 -> [RestaurantModel(1) , RestaurantModel(2) , RestaurantModel(3)]
    // getDetail(2);
    // [RestaurantModel(1) , RestaurantDetailModel(2) , RestaurantModel(3)]
    state = pState.copyWith(
        data: pState.data
            .map<RestaurantModel>((e) => e.id == id ? resp : e)
            .toList());
  }
}
