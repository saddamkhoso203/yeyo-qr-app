import 'package:flutter/material.dart';
import '../widgets/bottom_nav.dart';
import '../theme/app_text_style.dart';
import '../Languages/translator.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t["more"] ?? "More"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                _item(
                  context: context,
                  title: t["about"] ?? "About",
                  onTap: () => Navigator.pushNamed(context, '/about'),
                ),
                _item(
                  context: context,
                  title: t["help"] ?? "Help",
                  onTap: () => Navigator.pushNamed(context, '/help'),
                ),
                _item(
                  context: context,
                  title: t["rate_us"] ?? "Rate us",
                  onTap: () {},
                ),
                _item(
                  context: context,
                  title: t["privacy_policy"] ?? "Privacy Policy",
                  onTap: () => Navigator.pushNamed(context, '/privacy'),
                ),
              ],
            ),
          ),
          const BottomNavBar(active: BottomTab.more),
        ],
      ),
    );
  }

  Widget _item({
    required BuildContext context,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        title: Text(title, style: AppTextStyle.heading),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
