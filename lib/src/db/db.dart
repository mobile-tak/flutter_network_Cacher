import 'dart:io';

import 'package:flutter_network_cacher/src/models/generated/objectbox.g.dart';
import 'package:flutter_network_cacher/src/models/response_storage_model/response_storage_model.dart';
import 'package:path_provider/path_provider.dart';

class Db {
  late final Box<ResponseStorageModel> _responseStorageBox;
  late final Store _requestStore;

  static Future<Db> init() async {
    var res = await getTemporaryDirectory();
    String path = "${res.path}/requeststore";

    Store store;

    if (Store.isOpen(path)) {
      store = Store.attach(null, path);
    } else {
      store = await openStore(directory: path);
      await store.runAsync((store, parameter) => null, "");
    }

    // final store = await openStore(directory: path);

    // await store.runAsync((store, parameter) => null, "");

    return Db._init(store);
  }

  Db._init(this._requestStore) {
    _responseStorageBox = Box<ResponseStorageModel>(_requestStore);
  }

  // Future<void> init(
  //     {required String imageBucket,
  //     required String networkRequestBucket}) async {
  //   _imageBucket = GetStorage(imageBucket);
  //   _networkRequestBucket = GetStorage(networkRequestBucket);
  // }

  Future<String?> getStringData({required String key}) async {
    final queryResponse = _responseStorageBox
        .query(ResponseStorageModel_.uniqueUrl.equals(key))
        .build();
    final queriedResponse = queryResponse?.findFirst();
    queryResponse.close();
    return queriedResponse?.data;
  }

  Future<String?> putStringData(
      {required String uId,
      String? data,
      Duration maxAge = const Duration(seconds: 5)}) async {
    int? id = await _responseStorageBox
        ?.putAsync(ResponseStorageModel(uniqueUrl: uId, data: data));
    if (id != null) {
      return _responseStorageBox.get(id)?.data;
    }
    return null;
  }

  Future<String?> removeStringData({required String key}) async {
    final queryResponse = _responseStorageBox
        .query(ResponseStorageModel_.uniqueUrl.equals(key))
        .build();
    final queriedResponse = queryResponse?.findFirst();
    queryResponse.close();
    if (queriedResponse?.data != null) {
      _responseStorageBox.remove((queriedResponse?.id)!);
    }

    return queriedResponse?.data;
  }

  Future clearResponseData() async {
    var path = _requestStore.directoryPath;
    _responseStorageBox.removeAll();

    if (path != null) {
      bool directoryExists = await Directory(path).exists();
      bool fileExists = await File(path).exists();
      if (directoryExists || fileExists) {
        Directory(path).deleteSync(recursive: true);
      }
    }
  }

  tempMe() {}
}
