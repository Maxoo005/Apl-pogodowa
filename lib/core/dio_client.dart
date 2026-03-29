import "package:dio/dio.dart";
import "api_paths.dart";

Dio buildDio(){
  final dio = Dio(BaseOptions(
    baseUrl: ApiPaths.baseUrl,
    headers: const{
      "Accept": "application/json",
      "Content-Type": "application/json",
    },

    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 15),
    sendTimeout: const Duration(seconds: 15),
    validateStatus: (s) => s != null && s < 500,
  ));

  dio.interceptors.add(LogInterceptor(
    request: true,
    requestBody: true,
    responseBody: true,
    responseHeader: false,
  ));

  return dio;
}
