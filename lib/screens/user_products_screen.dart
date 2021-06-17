import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './edit_product_screen.dart';
import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../models/error_dialog.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = './user-products';

  Future<void> _refreshProducts(BuildContext context) async{
    try{
      await Provider.of<Products>(context, listen: false).fetchProducts();
    }catch(error){
      await ErrorDialog().showCustomDialog(context, error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text("Your products"),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName);
                })
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (_, index) => UserProductItem(
                  productsData.items[index].id,
                  productsData.items[index].name,
                  productsData.items[index].imageUrl),
              itemCount: productsData.items.length,
            ),
          ),
        ));
  }
}
