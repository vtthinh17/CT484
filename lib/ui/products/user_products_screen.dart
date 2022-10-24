// import 'dart:js';
import 'package:myshop/ui/screens.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'user_product_list_tile.dart';
import 'products_manager.dart';
import '../shared/app_drawer.dart';
class UserProductsScreen extends StatelessWidget{
  const UserProductsScreen({super.key});
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext context) async{
    await context.read<ProductsManager>().fetchProducts(true);
  }

  @override
  Widget build(BuildContext context){
    // final productsManager = ProductsManager();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          buildAddButton(context)
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator(),);
          }
          return RefreshIndicator(
            onRefresh: () => _refreshProducts(context),
            child: buildUserProductListView(),
          );
        }
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

  Widget buildAddButton(BuildContext context){
    return IconButton(
      onPressed: () {
        Navigator.of(context).pushNamed(EditProductScreen.routeName);
      },
      icon: const Icon(Icons.add)
      );
  }
}

