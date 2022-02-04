import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/widgets/user_product_item.dart';

import '../providers/products.dart';
import '../widgets/main_drawer.dart';
import 'edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-product';

  Future<void> _refrshproducts(BuildContext context) async {
    Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () =>
                Navigator.of(context).pushNamed(EditProductScreen.routeName),
            icon: Icon(Icons.add),
          ),
        ],
        title: Text('Manage Products'),
      ),
      body: RefreshIndicator(
        onRefresh: () => _refrshproducts(context),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (BuildContext _, int i) {
            return Column(
              children: [
                UserProductItem(productsData.items[i].title,
                    productsData.items[i].imageUrl, productsData.items[i].id),
                Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
