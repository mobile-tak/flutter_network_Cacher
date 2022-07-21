import 'package:flutter_network_cacher/src/constants/kstring.dart';

/// Base Class For initializing Flutter network cacher.

class Fnc {
  //Converting Fnc to singleton.
  //limitting object creation.
  static final Fnc _obj = Fnc._internal();
  Fnc._internal();
  factory Fnc() {
    return _obj;
  }

  String? _imageBucket;
  String? _networkRequestBucket;

  ///Initialize database for flutter network cacher with provided configuration
  ///by default [_imageBucket]="fnc_internal_imageBucket" and
  ///[networkRequestBucket]="fnc_internal_networkRequestBucket"
  Future<void> init({String? imageBucket, String? networkRequestBucket}) async {
    _imageBucket = imageBucket ?? KString.imageBucket;
    _networkRequestBucket =
        networkRequestBucket ?? KString.networkRequestBucket;
  }
}
