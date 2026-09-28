import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../models/transaction.dart';

/// Bertanggung jawab menyimpan setiap transaksi ke satu file Excel
/// yang terus bertambah (append), tersimpan permanen di penyimpanan
/// aplikasi (tidak hilang saat app ditutup).
class ExcelService {
  static const String _fileName = 'data_penjualan_bakpau.xlsx';
  static const String _sheetName = 'Penjualan';

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  /// Path lengkap file Excel, untuk ditampilkan ke user.
  Future<String> getFilePath() async => (await _getFile()).path;

  /// Menambahkan satu transaksi (bisa berisi beberapa varian) sebagai
  /// baris-baris baru di file Excel. Membuat file + header kalau file
  /// belum ada.
  Future<void> appendTransaction(TransactionData trx) async {
    final file = await _getFile();
    Excel excelFile;

    if (await file.exists()) {
      final bytes = await file.readAsBytes();
      excelFile = Excel.decodeBytes(bytes);
      if (excelFile.sheets[_sheetName] == null) {
        excelFile[_sheetName]; // membuat sheet jika belum ada
        _writeHeader(excelFile[_sheetName]);
      }
    } else {
      excelFile = Excel.createExcel();
      final defaultSheet = excelFile.getDefaultSheet();
      if (defaultSheet != null) {
        excelFile.rename(defaultSheet, _sheetName);
      }
      _writeHeader(excelFile[_sheetName]);
    }

    final sheet = excelFile[_sheetName];
    final tanggal = '${trx.date.day.toString().padLeft(2, '0')}-'
        '${trx.date.month.toString().padLeft(2, '0')}-${trx.date.year} '
        '${trx.date.hour.toString().padLeft(2, '0')}:${trx.date.minute.toString().padLeft(2, '0')}';

    for (var i = 0; i < trx.items.length; i++) {
      final item = trx.items[i];
      sheet.appendRow([
        TextCellValue(tanggal),
        TextCellValue(trx.id),
        TextCellValue(item.name),
        IntCellValue(item.quantity),
        IntCellValue(item.price),
        IntCellValue(item.subtotal),
        // Total, Bayar, Kembalian cukup ditulis sekali di baris pertama
        // tiap transaksi supaya tidak berulang di setiap baris varian.
        i == 0 ? IntCellValue(trx.total) : TextCellValue(''),
        i == 0 ? IntCellValue(trx.paid) : TextCellValue(''),
        i == 0 ? IntCellValue(trx.change) : TextCellValue(''),
      ]);
    }

    final fileBytes = excelFile.encode();
    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes, flush: true);
    }
  }

  void _writeHeader(Sheet sheet) {
    sheet.appendRow([
      TextCellValue('Tanggal'),
      TextCellValue('ID Transaksi'),
      TextCellValue('Varian Bakpau'),
      TextCellValue('Qty'),
      TextCellValue('Harga Satuan'),
      TextCellValue('Subtotal'),
      TextCellValue('Total Transaksi'),
      TextCellValue('Dibayar'),
      TextCellValue('Kembalian'),
    ]);
  }

  /// Membagikan file Excel (WhatsApp, email, simpan ke Drive, dll).
  Future<void> shareFile() async {
    final file = await _getFile();
    if (await file.exists()) {
      await Share.shareXFiles([XFile(file.path)], text: 'Data penjualan bakpau');
    }
  }
}