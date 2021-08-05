import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart_screen.dart';
import '../widgets/app_drawer.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

enum FilterOptions { Favourites, All }

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = "/product-overview";

  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;
  Future? _productsFuture;

  /*@override
  void didChangeDependencies() {
    if (_isInit) {
      _isLoading = true;
      Provider.of<Products>(context).fetchProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }*/

  Future _obtainProductsFuture() async{
    return await Provider.of<Products>(context, listen: false).fetchProducts();
  }


  @override
  void initState() {
    _productsFuture = _obtainProductsFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selected) {
                setState(() {
                  if (selected == FilterOptions.Favourites) {
                    _showOnlyFavourites = true;
                  } else {
                    _showOnlyFavourites = false;
                  }
                });
              },
              icon: Icon(Icons.more_vert),
              itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: Text("Only Favourites"),
                      value: FilterOptions.Favourites,
                    ),
                    PopupMenuItem(
                      child: Text("Show all"),
                      value: FilterOptions.All,
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch!,
              value: cart.itemCount.toString()
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(future: Provider.of<Products>(context, listen: false).fetchProducts(),
        builder: (ctx, dataSnapshot) {
          if(dataSnapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator(),);
          }else {
            if(dataSnapshot.error != null){
              return Center(child: Text("Somthing went wrong getting the products"),);
            }else {
              return ProductsGrid(_showOnlyFavourites);
            }
          }
        } ,
      )
    );
  }
}
