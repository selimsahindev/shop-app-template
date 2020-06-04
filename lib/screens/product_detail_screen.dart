import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shopapp/providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/product_detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Products>(
      context,
      listen: false,
    ).findById(productId);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10.0),
                Text(
                  '\$${loadedProduct.price}',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 20.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.0),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 800),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
