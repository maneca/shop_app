import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/auth.dart';

import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';
import './screens/user_products_screen.dart';
import './screens/auth_screen.dart';
import './screens/splash_screen.dart';

import './providers/orders.dart';
import './providers/products.dart';
import './providers/cart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Auth()),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (_) => Products("", "", []),
          update: (_, auth, previousProducts) => Products(
              auth.userId,
              auth.token,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders("", "", []),
          update: (_, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
                title: 'MyShop',
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                  accentColor: Colors.deepOrange,
                  fontFamily: "Lato",
                  visualDensity: VisualDensity.adaptivePlatformDensity,
                ),
                home: auth.isAuth
                    ? ProductsOverviewScreen()
                    : FutureBuilder(
                        future: auth.tryAutoLogin(),
                        builder: (ctx, authResultSnapshot) =>
                            authResultSnapshot.connectionState ==
                                    ConnectionState.waiting
                                ? SplashScreen()
                                : AuthScreen()),
                routes: {
                  ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                  CartScreen.routeName: (ctx) => CartScreen(),
                  OrdersScreen.routeName: (ctx) => OrdersScreen(),
                  UserProductsScreen.routeName: (cts) => UserProductsScreen(),
                  EditProductScreen.routeName: (cts) => EditProductScreen()
                },
              )),
    );
  }
}
