import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';
import '../models/transaction.dart';

class ReceiptScreen extends StatelessWidget {
  final TransactionData transaction;
  const ReceiptScreen({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final tanggal = DateFormat('dd MMM yyyy, HH:mm').format(transaction.date);

    return Scaffold(
      appBar: AppBar(title: const Text('Struk Pembayaran')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            width: 340,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 10)],
            ),
            child: Column(
              children: [
                const Text('BAKPAU KASIR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(tanggal, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Text('No. ${transaction.id}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                const Padding(padding: EdgeInsets.symmetric(vertical: 12), child: Divider()),
                ...transaction.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text('${item.name} x${item.quantity}', style: const TextStyle(fontFamily: 'monospace')),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            currency.format(item.subtotal),
                            textAlign: TextAlign.right,
                            style: const TextStyle(fontFamily: 'monospace'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(),
                _summaryRow('Total', currency.format(transaction.total), bold: true),
                _summaryRow('Bayar', currency.format(transaction.paid)),
                _summaryRow('Kembalian', currency.format(transaction.change)),
                const SizedBox(height: 16),
                const Text('Terima kasih sudah membeli bakpau kami! 🥟',
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: const Icon(Icons.share),
                label: const Text('Bagikan'),
                onPressed: () => _shareReceipt(currency, tanggal),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton.icon(
                icon: const Icon(Icons.check),
                label: const Text('Selesai'),
                onPressed: () => Navigator.popUntil(context, (route) => route.isFirst),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label, style: style), Text(value, style: style)],
      ),
    );
  }

  void _shareReceipt(NumberFormat currency, String tanggal) {
    final buffer = StringBuffer()
      ..writeln('BAKPAU KASIR')
      ..writeln(tanggal)
      ..writeln('No. ${transaction.id}')
      ..writeln('------------------------------');
    for (final item in transaction.items) {
      buffer.writeln('${item.name} x${item.quantity}  ${currency.format(item.subtotal)}');
    }
    buffer
      ..writeln('------------------------------')
      ..writeln('Total     : ${currency.format(transaction.total)}')
      ..writeln('Bayar     : ${currency.format(transaction.paid)}')
      ..writeln('Kembalian : ${currency.format(transaction.change)}')
      ..writeln('Terima kasih!');

    Share.share(buffer.toString());
  }
}