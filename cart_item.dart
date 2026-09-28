import 'product.dart';

/// Satu baris item di keranjang (produk + jumlah).
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  int get subtotal => product.price * quantity;
}