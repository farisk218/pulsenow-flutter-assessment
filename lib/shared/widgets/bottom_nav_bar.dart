import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/routes/app_router.dart';
import '../../utils/strings.dart';

/// Shared bottom navigation bar for all screens
class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentPath = GoRouterState.of(context).uri.path;
    int currentIndex = 0;
    if (currentPath == AppRouter.analytics) {
      currentIndex = 1;
    } else if (currentPath == AppRouter.portfolio) {
      currentIndex = 2;
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go(AppRouter.dashboard);
            break;
          case 1:
            context.go(AppRouter.analytics);
            break;
          case 2:
            context.go(AppRouter.portfolio);
            break;
          case 3:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text(AppStrings.comingSoon)),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.trending_up),
          label: AppStrings.marketsTab,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: AppStrings.analyticsTab,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_balance_wallet),
          label: AppStrings.portfolioTab,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: AppStrings.alertsTab,
        ),
      ],
    );
  }
}
