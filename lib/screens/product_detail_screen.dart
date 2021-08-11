import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;
    final Product loadedProduct = Provider.of<Products>(context,
            listen:
                false // when it is false, the widget does not get rebuilt whenever a new product is added to the product list
            // It is relevant for situations where you just want to get the information and are not interested in updates
            )
        .findProductById(productId);

    return Scaffold(
      body: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: Container(
                child: Text(
                  loadedProduct.name,
                  textAlign: TextAlign.start,
                ),
                width: double.infinity,
                height: 30,
                color: Theme.of(context).primaryColor),
            background: Hero(
              tag: loadedProduct.id,
              child: Image.network(
                loadedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
          SizedBox(
            height: 10,
          ),
          Text(
            "\$${loadedProduct.price}",
            style: TextStyle(color: Colors.grey, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "${loadedProduct.description}",
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
              SizedBox(height: 800,)
        ]))
      ]),
    );
  }
}
