import 'package:flutter/material.dart';
import 'ui/screens.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async{
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ProductsManager()),
        ChangeNotifierProvider(create: (context) => CartManager()),
        ChangeNotifierProvider(create: (context) => OrdersManager()),
        ChangeNotifierProvider(create: (context) => AuthManager()),
      ],
      child: Consumer<AuthManager>(
        builder: (context, authManager, child) {
          return MaterialApp(
            title: 'My Shop',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Lato',
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.purple,
              ).copyWith(
                secondary: Colors.deepOrange
              ),      
            ),
            home: authManager.isAuth 
            ?const ProductsOverviewScreen()
            :FutureBuilder(
              future: authManager.tryAutoLogin(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                  ? const SplashScreen()
                  : const AuthScreen();
                }
              ),           
            routes: {
              CartScreen.routeName:(context) => const CartScreen(),
              OrdersScreen.routeName:(context) => const OrdersScreen(),
              UserProductsScreen.routeName:(context) => const UserProductsScreen(),
            },
            onGenerateRoute: (settings){
              if (settings.name == EditProductScreen.routeName){
                final productId = settings.arguments as String?;
                return MaterialPageRoute(builder: (context){
                  return EditProductScreen(
                    productId != null
                    ?context.read<ProductsManager>().findByID(productId)
                    :null
                  );
                });
              }
              return null;
            },
          );
        },
       
      ),
    );
  }
}


