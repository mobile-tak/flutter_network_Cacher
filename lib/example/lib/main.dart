import 'package:example/objbox/object_box.dart';
import 'package:example/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

late ObjectBox objectBox;

void main() async {
  ImageCache().maximumSize = 5;
  WidgetsFlutterBinding.ensureInitialized();
  objectBox = await ObjectBox.init();
  objectBox.clearCache();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}
