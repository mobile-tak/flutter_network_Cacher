import 'dart:typed_data';

import 'package:objectbox/objectbox.dart';

@Entity()
class ImageModel {
  int id;
  String url;
  Uint8List imageData;

  ImageModel({required this.imageData, required this.url, this.id = 0});
}
