// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:dio_client_handler/dio_client_handler.dart';
import 'package:flutter/material.dart';

class DioClientHandler {
  static final DioClientHandler _instance = DioClientHandler._internal();

  factory DioClientHandler() => _instance;

  late Dio dio;
  CancelToken cancelToken = CancelToken();

  DioClientHandler._internal() {
    BaseOptions options = BaseOptions(
      baseUrl: DioConstants.BASE,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {},
      contentType: 'application/json; charset=utf-8',
    );

    dio = Dio(options);

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // debugPrint('\n');
          // debugPrint('<--------------------------------->');
          // debugPrint('Request:');
          // debugPrint('Method: ${options.method}');
          // debugPrint('URI: ${options.uri}');
          // debugPrint('Headers: ${options.headers}');
          // debugPrint('Data: ${options.data}');
          // debugPrint('<--------------------------------->');
          // debugPrint('\n');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // debugPrint(' ');
          // debugPrint('<--------------------------------->');
          // debugPrint('Response:');
          // debugPrint('Status Code: ${response.statusCode}');
          // debugPrint('Headers: ${response.headers}');
          // debugPrint('Data: ${response.data}');
          // debugPrint('<--------------------------------->');
          // debugPrint(' ');
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          debugPrint('CODE: ${e.response?.statusCode}');
          debugPrint('CODE: ${e.response?.statusMessage}');
          // Do something with response error
          ErrorEntity eInfo = createErrorEntity(e);
          debugPrint('CODE: ${eInfo.code}');
          // override statusMessage
          e.response?.statusMessage = eInfo.message;
          switch (eInfo.code) {
            case 401: // No permission to log in again
              // navigateToLoginScreen();
              // setLoginStatus(false);
              break;
            default:
          }
          return handler.next(e); //continue
          // If you want to complete the request and return some custom data, you can resolve a `Response`, such as `handler.resolve(response)`.
          // In this way, the request will be terminated, the upper then will be called, and the data returned in then will be your custom response.
        },
      ),
    );
  }

  /*
    + Error unified processing
    */
  // error message
  ErrorEntity createErrorEntity(DioError error) {
    debugPrint('error response => ${error.response}');
    debugPrint('error response => ${error.type}');

    String? errorMessage;

    if (error.response?.data.containsKey('error')) {
      errorMessage = error.response?.data['error'];
    } else if (error.response?.data.containsKey('errors')) {
      errorMessage = error.response?.data['errors'][0];
    }

    switch (error.type) {
      case DioErrorType.cancel:
        return ErrorEntity(code: -1, message: 'Request cancellation');
      case DioErrorType.connectionTimeout:
        return ErrorEntity(code: -1, message: 'Connection timed out');
      case DioErrorType.sendTimeout:
        return ErrorEntity(code: -1, message: 'Request timed out');
      case DioErrorType.receiveTimeout:
        return ErrorEntity(code: -1, message: 'Response timeout');
      // case DioErrorType.badResponse:
      // return ErrorEntity(code: -1, message: errorMessage ?? 'Response bad request');
      case DioErrorType.badResponse:
        {
          try {
            int? errCode = error.response?.statusCode;
            switch (errCode) {
              case 400:
                return ErrorEntity(
                  code: errCode,
                  message: errorMessage ?? 'Request syntax error',
                );
              case 401:
                return ErrorEntity(
                  code: errCode,
                  message: errorMessage ?? 'Permission denied',
                );
              case 403:
                return ErrorEntity(
                  code: errCode,
                  message: errorMessage ?? 'Server refused to execute',
                );
              case 404:
                return ErrorEntity(
                  code: errCode,
                  message: errorMessage ?? 'Can not reach server',
                );
              case 422:
                return ErrorEntity(
                  code: errCode,
                  message: errorMessage ?? 'Unprocessable content',
                );
              case 405:
                return ErrorEntity(
                  code: errCode,
                  message: errorMessage ?? 'Request method is forbidden',
                );
              case 500:
                return ErrorEntity(
                  code: errCode,
                  message: errorMessage ?? 'Server internal error',
                );
              case 502:
                return ErrorEntity(
                  code: errCode,
                  message: errorMessage ?? 'Invalid request',
                );
              case 503:
                return ErrorEntity(
                  code: errCode,
                  message: errorMessage ?? 'Server hung up',
                );
              case 505:
                return ErrorEntity(
                  code: errCode,
                  message:
                      errorMessage ?? 'Does not support HTTP protocol request',
                );
              default:
                {
                  // return ErrorEntity(code: errCode, message: 'Unknown error');
                  return ErrorEntity(
                    code: errCode,
                    message: error.response?.statusMessage,
                  );
                }
            }
          } on Exception catch (_) {
            // showSnack('error'.tr, 'internet_conn_err'.tr, SnackType.error);
            return ErrorEntity(code: -1, message: 'Unknown error');
          }
        }
      default:
        {
          return ErrorEntity(code: -1, message: error.message);
        }
    }
  }

  /*
    Cancel Request
    The same cancel token can be used for multiple requests. When a cancel token is cancelled,
    all requests using the cancel token will be cancelled. So the parameters are optional
  */
  void cancelRequests(CancelToken token) {
    token.cancel('cancelled');
  }

  Future<Map<String, dynamic>> getAuthorizationHeader() async {
    Map<String, dynamic> headers;
    headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    return headers;
  }

  Future get({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = false,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra!.addAll({
      'refresh': refresh,
      'noCache': noCache,
      'list': list,
      'cacheKey': cacheKey,
      'cacheDisk': cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = await getAuthorizationHeader();
    requestOptions.headers!.addAll(authorization);

    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future<Response<dynamic>> getWithResponse({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    bool refresh = false,
    bool noCache = false,
    bool list = false,
    String cacheKey = '',
    bool cacheDisk = false,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.extra ??= {};
    requestOptions.extra!.addAll({
      'refresh': refresh,
      'noCache': noCache,
      'list': list,
      'cacheKey': cacheKey,
      'cacheDisk': cacheDisk,
    });
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = await getAuthorizationHeader();
    requestOptions.headers!.addAll(authorization);

    var response = await dio.get(
      path,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful post
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = await getAuthorizationHeader();
    requestOptions.headers!.addAll(authorization);
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful post with response
  Future<Response<dynamic>> postWithResponse(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = await getAuthorizationHeader();
    requestOptions.headers!.addAll(authorization);
    var response = await dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful put
  Future put(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = await getAuthorizationHeader();
    requestOptions.headers!.addAll(authorization);
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  Future<Response<dynamic>> putWithResponse(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = await getAuthorizationHeader();
    requestOptions.headers!.addAll(authorization);
    var response = await dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response;
  }

  /// restful patch
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = await getAuthorizationHeader();
    requestOptions.headers!.addAll(authorization);
    var response = await dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
      cancelToken: cancelToken,
    );
    return response.data;
  }

  /// restful delete
  Future<Response<dynamic>> delete(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    Options requestOptions = options ?? Options();
    requestOptions.headers = requestOptions.headers ?? {};
    Map<String, dynamic>? authorization = await getAuthorizationHeader();
    requestOptions.headers!.addAll(authorization);
    var response = await dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: requestOptions,
    );
    return response;
  }
}

// Exception handling
class ErrorEntity implements Exception {
  int? code;
  String? message;

  ErrorEntity({this.code, this.message});

  @override
  String toString() {
    if (message == null) return 'Exception';
    return 'Exception: code $code, $message';
  }
}
