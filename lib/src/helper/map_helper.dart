import 'package:dio/dio.dart';
import 'package:flutter_network_cacher/src/constants/kstring.dart';
import 'package:flutter_network_cacher/src/models/dio_cache_options.dart';

class MapHelper {
  MapHelper._();

  static DioCacheOptions? getDioCacheOptionsFromExtras(RequestOptions request) {
    return request.extra[KString.dioCacheOptionKey];
  }
}
