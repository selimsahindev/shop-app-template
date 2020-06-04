import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/product_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavorites;

  ProductsGrid({this.showFavorites});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      itemCount: products.length,
      itemBuilder: (context, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
