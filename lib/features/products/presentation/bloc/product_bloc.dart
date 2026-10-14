import 'package:flutter/foundation.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products_usecase.dart';

class ProductBloc extends ChangeNotifier {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc({required this.getProductsUseCase});

  List<Product> products = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> fetchProducts() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      products = await getProductsUseCase();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}