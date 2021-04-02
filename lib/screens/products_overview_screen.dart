import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
 Favourites,
 All
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavourites = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyShop"),
        actions: [
          PopupMenuButton(
            onSelected: (FilterOptions selected) {
              setState(() {
                if(selected == FilterOptions.Favourites){
                  _showOnlyFavourites = true;
                }else{
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
                  ])
        ],
      ),
      body: new ProductsGrid(_showOnlyFavourites),
    );
  }
}
