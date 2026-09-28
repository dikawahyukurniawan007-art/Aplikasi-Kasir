import 'cart_item.dart';

/// Salinan item di dalam satu transaksi (agar tidak berubah walau
/// data produk asli diedit di kemudian hari).
class TransactionItem {
  final String name;
  final int price;
  final int quantity;
  final int subtotal;

  TransactionItem({
    required this.name,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });
}

/// Satu transaksi penjualan yang sudah selesai dibayar.
class TransactionData {
  final String id;
  final DateTime date;
  final List<TransactionItem> items;
  final int total;
  final int paid;
  final int change;

  TransactionData({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.paid,
    required this.change,
  });

  factory TransactionData.fromCart({
    required List<CartItem> cartItems,
    required int paid,
  }) {
    final items = cartItems
        .map((c) => TransactionItem(
              name: c.product.name,
              price: c.product.price,
              quantity: c.quantity,
              subtotal: c.subtotal,
            ))
        .toList();
    final total = items.fold<int>(0, (sum, i) => sum + i.subtotal);
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    return TransactionData(
      id: id,
      date: DateTime.now(),
      items: items,
      total: total,
      paid: paid,
      change: paid - total,
    );
  }
}