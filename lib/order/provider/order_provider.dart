import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/order/model/order_model.dart';
import 'package:delivery_app/order/model/post_order_body.dart';
import 'package:delivery_app/order/repository/order_repository.dart';
import 'package:delivery_app/user/provider/basket_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

final orderProvider =
    StateNotifierProvider<OrderStateNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(orderRepositoryProvider);
  return OrderStateNotifier(ref: ref, repository: repo);
});

class OrderStateNotifier
    extends PaginationStateNotifier<OrderModel, OrderRepository> {
  final Ref ref;

  OrderStateNotifier({required this.ref, required super.repository}) : super();

  // api 정의서를 보고
  // http://$ip/order repository의 postOrder요청을 위해 == repository(retrofit)의 함수를 구현하기 위해
  // post Data : postOrderBody 구성
  // return Data : orderModel
  Future<bool> postOrder() async {
    try {
      final uuid = Uuid();

      final id = uuid.v4();
      final state = ref.watch(basketProvider);

      final resp = await repository.postOrder(
        body: PostOrderBody(
          id: id,
          products: state
              .map((e) =>
                  PostOrderBodyProduct(productId: e.product.id, count: e.count))
              .toList(),
          totalPrice:
              state.fold<int>(0, (p, n) => p + (n.count * n.product.price)),
          createdAt: DateTime.now().toString(),
        ),
      );
      return true;
    } catch (e) {
      return false;
    }
  }
}
