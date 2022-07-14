import 'package:flutter/material.dart';
import 'package:flutter_network_cacher/flutter_network_cacher.dart';

import '../widgets/custom_text_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    Fnc().init();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextButton(
              label: "Image Caching",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
