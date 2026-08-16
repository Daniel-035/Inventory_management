import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class SuppliersScreen extends StatelessWidget {
  const SuppliersScreen({super.key});

  static const List<Map<String, dynamic>> _suppliers = [
    {
      'name': 'Apple Inc. Wholesale',
      'contact': 'Tim Cook / B2B Sales',
      'email': 'b2b@apple.com',
      'phone': '+1 (800) 692-7753',
      'itemsCount': 12,
      'status': 'Active Supplier',
      'rating': 4.9,
    },
    {
      'name': 'Logitech Direct Global',
      'contact': 'Sarah Jenkins',
      'email': 'orders@logitech.com',
      'phone': '+1 (800) 255-8891',
      'itemsCount': 8,
      'status': 'Active Supplier',
      'rating': 4.8,
    },
    {
      'name': 'Dell Enterprise Distribution',
      'contact': 'Marcus Vance',
      'email': 'supply@dell.com',
      'phone': '+1 (800) 456-3355',
      'itemsCount': 15,
      'status': 'Active Supplier',
      'rating': 4.7,
    },
    {
      'name': 'Herman Miller Commercial',
      'contact': 'Elena Rostova',
      'email': 'commercial@hermanmiller.com',
      'phone': '+1 (888) 443-4357',
      'itemsCount': 6,
      'status': 'Pending Renewal',
      'rating': 4.6,
    },
    {
      'name': 'Anker Innovations Supply',
      'contact': 'David Wei',
      'email': 'sales@anker.com',
      'phone': '+1 (800) 988-7973',
      'itemsCount': 22,
      'status': 'Active Supplier',
      'rating': 4.9,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
                  Text('Supplier Directory', style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 28)),
                  const SizedBox(height: 4),
                  Text('Manage vendor partners, contacts & procurement contracts', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_business_outlined),
                label: const Text('Add Supplier'),
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
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.4,
              ),
              itemCount: _suppliers.length,
              itemBuilder: (context, index) {
                final supplier = _suppliers[index];
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceDark,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.08)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.business, color: AppColors.primaryAccent),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              supplier['status'],
                              style: const TextStyle(color: AppColors.success, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(supplier['name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('Contact: ${supplier['contact']}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(Icons.email_outlined, size: 14, color: AppColors.textMuted),
                          const SizedBox(width: 6),
                          Expanded(child: Text(supplier['email'], style: const TextStyle(color: AppColors.textMuted, fontSize: 12))),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('${supplier['itemsCount']} Products Supplied', style: const TextStyle(color: AppColors.primaryAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.warning, size: 14),
                              const SizedBox(width: 4),
                              Text('${supplier['rating']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
