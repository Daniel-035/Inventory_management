import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/inventory_item.dart';
import '../../core/providers/inventory_provider.dart';
import '../inventory/widgets/add_item_dialog.dart';
import '../scanner/barcode_scanner_modal.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalValue = ref.watch(totalInventoryValueProvider);
    final items = ref.watch(inventoryProvider);
    final lowStockItems = ref.watch(lowStockItemsProvider);
    final categories = ref.watch(categoriesProvider);

    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header title banner
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Inventory Dashboard',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Real-time overview of warehouse stock, valuations & alerts.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const BarcodeScannerModal(),
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner, size: 18),
                    label: const Text('Scan Stock'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.surfaceDark,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => const AddItemDialog(),
                      );
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('Add Item'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 24),

          // KPI Cards Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;
              return GridView.count(
                crossAxisCount: isWide ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: isWide ? 1.8 : 1.5,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildKpiCard(
                    context,
                    title: 'Total Stock Value',
                    value: currencyFormat.format(totalValue),
                    icon: Icons.account_balance_wallet_outlined,
                    color: AppColors.primary,
                    gradient: AppColors.primaryGradient,
                  ),
                  _buildKpiCard(
                    context,
                    title: 'Total Active SKUs',
                    value: items.length.toString(),
                    icon: Icons.inventory_2_outlined,
                    color: AppColors.secondary,
                    gradient: const LinearGradient(colors: [Color(0xFF0EA5E9), Color(0xFF06B6D4)]),
                  ),
                  _buildKpiCard(
                    context,
                    title: 'Low Stock Alerts',
                    value: lowStockItems.length.toString(),
                    icon: Icons.warning_amber_rounded,
                    color: AppColors.warning,
                    gradient: const LinearGradient(colors: [Color(0xFFF59E0B), Color(0xFFD97706)]),
                  ),
                  _buildKpiCard(
                    context,
                    title: 'Categories',
                    value: (categories.length - 1).toString(),
                    icon: Icons.category_outlined,
                    color: AppColors.accentTeal,
                    gradient: const LinearGradient(colors: [Color(0xFF14B8A6), Color(0xFF0D9488)]),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),

          // Analytics Section: Chart + Low Stock Alert Box
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              return isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: _buildCategoryChartCard(context, items)),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: _buildLowStockAlertCard(context, ref, lowStockItems)),
                      ],
                    )
                  : Column(
                      children: [
                        _buildCategoryChartCard(context, items),
                        const SizedBox(height: 24),
                        _buildLowStockAlertCard(context, ref, lowStockItems),
                      ],
                    );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required LinearGradient gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 14, fontWeight: FontWeight.w500),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
            ],
          ),
          Text(
            value,
            style: const TextStyle(color: AppColors.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChartCard(BuildContext context, List<InventoryItem> items) {
    // Map stock quantity by category
    final categoryCounts = <String, double>{};
    for (var item in items) {
      categoryCounts[item.category] = (categoryCounts[item.category] ?? 0) + item.stockQuantity;
    }

    final colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.accentTeal,
      AppColors.warning,
      AppColors.success,
    ];

    int colorIndex = 0;
    final sections = categoryCounts.entries.map((entry) {
      final color = colors[colorIndex % colors.length];
      colorIndex++;
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${entry.value.toInt()}',
        radius: 40,
        titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
      );
    }).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Stock Distribution by Category', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sections: sections,
                      centerSpaceRadius: 40,
                      sectionsSpace: 4,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: categoryCounts.keys.toList().asMap().entries.map((entry) {
                    final color = colors[entry.key % colors.length];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          Text(entry.value, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockAlertCard(BuildContext context, WidgetRef ref, List<InventoryItem> lowStockItems) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: AppColors.warning),
              SizedBox(width: 8),
              Text(
                'Low Stock Action Items',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (lowStockItems.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text('All inventory items are sufficiently stocked!', style: TextStyle(color: AppColors.textMuted)),
              ),
            )
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: lowStockItems.length,
              separatorBuilder: (_, __) => const Divider(color: Color(0x1FFFFFFF)),
              itemBuilder: (context, index) {
                final item = lowStockItems[index];
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          Text('SKU: ${item.sku} • Stock: ${item.stockQuantity} ${item.unit}',
                              style: TextStyle(
                                color: item.stockQuantity == 0 ? AppColors.error : AppColors.warning,
                                fontSize: 12,
                              )),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: AppColors.textMuted, size: 20),
                          onPressed: () => ref.read(inventoryProvider.notifier).adjustStock(item.id, -1),
                        ),
                        Text('${item.stockQuantity}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: AppColors.primary, size: 20),
                          onPressed: () => ref.read(inventoryProvider.notifier).adjustStock(item.id, 5),
                        ),
                      ],
                    )
                  ],
                );
              },
            ),
        ],
      ),
    );
  }
}
