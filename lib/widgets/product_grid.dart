import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool isFave;
  ProductGrid(this.isFave);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    final products = isFave ? productsData.FavoriteList : productsData.items;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) =>
          ChangeNotifierProvider.value(
        value: products[index],
        child: Container(
          padding: EdgeInsets.all(5),
          child: ProductItem(),
        ),
      ),
    );
  }
}
