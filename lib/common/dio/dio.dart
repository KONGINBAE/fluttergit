//intercept 요청보낼시 , 응답받을떄 , 에러가 났을떄

import 'package:actual/common/const/data.dart';
import 'package:actual/common/secure_storage/secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


final dioProvider = Provider<Dio>((ref) {
    final dio = Dio();
    final storage = ref.watch(secureStorageProvider);

  dio.interceptors.add(
    CustomInterceptor(storage: storage)
  );

  return dio;
});

class CustomInterceptor extends Interceptor{
  final FlutterSecureStorage storage;

  CustomInterceptor({
    required this.storage,
});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    print('[REQ[${options.method}]] ${options.uri}');

    if (options.headers['accessToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('accessToken');

      final token = await storage.read(key: ACCESS_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    if (options.headers['refreshToken'] == 'true') {
      // 헤더 삭제
      options.headers.remove('refreshToken');

      final token = await storage.read(key: REFRESH_TOKEN_KEY);

      // 실제 토큰으로 대체
      options.headers.addAll({
        'authorization': 'Bearer $token',
      });
    }

    // TODO: implement onRequest
    return super.onRequest(options, handler);
  }
 @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {

   print('[RES][${response.requestOptions.method}] ${response.requestOptions.uri}');

       return super.onResponse(response, handler);
  }
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO: implement onError

    print('[err] [${err.requestOptions.method}] ${err.requestOptions.uri}');

    final refreshToken =await storage.read(key: REFRESH_TOKEN_KEY);

    //refreshtoken이 없으면 에러를 일으킨다.
    if(refreshToken == null){
      return handler.reject(err);
    }

    final isStatus401 = err.response?.statusCode == 401;
    final isPathRefresh = err.requestOptions.path == '/auth/token';

    if(isStatus401 && !isPathRefresh){
      final dio =Dio();

      try{
        final resp = await dio.post(
            'http://$ip/auth/token', options: Options(
            headers: {
              'authorization' :'Bearer $refreshToken '
            }),);
        final accessToken = resp.data['accessToken'];
        final options = err.requestOptions;

        options.headers.addAll({
          'authorization':'Bearer $accessToken'
        });

        await storage.write(key: ACCESS_TOKEN_KEY, value: accessToken);

        final response= await dio.fetch(options);
        return handler.resolve(response);
      } on DioError catch(e){
        return handler.reject(err);
      }


    }

   // return handler.resolve(response);
   // return super.onError(err, handler);
  }

}