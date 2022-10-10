import 'package:objectbox/objectbox.dart';

@Entity()
class ResponseStorageModel {
  int id;
  String uniqueUrl;
  String? data;
  DateTime dateAdded;

  ResponseStorageModel({
    required this.uniqueUrl,
    required this.data,
    required this.dateAdded,
    this.id = 0,
  });
}
