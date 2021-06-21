import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/order_button.dart';
import '../widgets/app_drawer.dart';
import '../widgets/cart_item.dart';
import '../providers/cart.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const routeName = "./cart";

  @override
  Widget build(BuildContext context) {
    var cartData = Provider.of<Cart>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Your cart"),
      ),
      drawer: AppDrawer(),
      body: Column(
        children: [
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                      backgroundColor: Theme.of(context).primaryColor,
                      label: Text(
                        "\$${cartData.totalAmount.toStringAsFixed(2)}",
                        style: TextStyle(
                            color: Theme.of(context)
                                .primaryTextTheme
                                .headline6!
                                .color),
                      )),
                  OrderButton(cart: cartData,)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: cartData.cart.length,
                  itemBuilder: (ctx, i) => CartItem(
                      cartData.cart.values.elementAt(i).id,
                      cartData.cart.keys.elementAt(i),
                      cartData.cart.values.elementAt(i).name,
                      cartData.cart.values.elementAt(i).quantity,
                      cartData.cart.values.elementAt(i).price)))
        ],
      ),
    );
  }
}
