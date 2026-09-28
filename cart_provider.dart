import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/transaction.dart';
import '../data/dummy_products.dart';
import 'excel_service.dart';

/// Menyimpan seluruh state aplikasi kasir: daftar produk, isi keranjang,
/// dan riwayat transaksi selama sesi aplikasi berjalan.
class CartProvider extends ChangeNotifier {
  final List<Product> products = dummyProducts;
  final Map<String, CartItem> _cart = {};
  final List<TransactionData> _history = [];
  final ExcelService _excelService = ExcelService();

  List<CartItem> get cartItems => _cart.values.toList();

  /// Riwayat transaksi sesi ini, terbaru di atas.
  List<TransactionData> get history => List.unmodifiable(_history.reversed);

  int get totalItemCount => _cart.values.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice => _cart.values.fold(0, (sum, item) => sum + item.subtotal);

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  /// Jumlah transaksi yang terjadi hari ini (untuk panel statistik).
  int get todayTransactionCount => _history.where((t) => _isToday(t.date)).length;

  /// Total pendapatan hari ini (untuk panel statistik).
  int get todayRevenue =>
      _history.where((t) => _isToday(t.date)).fold(0, (sum, t) => sum + t.total);

  void addToCart(Product product) {
    if (_cart.containsKey(product.id)) {
      _cart[product.id]!.quantity++;
    } else {
      _cart[product.id] = CartItem(product: product);
    }
    notifyListeners();
  }

  void increment(String productId) {
    _cart[productId]?.quantity++;
    notifyListeners();
  }

  void decrement(String productId) {
    final item = _cart[productId];
    if (item == null) return;
    if (item.quantity <= 1) {
      _cart.remove(productId);
    } else {
      item.quantity--;
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _cart.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  /// Menutup transaksi: catat ke riwayat, kosongkan keranjang, dan
  /// simpan otomatis ke file Excel.
  Future<TransactionData> checkout(int paid) async {
    final trx = TransactionData.fromCart(cartItems: cartItems, paid: paid);
    _history.add(trx);
    clearCart();
    notifyListeners();
    await _excelService.appendTransaction(trx);
    return trx;
  }

  Future<String> exportExcelPath() => _excelService.getFilePath();

  Future<void> shareExcel() => _excelService.shareFile();
}