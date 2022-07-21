import 'package:get_storage/get_storage.dart';

class Db {
  static const String _requestStorage = "requestStorage";

  static final Db _singleton = Db._internal();
  factory Db() {
    return _singleton;
  }
  Db._internal();

  GetStorage? _reqBox;

  Future init({String? directoy}) async {
    _reqBox = GetStorage(_requestStorage);
  }

  Future<String?> getStringData({required String key}) async {
    return _reqBox?.read<String?>(key);
  }

  Future<String?> putStringData(
      {required String uId,
      String? data,
      Duration maxAge = const Duration(seconds: 5)}) async {
    await _reqBox?.write(uId, data);
    return null;
  }

  Future removeStringData({required String key}) async {
    await _reqBox?.remove(key);
  }

  Future clearResponseData() async {
    _reqBox?.erase();
  }
}
