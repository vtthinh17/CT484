// import 'dart:js';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'user_product_list_tile.dart';
import 'products_manager.dart';
import '../shared/app_drawer.dart';
class UserProductsScreen extends StatelessWidget{
  const UserProductsScreen({super.key});
  static const routeName = '/user-products';
  @override
  Widget build(BuildContext context){
    // final productsManager = ProductsManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          buildAddButton()
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => print('refresh products'),
        child: buildUserProductListView(),
      ),
    );
  }

  Widget buildUserProductListView(){
    return Consumer<ProductsManager>(
      builder:(context, productsManager, child){
        return ListView.builder(
          itemCount: productsManager.itemCount,
          itemBuilder: ((context, index) => Column(
            children: [ 
              UserProductListTile(productsManager.items[index]),
              const Divider()
            ],
          )),
        );
      },
    );
  }

  Widget buildAddButton(){
    return IconButton(
      onPressed: () => print('Go to edit product screen'),
      icon: const Icon(Icons.add)
      );
  }
}

