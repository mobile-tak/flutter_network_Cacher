import 'package:example/main.dart';
import 'package:example/objbox/model/generated/objectbox.g.dart';
import 'package:example/presentation/pages/image_caching_page.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_text_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // Fnc().init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
            width: double.infinity,
          ),
          CustomTextButton(
            label: "Image Caching",
            onTap: () {
              // objectBox.clearCache();
              // ImageCache().clear();
              // ImageCache().clearLiveImages();
              // ImageCache().maximumSize = 12;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ImageCachingPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
