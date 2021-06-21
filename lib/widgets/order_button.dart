import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/orders.dart';
import '../models/error_dialog.dart';

class OrderButton extends StatefulWidget {
  const OrderButton({Key? key, required this.cart}) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  void _updateLoadingWidget(){
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.cart.totalAmount == 0 || _isLoading) ? null : () async {
          _updateLoadingWidget();
          try{
            await Provider.of<Orders>(context, listen: false)
                .addOrder(
                widget.cart.cart.values.toList(), widget.cart.totalAmount);
            _updateLoadingWidget();
            widget.cart.clearCart();
          }catch(error){
            await ErrorDialog().showCustomDialog(context, error.toString());
          }
        },
        child: _isLoading ? CircularProgressIndicator() : Text(
          "ORDER NOW",
          style: TextStyle(color: Theme.of(context).primaryColor),
        ));
  }
}
