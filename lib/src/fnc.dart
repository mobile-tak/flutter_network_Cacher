import 'package:flutter_network_cacher/src/constants/kstring.dart';
import 'package:flutter_network_cacher/src/db/base_db.dart';
import 'package:flutter_network_cacher/src/db/db.dart';

/// Base Class For initializing Flutter network cacher.

class Fnc {
  //Converting Fnc to singleton.
  //limitting object creation.
  static final Fnc _obj = Fnc._internal();
  Fnc._internal();
  factory Fnc() {
    return _obj;
  }

  late BaseDb baseDb;

  String? imageBucket;
  String? networkRequestBucket;

  ///Initialize database for flutter network cacher with provided configuration
  ///by default [imageBucket]="fnc_internal_imageBucket" and
  ///[networkRequestBucket]="fnc_internal_networkRequestBucket"
  Future<void> init(
      {String? imageBucket,
      String? networkRequestBucket,
      required BaseDb cacheStore}) async {
    imageBucket = imageBucket ?? KString.imageBucket;
    networkRequestBucket = networkRequestBucket ?? KString.networkRequestBucket;
    baseDb = await cacheStore.init();
  }
}
