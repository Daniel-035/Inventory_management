import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Center(
        child: Text(
          'Suppliers Screen (Starting from 0)',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
