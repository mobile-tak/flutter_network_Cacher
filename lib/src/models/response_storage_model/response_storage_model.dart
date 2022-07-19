import 'package:objectbox/objectbox.dart';

@Entity()
class ResponseStorageModel {
  int id;
  String uniqueUrl;
  String? data;

  ResponseStorageModel(
      {required this.uniqueUrl, required this.data, this.id = 0});
}
