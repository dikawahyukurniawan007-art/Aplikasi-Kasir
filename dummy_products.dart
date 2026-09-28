import 'package:flutter/material.dart';
import '../models/product.dart';

/// Data contoh 16 varian bakpau.
///
/// GANTI di sini sesuai menu asli kamu: ubah `name`, `price`, dan
/// `imageUrl`.
///
/// Saat ini `imageUrl` memakai foto placeholder acak (bukan foto bakpau
/// asli) hanya supaya tampilan kartu produk bisa dilihat dengan foto.
/// Untuk pakai foto ASLI produk kamu, ada 2 cara:
///
/// 1) Paling gampang — pakai foto dari internet (link langsung ke file
///    .jpg/.png), tinggal ganti nilai `imageUrl` dengan link tersebut.
///
/// 2) Simpan foto di dalam aplikasi (tidak butuh internet saat dipakai):
///    - Taruh file foto di folder `assets/images/` (buat foldernya di
///      root project, sejajar dengan folder `lib/`).
///    - Di `pubspec.yaml`, tambahkan di bagian `flutter:`:
///        assets:
///          - assets/images/
///    - Ganti `imageUrl: 'https://...'` menjadi path asset, misalnya
///      `imageUrl: 'assets/images/kacang_hijau.jpg'`.
///    - Di `lib/widgets/product_card.dart`, ganti `Image.network(...)`
///      menjadi `Image.asset(...)`.
final List<Product> dummyProducts = [
  Product(
    id: 'p1',
    name: 'Kacang Hijau',
    price: 5000,
    color: Colors.green.shade400,
    imageUrl: 'https://picsum.photos/seed/bakpau-kacang-hijau/400/400',
  ),
  Product(
    id: 'p2',
    name: 'Coklat',
    price: 5000,
    color: Colors.brown.shade400,
    imageUrl: 'https://picsum.photos/seed/bakpau-coklat/400/400',
  ),
  Product(
    id: 'p3',
    name: 'Keju',
    price: 6000,
    color: Colors.amber.shade600,
    imageUrl: 'https://picsum.photos/seed/bakpau-keju/400/400',
  ),
  Product(
    id: 'p4',
    name: 'Ayam',
    price: 7000,
    color: Colors.orange.shade400,
    imageUrl: 'https://picsum.photos/seed/bakpau-ayam/400/400',
  ),
  Product(
    id: 'p5',
    name: 'Daging Sapi',
    price: 8000,
    color: Colors.red.shade400,
    imageUrl: 'https://picsum.photos/seed/bakpau-daging-sapi/400/400',
  ),
  Product(
    id: 'p6',
    name: 'Kacang Merah',
    price: 5000,
    color: Colors.red.shade200,
    imageUrl: 'https://picsum.photos/seed/bakpau-kacang-merah/400/400',
  ),
  Product(
    id: 'p7',
    name: 'Ubi Ungu',
    price: 6000,
    color: Colors.purple.shade300,
    imageUrl: 'https://picsum.photos/seed/bakpau-ubi-ungu/400/400',
  ),
  Product(
    id: 'p8',
    name: 'Strawberry',
    price: 5500,
    color: Colors.pink.shade300,
    imageUrl: 'https://picsum.photos/seed/bakpau-strawberry/400/400',
  ),
  Product(
    id: 'p9',
    name: 'Durian',
    price: 8000,
    color: Colors.yellow.shade800,
    imageUrl: 'https://picsum.photos/seed/bakpau-durian/400/400',
  ),
  Product(
    id: 'p10',
    name: 'Pandan',
    price: 5500,
    color: Colors.green.shade300,
    imageUrl: 'https://picsum.photos/seed/bakpau-pandan/400/400',
  ),
  Product(
    id: 'p11',
    name: 'Original',
    price: 4500,
    color: Colors.grey.shade500,
    imageUrl: 'https://picsum.photos/seed/bakpau-original/400/400',
  ),
  Product(
    id: 'p12',
    name: 'Vanilla',
    price: 5500,
    color: Colors.orange.shade200,
    imageUrl: 'https://picsum.photos/seed/bakpau-vanilla/400/400',
  ),
  Product(
    id: 'p13',
    name: 'Matcha',
    price: 6500,
    color: Colors.teal.shade400,
    imageUrl: 'https://picsum.photos/seed/bakpau-matcha/400/400',
  ),
  Product(
    id: 'p14',
    name: 'Kopi',
    price: 6000,
    color: Colors.brown.shade700,
    imageUrl: 'https://picsum.photos/seed/bakpau-kopi/400/400',
  ),
  Product(
    id: 'p15',
    name: 'Nanas',
    price: 6000,
    color: Colors.yellow.shade700,
    imageUrl: 'https://picsum.photos/seed/bakpau-nanas/400/400',
  ),
  Product(
    id: 'p16',
    name: 'Mocha',
    price: 6500,
    color: Colors.brown.shade300,
    imageUrl: 'https://picsum.photos/seed/bakpau-mocha/400/400',
  ),
];