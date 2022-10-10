import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_network_cacher/flutter_network_cacher.dart';
import 'package:flutter_network_cacher/src/helper/map_helper.dart';
import 'package:flutter_network_cacher/src/util/fnc_logger.dart';

class DioCacheInterceptor extends Interceptor {
  late Dio _dio;
  DioCacheOptions? globalDioCacheOptions;
  static const String kPost = "POST";
  static const String kGet = "GET";
  static const String kPatch = "PATCH";
  static const String kPut = "PUT";
  static const String kDelete = "DELETE";

  DioCacheInterceptor({required Dio dioInstance, this.globalDioCacheOptions}) {
    _dio = Dio();
    _dio.transformer = dioInstance.transformer;
    _dio.httpClientAdapter = dioInstance.httpClientAdapter;
    _dio.options = dioInstance.options;
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    var dioCacheOptions =
        MapHelper.getDioCacheOptionsFromExtras(err.requestOptions) ??
            globalDioCacheOptions;

    if (dioCacheOptions?.httpCacheOnError != null) {
      bool isError = dioCacheOptions?.httpCacheOnError!(err) ?? false;

      if (isError) {
        String? data = await Fnc()
            .baseDb
            .getResponseData(key: _getStorageUrl(err.requestOptions));

        if (data != null) {
          return handler.resolve(Response(
              requestOptions: err.requestOptions, data: json.decode(data)));
        }
        return super.onError(err, handler);
      } else {
        return super.onError(err, handler);
      }
    } else {
      super.onError(err, handler);
    }
  }

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    DioCacheOptions? dioCacheOptions =
        MapHelper.getDioCacheOptionsFromExtras(options) ??
            globalDioCacheOptions;

    if (dioCacheOptions?.dioCacheMethod == DioCacheMethod.noCache) {
      return super.onRequest(options, handler);
    } else if (dioCacheOptions?.dioCacheMethod == DioCacheMethod.cacheOnly) {
      String? data =
          await Fnc().baseDb.getResponseData(key: _getStorageUrl(options));

      if (data == null) {
        return super.onRequest(options, handler);
      }

      return handler.resolve(
          Response(requestOptions: options, data: json.decode(data)), true);
    } else if (dioCacheOptions?.dioCacheMethod ==
        DioCacheMethod.emitLastResponse) {
      String? data =
          await Fnc().baseDb.getResponseData(key: _getStorageUrl(options));

      if (data == null) {
        return super.onRequest(options, handler);
      }

      try {
        loadAsyncRequest(options, _dio);

        return handler.resolve(
            Response(requestOptions: options, data: json.decode(data)), true);
      } catch (e) {
        FncLogger.logFnc(e.toString());
      }
    } else {
      return super.onRequest(options, handler);
    }
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    var dioCacheOptions =
        MapHelper.getDioCacheOptionsFromExtras(response.requestOptions) ??
            globalDioCacheOptions;
    if (dioCacheOptions?.dioCacheMethod != DioCacheMethod.noCache) {
      await Fnc().baseDb.putResponseData(
          uId: _getStorageUrl(response.requestOptions),
          data: jsonEncode(response.data));
    }

    super.onResponse(response, handler);
  }

  Future loadAsyncRequest(RequestOptions requestOptions, Dio dio) async {
    Response response = Response(requestOptions: requestOptions);

    if (requestOptions.method == kGet) {
      response = await dio.get(
        requestOptions.path,
        queryParameters: requestOptions.queryParameters,
        options: Options(
          contentType: requestOptions.contentType,
          followRedirects: requestOptions.followRedirects,
          headers: requestOptions.headers,
          listFormat: requestOptions.listFormat,
          maxRedirects: requestOptions.maxRedirects,
          method: requestOptions.method,
          receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
          receiveTimeout: requestOptions.receiveTimeout,
          requestEncoder: requestOptions.requestEncoder,
          responseDecoder: requestOptions.responseDecoder,
          sendTimeout: requestOptions.sendTimeout,
          responseType: requestOptions.responseType,
          validateStatus: requestOptions.validateStatus,
        ),
      );
    } else if (requestOptions.method == kPost) {
      response = await dio.post(
        requestOptions.path,
        cancelToken: requestOptions.cancelToken,
        data: requestOptions.data,
        onReceiveProgress: requestOptions.onReceiveProgress,
        queryParameters: requestOptions.queryParameters,
        onSendProgress: requestOptions.onSendProgress,
        options: Options(
          contentType: requestOptions.contentType,
          followRedirects: requestOptions.followRedirects,
          headers: requestOptions.headers,
          listFormat: requestOptions.listFormat,
          maxRedirects: requestOptions.maxRedirects,
          method: requestOptions.method,
          receiveDataWhenStatusError: requestOptions.receiveDataWhenStatusError,
          receiveTimeout: requestOptions.receiveTimeout,
          requestEncoder: requestOptions.requestEncoder,
          responseDecoder: requestOptions.responseDecoder,
          sendTimeout: requestOptions.sendTimeout,
          responseType: requestOptions.responseType,
          validateStatus: requestOptions.validateStatus,
        ),
      );
    }
    await Fnc().baseDb.putResponseData(
        uId: _getStorageUrl(requestOptions), data: jsonEncode(response.data));
  }

  _getStorageUrl(RequestOptions options) {
    DioCacheOptions? dioCacheOptions =
        MapHelper.getDioCacheOptionsFromExtras(options) ??
            globalDioCacheOptions;
    try {
      String tempHeader;
      if (dioCacheOptions?.uniqueHeader != null &&
          options.headers.containsKey(dioCacheOptions?.uniqueHeader)) {
        tempHeader = options.headers[dioCacheOptions?.uniqueHeader];
      } else {
        tempHeader = "";
      }
      String? str = (options.uri.toString() +
          options.data.toString() +
          tempHeader.toString());

      return str;
    } catch (e) {
      return "";
    }
  }
}
