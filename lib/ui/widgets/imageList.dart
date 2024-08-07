import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gallery/repositories/pixabay/models/pixbayImageModel.dart';
import 'package:gallery/repositories/pixabay/pixabayRepository.dart';

class ImageList extends StatefulWidget {
  List<Pixbayimagemodel> images;
  String s;
  ImageList({Key? key, required this.images, required this.s})
      : super(key: key);

  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  int page = 1;
  int width = 0;
  void addImages() async {
    page += 1;
    widget.images.addAll(await PixabayRepository().getImages(widget.s, page));
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      width = MediaQuery.of(context).size.width.toInt();
    });
    return Container(
      child: ListView.builder(
          controller: ScrollController(),
          itemBuilder: (context, index) {
            try {
              final rowImages = widget.images.getRange(
                  index * (width / 300).toInt(),
                  index * (width / 300).toInt() + (width / 300).toInt());
              List<Widget> row = [];
              rowImages.forEach(
                (element) {
                  row.add(Column(
                    children: [
                      InkWell(
                        onTap: () => showGeneralDialog(
                            context: context,
                            transitionBuilder: (context, a1, a2, widget) {
                              return Transform.scale(
                                scale: a1.value,
                                child: Opacity(
                                  opacity: a1.value,
                                  child: AlertDialog(
                                    content: Image.network(
                                      element.previewURL,
                                      fit: BoxFit.cover,
                                    ),
                                    actions: [
                                      TextButton(
                                        child: Text('вернуться'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            pageBuilder: (context, animation1, animation2) {
                              return Container();
                            }),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            element.previewURL,
                            height: 300,
                            width: 300,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      SizedBox(
                        width: 300,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "лайки: " + element.likes.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              " просмотры: " + element.views.toString(),
                              style: Theme.of(context).textTheme.bodySmall,
                            )
                          ],
                        ),
                      )
                    ],
                  ));
                },
              );
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: row,
                ),
              );
            } catch (e) {
              addImages();
              return SizedBox(
                height: 300,
                width: 300,
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                      textAlign: TextAlign.center,
                      "не удалось загрузить картинки, попробуйте включить впн или обновить запрос (ограничение api 500 изображений)",
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              );
            }
          }),
    );
  }
}
