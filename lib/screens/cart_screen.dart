import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'orders_screen.dart';
import '../widgets/cart_item.dart';
import '../providers/order.dart';
import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.items.length,
              itemBuilder: (BuildContext context, int index) => Container(
                child: CartItem(
                  cart.items.values.toList()[index].id,
                  cart.items.keys.toList()[index],
                  cart.items.values.toList()[index].title,
                  cart.items.values.toList()[index].price,
                  cart.items.values.toList()[index].quantity,
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.all(5),
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total :',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 15),
                    child: Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        '${cart.totalAmount.toStringAsFixed(2)}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  Spacer(),
                  OrderButton(orderData: orderData, cart: cart)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.orderData,
    required this.cart,
  }) : super(key: key);

  final Order orderData;
  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: widget.cart.totalAmount <= 0 ||_isLoading
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });

              await widget.orderData.addToOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                _isLoading=false;
              });
              widget.cart.CartClear();
            },
      child:_isLoading?CircularProgressIndicator(): Text('Add To Order', style: TextStyle(color: Colors.white)),
      color: Colors.teal.shade700,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    );
  }
}
