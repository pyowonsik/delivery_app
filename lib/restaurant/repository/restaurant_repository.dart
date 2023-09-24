import 'package:delivery_app/restaurant/model/restaurant_detail_model.dart';
import 'package:dio/dio.dart' hide Headers;
import 'package:retrofit/retrofit.dart';

part 'restaurant_repository.g.dart';

@RestApi()
abstract class RestaurantRepository {
  factory RestaurantRepository(Dio dio, {String baseUrl}) =
      _RestaurantRepository;

  @GET("/{id}")
  @Headers({'accessToken': 'true'}) // 'true'를 문자열로 설정
  Future<RestaurantDetailModel> getRestaurantDetail({
    @Path() required String id,
  });
}
