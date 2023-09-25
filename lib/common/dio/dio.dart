import 'package:delivery_app/common/const/data.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final FlutterSecureStorage storage;

  CustomInterceptor({required this.storage});

  // 1. 요청
  // 요청이 보내질때마다 요청의 Header에 accessToken : 'true' 라는 값이 있다면
  // 실제 토큰을 가져와서 (storage)에서 'authorization': 'Bearer $token'으로
  // 헤더를 변경
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ] [${options.method}] ${options.uri}');

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

  // 정상적인 응답
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        '[REP] [${response.requestOptions.method}] ${response.requestOptions.uri}');

    // TODO: implement onResponse
    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 401 에러
    // 토큰 재발급 시도하고
    // 토큰 재발급 되면 다시 새로운 토큰으로 요청

    // AccessToken 만료시 RefreshToken으로 재발급
    print('[ERR] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken = await storage.read(key: REFRESH_TOKEN_KEY);

    if (refreshToken == null) {
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    // accessToken을 필요로 한다면
    if (isStatus401 && !isPathRefresh) {
      final dio = Dio();

      // AccessToken 재발급
      try {
        final resp = await dio.post(
          'http://$ip/auth/token',
          options: Options(
            headers: {'authorization': 'Bearer $refreshToken'},
          ),
        );

        // 재발급 받은 AccessToken 등록
        final accessToken = resp.data['accessToken'];

        final options = err.requestOptions;

        options.headers.addAll({'authorization': 'Bearer $accessToken'});

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        final response = await dio.fetch(options);

        return handler.resolve(response);

        // 에러가 발생하더라도 , 요청 성공을 반환
      }
      // Token문제가 아니라면 err
      catch (e) {
        // 에러 반환
        return handler.reject(err);
      }
    }
    return handler.reject(err);
  }
}
