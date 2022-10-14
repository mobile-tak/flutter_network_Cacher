import 'dart:developer';
import 'dart:io';

import 'package:flutter_network_cacher/flutter_network_cacher.dart';
import 'package:flutter_network_cacher/src/db/base_db.dart';
import 'package:flutter_network_cacher/src/models/generated/objectbox.g.dart';
import 'package:flutter_network_cacher/src/models/response_storage_model/response_storage_model.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBoxDb extends BaseDb {
  late final Box<ResponseStorageModel> _responseStorageBox;
  late final Store _requestStore;

  @override
  Future clearResponseData() async {
    // var path = _requestStore.directoryPath;
    _responseStorageBox.removeAll();

    // bool directoryExists = await Directory(path).exists();
    // bool fileExists = await File(path).exists();
    // if (directoryExists || fileExists) {
    //   Directory(path).deleteSync(recursive: true);
    // }
  }

  @override
  Future<String?> getResponseData({required String key}) async {
    final queryResponse = _responseStorageBox
        .query(ResponseStorageModel_.uniqueUrl.equals(key))
        .build();
    final queriedResponse = queryResponse.findFirst();

    queryResponse.close();
    return queriedResponse?.data;
  }

  @override
  Future<BaseDb> init() async {
    var res = await getTemporaryDirectory();
    String path = "${res.path}/requeststore";

    if (Store.isOpen(path)) {
      _requestStore = Store.attach(null, path);
    } else {
      _requestStore = await openStore(directory: path);
    }

    await _requestStore.runAsync((store, parameter) => null, "");

    _responseStorageBox = Box<ResponseStorageModel>(_requestStore);

    return this;
  }

  @override
  Future<String?> putResponseData(
      {required String uId,
      String? data,
      Duration maxAge = const Duration(seconds: 5)}) async {
    int id = await _responseStorageBox.putAsync(ResponseStorageModel(
        uniqueUrl: uId, data: data, dateAdded: DateTime.now()));
    return _responseStorageBox.get(id)?.data;
  }

  @override
  Future<String?> removeResponseData({required String key}) async {
    final queryResponse = _responseStorageBox
        .query(ResponseStorageModel_.uniqueUrl.equals(key))
        .build();
    final queriedResponse = queryResponse.findFirst();
    queryResponse.close();
    if (queriedResponse?.data != null) {
      _responseStorageBox.remove((queriedResponse?.id)!);
    }

    return queriedResponse?.data;
  }
}
