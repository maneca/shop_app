import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import '../providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";
  
  @override
  Widget build(BuildContext context) {
    final String productId = ModalRoute.of(context).settings.arguments;
    final Product loadedProduct =
        Provider.of<Products>(
            context,
            listen: false // when it is false, the widget does not get rebuilt whenever a new product is added to the product list
            // It is relevant for situations where you just want to get the information and are not interested in updates
        ).findProductById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.name),
      ),
    );
  }
}
