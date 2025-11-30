import 'package:diamate/core/database/api/end_points.dart';
import 'package:diamate/core/database/secure_storage.dart';
import 'package:dio/dio.dart';
import 'dart:async';

class ApiInterceptors extends Interceptor {
  final Dio dio;
  bool _isRefreshing = false;
  Completer<void>? _refreshCompleter;

  ApiInterceptors(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Read tokens asynchronously but don't mark the method `async` because
    // Dio's interceptor expects a synchronous signature. We update headers
    // once the futures complete and then continue the chain.
    SecureStorage.getString(key: Apikeys.accessToken)
        .then((accessToken) {
          if (accessToken != null && accessToken.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $accessToken';
          }
        })
        .whenComplete(() async {
          // Try to add refresh token if available.
          String? refreshToken = await SecureStorage.getString(
            key: Apikeys.refreshToken,
          );
          if (refreshToken != null && refreshToken.isNotEmpty) {
            options.headers['Cookie'] = 'refresh_token=$refreshToken';
          }

          // Ensure content type is set
          options.headers['Content-Type'] = 'application/json';

          handler.next(options);
        })
        .catchError((_) {
          // In case of any error reading storage, still continue the request
          options.headers['Content-Type'] = 'application/json';
          handler.next(options);
        });
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // If unauthorized, attempt token refresh and retry the original request.
    if (err.response?.statusCode == 401) {
      _handle401Error(err, handler);
      return;
    }
    handler.next(err);
  }

  void _handle401Error(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final refreshToken = await SecureStorage.getString(
      key: Apikeys.refreshToken,
    );
    if (refreshToken == null || refreshToken.isEmpty) {
      // No refresh token available — forward error (client should logout)
      handler.next(err);
      return;
    }

    final requestOptions = err.requestOptions;

    // If a refresh is already in progress, wait for it to finish then retry
    if (_isRefreshing) {
      // wait until refresh finishes
      await Future.doWhile(() async {
        await Future.delayed(const Duration(milliseconds: 100));
        return _isRefreshing;
      });

      final newAccess = await SecureStorage.getString(key: Apikeys.accessToken);
      if (newAccess == null) {
        handler.next(err);
        return;
      }

      // Set new header and retry
      requestOptions.headers['Authorization'] = 'Bearer $newAccess';
      try {
        final response = await dio.fetch(requestOptions);
        handler.resolve(response);
      } catch (e) {
        handler.next(err);
      }
      return;
    }

    // Start refresh
    _isRefreshing = true;
    _refreshCompleter = Completer<void>();
    try {
      final refreshDio = Dio();
      // call refresh endpoint
      final refreshResp = await refreshDio.post(
        '${EndPoint.baseUrl}${EndPoint.refreshToken}',
        data: {'refresh_token': refreshToken},
      );

      // Expected response contains new tokens; adjust according to your API
      final newAccess = refreshResp.data['access_token'] as String?;
      final newRefresh = refreshResp.data['refresh_token'] as String?;

      if (newAccess == null || newAccess.isEmpty) {
        // Refresh failed
        await SecureStorage.clearAll();
        handler.next(err);
        return;
      }

      // Save new tokens
      await SecureStorage.setString(key: Apikeys.accessToken, value: newAccess);
      if (newRefresh != null && newRefresh.isNotEmpty) {
        await SecureStorage.setString(
          key: Apikeys.refreshToken,
          value: newRefresh,
        );
      }

      // Update default header for future requests
      dio.options.headers['Authorization'] = 'Bearer $newAccess';

      // Retry the failed request with new token
      requestOptions.headers['Authorization'] = 'Bearer $newAccess';
      final retryResponse = await dio.fetch(requestOptions);
      handler.resolve(retryResponse);
    } catch (e) {
      // Refresh failed — clear storage and forward error (logout)
      await SecureStorage.clearAll();
      handler.next(err);
    } finally {
      _isRefreshing = false;
      _refreshCompleter?.complete();
      _refreshCompleter = null;
    }
  }
}
