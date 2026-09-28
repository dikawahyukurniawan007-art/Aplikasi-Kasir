import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/cart_provider.dart';
import 'payment_dialog.dart';

class CartPanel extends StatelessWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.shopping_cart_outlined),
                const SizedBox(width: 8),
                Text('Keranjang', style: Theme.of(context).textTheme.titleMedium),
                const Spacer(),
                if (cart.cartItems.isNotEmpty)
                  TextButton(onPressed: cart.clearCart, child: const Text('Kosongkan')),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: cart.cartItems.isEmpty
                ? const Center(child: Text('Belum ada item', style: TextStyle(color: Colors.grey)))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    itemCount: cart.cartItems.length,
                    separatorBuilder: (_, __) => const Divider(height: 16),
                    itemBuilder: (context, index) {
                      final item = cart.cartItems[index];
                      return Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.product.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                Text(currency.format(item.subtotal),
                                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () => cart.decrement(item.product.id),
                          ),
                          Text('${item.quantity}'),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () => cart.increment(item.product.id),
                          ),
                        ],
                      );
                    },
                  ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    Text(currency.format(cart.totalPrice),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                // PERBAIKAN: Tombol Bayar dibuat lebih proporsional (tidak terlalu besar)
                SizedBox(
                  width: double.infinity,
                  height: 44, // Tinggi disesuaikan agar tidak terlalu besar
                  child: FilledButton.icon(
                    icon: const Icon(Icons.payment, size: 20),
                    label: const Text('Bayar'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 0), // Mengurangi padding vertikal bawaan
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: cart.cartItems.isEmpty
                        ? null
                        : () => showDialog(context: context, builder: (_) => const PaymentDialog()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}