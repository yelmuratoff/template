part of '../page/root.dart';

/// `BottomNavigationBar` widget for bottom navigation in root view.
class _BottomNavigationBar extends StatelessWidget {
  const _BottomNavigationBar({
    required this.navigationShell,
  });
  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: context.theme.colorScheme.onSurface.withOpacity(0.1),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: NavigationBar(
          selectedIndex: navigationShell.currentIndex,
          onDestinationSelected: (index) {
            navigationShell.goBranch(
              index,
              // It is need for go to the initial page of the current branch
              //if tap on the selected destination.
              initialLocation: index == navigationShell.currentIndex,
            );
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(IconsaxPlusLinear.home),
              selectedIcon:
                  const Icon(IconsaxPlusBold.home, color: Colors.white),
              label: L10n.current.home,
            ),
            NavigationDestination(
              icon: const Icon(IconsaxPlusLinear.user_square),
              selectedIcon:
                  const Icon(IconsaxPlusBold.user_square, color: Colors.white),
              label: L10n.current.profile,
            ),
          ],
        ),
      );
}
