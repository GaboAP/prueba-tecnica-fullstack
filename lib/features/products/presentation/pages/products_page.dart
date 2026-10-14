import 'package:flutter/material.dart';
import '../bloc/product_bloc.dart';

class ProductsPage extends StatelessWidget {
  final ProductBloc provider;

  const ProductsPage({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TiendaApp - Catálogo')),
      body: AnimatedBuilder(
        animation: provider,
        builder: (context, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(child: Text('Error: ${provider.errorMessage}'));
          }

          if (provider.products.isEmpty) {
            return const Center(child: Text('No hay productos disponibles'));
          }

          return ListView.builder(
            itemCount: provider.products.length,
            itemBuilder: (context, index) {
              final product = provider.products[index];
              return ListTile(
                leading: Image.network(
                  product.thumbnail,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.broken_image),
                ),
                title: Text(product.title),
                subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => provider.fetchProducts(),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}