import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: [
            ListTile(
              onTap: () => Navigator.of(context).pushReplacementNamed('/'),
              title: Text('Shop'),
              leading: Icon(Icons.shopping_bag_rounded, color: Colors.grey),
            ),
            ListTile(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed('/order-screen'),
              title: Text('Billing'),
              leading: Icon(Icons.payment_rounded, color: Colors.grey),
            ),
            ListTile(
              onTap: () =>
                  Navigator.of(context).pushReplacementNamed('/user-product'),
              title: Text('Manage Products'),
              leading: Icon(Icons.edit, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
