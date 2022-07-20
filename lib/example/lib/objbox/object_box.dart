import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:example/objbox/model/generated/objectbox.g.dart';
import 'package:example/objbox/model/image_model/image_model.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  late final Store _store;
  late final Box<ImageModel> _imageBox;

  ObjectBox._init(this._store) {
    _imageBox = Box<ImageModel>(_store);
  }

  static Future<ObjectBox> init() async {
    var res = await getTemporaryDirectory();

    String path = res.path;

    final store = await openStore();
    final anotherStore = await openStore(directory: "$path/test");

    await store.runAsync((store, parameter) => null,
        ""); // store.runAsync((store, parameter) => null, param);
    return ObjectBox._init(store);
  }

  // int insertImage() => _imageBox.
  int insertImage({required String url, required Uint8List imageData}) =>
      _imageBox.put(
        ImageModel(imageData: imageData, url: url),
      );

  ImageModel? getImage({required String url}) {
    final queryImage = _imageBox.query(ImageModel_.url.equals(url)).build();
    final image = queryImage.findFirst();
    queryImage.close();
    return image;
  }

  List<ImageModel?>? getAllImage() {
    return _imageBox.getAll();
  }

  clearCache() async {
    // _imageBox.removeAll();
    var path = _store.directoryPath;

    bool directoryExists = await Directory(path).exists();
    bool fileExists = await File(path).exists();
    if (directoryExists || fileExists) {
      Directory(path).deleteSync(recursive: true);
    }
  }
}
