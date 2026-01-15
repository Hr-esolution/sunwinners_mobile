import 'package:flutter/material.dart';

class BottomNavigationWidget extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  @override
  Widget build(BuildContext context) {
    print('DEBUG: Building BottomNavigationWidget');
    print('DEBUG: Current index: ${widget.currentIndex}');

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1f2e), Color(0xFF0f1419)],
        ),
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: widget.currentIndex,
          onTap: (index) {
            print('DEBUG: Bottom navigation tapped at index: $index');
            widget.onTap(index);
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF0f1419),
          selectedItemColor: const Color(0xFFffd60a),
          unselectedItemColor: Colors.white.withValues(alpha: 0.6),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
          elevation: 0,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded, color: Color(0xFFffd60a)),
              label: 'Accueil',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              activeIcon: Icon(
                Icons.list_alt_rounded,
                color: Color(0xFFffd60a),
              ),
              label: 'Devis',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.work_outline),
              activeIcon: Icon(Icons.work_rounded, color: Color(0xFFffd60a)),
              label: 'Projets',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person_rounded, color: Color(0xFFffd60a)),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}

// Alternative implementation with custom bottom navigation
class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<String> titles;

  const CustomBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    this.titles = const ['Accueil', 'Devis', 'Projets', 'Profil'],
  }) : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    print('DEBUG: Building CustomBottomNavigation');
    print('DEBUG: Current index: ${widget.currentIndex}');
    print('DEBUG: Available titles: ${widget.titles}');

    return Container(
      height: 80,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1a1f2e), Color(0xFF0f1419)],
        ),
        border: Border(
          top: BorderSide(
            color: Color(0xFFffd60a).withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(widget.titles.length, (index) {
              bool isSelected = index == widget.currentIndex;

              print('DEBUG: Building item $index, isSelected: $isSelected');

              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    print('DEBUG: Custom bottom nav item $index tapped');
                    widget.onTap(index);
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? Color(0xFFffd60a).withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconByIndex(index),
                          color: isSelected
                              ? Color(0xFFffd60a)
                              : Colors.white.withValues(alpha: 0.6),
                          size: 24,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.titles[index],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? Color(0xFFffd60a)
                                : Colors.white.withValues(alpha: 0.6),
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  IconData _getIconByIndex(int index) {
    switch (index) {
      case 0:
        return Icons.home_rounded;
      case 1:
        return Icons.list_alt_rounded;
      case 2:
        return Icons.work_rounded;
      case 3:
        return Icons.person_rounded;
      default:
        return Icons.home_rounded;
    }
  }
}
