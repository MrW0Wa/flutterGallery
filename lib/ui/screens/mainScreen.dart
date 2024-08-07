import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gallery/repositories/pixabay/models/pixbayImageModel.dart';
import 'package:gallery/repositories/pixabay/pixabayRepository.dart';
import 'package:gallery/ui/widgets/imageList.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Pixbayimagemodel> images = [];
  Timer? _debounce;
  final TextEditingController controller = TextEditingController();

  void initAddImages() async {
    images.addAll(await PixabayRepository().getImages("", 1));
  }

  @override
  void initState() {
    initAddImages();
    super.initState();
    setState(() {});
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(
          children: [
            SizedBox(height: 30),
            SizedBox(
              height: 50,
              child: TextField(
                controller: controller,
                onChanged: (String value) async {
                  if (_debounce?.isActive ?? false) _debounce?.cancel();
                  _debounce =
                      Timer(const Duration(milliseconds: 500), () async {
                    images =
                        await PixabayRepository().getImages(controller.text, 1);
                    setState(() {});
                  });
                },
                maxLength: 100,
                maxLines: 1,
                style: Theme.of(context).textTheme.bodyMedium,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Color(0xFF282828),
                  hintText: "Введите запрос",
                  hintStyle: Theme.of(context).textTheme.bodyMedium,
                  contentPadding: EdgeInsets.all(10),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                flex: 12,
                child: ImageList(
                  images: images,
                  s: controller.text,
                ))
          ],
        ),
      ),
    );
  }
}
