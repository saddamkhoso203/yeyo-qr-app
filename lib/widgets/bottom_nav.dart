import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum BottomTab { scan, history, settings, more }

class BottomNavBar extends StatelessWidget {
  final BottomTab active;
  const BottomNavBar({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _item(context, Icons.crop_free, BottomTab.scan),
              _item(context, Icons.history, BottomTab.history),
              _item(context, Icons.settings, BottomTab.settings),
              _item(context, Icons.more_horiz, BottomTab.more),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item(BuildContext context, IconData icon, BottomTab tab) {
    final bool isActive = tab == active;

    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        if (!isActive) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/${tab.name}',
            (r) => false,
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        height: 40,
        decoration: BoxDecoration(
          color: isActive ? AppColors.green : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          icon,
          size: 22,
          color: isActive ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}
