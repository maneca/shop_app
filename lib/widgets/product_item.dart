import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/error_dialog.dart';
import '../screens/product_detail_screen.dart';
import '../providers/product.dart';
import '../providers/cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context);

    // listen is set to false because we don't need for the whole widget to rebuild
    // when only the isFavourite property changes
    // We wrap the IconButton in a Consumer widget because it is only necessary
    // to rebuild the favourite icon

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () async{
                try{
                  await product.toggleFavourite();
                }catch(error){
                  await ErrorDialog().showCustomDialog(context, error.toString());
                }
              },
            ),
          ),
          title: Text(
            product.name,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItemToCart(product.id, product.price, product.name);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Added item to cart"),
                duration: Duration(seconds: 2),
                action: SnackBarAction(label: "UNDO", onPressed: (){
                  cart.removeSingleItem(product.id);
                },),
              ));
            },
          ),
        ),
      ),
    );
  }
}
