import 'dart:io';

import 'package:flutter_network_cacher/src/models/generated/objectbox.g.dart';
import 'package:flutter_network_cacher/src/models/response_storage_model/response_storage_model.dart';
import 'package:path_provider/path_provider.dart';

class Db {
  static final Db _obj = Db._internal();
  Db._internal();
  factory Db() {
    return _obj;
  }

  Box<ResponseStorageModel>? _responseStorageBox;
  Store? _requestStore;

  Future init() async {
    var res = await getTemporaryDirectory();
    String path = "${res.path}/requeststore";

    Store.isOpen(path);

    if (!Store.isOpen(path)) {
      _requestStore = await openStore(directory: path);
    }

    await _requestStore?.runAsync((store, parameter) => null, null);

    if (_requestStore != null) {
      _responseStorageBox = Box<ResponseStorageModel>(_requestStore!);
    }
  }

  // Future<void> init(
  //     {required String imageBucket,
  //     required String networkRequestBucket}) async {
  //   _imageBucket = GetStorage(imageBucket);
  //   _networkRequestBucket = GetStorage(networkRequestBucket);
  // }

  Future<String?> getStringData({required String key}) async {
    final queryResponse = _responseStorageBox
        ?.query(ResponseStorageModel_.uniqueUrl.equals(key))
        .build();
    final queriedResponse = queryResponse?.findFirst();
    queryResponse?.close();
    return queriedResponse?.data;
  }

  Future<String?> putStringData(
      {required String uId,
      String? data,
      Duration maxAge = const Duration(seconds: 5)}) async {
    int? id = await _responseStorageBox
        ?.putAsync(ResponseStorageModel(uniqueUrl: uId, data: data));
    if (id != null) {
      return _responseStorageBox?.get(id)?.data;
    }
    return null;
  }

  Future<String?> removeStringData({required String key}) async {
    final queryResponse = _responseStorageBox
        ?.query(ResponseStorageModel_.uniqueUrl.equals(key))
        .build();
    final queriedResponse = queryResponse?.findFirst();
    queryResponse?.close();
    if (queriedResponse?.data != null) {
      _responseStorageBox?.remove((queriedResponse?.id)!);
    }

    return queriedResponse?.data;
  }

  Future clearResponseData() async {
    var path = _requestStore?.directoryPath;
    _responseStorageBox?.removeAll();

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
