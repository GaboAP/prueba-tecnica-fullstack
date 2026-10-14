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
          // 1. Estado de Carga
          if (provider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando productos...'),
                ],
              ),
            );
          }

          // 2. Estado de Sin Conexión (Distinto al error de servidor)
          if (provider.isNetworkError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                      'Sin conexión a internet',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage ?? 'Verifica tu red e inténtalo nuevamente.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => provider.fetchProducts(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 3. Estado de Error del Servidor
          if (provider.errorMessage != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    const Text(
                      '¡Vaya! Algo salió mal',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      provider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => provider.fetchProducts(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          // 4. Estado de Lista Vacía
          if (provider.products.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.inbox_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No hay productos disponibles',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  TextButton.icon(
                    onPressed: () => provider.fetchProducts(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Actualizar'),
                  ),
                ],
              ),
            );
          }

          // 5. Listado Exitoso de Productos (RF-01)
// 5. Listado Exitoso de Productos y Chips (RF-01 y RF-03)
          return Column(
            children: [
              // Muestra los chips arriba si hay etiquetas disponibles
              if (provider.availableTopTags.isNotEmpty)
                Container(
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: provider.availableTopTags.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final tag = provider.availableTopTags[index];
                      final isSelected = provider.selectedTagFilter == tag;

                      return ChoiceChip(
                        label: Text(tag),
                        selected: isSelected,
                        onSelected: (_) => provider.toggleTagFilter(tag),
                      );
                    },
                  ),
                ),

              // Listado de productos filtrados abajo ocupando el resto de la pantalla
              Expanded(
                child: ListView.builder(
                  itemCount: provider.filteredProducts.length, // 👈 Usamos filteredProducts
                  itemBuilder: (context, index) {
                    final product = provider.filteredProducts[index]; // 👈 Usamos filteredProducts
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}