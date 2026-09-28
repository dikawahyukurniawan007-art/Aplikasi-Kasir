import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/cart_provider.dart';
import 'screens/pos_screen.dart';

void main() {
  runApp(const BakpauKasirApp());
}

class BakpauKasirApp extends StatelessWidget {
  const BakpauKasirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Kasir Bakpau',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: const Color(0xFFB5651D), // cokelat hangat, kesan bakery
          scaffoldBackgroundColor: const Color(0xFFFFF8F0),
          appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
        ),
        home: const PosScreen(),
      ),
    );
  }
}