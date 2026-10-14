import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final http.Client client;

  ProductRemoteDataSourceImpl({required this.client});

  @override
  Future<List<ProductModel>> getProducts() async {
    // Agregamos el delay de 2000ms
    final url = Uri.parse('https://dummyjson.com/products?limit=20&delay=2000');
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List productsJson = data['products'];
      return productsJson.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los productos del servidor');
    }
  }
}