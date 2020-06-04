import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/providers/products.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  UserProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100.0,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: id);
              },
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Products>(context, listen: false)
                      .deleteProduct(id);
                } catch (e) {
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(
                        'Deleting Failed',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
