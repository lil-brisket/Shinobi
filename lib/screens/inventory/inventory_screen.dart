import 'package:flutter/material.dart';
import '../../widgets/section_header.dart';
import '../../widgets/silhouette.dart';
import '../../app/theme.dart';
import 'jutsus_screen.dart';
import 'items_screen.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventory'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
          child: SafeArea(
            child: Column(
              children: [
                const SectionHeader(title: 'Inventory'),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.white60,
                    indicatorColor: AppTheme.accentColor,
                    tabs: [
                      Tab(text: 'Equipment'),
                      Tab(text: 'Jutsus'),
                    ],
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      const ImprovedInventoryLayout(),
                      const JutsusScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
