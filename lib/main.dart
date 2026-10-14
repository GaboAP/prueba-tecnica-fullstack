import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tienda_app/features/products/presentation/bloc/product_bloc.dart';
import 'features/products/data/datasources/product_remote_datasource.dart';
import 'features/products/data/repositories_impl/product_repository_impl.dart';
import 'features/products/domain/usecases/get_products_usecase.dart';
import 'features/products/presentation/bloc/product_bloc.dart';
import 'features/products/presentation/pages/products_page.dart';

void main() {
  // Inyección de dependencias
  final client = http.Client();
  final remoteDataSource = ProductRemoteDataSourceImpl(client: client);
  final repository = ProductRepositoryImpl(remoteDataSource: remoteDataSource);
  final getProductsUseCase = GetProductsUseCase(repository);
  final productProvider = ProductBloc(getProductsUseCase: getProductsUseCase);

  // Disparamos la carga inicial al arrancar
  productProvider.fetchProducts();

  runApp(TiendaApp(productProvider: productProvider));
}

class TiendaApp extends StatelessWidget {
  final ProductBloc productProvider;
  const TiendaApp({super.key, required this.productProvider});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TiendaApp',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ProductsPage(provider: productProvider),
    );
  }
}