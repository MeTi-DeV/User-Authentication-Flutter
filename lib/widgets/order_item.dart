import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/order.dart' as orde;

class OrderItem extends StatefulWidget {
  final orde.OrderItem order;
  OrderItem(this.order);
  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var isShowMore = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text('\$ ${widget.order.amount}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            subtitle: Text(
              DateFormat.MMMMEEEEd().format(widget.order.time),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  isShowMore = !isShowMore;
                });
              },
              icon: Icon(isShowMore ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (isShowMore)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20 + 10, 100),
              child: ListView(
                children: [
                  ...widget.order.products.map(
                    (product) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            product.title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${product.quantity}x ${product.price} \$',
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      );
                    },
                  ).toList()
                ],
              ),
            ),
        ],
      ),
    );
  }
}
