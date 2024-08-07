class Pixbayimagemodel {
  Pixbayimagemodel(
      {required this.largeImageURL,
      required this.previewURL,
      required this.likes,
      required this.views});

  final String previewURL;
  final String largeImageURL;
  final int likes;
  final int views;
}
