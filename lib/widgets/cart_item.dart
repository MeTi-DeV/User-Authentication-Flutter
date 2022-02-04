import '../providers/cart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String title;
  final double price;
  final int quantity;
  CartItem(this.id, this.productId, this.title, this.price, this.quantity);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Delete Item'),
            content: Text('Are you sure you want to delete ${title}'),
            actions: [
              FlatButton(
                color: null,
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(
                  'No',
                  style: TextStyle(color: Colors.red.shade800),
                ),
              ),
              FlatButton(
                color: null,
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(
                  'Yes',
                  style: TextStyle(color: Colors.blue.shade800),
                ),
              ),
            ],
          ),
        );
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          child: Row(
            textDirection: TextDirection.rtl,
            children: [
              Icon(
                Icons.delete,
                color: Colors.white,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Delete',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Lato',
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: ListTile(
          leading: Container(
              child: Text(
            '${quantity} x',
            textAlign: TextAlign.center,
          )),
          title: Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          subtitle: Text('${(price * quantity).toStringAsFixed(2)}'),
          trailing: Container(
            decoration: BoxDecoration(
                color: Colors.pink.shade500,
                borderRadius: BorderRadius.circular(30)),
            padding: EdgeInsets.all(10),
            child: Text(
              '${price.toStringAsFixed(2)}\$',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (directin) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
    );
  }
}
