import 'package:delivery_app/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  // 1. 요청
  // 요청이 보내질때마다 요청의 Header에 accessToken : true라는 값이 있다면
  // 실제 토큰을 가져와서 (storage)에서  authorization': 'Bearer $token으로
  // 헤더를 변경
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');
    print(options.headers);

    // print(options.headers['accessToken']);

    // 보내려는 요청의 헤더
    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      // 실제 토큰 대체
      final token = await storage.read(key: ACCESS_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    // 보내려는 요청의 헤더
    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      // 실제 토큰 대체
      final token = await storage.read(key: REFRESH_TOKEN_KEY);
      options.headers.addAll({'authorization': 'Bearer $token'});
    }

    // TODO: implement onRequest
    return super.onRequest(options, handler);
  }
}
