import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/providers/products.dart';

import '../providers/cart.dart';
import '../widgets/badge.dart';
import '../widgets/main_drawer.dart';
import '../widgets/product_grid.dart';

enum FavoriteOptions { All, Favorite }

class OverviewProductsScreen extends StatefulWidget {
  @override
  State<OverviewProductsScreen> createState() => _OverviewProductsScreenState();
}

class _OverviewProductsScreenState extends State<OverviewProductsScreen> {
  var _selectFavorite = false;
  var _isinitState = true;
  var _isLaoding = false;
  void didChangeDependencies() {
    if (_isinitState) {
      setState(() {
        _isLaoding = true;
      });

      Provider.of<Products>(context).fetchAndSetProducts().then((_) {
        setState(() {
          _isLaoding = false;
        });
      });
    }
    _isinitState = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        actions: [
          PopupMenuButton(
            onSelected: (FavoriteOptions selectedValue) {
              setState(() {
                if (selectedValue == FavoriteOptions.Favorite) {
                  _selectFavorite = true;
                } else {
                  _selectFavorite = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                  child: Text('Show Favorite'),
                  value: FavoriteOptions.Favorite),
              PopupMenuItem(child: Text('Show All'), value: FavoriteOptions.All)
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, ch) => Badge(
              child: ch as Widget,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () => Navigator.of(context).pushNamed('/cart'),
              icon: Icon(
                Icons.shopping_cart,
              ),
            ),
          ),
        ],
        title: Text('Shop App'),
      ),
      body: _isLaoding
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.pinkAccent,
              ),
            )
          : ProductGrid(_selectFavorite),
    );
  }
}
