import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../widgets/bottom_nav.dart';
import '../Languages/translator.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    final items = [
      {
        'title': 'QR Code',
        'subtitle': 'https://example.com/promo',
        'time': 'Today, 10:45 AM',
      },
      {
        'title': 'Barcode',
        'subtitle': '12345678906723',
        'time': 'Today, 09:21 AM',
      },
      {
        'title': 'QR Code',
        'subtitle': '10% OFF DISCOUNT',
        'time': 'Yesterday, 05:06 PM',
      },
      {
        'title': 'Barcode',
        'subtitle': '3647852109487',
        'time': 'Yesterday, 03:12 PM',
      },
      {
        'title': 'QR Code',
        'subtitle': 'https://website.com/product',
        'time': 'Mar 12, 11:34 AM',
      },
    ];

    return Scaffold(
      appBar: AppBar(title: Text(t['history'] ?? 'History')),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: AppColors.border),
              itemBuilder: (_, index) {
                final item = items[index];
                return _HistoryRow(
                  title: item['title']!,
                  subtitle: item['subtitle']!,
                  time: item['time']!,
                );
              },
            ),
          ),
          const BottomNavBar(active: BottomTab.history),
        ],
      ),
    );
  }
}

class _HistoryRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const _HistoryRow({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.lightBackground,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.qr_code,
                size: 18, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyle.heading),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: AppTextStyle.small
                      .copyWith(color: AppColors.textPrimary),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(time, style: AppTextStyle.small),
              ],
            ),
          ),
          const Icon(Icons.chevron_right,
              color: AppColors.textSecondary, size: 20),
        ],
      ),
    );
  }
}
