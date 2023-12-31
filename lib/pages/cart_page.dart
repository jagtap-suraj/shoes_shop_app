import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shoes_shop_app/providers/cart_provider.dart';
import 'package:shoes_shop_app/pages/home_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;

    // Function to handle item removal and display snackbar
    void removeCartItem(BuildContext context, dynamic cartItem) {
      final cartProvider = context.read<CartProvider>();

      // Show a snackbar with an undo option
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Item removed from cart'),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              // Add the removed item back to the cart
              cartProvider.addProduct(cartItem);
            },
          ),
        ),
      );

      // Remove the item from the cart
      cartProvider.removeProduct(cartItem);
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Cart Page'),
      ),
      body: ListView.builder(
        itemCount: cart.length,
        itemBuilder: ((context, index) {
          final cartItem = cart[index];

          return Dismissible(
            key: Key(cartItem['productId'].toString()),
            background: Container(
              color: Colors.red,
              child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            onDismissed: (direction) {
              removeCartItem(context, cartItem);
            },
            direction: DismissDirection.startToEnd,
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(cartItem['imageUrl'].toString()),
                radius: 30,
              ),
              title: Text(
                cartItem['title'].toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              subtitle: Text(cartItem['size'].toString()),
              trailing: IconButton(
                onPressed: () {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(
                          'Delete Product',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        content: Text(
                          'Are you sure you want to delete this product?',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              removeCartItem(context, cartItem);
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
