import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String description;
  final String title;
  final double price;
  final String imageUrl;
  bool isFavorite;
  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});
  void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }
  Future<void> toggledStatusFavorite() async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    final url = Uri.parse(
        'https://flutter-shop-b4316-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    try {
      final response =
          await http.patch(url, body: json.encode({'isFavorite': isFavorite}));
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
      notifyListeners();
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}
