import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/restaurant/model/restaurant_model.dart';
import 'package:delivery_app/restaurant/repository/restaurant_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

final restaurantDetailProvier =
    Provider.family<RestaurantModel?, String>((ref, id) {
  final state = ref.watch(restaurantProvider);

  if (state is! CursorPagination) {
    return null;
  }

  return state.data.firstWhereOrNull((e) => e.id == id);
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
    // 요청 id가 10일때 ???
    // 데이터 없음 -> 에러 발생
    // 데이터가 없을때는 캐시의 끝에다가 데이터를 추가하면된다.
    // [RestaurantModel(1) , RestaurantModel(2) , RestaurantModel(3) ,
    // RestaurantDetailModel(10)]
    // 결론은 , ProductCard 선택시 id가 현재 Restaurant에 없다면 RestaurantDetailModel을 extends 받고 있는
    // ProductModel을 이용해서 state에 강제로 추가한다. -> ProductCard 선택시 RestaurantDetail 가능

    print(state);

    if (pState.data.where((e) => id == e.id).isEmpty) {
      // emit 역할
      state = pState.copyWith(data: <RestaurantModel>[...pState.data, resp]);
    } else {
      // pState.data = pagination() 결과값 -> [RestaurantModel(1) , RestaurantModel(2) , RestaurantModel(3)]
      // getDetail(2);
      // [RestaurantModel(1) , RestaurantDetailModel(2) , RestaurantModel(3)]
      state = pState.copyWith(
          data: pState.data
              .map<RestaurantModel>((e) => e.id == id ? resp : e)
              .toList());
    }
  }
}
