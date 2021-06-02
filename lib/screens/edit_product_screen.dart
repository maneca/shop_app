import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({Key key}) : super(key: key);
  static const routeName = "./edit-product";

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _editMode = false;
  Product _product = new Product(description: "", imageUrl: "", name: "", price: 0.0);

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    // we need to dispose of our manually created FocusNode to avoid memory leaks
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    if(_isInit){
      final productId = ModalRoute.of(context).settings.arguments as String;
      _isInit = false;
      if(productId != null){
        _editMode = true;
        _product = Provider.of<Products>(context, listen: false).findProductById(productId);
        _imageUrlController.text = _product.imageUrl;
      }
    }

    super.didChangeDependencies();
  }

  void _updateImageUrl(){
    if(!_imageUrlFocusNode.hasFocus)
      setState(() { });
  }

  void _saveForm(){
    if(_form.currentState.validate()){
      _form.currentState.save();
      if(!_editMode){
        Provider.of<Products>(context, listen: false).addProduct(_product);
      }else{
        Provider.of<Products>(context, listen: false).updateProduct(_product.id, _product);
      }

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Product"),
        actions: [
          IconButton(
              onPressed: () => _saveForm(),
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: _product.name,
                  decoration: InputDecoration(labelText: "Product name"),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(_priceFocusNode);
                  },
                  validator: (value){
                    if(value.isEmpty){
                      return "Please insert a value";
                    }

                    return null;
                  },
                  onSaved: (value){
                    _product.name = value;
                  },
                ),
                TextFormField(
                  initialValue: _product.price.toString(),
                  decoration: InputDecoration(labelText: "Price"),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  focusNode: _priceFocusNode,
                  onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value){
                    if(value.isEmpty){
                      return "Please insert a price";
                    }

                    if(double.tryParse(value) == null)
                      return "Please insert a valid price";

                    if(double.parse(value) < 0){
                      return "Only positive values are accepted";
                    }

                    return null;
                  },
                  onSaved: (value){
                    _product.price = double.parse(value);
                  },
                ),
                TextFormField(
                  initialValue: _product.description,
                  decoration: InputDecoration(labelText: "Description"),
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  focusNode: _descriptionFocusNode,
                  validator: (value){
                    if(value.isEmpty)
                      return "Please insert a description";

                    return null;
                  },
                  onSaved: (value){
                    _product.description = value;
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(top: 8, right: 10),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                          ? Text("Enter a URL")
                          : FittedBox(
                              child: Image.network(_imageUrlController.text),
                        fit: BoxFit.cover,
                            ),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: "Image URL"),
                        keyboardType: TextInputType.url,
                        textInputAction: TextInputAction.done,
                        controller: _imageUrlController,
                        focusNode: _imageUrlFocusNode,
                        onEditingComplete: (){
                          setState(() { });
                        },
                        onSaved: (value){
                          _product.imageUrl = value;
                        },
                        validator: (value){
                          if(value.isEmpty)
                            return "Please insert an image URL";

                          return null;
                        },
                        onFieldSubmitted: (_){
                          _saveForm();
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
