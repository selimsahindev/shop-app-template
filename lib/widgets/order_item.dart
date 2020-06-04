import 'dart:math';
import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:shopapp/providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: _expanded
          ? min(widget.order.products.length * 20.0 + 120, 200.0)
          : 95.0,
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
              subtitle: Text(
                  DateFormat('dd/MM/yyy hh:mm').format(widget.order.dateTime)),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
              height: _expanded
                  ? min(widget.order.products.length * 20.0 + 25, 100.0)
                  : 0,
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${prod.quantitiy}x \$${prod.price}',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ))
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
