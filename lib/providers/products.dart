import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:shopapp/models/http_exception.dart';
import 'package:shopapp/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((product) => product.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts([bool filterByUser = false]) async {
    final filterString =
        filterByUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';
    // TODO: Check URL (products.dart)
    var url =
        'https://APP-RELEVANT.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      // TODO: Check URL (products.dart)
      url =
          'https://APP-RELEVANT.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.insert(
            0,
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
              imageUrl: prodData['imageUrl'],
            ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    // TODO: Check URL (products.dart)
    final String url =
        'https://APP-RELEVANT.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imageUrl': product.imageUrl,
          'creatorId': userId,
        }),
      );
      final Product newProduct = Product(
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl,
          id: json.decode(response.body)['name'] // Returns assigned product id,
          );
      //_items.add(newProduct); // at the start of the list
      _items.insert(0, newProduct); // at the end of the list
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      // TODO: Check URL (products.dart)
      final String url =
          'https://APP-RELEVANT.firebaseio.com/products/$id.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'price': newProduct.price,
          'imageUrl': newProduct.imageUrl,
        }),
      );
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  // Optimistic Updating Example
  Future<void> deleteProduct(String id) async {
    // TODO: Check URL (products.dart)
    final String url =
        'https://APP-RELEVANT.firebaseio.com/products/$id.json?auth=$authToken';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    var existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
