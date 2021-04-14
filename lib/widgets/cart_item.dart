import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final String name;
  final int quantity;
  final double price;

  CartItem(this.id, this.productId, this.name, this.quantity, this.price);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      ),
      confirmDismiss: (direction) => showAlertDialog(context, direction),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: Padding(
            padding: EdgeInsets.all(5),
            child: CircleAvatar(
              child: FittedBox(child: Text("\$$price")),
            ),
          ),
          title: Text(name),
          subtitle: Text("${price * quantity}"),
          trailing: Text("$quantity x"),
        ),
      ),
    );
  }

  Future<bool> showAlertDialog(BuildContext context, DismissDirection _) {
    return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("Are you sure?"),
              content:
                  Text("Do you really want to remove this item from the cart?"),
              actions: [
                TextButton(onPressed: () {
                  Navigator.of(context).pop(false);
                }, child: Text("NO")),
                TextButton(onPressed: () {
                  Navigator.of(context).pop(true);
                }, child: Text("YES")),
              ],
            ));
  }
}
