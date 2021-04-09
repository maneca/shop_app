import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/orders.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.order.amount}"),
            subtitle: Text(
                DateFormat("dd/MM/yyyy hh:mm").format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(
                _expanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 40.0 + 10, 100),
              child: Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Product",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            "Quantity",
                            style: TextStyle(fontSize: 15, color: Colors.grey),
                          ),
                        ),
                        Text(
                          "Unit Price",
                          style: TextStyle(fontSize: 15, color: Colors.grey),
                        ),
                      ]),
                  Expanded(
                    child: ListView.builder(
                        itemCount: widget.order.products.length,
                        itemBuilder: (ctx, i) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    widget.order.products[i].name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Spacer(),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                                    child: Text(
                                      "${widget.order.products[i].quantity}",
                                      style: TextStyle(
                                          fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Text(
                                    "\$${widget.order.products[i].price}",
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
