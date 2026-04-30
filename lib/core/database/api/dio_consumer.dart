import 'package:diamate/core/database/error/exception.dart';
import 'package:diamate/core/database/error/failure.dart';
import 'package:dio/dio.dart';

import 'api_consumer.dart';
import 'api_interceptors.dart';
import 'end_points.dart';

class DioConsumer extends ApiConsumer {
  final Dio dio;

  DioConsumer(this.dio) {
    dio.options.baseUrl = EndPoint.baseUrl;
    dio.options.contentType = Headers.jsonContentType;
    dio.interceptors.add(ApiInterceptors(dio));
    dio.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
  }
  @override
  Future delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var res = await dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future get(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      var res = await dio.get(
        path,
        data: data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future patch(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      var res = await dio.patch(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  @override
  Future post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
    Options? options,
  }) async {
    try {
      var res = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
        options: options,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  // ignore: strict_top_level_inference
  void handleDioException(DioException e) {
    Failure failure;

    if (e.response != null && e.response!.data != null) {
      try {
        failure = Failure.fromJson(e.response!.data as Map<String, dynamic>);
      } catch (_) {
        failure = Failure(
          errorMessage: e.message ?? "Unexpected error occurred",
          statusCode: e.response?.statusCode ?? 400,
        );
      }
    } else {
      failure = Failure(
        errorMessage: e.message ?? "Connection error or server unreachable",
        statusCode: 500,
      );
    }

    switch (e.type) {
      case DioExceptionType.connectionError:
        throw ConnectionErrorException(failure);
      case DioExceptionType.badCertificate:
        throw BadCertificateException(failure);
      case DioExceptionType.connectionTimeout:
        throw ConnectionTimeoutException(failure);
      case DioExceptionType.receiveTimeout:
        throw ReceiveTimeoutException(failure);
      case DioExceptionType.sendTimeout:
        throw SendTimeoutException(failure);

      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            throw BadResponseException(failure);
          case 401:
            throw UnauthorizedException(failure);
          case 403:
            throw ForbiddenException(failure);
          case 404:
            throw NotFoundException(failure);
          case 409:
            throw CofficientException(failure);
          case 504:
            throw BadResponseException(failure);
          default:
            throw UnknownException(failure);
        }

      case DioExceptionType.cancel:
        throw CancelException(failure);

      case DioExceptionType.unknown:
        throw UnknownException(failure);
    }
  }
}
