import 'dart:io';
import 'package:flutter_network_cacher/src/helper/string_helper.dart';
import 'package:get_storage/get_storage.dart';

class Db {
  static final Db _obj = Db._internal();
  Db._internal();
  factory Db() {
    return _obj;
  }

  late GetStorage _imageBucket;
  late GetStorage _networkRequestBucket;

  Future<void> init(
      {required String imageBucket,
      required String networkRequestBucket}) async {
    _imageBucket = GetStorage(imageBucket);
    _networkRequestBucket = GetStorage(networkRequestBucket);
  }

  static Future<String?> getStringData({required String key}) async {
    FileInfo? fileInfo =
        await DefaultCacheManager().getFileFromCache(key, ignoreMemCache: true);
    if (fileInfo != null) {
      return await fileInfo.file.readAsString();
    } else {
      return null;
    }
  }

  static Future<String> putStringData(
      {required String uId,
      String? data,
      Duration maxAge = const Duration(seconds: 5)}) async {
    File file = await DefaultCacheManager().putFile(
        uId, StringHelper.stringToUnit8List(data ?? ""),
        maxAge: maxAge, eTag: uId);
    return file.readAsString();
  }

  static Future clearCache() async {
    await DefaultCacheManager().emptyCache();
  }

  tempMe() {
    _imageBucket.w
  }
}
