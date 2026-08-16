import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/inventory_provider.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  void _generatePdfInvoice(BuildContext context, WidgetRef ref) async {
    final pdf = pw.Document();
    final items = ref.read(inventoryProvider);
    final currency = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context pdfContext) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('INVENTORY SALES INVOICE', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.Text('INV-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}', style: const pw.TextStyle(fontSize: 14)),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}'),
              pw.Text('Warehouse: Main Central Hub - Zone A'),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                headers: ['Item Name', 'SKU', 'Unit Price', 'Stock Qty', 'Total Value'],
                data: items.map((item) => [
                  item.name,
                  item.sku,
                  currency.format(item.unitPrice),
                  '${item.stockQuantity} ${item.unit}',
                  currency.format(item.totalValue),
                ]).toList(),
              ),
              pw.SizedBox(height: 20),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Grand Total Valuation: ${currency.format(ref.read(totalInventoryValueProvider))}',
                  style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(inventoryProvider);
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);

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
                  Text('Sales & Invoicing', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
                  const SizedBox(height: 4),
                  Text('Generate commercial invoices, sales orders & printable receipts', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _generatePdfInvoice(context, ref),
                icon: const Icon(Icons.picture_as_pdf_outlined),
                label: const Text('Export PDF Invoice'),
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
                  const Text('Stock Sales Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, index) => const Divider(color: Color(0x1FFFFFFF)),
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            child: Text('${index + 1}', style: const TextStyle(color: AppColors.primaryAccent, fontWeight: FontWeight.bold)),
                          ),
                          title: Text(item.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                          subtitle: Text('SKU: ${item.sku} • Price: ${currencyFormat.format(item.unitPrice)}'),
                          trailing: ElevatedButton(
                            onPressed: () {
                              ref.read(inventoryProvider.notifier).adjustStock(item.id, -1);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sold 1 unit of ${item.name}'), backgroundColor: AppColors.success),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Record Sale (-1 Qty)'),
                          ),
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
}
