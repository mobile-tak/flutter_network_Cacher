import 'package:dio/dio.dart';
import 'package:flutter_network_cacher/src/constants/kstring.dart';

import '../constants/enums.dart';

class CacheOptions extends Options {
  CacheOptions({
    String? method,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    Map<String, dynamic>? extra,
    Map<String, dynamic>? headers,
    ResponseType? responseType,
    String? contentType,
    ValidateStatus? validateStatus,
    bool? receiveDataWhenStatusError,
    bool? followRedirects,
    int? maxRedirects,
    RequestEncoder? requestEncoder,
    ResponseDecoder? responseDecoder,
    ListFormat? listFormat,
    DioCacheOptions? dioCacheOptions,
  }) : super(
          method: method,
          sendTimeout: sendTimeout,
          receiveTimeout: receiveTimeout,
          extra: extra,
          headers: headers,
          responseType: responseType,
          contentType: contentType,
          validateStatus: validateStatus,
          receiveDataWhenStatusError: receiveDataWhenStatusError,
          followRedirects: followRedirects,
          maxRedirects: maxRedirects,
          requestEncoder: requestEncoder,
          responseDecoder: responseDecoder,
          listFormat: listFormat,
        ) {
    this.extra = {KString.dioCacheOptionKey: dioCacheOptions};
  }
}

class DioCacheOptions {
  final DioCacheMethod? dioCacheMethod;
  final String? uniqueHeader;
  final bool? clearCacheForRequest;
  final bool Function(DioError)? httpCacheOnError;
  DioCacheOptions({
    this.httpCacheOnError,
    this.dioCacheMethod,
    this.uniqueHeader,
    this.clearCacheForRequest,
  });
}
