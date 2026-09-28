import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../services/cart_provider.dart';
import '../screens/receipt_screen.dart';

class PaymentDialog extends StatefulWidget {
  const PaymentDialog({super.key});

  @override
  State<PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  final TextEditingController _controller = TextEditingController();
  int _paid = 0;
  String _paymentMethod = 'Cash'; // Default metode pembayaran

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();
    final total = cart.totalPrice;
    final currency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final change = _paid - total;

    return AlertDialog(
      title: const Text('Pembayaran'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pilihan Metode Pembayaran
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('Cash')),
                    selected: _paymentMethod == 'Cash',
                    onSelected: (val) {
                      setState(() {
                        _paymentMethod = 'Cash';
                        _paid = 0;
                        _controller.clear();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Center(child: Text('QRIS')),
                    selected: _paymentMethod == 'QRIS',
                    onSelected: (val) {
                      setState(() {
                        _paymentMethod = 'QRIS';
                        _paid = total; // QRIS dianggap uang pas
                        _controller.text = total.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Belanja'),
                Text(currency.format(total), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            
            // Tampilan Kondisional berdasarkan Metode
            if (_paymentMethod == 'Cash') ...[
              TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Jumlah Dibayar',
                  prefixText: 'Rp ',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _paid = int.tryParse(value) ?? 0),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _quickButton(total, 'Uang Pas'),
                  _quickButton(20000, 'Rp 20rb'),
                  _quickButton(50000, 'Rp 50rb'),
                  _quickButton(100000, 'Rp 100rb'),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Kembalian'),
                  Text(
                    currency.format(change < 0 ? 0 : change),
                    style: TextStyle(fontWeight: FontWeight.bold, color: change < 0 ? Colors.red : Colors.green),
                  ),
                ],
              ),
            ] else ...[
              // Tampilan QRIS
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Icon(Icons.qr_code_2, size: 100, color: Colors.grey.shade700),
                    const SizedBox(height: 8),
                    Text(
                      'Silakan scan QRIS untuk membayar',
                      style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
        FilledButton(
          onPressed: _paid < total
              ? null
              : () async {
                  final trx = await cart.checkout(_paid);
                  if (context.mounted) {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ReceiptScreen(transaction: trx)),
                    );
                  }
                },
          child: const Text('Konfirmasi'),
        ),
      ],
    );
  }

  Widget _quickButton(int amount, String label) {
    return OutlinedButton(
      onPressed: () {
        _controller.text = amount.toString();
        setState(() => _paid = amount);
      },
      child: Text(label),
    );
  }
}