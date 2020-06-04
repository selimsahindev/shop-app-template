import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/providers/orders.dart' show Orders;
import 'package:shopapp/widgets/app_drawer.dart';
import 'package:shopapp/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    //we won't init provider here to prevent infinite loop. we'll use consumer()
    //final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
        builder: (context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              return Center(
                child: Text('An error occured!'),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, orderData, child) => ListView.builder(
                  itemCount: orderData.orders.length,
                  itemBuilder: (context, i) => OrderItem(orderData.orders[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
