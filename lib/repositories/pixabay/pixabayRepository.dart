import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery/repositories/pixabay/models/pixbayImageModel.dart';

class PixabayRepository {
  Future<List<Pixbayimagemodel>> getImages(String s, int page) async {
    if (page <= 3) {
      final response = await Dio().get(
          "https://pixabay.com/api/?key=45291057-9b62335031d534d05a91dfbe8&q=$s&per_page=200&page=$page");

      final data = response.data as Map<String, dynamic>;
      final List hits = data['hits'];
      final hitsData = hits
          .map((e) => Pixbayimagemodel(
              largeImageURL: e["largeImageURL"],
              previewURL: e["webformatURL"],
              likes: e["likes"],
              views: e["views"]))
          .toList();

      debugPrint(hitsData.toString());
      return hitsData;
    } else {
      return [];
    }
  }
}
