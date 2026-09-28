import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/cart_provider.dart';
import 'receipt_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat & Data Excel'),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: 'Bagikan file Excel',
            onPressed: cart.shareExcel,
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder<String>(
            future: cart.exportExcelPath(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();
              return Container(
                width: double.infinity,
                color: Colors.green.withOpacity(0.08),
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.table_chart, color: Colors.green, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Setiap transaksi otomatis tersimpan permanen di:\n${snapshot.data}\n\n'
                        'Daftar di bawah ini hanya menampilkan transaksi sesi aplikasi saat ini, '
                        'tapi file Excel di atas menyimpan SEMUA transaksi dari sejak pertama kali dipakai.',
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: cart.history.isEmpty
                ? const Center(child: Text('Belum ada transaksi di sesi ini', style: TextStyle(color: Colors.grey)))
                : ListView.separated(
                    itemCount: cart.history.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final trx = cart.history[index];
                      return ListTile(
                        leading: const Icon(Icons.receipt),
                        title: Text(currency.format(trx.total)),
                        subtitle: Text(DateFormat('dd MMM yyyy, HH:mm').format(trx.date)),
                        trailing: Text('${trx.items.length} varian'),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => ReceiptScreen(transaction: trx)),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}