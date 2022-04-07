import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../constants/messages.dart';
import '../../constants/network.dart';
import '../../data_models/core/api_response.dart';
import '../../data_models/core/error_response.dart';
import '../../utils/check_network.dart';
import '../local_repo.dart';
import 'interceptor.dart';
import 'options.dart';
import 'transformer.dart';

enum RequestGrantType { jSON, formData, multiPart }

enum RequestType { get, post, put, delete, patch }

/// Provider class for handling REST api calls
///
/// Handles the network connectivity check.
/// Provides retry option based on the 'shouldRetry' flag.
/// Handles all error cases based on the error type as well as response status
/// code.
class ApiProvider {
  final Dio dio;
  final LocalRepository localRepository;
  final CancelToken cancelToken;

  ApiProvider(
      {required this.dio,
      required this.localRepository,
      required this.cancelToken});

  /// Handles all the api calls based on RequestType and RequestMethod
  Future<ApiResponse?> performApi(
      {required String url,
      Map<String, dynamic> request = const {},
      Map<String, String> headers = const {},
      RequestType requestType = RequestType.get,
      RequestGrantType requestGrantType = RequestGrantType.jSON,
      bool shouldRetry = false,
      bool authorize = false,
      bool cancelAllCalls = false}) async {
    /// Checks for internet connectivity
    if (await checkNetwork()) {
      return call(
          url: url,
          request: request,
          headers: headers,
          requestType: requestType,
          requestGrantType: requestGrantType,
          shouldRetry: shouldRetry,
          authorize: authorize,
          cancelPreviousCalls: cancelAllCalls);
    } else {
      /// Sends back response with no connectivity message
      return ApiResponse(
          result: null,
          statusCode: null,
          message: Messages.noNetworkMessage,
          isSuccess: false);
    }
  }

  /// Handles all api calls
  Future<ApiResponse?> call(
      {required String url,
      required Map<String, dynamic> request,
      required Map<String, String> headers,
      required RequestType requestType,
      required RequestGrantType requestGrantType,
      required bool shouldRetry,
      required bool authorize,
      required bool cancelPreviousCalls}) async {
    /// Appending token to the header if 'authorize' key is true
    String? token = await localRepository.getAccessToken();
    Map<String, String> requestHeaders = authorize
        ? {
            NetworkConstants.authorization:
                token.isEmpty ? '' : 'Bearer ' + token
          }
        : {};
    requestHeaders.putIfAbsent(NetworkConstants.apikey, () {
      return NetworkConstants.apiKeyValue;
    });
    if (!kIsWeb) {
      requestHeaders.putIfAbsent(NetworkConstants.platformKey, () {
        return Platform.isIOS
            ? NetworkConstants.platformIos
            : NetworkConstants.platformAndroid;
      });
    }
    requestHeaders.addAll(headers);

    String requestUrl = url;

    try {
      Response response;
      dio.options.headers = requestHeaders;

      dio.transformer = FlutterTransformer();

      /// Retry option configuration
      RetryOptions retryOptions = RetryOptions(
        retryInterval: const Duration(seconds: 3),
        retries: 3,
        retryEvaluator: (error) =>
            error.type != DioErrorType.cancel &&
            error.type != DioErrorType.response,
      );
      if (shouldRetry) {
        dio.interceptors.add(RetryInterceptor(
          dio: dio,
          logger: Logger("Retry"),
          options: retryOptions,
        ));
      }

      dio.interceptors.add(PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90));

      if (cancelPreviousCalls) cancelToken.cancel('Cancelled');

      /// Performing api calls based on RequestType and RequestMethod
      switch (requestType) {
        case RequestType.post:
          if (requestGrantType == RequestGrantType.formData) {
            FormData formData = FormData.fromMap(request);
            if (shouldRetry) {
              response = (await dio.post(requestUrl,
                  data: formData,
                  cancelToken: cancelToken,
                  options: Options(extra: retryOptions.toExtra())));
            } else {
              response = (await dio.post(requestUrl,
                  data: formData, cancelToken: cancelToken));
            }
          } else {
            if (shouldRetry) {
              response = (await dio.post(requestUrl,
                  data: request,
                  cancelToken: cancelToken,
                  options: Options(extra: retryOptions.toExtra())));
            } else {
              response = (await dio.post(requestUrl,
                  data: request, cancelToken: cancelToken));
            }
          }
          break;
        case RequestType.get:
          if (shouldRetry) {
            response = (await dio.get(requestUrl,
                queryParameters: request,
                cancelToken: cancelToken,
                options: Options(extra: retryOptions.toExtra())));
          } else {
            response = (await dio.get(requestUrl,
                queryParameters: request, cancelToken: cancelToken));
          }
          break;
        case RequestType.put:
          if (requestGrantType == RequestGrantType.formData) {
            FormData formData = FormData.fromMap(request);
            if (shouldRetry) {
              response = (await dio.put(requestUrl,
                  data: formData,
                  cancelToken: cancelToken,
                  options: Options(extra: retryOptions.toExtra())));
            } else {
              response = (await dio.put(requestUrl,
                  data: formData, cancelToken: cancelToken));
            }
          } else {
            if (shouldRetry) {
              response = (await dio.put(requestUrl,
                  data: request,
                  cancelToken: cancelToken,
                  options: Options(extra: retryOptions.toExtra())));
            } else {
              response = (await dio.put(requestUrl,
                  data: request, cancelToken: cancelToken));
            }
          }
          break;
        case RequestType.patch:
          if (requestGrantType == RequestGrantType.formData) {
            FormData formData = FormData.fromMap(request);
            if (shouldRetry) {
              response = (await dio.patch(requestUrl,
                  data: formData,
                  cancelToken: cancelToken,
                  options: Options(extra: retryOptions.toExtra())));
            } else {
              response = (await dio.patch(requestUrl,
                  data: formData, cancelToken: cancelToken));
            }
          } else {
            if (shouldRetry) {
              response = (await dio.patch(requestUrl,
                  data: request,
                  cancelToken: cancelToken,
                  options: Options(extra: retryOptions.toExtra())));
            } else {
              response = (await dio.patch(requestUrl,
                  data: request, cancelToken: cancelToken));
            }
          }
          break;
        case RequestType.delete:
          if (shouldRetry) {
            response = (await dio.delete(requestUrl,
                cancelToken: cancelToken,
                options: Options(extra: retryOptions.toExtra())));
          } else {
            response = (await dio.delete(requestUrl, cancelToken: cancelToken));
          }
      }

      if (response.statusCode == NetworkConstants.statusCodeSuccess) {
        return ApiResponse(
            result: response.data,
            message: null,
            statusCode: response.statusCode,
            isSuccess: true);
      }
    } catch (error, stacktrace) {
      debugPrint("Exception occured: $error stackTrace: $stacktrace");
      ApiResponse? errorMessage = await _handleError(error);
      return errorMessage;
    }
    return null;
  }

  Future<ApiResponse> uploadFileBloc({
    required String url,
    required File file,
    required Map<String, String> headers,
    required bool shouldRetry,
    required bool authorize,
    bool cancelPreviousCalls = false,
    required Function(double) progressCallback,
  }) async {
    /// Appending token to the header if 'authorize' key is true
    ///
    if (await checkNetwork()) {
      String? token = await localRepository.getRestApiAccessToken();
      Map<String, String> requestHeaders = authorize
          ? {
              NetworkConstants.authorization:
                  token.isEmpty ? '' : 'Bearer ' + token
            }
          : {};
      requestHeaders.putIfAbsent(NetworkConstants.apikey, () {
        return NetworkConstants.apiKeyValue;
      });
      requestHeaders.putIfAbsent(NetworkConstants.platformKey, () {
        return Platform.isIOS
            ? NetworkConstants.platformIos
            : NetworkConstants.platformAndroid;
      });
      requestHeaders.addAll(headers);

      ApiResponse apiResponse;

      try {
        Response response;
        dio.options.receiveTimeout = NetworkConstants.imageUploadTimeout;
        dio.options.connectTimeout = NetworkConstants.imageUploadTimeout;
        dio.options.headers = requestHeaders;

        /// Retry option configuration
        RetryOptions retryOptions = RetryOptions(
          retryInterval: const Duration(seconds: 3),
          retries: 3,
          retryEvaluator: (error) =>
              error.type != DioErrorType.cancel &&
              error.type != DioErrorType.response,
        );
        if (shouldRetry) {
          dio.interceptors.add(RetryInterceptor(
            dio: dio,
            logger: Logger("Retry"),
            options: retryOptions,
          ));
        }

        String fileName = file.path.split('/').last;

        FormData data = FormData.fromMap({
          'is_public': 'on',
          "image": await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        });

        apiResponse = ApiResponse(
            result: null,
            isSuccess: false,
            message: null,
            statusCode: null,
            isFileUpload: true);

        if (cancelPreviousCalls) cancelToken.cancel('Cancelled');

        response = await dio.post(
          url,
          data: data,
          cancelToken: cancelToken,
          onSendProgress: (sent, total) {
            double progress = (sent / total);
            debugPrint('Progress: $progress');
            progressCallback(progress);
          },
        );

        if (response.statusCode == NetworkConstants.statusCodeSuccess) {
          debugPrint(response.data);
          apiResponse = ApiResponse(
              result: response.data,
              message: null,
              statusCode: response.statusCode,
              isSuccess: true,
              isFileUpload: true,
              uploadProgress: 100);
        }
      } catch (error, stacktrace) {
        debugPrint("Exception occured: $error stackTrace: $stacktrace");
        ApiResponse? errorMessage = await _handleError(error);
        return errorMessage;
      }
      return apiResponse;
    } else {
      /// Sends back response with no connectivity message
      return ApiResponse(
          result: null,
          statusCode: null,
          message: Messages.noNetworkMessage,
          isSuccess: false);
    }
  }

  Future<ApiResponse> uploadFile({
    required String url,
    required File file,
    required Map<String, String> headers,
    required bool shouldRetry,
    required bool authorize,
    bool cancelPreviousCalls = false,
  }) async {
    /// Appending token to the header if 'authorize' key is true
    ///
    if (await checkNetwork()) {
      String? token = await localRepository.getRestApiAccessToken();
      Map<String, String> requestHeaders = authorize
          ? {
              NetworkConstants.authorization:
                  token.isEmpty ? '' : 'Bearer ' + token
            }
          : {};
      requestHeaders.putIfAbsent(NetworkConstants.apikey, () {
        return NetworkConstants.apiKeyValue;
      });
      requestHeaders.putIfAbsent(NetworkConstants.platformKey, () {
        return Platform.isIOS
            ? NetworkConstants.platformIos
            : NetworkConstants.platformAndroid;
      });
      requestHeaders.addAll(headers);

      ApiResponse apiResponse;

      try {
        Response response;
        dio.options.headers = requestHeaders;

        /// Retry option configuration
        RetryOptions retryOptions = RetryOptions(
          retryInterval: const Duration(seconds: 3),
          retries: 3,
          retryEvaluator: (error) =>
              error.type != DioErrorType.cancel &&
              error.type != DioErrorType.response,
        );
        if (shouldRetry) {
          dio.interceptors.add(RetryInterceptor(
            dio: dio,
            logger: Logger("Retry"),
            options: retryOptions,
          ));
        }

        String fileName = file.path.split('/').last;

        FormData data = FormData.fromMap({
          "avatar": await MultipartFile.fromFile(
            file.path,
            filename: fileName,
          ),
        });

        apiResponse = ApiResponse(
            result: null,
            isSuccess: false,
            message: null,
            statusCode: null,
            isFileUpload: true);

        if (cancelPreviousCalls) cancelToken.cancel('Cancelled');

        response = await dio.post(url, data: data, cancelToken: cancelToken);

        if (response.statusCode == NetworkConstants.statusCodeSuccess) {
          debugPrint(response.data);
          apiResponse = ApiResponse(
              result: response.data,
              message: null,
              statusCode: response.statusCode,
              isSuccess: true,
              isFileUpload: true,
              uploadProgress: 100);
        }
      } catch (error, stacktrace) {
        debugPrint("Exception occured: $error stackTrace: $stacktrace");
        ApiResponse? errorMessage = await _handleError(error);
        return errorMessage;
      }
      return apiResponse;
    } else {
      /// Sends back response with no connectivity message
      return ApiResponse(
          result: null,
          statusCode: null,
          message: Messages.noNetworkMessage,
          isSuccess: false);
    }
  }

  /// Handles all api error cases and return ApiResponse with corresponding
  /// message.
  Future<ApiResponse> _handleError(error) async {
    ApiResponse apiResponse;
    String errorDescription = "";
    if (error is DioError) {
      DioError dioError = error;
      switch (dioError.type) {
        case DioErrorType.cancel:
          errorDescription = Messages.apiCancelledMessage;
          apiResponse = ApiResponse(
              result: null,
              statusCode: dioError.response?.statusCode,
              message: errorDescription,
              isSuccess: false);
          break;
        case DioErrorType.connectTimeout:
          errorDescription = Messages.apiConnectTimeOutMessage;
          apiResponse = ApiResponse(
              result: null,
              statusCode: null,
              message: errorDescription,
              isSuccess: false);
          break;
        case DioErrorType.other:
          errorDescription = Messages.apiUnknownDioErrorTypeMessage;
          apiResponse = ApiResponse(
              result: null,
              statusCode: null,
              message: errorDescription,
              isSuccess: false);
          break;
        case DioErrorType.receiveTimeout:
          errorDescription = Messages.apiReceiveTimeOutMessage;
          apiResponse = ApiResponse(
              result: null,
              statusCode: null,
              message: errorDescription,
              isSuccess: false);
          break;
        case DioErrorType.response:
          int? statusCode = dioError.response?.statusCode;
          if (statusCode != null) {
            if (statusCode > 399 && statusCode < 500) {
              //Response in 400 series
              if (statusCode == NetworkConstants.statusCodeUnauthorized) {
                apiResponse = ApiResponse(
                    result: null,
                    statusCode: statusCode,
                    message: Messages.apiUnauthorised,
                    isSuccess: false);
                _navigateToLogin();
              } else {
                ErrorResponse errorResponse;
                if (dioError.response?.data is String) {
                  String error = dioError.response?.data;
                  errorResponse = ErrorResponse(message: error);
                } else {
                  errorResponse =
                      ErrorResponse.fromJson(dioError.response?.data);
                }
                apiResponse = ApiResponse(
                    result: null,
                    statusCode: statusCode,
                    message: errorResponse.message,
                    isSuccess: false,
                    formErrors: errorResponse.errors);
              }
            } else if (statusCode > 499 && statusCode < 600) {
              //Response in 500 series
              ErrorResponse errorResponse;
              if (dioError.response?.data is String) {
                String error = dioError.response?.data;
                errorResponse = ErrorResponse(message: error);
              } else {
                errorResponse = ErrorResponse.fromJson(dioError.response?.data);
              }
              apiResponse = ApiResponse(
                  result: null,
                  statusCode: statusCode,
                  message: errorResponse.message,
                  isSuccess: false);
            } else {
              // If the server did not return a 200 OK dioError.response,
              // then throw an exception.
              apiResponse = ApiResponse(
                  result: null,
                  statusCode: statusCode,
                  message: Messages.apiUnhandledStatusCode,
                  isSuccess: false);
            }
          } else {
            apiResponse = ApiResponse(
                result: null,
                statusCode: null,
                message: Messages.apiNullStatusCode,
                isSuccess: false);
          }
          break;
        case DioErrorType.sendTimeout:
          errorDescription = Messages.apiSendTimeOutMessage;
          apiResponse = ApiResponse(
              result: null,
              statusCode: null,
              message: errorDescription,
              isSuccess: false);
          break;
        default:
          return ApiResponse(
              result: null,
              statusCode: null,
              message: Messages.apiUnhandledErrorMessage,
              isSuccess: false);
      }
    } else {
      errorDescription = Messages.apiUnknwonErrorTypeMessage;
      return ApiResponse(
          result: null,
          statusCode: null,
          message: errorDescription,
          isSuccess: false);
    }
    return apiResponse;
  }

  /// Show session expired dialog and navigating to login page on user input.
  void _navigateToLogin() {}
}
