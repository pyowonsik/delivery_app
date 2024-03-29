import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/model/model_with_id.dart';
import 'package:delivery_app/common/model/pagination_params.dart';
import 'package:delivery_app/common/repository/base_pagination_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Generic을 이용한 공통회 정리 ->
// 공통 Model(IModelWithId)과 Repository(IBasePaginationRepository)를 인터페이스로 생성
// model들은 공통 모델인 IModelWithId를 상속 받게한다.
// 공통 PaginationStateNotifier를 생성할때 제네릭을 이용하여 어떤 타입의 모델인지를
// IModelWithId를 상속 받는 모델을 Generic을 사용하여 구분할수 있게 한다.
// repository는 공통 레포지토리(IBasePaginationRepository)상속 받게 하는데 공통 레포지토리(IBasePaginationRepository)는 어떤 모델의 레포지토리인지 구분을 위하여
// 공통모델을 제네릭을 사용하여 구분한 레포지토리를 상속받는다.
// 공통 PaginationStateNotifier를 이용하여 Provider를 생성한다.

class _PaginationInfo {
  int fetchCount;
  bool fetchMore;
  bool forceRefetch;

  _PaginationInfo(
      {this.fetchCount = 20,
      this.fetchMore = false,
      this.forceRefetch = false});
}

class PaginationStateNotifier<T extends IModelWithId,
        U extends IBasePaginationRepository<T>>
    extends StateNotifier<CursorPaginationBase> {
  final U repository;
  final paginationThrottle = Throttle(const Duration(seconds: 3),
      initialValue: _PaginationInfo(), checkEquality: false);
  PaginationStateNotifier({required this.repository})
      : super(CursorPaginationLoading()) {
    paiginate();

    // paginationThrottle.setValue 실행시 감지되어 _throttlePagination 실행
    paginationThrottle.values.listen((state) {
      _throttlePagination(state);
    });
  }

  Future<void> paiginate({
    int fetchCount = 20,
    // 추가로 데이터 가져오기
    // true - 다음 데이터
    // false - 첫 데이터 새로고침
    bool fetchMore = false,
    // 강제로 다시 로딩
    // true - cursorPaginationLoading()
    bool forceRefetch = false,
  }) async {
    paginationThrottle.setValue(_PaginationInfo(
        fetchCount: fetchCount,
        fetchMore: fetchMore,
        forceRefetch: forceRefetch));
  }

  _throttlePagination(_PaginationInfo info) async {
    try {
      // 1. CursorPagination - 정상적으로 데이터 있는 상태
      // 2. CursorPaginationLoading - 데이터 로딩중
      // 3. CursorPaginationError - 에러
      // 4. CursorPaginationRefetching - 첫번째 페이지부터 데이터를 다시 가져올때
      // 5. CursorPaginationFetchMore - 추가 데이터를 paginate 해오라는 요청

      // 바로 반환되는 상황
      // 1. HasMore가 false 일때 (기존 상태에서 이미 다음 데이터가 없다는 값을 들고있다면)
      // 2. 로딩중 = fetchMoreㄴㅅ : true
      //    fetchMore가 아닐때 -> 새로고침 의도가 있을수 있다.

      // 첫번째 요청후 재요청 없이 그냥 반환 -> 처음 pagination이 되면 더이상 하지않는다.
      // 1번 반환 상황
      // 기본값 fetchMore == false , 데이터를 가져왔지만 새로고침을 하지않을경우 데이터를 더 가져오지 않을때에는 반환을 해야한다.
      if (state is CursorPagination && info.forceRefetch == false) {
        // 강제적 가정을 해야 state의 meta , data 접근 가능
        final pState = state as CursorPagination;

        if (pState.meta.hasMore == false) {
          return;
        }
      }

      final isLoading = state is CursorPaginationLoading;
      final isRefetching = state is CursorPaginationRefetching;
      final isFetchingMore = state is CursorPaginationFetchingMore;

      // 2번 반환 상황
      // fetchMore == true , 추가데이터를 요청했는데 상태가 로딩 상태일경우(데이터 요청) 중복으로 데이터를 가져올수 있으니 , 로딩상태일때는 즉각 반환을 해야한다.
      if (info.fetchMore && (isLoading || isRefetching || isFetchingMore)) {
        return;
      }

      // ------------------------------------------------------------------------- //
      // 재요청을 위해 paginationParams 생성
      PaginationParams paginationParams = PaginationParams(
        count: info.fetchCount,
      );

      // fetchMore == true , 첫번째 요청후 데이터를 추가로 가져오는 상황
      // 새로운 데이터를 가져오는 상황
      if (info.fetchMore) {
        final pState = state as CursorPagination<T>;

        // 중복으로 데이터를 가져올수 있으니 , state를 CursorPaginationFetchingMore 상태로 바꿔줘서 반환이 되게 하고
        state =
            CursorPaginationFetchingMore(meta: pState.meta, data: pState.data);

        // 더 가져오려면 마지막 데이터의 id가 필요 paginationParams에 id 바꿔줌
        paginationParams =
            paginationParams.copyWith(after: pState.data.last.id);
      }

      // fetchMore이 아닌경우에는 paginationParams를 건들지 않기때문에 초기 상태만 상황에맞게 변경하면됨.
      // 데이터를 처음 부터 가져오는 상황
      else {
        // 만약 데이터가 있는 상황이라면
        // 기존 데이터를 보존한채로 Fetch(API 요청)을 진행
        if (state is CursorPagination && !info.forceRefetch) {
          final pState = state as CursorPagination;
          state =
              CursorPaginationRefetching(meta: pState.meta, data: pState.data);
        } else {
          state = CursorPaginationLoading();
        }
      }

      // 변경된 paginationParams,상태를 이용해서 paginate후 데이터 변경
      final resp =
          await repository.paginate(paginationParams: paginationParams);

      if (state is CursorPaginationFetchingMore) {
        final pState = state as CursorPaginationFetchingMore;

        // 기존 데이터에
        // 새로운 데이터 추가하여 반환
        state = resp.copyWith(data: [...pState.data, ...resp.data]);
      } else {
        state = resp;
      }
    } catch (e) {
      state = CursorPaginationError(message: '데이터를 가져오지 못했습니다.');
    }
  }
}
