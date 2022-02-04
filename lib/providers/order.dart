import 'dart:convert';

import 'package:flutter/material.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final DateTime time;
  final List<CartItem> products;
  OrderItem(
      {required this.id,
      required this.amount,
      required this.time,
      required this.products});
}

class Order with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }
//comment 1 : create a function to fetch and set data of orders
  Future<void> setAndFetchOrders() async {
    final url = Uri.parse(
        'https://flutter-shop-b4316-default-rtdb.asia-southeast1.firebasedatabase.app/orders.json');
    final response = await http.get(url);
    final List<OrderItem> laodedOrders = [];
    //comment 2 : store data from database to extractedData
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    //comment 3 : if order list was empty return nothing
    if (extractedData.isEmpty) {
      return;
    }
    //comment 4 : with forEach we can render list of data  to laodedOrders and add them to this list with add()

    extractedData.forEach((orderId, orderData) {
      laodedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          time: DateTime.parse(orderData['time']),
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                  id: item['id'],
                  title: item['title'],
                  price: item['price'],
                  quantity: item['quantity'])).toList()
              ));
    });
    //comment 5 : after release laodedOrders to _orders and reversed for put last order at top of list
    _orders=laodedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addToOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.https(
        'flutter-shop-b4316-default-rtdb.asia-southeast1.firebasedatabase.app',
        '/orders.json');
    final stampTime = DateTime.now().toIso8601String();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'time': stampTime,
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList()
        }));
    _orders.insert(
      0,
      OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          time: DateTime.now(),
          products: cartProducts),
    );
    notifyListeners();
  }
}
