import 'dart:convert';
import 'dart:typed_data';

class StringHelper {
  StringHelper._();

  static Uint8List stringToUnit8List(String str) {
    List<int> list = utf8.encode(str);
    Uint8List bytes = Uint8List.fromList(list);
    return bytes;
  }

  static String uint8ListToString(Uint8List byte) {
    return utf8.decode(byte);
  }
}
