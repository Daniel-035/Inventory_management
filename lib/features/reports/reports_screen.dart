import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/inventory_provider.dart';

class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  void _exportCsv(BuildContext context, WidgetRef ref) {
    final items = ref.read(inventoryProvider);
    List<List<dynamic>> rows = [
      ['ID', 'Name', 'SKU', 'Category', 'Quantity', 'Unit', 'Unit Price', 'Total Value', 'Status', 'Supplier', 'Barcode'],
      for (var item in items)
        [
          item.id,
          item.name,
          item.sku,
          item.category,
          item.stockQuantity,
          item.unit,
          item.unitPrice,
          item.totalValue,
          item.status.name,
          item.supplier,
          item.barcode,
        ]
    ];

    String csvData = const ListToCsvConverter().convert(rows);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Exported CSV Preview', style: TextStyle(color: Colors.white)),
        content: SingleChildScrollView(
          child: SelectableText(
            csvData,
            style: const TextStyle(fontFamily: 'monospace', fontSize: 11, color: AppColors.textSecondary),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: AppColors.primaryAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inventoryProvider);
    final totalValue = ref.watch(totalInventoryValueProvider);
    final lowStock = ref.watch(lowStockItemsProvider);
    final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Reports & Analytics', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
                  const SizedBox(height: 4),
                  Text('Audit warehouse metrics & export inventory stock sheets', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _exportCsv(context, ref),
                icon: const Icon(Icons.download_outlined),
                label: const Text('Export CSV Sheet'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  context,
                  title: 'Total Stock Valuation',
                  value: currency.format(totalValue),
                  icon: Icons.account_balance_wallet,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  context,
                  title: 'Low Stock Risk Items',
                  value: '${lowStock.length} SKUs',
                  icon: Icons.warning_amber_rounded,
                  color: AppColors.warning,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildMetricTile(
                  context,
                  title: 'Total Inventory Items',
                  value: '${items.length} Products',
                  icon: Icons.inventory,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Inventory Audit Log', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(color: Color(0x1FFFFFFF)),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                                Text('Last audit: ${DateFormat('yyyy-MM-dd HH:mm').format(item.lastUpdated)}',
                                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12)),
                              ],
                            ),
                            Text(
                              currency.format(item.totalValue),
                              style: const TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(BuildContext context, {required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
