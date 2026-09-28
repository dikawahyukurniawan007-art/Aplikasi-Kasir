import 'package:flutter/material.dart';

/// Merepresentasikan satu varian rasa bakpau.
class Product {
  final String id;
  final String name;
  final int price; // dalam Rupiah, tanpa desimal
  final Color color; // warna identitas varian (dipakai kalau foto gagal dimuat)
  final String imageUrl; // foto varian. Bisa URL (Image.network) atau path asset (Image.asset)

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.color,
    required this.imageUrl,
  });
}