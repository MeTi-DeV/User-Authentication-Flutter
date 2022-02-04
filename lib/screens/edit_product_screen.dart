import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit_screen';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _imageUrlController = TextEditingController();

  final _imageUrlFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();

  var _editProduct = Product(
    id: '',
    title: '',
    description: '',
    price: 0,
    imageUrl: '',
  );
  var _initValue = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };
  var _isLoading = false;
  var _isInstate = true;

  @override
  void initState() {
    _imageUrlController.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _imageUrlController.removeListener(_updateImageUrl);
    _imageUrlController.dispose();

    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInstate) {
      final productId = ModalRoute.of(context)!.settings.arguments == null
          ? "NULL"
          : ModalRoute.of(context)!.settings.arguments as String;
      if (productId != "NULL") {
        _editProduct =
            Provider.of<Products>(context, listen: false).findById(productId);
        _initValue = {
          'title': _editProduct.title,
          'description': _editProduct.description,
          'price': _editProduct.price.toString(),
          'imageUrl': '',
        };
        _imageUrlController.text = _editProduct.imageUrl;
      }
    }
    _isInstate = false;
    super.didChangeDependencies();
  }

  void _saveForm() async {
    final isSave = _form.currentState!.validate();
    if (!isSave) {
      return;
    }

    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    if (_editProduct.id != '') {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(_editProduct.id, _editProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProducts(_editProduct);
      } catch (error) {
        showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error ocurred'),
            content: Text('something went wrong'),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text('okay'),
              ),
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: _saveForm, icon: Icon(Icons.save))],
        title: Text('Edit Product'),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.pink[900],
              ),
            )
          : Form(
              key: _form,
              child: Container(
                margin: EdgeInsets.all(16),
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValue['title'],
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      onSaved: (value) {
                        _editProduct = Product(
                            id: _editProduct.id,
                            title: value as String,
                            description: _editProduct.description,
                            price: _editProduct.price,
                            imageUrl: _editProduct.imageUrl);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please provide a value';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValue['price'],
                      validator: (value) {
                        if (double.tryParse(value!) == null) {
                          return 'Please Enter a valid number';
                        }
                        if (value.isEmpty) {
                          return 'Please Enter a number';
                        }
                        if (double.parse(value) <= 0) {
                          return 'Please enter a number more than 0';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            id: _editProduct.id,
                            title: _editProduct.title,
                            description: _editProduct.description,
                            price: double.parse(value!),
                            imageUrl: _editProduct.imageUrl,
                            isFavorite: _editProduct.isFavorite);
                      },
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(labelText: 'price'),
                    ),
                    TextFormField(
                      initialValue: _initValue['description'],
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complate fields';
                        }
                        if (value.length < 10) {
                          return 'please enter characters more than 10';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editProduct = Product(
                            id: _editProduct.id,
                            isFavorite: _editProduct.isFavorite,
                            title: _editProduct.title,
                            description: value as String,
                            price: _editProduct.price,
                            imageUrl: _editProduct.imageUrl);
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,

                      decoration: InputDecoration(labelText: 'description'),
                      // focusNode: _descriptionFocusNode,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10, right: 8),
                          width: 100,
                          height: 100,
                          child: _imageUrlController.text.isEmpty
                              ? Text('Its Empty')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                            ),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter an URL Image';
                              }
                              if (!value.startsWith('http') &&
                                  (!value.startsWith('https'))) {
                                return 'Please Enter a correct URL Image';
                              }
                              if (!value.endsWith('.jpg') &&
                                  !value.endsWith('.png') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Please enter a correct Image with suffix (.jpg ,.png,.jpeg)';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _editProduct = Product(
                                  id: _editProduct.id,
                                  isFavorite: _editProduct.isFavorite,
                                  title: _editProduct.title,
                                  description: _editProduct.description,
                                  price: _editProduct.price,
                                  imageUrl: value as String);
                            },
                            controller: _imageUrlController,
                            keyboardType: TextInputType.url,
                            maxLines: 3,
                            textInputAction: TextInputAction.done,
                            decoration: InputDecoration(labelText: 'Enter Url'),
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveForm(),
                            onEditingComplete: () => setState(() {}),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
