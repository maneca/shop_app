import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final String name;
  final String imageUrl;

  UserProductItem(this.name, this.imageUrl);

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
                    onPressed: () {}),
                IconButton(
                    icon: Icon(Icons.delete),
                    color: Theme.of(context).errorColor,
                    onPressed: () {}),
              ],
            )),
      ),
    );
  }
}
