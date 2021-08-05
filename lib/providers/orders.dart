import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../api/orders_api.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final timestamp = DateTime.now();
    var orderId = await OrdersApi().addOrder(products, total, timestamp);
    _orders.add(OrderItem(
        id: orderId, amount: total, products: products, dateTime: timestamp));
    notifyListeners();
  }

  Future<void> fetchOrders() async {
    var ordersMap = await OrdersApi().fetchOrders();
    _orders = [];

    if (ordersMap != null) {
      ordersMap.forEach((key, value) {
        var orderItem = OrderItem(
            id: key,
            amount: value["amount"],
            dateTime: DateTime.parse(value['dateTime']),
            products: (value["products"] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['id'],
                    price: item['price'],
                    name: item['name'],
                    quantity: item['quantity']))
                .toList());
        _orders.add(orderItem);
      });
      _orders.reversed.toList();
      notifyListeners();
    }
  }
}
