import 'dart:async';
import 'dart:ui' as im;
import 'package:http/http.dart' as http;
import 'package:example/main.dart';
import 'package:example/presentation/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class ImageCachingPage extends StatefulWidget {
  const ImageCachingPage({Key? key}) : super(key: key);

  @override
  State<ImageCachingPage> createState() => _ImageCachingPageState();
}

class _ImageCachingPageState extends State<ImageCachingPage> {
  int totalImageFetched = 0;
  String imageUrl() => "https://placekitten.com/400/$totalImageFetched";

  String imageUrls = "https://placekitten.com/400/";

  ScrollController scrollController = ScrollController();

  getSingleImage() async {
    http.Response response = await http.get(Uri.parse(imageUrl()));
    objectBox.insertImage(url: imageUrl(), imageData: response.bodyBytes);
    totalImageFetched += 1;
    setState(() {});
  }

  // animateController(){
  //   scrollController.position.
  // }

  @override
  void initState() {
    // log(objectBox.getImage(url: imageUrl)?.imageData?.toString() ?? "");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
            ),
            Text("Total Fetched $totalImageFetched"),
            // CachedNetworkImage(
            //   imageUrl: imageUrl,
            //   placeholder: (a, b) {
            //     return CircularProgressIndicator();
            //   },
            //   width: 400,
            //   height: 200,
            //   fit: BoxFit.fill,
            //   errorWidget: (c, e, d) {
            //     return Icon(Icons.error);
            //   },
            // ),
            CustomTextButton(
              label: "Fetch Images",
              onTap: () async {
                for (var i = 0; i < 500; i++) {
                  await getSingleImage();
                }
              },
            ),
            Expanded(
              child: ListView.builder(
                // controller: ,
                physics: CustomScrollPhysics(),
                itemCount: 500,
                itemBuilder: (context, index) {
                  return Container(
                    margin: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Text(index.toString()),
                        // Stack(
                        //   alignment: Alignment.center,
                        //   children: [
                        //     CachedNetworkImage(
                        //         placeholder: (context, url) {
                        //           return SizedBox(
                        //             // width: double.infinity,
                        //             // height: 100,
                        //             child: const CircularProgressIndicator(),
                        //           );
                        //         },
                        //         errorWidget: (_, e, f) {
                        //           return const Icon(Icons.error);
                        //         },
                        //         fadeInDuration: Duration(seconds: 0),
                        //         fadeOutDuration: Duration(seconds: 0),
                        //         imageUrl: imageUrls + index.toString()),
                        //     Text(
                        //       "Cache Manger",
                        //       style: TextStyle(color: Colors.white),
                        //     ),
                        //   ],
                        // ),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomImageWidget(
                              url: imageUrls + index.toString(),
                            ),
                            Text(
                              "Custom Image Manger",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomSimulation extends Simulation {
  final double initPosition;
  final double velocity;

  CustomSimulation({required this.initPosition, required this.velocity});

  @override
  double x(double time) {
    var max =
        math.max(math.min(initPosition, 0.0), initPosition + velocity * time);
    return max;
  }

  @override
  double dx(double time) {
    return 2500;
  }

  @override
  bool isDone(double time) {
    return false;
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  @override
  ScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics();
  }

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    return CustomSimulation(
      initPosition: position.pixels,
      velocity: velocity,
    );
  }
}

Map<String, List<int>> memCache = {};

insertToMemCache(String imageUrl, int width, int height) {
  memCache[imageUrl] = [width, height];
}

int getMemWidth(String imageUrl) {
  return memCache[imageUrl]?.first ?? 0;
}

int getMemHeight(String imageUrl) {
  return memCache[imageUrl]?.last ?? 0;
}

class CustomImageWidget extends StatefulWidget {
  final String url;

  const CustomImageWidget({super.key, required this.url});

  @override
  State<CustomImageWidget> createState() => _CustomImageWidgetState();
}

class _CustomImageWidgetState extends State<CustomImageWidget> {
  // Uint8List? uint8image;

  im.Image? image;

  @override
  void initState() {
    super.initState();
  }

  // Future<Uint8List> getSingleImage() async {
  //   if (uint8image != null) {
  //     return uint8image!;
  //   }

  //   var localImage = objectBox.getImage(url: widget.url);
  //   if (localImage != null) {
  //     uint8image = localImage.imageData;
  //     return localImage.imageData;
  //   }
  //   http.Response response = await http.get(Uri.parse(widget.url));

  //   var byteData = response.bodyBytes;

  //   objectBox.insertImage(url: widget.url, imageData: byteData);
  //   uint8image = byteData;
  //   return byteData;
  // }

  Future<im.Image> getSingleImageFile() async {
    if (image != null) {
      return image!;
    }

    var localImage = objectBox.getImage(url: widget.url);
    if (localImage != null) {
      var res = await decodeImageFromList(localImage.imageData);
      // insertToMemCache(widget.url, res.width, res.height);
      return res;
    }
    http.Response response = await http.get(Uri.parse(widget.url));

    var byteData = response.bodyBytes;

    objectBox.insertImage(url: widget.url, imageData: byteData);
    // uint8image = byteData;

    var res = await decodeImageFromList(byteData);
    // insertToMemCache(widget.url, res.width, res.height);
    return res;
  }

  @override
  Widget build(BuildContext context) {
    im.Image;

    // return Image.memory(
    //   (objectBox.getImage(url: widget.url)?.imageData)!,
    //   width: double.infinity,
    //   height: 100,
    //   fit: BoxFit.fill,
    // );
    return FutureBuilder<im.Image>(
      // future: getSingleImage(),
      future: getSingleImageFile(),

      initialData: null,
      builder: (context, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 1),
          child: snapshot.hasData
              ? RawImage(
                  image: snapshot.data,
                  // width: ScreenUtil.instance.setWidth(600),
                  // height: ScreenUtil.instance.setWidth(400),
                )
              : SizedBox(
                  // width: getMemWidth(widget.url).toDouble(),
                  // height: getMemHeight(widget.url).toDouble(),
                  child: const CircularProgressIndicator(),
                ),
        );

        if (snapshot.hasData) {
          return RawImage(
            fit: BoxFit.fill,
            image: snapshot.data,
            height: 100,
            width: double.infinity,
          );
          // return Image.memory(
          //   snapshot.data!,
          //   width: double.infinity,
          //   height: 100,
          //   fit: BoxFit.fill,
          // );
        } else if (snapshot.hasError) {
          return const Icon(Icons.error);
        } else {
          return SizedBox(
            width: double.infinity,
            height: 100,
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
