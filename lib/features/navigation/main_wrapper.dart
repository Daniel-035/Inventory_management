import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/inventory_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../inventory/inventory_screen.dart';
import '../suppliers/suppliers_screen.dart';
import '../sales/sales_screen.dart';
import '../reports/reports_screen.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

class MainWrapper extends ConsumerWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(navigationIndexProvider);
    final lowStockCount = ref.watch(lowStockItemsProvider).length;

    final screens = const [
      DashboardScreen(),
      InventoryScreen(),
      SuppliersScreen(),
      SalesScreen(),
      ReportsScreen(),
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: Row(
        children: [
          // Sleek Sidebar Navigation for Desktop/Tablet
          NavigationRail(
            backgroundColor: AppColors.surfaceDark,
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              ref.read(navigationIndexProvider.notifier).state = index;
            },
            extended: MediaQuery.of(context).size.width > 900,
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.warehouse_rounded, color: Colors.white, size: 24),
                  ),
                  if (MediaQuery.of(context).size.width > 900) ...[
                    const SizedBox(width: 12),
                    const Text(
                      'StockMaster Pro',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ],
              ),
            ),
            unselectedIconTheme: const IconThemeData(color: AppColors.textMuted),
            selectedIconTheme: const IconThemeData(color: AppColors.primaryAccent),
            unselectedLabelTextStyle: const TextStyle(color: AppColors.textMuted),
            selectedLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            destinations: [
              const NavigationRailDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard),
                label: Text('Dashboard'),
              ),
              NavigationRailDestination(
                icon: Badge(
                  isLabelVisible: lowStockCount > 0,
                  label: Text('$lowStockCount'),
                  backgroundColor: AppColors.warning,
                  child: const Icon(Icons.inventory_2_outlined),
                ),
                selectedIcon: Badge(
                  isLabelVisible: lowStockCount > 0,
                  label: Text('$lowStockCount'),
                  backgroundColor: AppColors.warning,
                  child: const Icon(Icons.inventory_2),
                ),
                label: const Text('Inventory'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.business_outlined),
                selectedIcon: Icon(Icons.business),
                label: Text('Suppliers'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.point_of_sale_outlined),
                selectedIcon: Icon(Icons.point_of_sale),
                label: Text('Sales'),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.analytics_outlined),
                selectedIcon: Icon(Icons.analytics),
                label: Text('Reports'),
              ),
            ],
          ),

          const VerticalDivider(thickness: 1, width: 1, color: Color(0x1FFFFFFF)),

          // Main View Content Area
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: screens[currentIndex],
            ),
          ),
        ],
      ),
    );
  }
}
