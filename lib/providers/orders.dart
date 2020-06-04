import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:shopapp/providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  final String authToken;
  final String userId;

  Orders(this.authToken, this.userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrders() async {
    // TODO: Check URL (orders.dart)
    final String url =
        'https://APP-RELEVANT.firebaseio.com/orders/$userId.json?auth=$authToken';
    final response = await http.get(url);
    print(json.decode(response.body));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    final List<OrderItem> loadedOrders = [];
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(
        OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((item) => CartItem(
                    id: item['id'],
                    title: item['title'],
                    quantitiy: item['quantity'],
                    price: item['price'],
                  ))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    // TODO: Check URL (orders.dart)
    final String url =
        'https://APP-RELEVANT.firebaseio.com/orders/$userId.json?auth=$authToken';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'amount': total,
          'products': cartProducts
              .map((cartProduct) => {
                    'id': cartProduct.id,
                    'title': cartProduct.title,
                    'price': cartProduct.price,
                    'quantity': cartProduct.quantitiy,
                  })
              .toList(),
          'dateTime': timestamp.toIso8601String(),
        }),
      );
      // We are using insert() method instead of add(),
      // so more recent orders will always be at the beginning of the list
      _orders.insert(
        0,
        OrderItem(
          id: jsonDecode(response.body)['name'],
          amount: total,
          products: cartProducts,
          dateTime: timestamp,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
