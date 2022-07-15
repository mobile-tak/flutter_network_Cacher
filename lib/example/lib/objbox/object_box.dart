import 'dart:io';
import 'dart:typed_data';

import 'package:example/objbox/model/generated/objectbox.g.dart';
import 'package:example/objbox/model/image_model/image_model.dart';
import 'package:flutter/foundation.dart';

class ObjectBox {
  late final Store _store;
  late final Box<ImageModel> _imageBox;

  ObjectBox._init(this._store) {
    _imageBox = Box<ImageModel>(_store);
  }

  static Future<ObjectBox> init() async {
    final store = await openStore();
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

  clearCache() {
    _imageBox.removeAll();
    // Directory(_store.directoryPath).deleteSync(recursive: true);
  }
}
