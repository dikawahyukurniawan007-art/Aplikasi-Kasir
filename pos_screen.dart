import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/cart_provider.dart';
import '../widgets/product_card.dart';
import '../widgets/cart_panel.dart';
import 'history_screen.dart';

class PosScreen extends StatelessWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.primary.withOpacity(0.75),
              ],
            ),
          ),
        ),
        title: const Text('Kasir Bakpau', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Riwayat & Excel',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryScreen()),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 700; // tablet / layar lebar
          // PERBAIKAN: childAspectRatio diubah dari 0.85 ke 0.75 
          // agar tidak terjadi overflow 27 pixels pada kartu produk
          final grid = _ProductGrid(crossAxisCount: isWide ? 4 : 2);

          if (isWide) {
            return Row(
              children: [
                Expanded(flex: 3, child: grid),
                const VerticalDivider(width: 1),
                const SizedBox(width: 320, child: CartPanel()),
              ],
            );
          }

          return Stack(
            children: [
              Padding(padding: const EdgeInsets.only(bottom: 72), child: grid),
              if (cart.cartItems.isNotEmpty)
                const Align(alignment: Alignment.bottomCenter, child: _MiniCartBar()),
            ],
          );
        },
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final int crossAxisCount;
  const _ProductGrid({required this.crossAxisCount});

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: cart.products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.75, // <-- Diubah untuk memperbaiki overflow
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (context, index) {
        final product = cart.products[index];
        return ProductCard(
          product: product,
          onTap: () => context.read<CartProvider>().addToCart(product),
        );
      },
    );
  }
}

/// Bar ringkas di bawah layar HP: tampil kalau keranjang berisi item,
/// tap untuk buka keranjang sebagai bottom sheet.
class _MiniCartBar extends StatelessWidget {
  const _MiniCartBar();

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(12),
        child: Material(
          elevation: 4,
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.primary,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (_) => const SizedBox(height: 500, child: CartPanel()),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(Icons.shopping_cart, color: Theme.of(context).colorScheme.onPrimary),
                  const SizedBox(width: 8),
                  Text(
                    '${cart.totalItemCount} item',
                    style: TextStyle(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Text('Lihat Keranjang', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}