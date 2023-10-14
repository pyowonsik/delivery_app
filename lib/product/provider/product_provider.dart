import 'package:delivery_app/common/model/cursor_pagination_model.dart';
import 'package:delivery_app/common/provider/pagination_provider.dart';
import 'package:delivery_app/product/model/product_model.dart';
import 'package:delivery_app/product/repository/product_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// PaginationStateNotifier의 반환값 = CursorPaginationBase
final productProvider =
    StateNotifierProvider<ProductProviderNotifier, CursorPaginationBase>((ref) {
  final repo = ref.watch(productRepositoryProvider);

  return ProductProviderNotifier(repository: repo);
});

class ProductProviderNotifier
    extends PaginationStateNotifier<ProductModel, ProductRepository> {
  ProductProviderNotifier({required super.repository});
}
