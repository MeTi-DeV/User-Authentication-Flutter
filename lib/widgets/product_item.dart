import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String imageUrl;
  // final String title;
  // final double price;
  // ProductItem(this.id, this.imageUrl, this.title, this.price);
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    final cart = Provider.of<Cart>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context)
                .pushNamed('product-details', arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(product.title, textAlign: TextAlign.center),
          leading: Consumer<Product>(builder: (context, product, _) {
            return IconButton(
              onPressed: () => product.toggledStatusFavorite(),
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
            );
          }),
          trailing: IconButton(
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();

              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('You add new product to your cart'),
                duration: Duration(seconds: 1),
                action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () => cart.removeRecentItem(product.id)),
              ));
            },
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }
}

//
