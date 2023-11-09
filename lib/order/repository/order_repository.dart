import 'package:delivery_app/common/const/data.dart';
import 'package:delivery_app/common/dio/dio.dart';
import 'package:delivery_app/order/model/order_model.dart';
import 'package:delivery_app/order/model/post_order_body.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'order_repository.g.dart';

final orderRepositoryProvider = Provider<OrderRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return OrderRepository(dio, baseUrl: 'http://$ip/order');
});

// http://$ip/order
// return Data : OrderModel
// post Data : PostOrderBody
@RestApi()
abstract class OrderRepository {
  factory OrderRepository(Dio dio, {String baseUrl}) = _OrderRepository;
  @POST('/')
  @Headers({'accessToken': 'true'})
  Future<OrderModel> postOrder({
    @Body() required PostOrderBody body,
  });
}
