abstract class BaseDb {
  Future<BaseDb> init();
  Future<String?> getResponseData({required String key});
  Future<String?> putResponseData(
      {required String uId,
      String? data,
      Duration maxAge = const Duration(seconds: 5)});
  Future<String?> removeResponseData({required String key});

  Future clearResponseData();
}
