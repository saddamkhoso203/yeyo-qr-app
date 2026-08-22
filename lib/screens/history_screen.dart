import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../widgets/bottom_nav.dart';
import '../Languages/translator.dart';
import '../data/scan_history_repository.dart';
import 'scan_detail_screen.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  String _formatTime(DateTime? timestamp, T t) {
    if (timestamp == null) return '';

    // timestamp is already a DateTime.
    final date = timestamp;
    final now = DateTime.now();

    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return '${t['today'] ?? 'Today'}, ${_formatHour(date)}';
    } else if (difference == 1) {
      return '${t['yesterday'] ?? 'Yesterday'}, ${_formatHour(date)}';
    } else {
      return '${_monthName(date.month, t)} ${date.day}, ${_formatHour(date)}';
    }
  }

  String _formatHour(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final amPm = date.hour >= 12 ? 'PM' : 'AM';

    return '$hour:${date.minute.toString().padLeft(2, '0')} $amPm';
  }

  String _monthName(int month, T t) {
    final months = [
      t['month_jan'] ?? 'Jan',
      t['month_feb'] ?? 'Feb',
      t['month_mar'] ?? 'Mar',
      t['month_apr'] ?? 'Apr',
      t['month_may'] ?? 'May',
      t['month_jun'] ?? 'Jun',
      t['month_jul'] ?? 'Jul',
      t['month_aug'] ?? 'Aug',
      t['month_sep'] ?? 'Sep',
      t['month_oct'] ?? 'Oct',
      t['month_nov'] ?? 'Nov',
      t['month_dec'] ?? 'Dec',
    ];

    return months[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    return Scaffold(
      appBar: AppBar(title: Text(t['history'] ?? 'History')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<ScanHistoryItem>>(
              stream: ScanHistoryRepository.getScanHistory(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        t['error_loading_history'] ?? 'Error loading history',
                        textAlign: TextAlign.center,
                        style: AppTextStyle.body,
                      ),
                    ),
                  );
                }

                final items = snapshot.data ?? [];

                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      t['no_history'] ?? 'No history found',
                      style: AppTextStyle.body,
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: items.length,
                  separatorBuilder: (_, __) {
                    return const Divider(height: 1, color: AppColors.border);
                  },
                  itemBuilder: (_, index) {
                    final item = items[index];

                    final isQr = item.type == 'qr';
                    final scannedId = item.scannedId;
                    final scannedAt = item.scannedAt;

                    return _HistoryRow(
                      title: isQr
                          ? (t['qr_code'] ?? 'QR Code')
                          : (t['barcode'] ?? 'Barcode'),
                      subtitle: scannedId,
                      time: _formatTime(scannedAt, t),
                      icon: isQr ? Icons.qr_code : Icons.qr_code_scanner,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ScanDetailScreen(scannedId: scannedId),
                          ),
                        );
                      },
                    );
                  },
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
  final IconData icon;
  final VoidCallback onTap;

  const _HistoryRow({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.lightBackground,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, size: 18, color: AppColors.textSecondary),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyle.small.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 2),

                  Text(
                    subtitle,
                    style: AppTextStyle.small.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    time,
                    style: AppTextStyle.small.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
