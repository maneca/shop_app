import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/edit_product_screen.dart';
import '../providers/products.dart';
import '../models/error_dialog.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String name;
  final String imageUrl;

  UserProductItem(this.id, this.name, this.imageUrl);

  Future<void> _deleteProduct(BuildContext context, String id) async {
      await Provider.of<Products>(context, listen: false).deleteProduct(id).catchError((error) async {
        await ErrorDialog().showCustomDialog(context, error.toString());
      });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      child: ListTile(
        title: Text(name),
        leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
        trailing: Container(
            width: 100,
            child: Row(
              children: [
                IconButton(
                    icon: Icon(Icons.edit),
                    color: Theme.of(context).primaryColor,
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                          EditProductScreen.routeName,
                          arguments: id);
                    }),
                IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () async => await _deleteProduct(context, id)),
              ],
            )),
      ),
    );
  }
}
