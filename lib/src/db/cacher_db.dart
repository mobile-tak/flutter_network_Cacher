abstract class CacherDb {
  Future<String?> getStringData({required String key});

  Future<String> putStringData(
      {required String uId,
      String? data,
      Duration maxAge = const Duration(days: 5)});

  Future<void> removeStringData({String? key});

  Future clearCache();

  Future initDb();
}
