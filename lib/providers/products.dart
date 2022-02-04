import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }

  List<Product> get FavoriteList {
    return _items.where((productItem) => productItem.isFavorite).toList();
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-b4316-default-rtdb.asia-southeast1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);

      final extractedProducts =
          jsonDecode(response.body) as Map<String, dynamic>;
          if (extractedProducts.isEmpty) {
            return;
          }
      final List<Product> loadedProducts = [];

      extractedProducts.forEach((prodId, prodData) {
        loadedProducts.insert(
          0,
          Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addProducts(Product product) async {
    final url = Uri.https(
        'flutter-shop-b4316-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/products.json');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            "title": product.title,
            "price": product.price,
            "description": product.description,
            "imageUrl": product.imageUrl,
            "isFavorite": product.isFavorite,
          },
        ),
      );
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      print(error);

      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final proIndex = items.indexWhere((prod) => prod.id == id);
    if (proIndex >= 0) {
      final Uri url = Uri.parse(
          'https://flutter-shop-b4316-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[proIndex] = newProduct;
      print(proIndex);
      notifyListeners();
    } else {
      print('...');
    }
  }

  Future<void> removeProduct(String id) async {
    final Uri url = Uri.parse(
        'https://flutter-shop-b4316-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json');
    final existingProdctIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProdctIndex];
    _items.removeAt(existingProdctIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProdctIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct = null;
  }
}
