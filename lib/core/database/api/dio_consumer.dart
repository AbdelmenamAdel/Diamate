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
  }) async {
    try {
      var res = await dio.post(
        path,
        data: isFormData ? FormData.fromMap(data) : data,
        queryParameters: queryParameters,
      );
      return res.data;
    } on DioException catch (e) {
      handleDioException(e);
    }
  }

  // ignore: strict_top_level_inference
  void handleDioException(e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
        throw ConnectionErrorException(Failure.fromJson(e.response!.data));
      case DioExceptionType.badCertificate:
        throw BadCertificateException(Failure.fromJson(e.response!.data));
      case DioExceptionType.connectionTimeout:
        throw ConnectionTimeoutException(Failure.fromJson(e.response!.data));

      case DioExceptionType.receiveTimeout:
        throw ReceiveTimeoutException(Failure.fromJson(e.response!.data));

      case DioExceptionType.sendTimeout:
        throw SendTimeoutException(Failure.fromJson(e.response!.data));
      // throw ServerException('connection Error');

      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400: // Bad request

            throw BadResponseException(Failure.fromJson(e.response!.data));

          case 401: //unauthorized
            throw UnauthorizedException(Failure.fromJson(e.response!.data));

          case 403: //forbidden
            throw ForbiddenException(Failure.fromJson(e.response!.data));

          case 404: //not found
            throw NotFoundException(Failure.fromJson(e.response!.data));

          case 409: //cofficient
            // throw ServerException('badResponse');
            throw CofficientException(Failure.fromJson(e.response!.data));

          case 504: // Bad request

            throw BadResponseException(Failure.fromJson(e.response!.data));
        }

      case DioExceptionType.cancel:
        throw CancelException(
          Failure(errorMessage: e.toString(), statusCode: 400),
        );

      case DioExceptionType.unknown:
        throw UnknownException(
          Failure(errorMessage: e.toString(), statusCode: 400),
        );
      // throw ServerException('badResponse');
    }
  }
}
