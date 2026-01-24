import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../data/driver_model.dart';
import '../data/driver_repository.dart';
import '../data/scan_history_repository.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_style.dart';
import '../widgets/bottom_nav.dart';
import '../Languages/translator.dart';
import '../utils/scan_feedback.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen>
    with WidgetsBindingObserver {
  bool _isScanning = false;
  MobileScannerController? _scannerController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController?.dispose();
    super.dispose();
  }

  /// 🔐 VALIDATE DRIVER QR FORMAT
  bool _isValidDriverQr(String value) {
    final cleaned = value.trim().toUpperCase();

    if (cleaned.startsWith('HTTP') ||
        cleaned.startsWith('WWW') ||
        cleaned.contains('://')) {
      return false;
    }

    final regex = RegExp(r'^[A-Z0-9]{5,}$');
    return regex.hasMatch(cleaned);
  }

  /// Handles scanned QR result
  Future<void> _handleScan(BuildContext context, String scannedId) async {
    if (_isScanning) return;
    _isScanning = true;

    final code = scannedId.trim().toUpperCase();

    // ❌ INVALID QR
    if (!_isValidDriverQr(code)) {
      _showError(context);
      _isScanning = false;
      return;
    }

    // 🔄 Loading overlay
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: AppColors.green),
      ),
    );

    Driver? driver = await DriverRepository.getDriverByBadge(code);
    driver ??= DriverRepository.getDriver(code);

    if (!mounted) return;
    Navigator.pop(context); // close loader

    // 🔔📳 Apply user feedback settings
    await ScanFeedback.onSuccess();

    // 💾 SAVE SCAN HISTORY (only if enabled)
    await ScanHistoryRepository.saveScan(
      scannedId: code,
      isApproved: driver?.isApproved ?? false,
    );

    if (driver == null) {
      Navigator.pushNamed(context, '/not-approved', arguments: null);
    } else if (driver.isApproved) {
      Navigator.pushNamed(context, '/approved', arguments: driver);
    } else {
      Navigator.pushNamed(context, '/not-approved', arguments: driver);
    }

    await Future.delayed(const Duration(seconds: 1));
    _isScanning = false;
  }

  /// 🚨 Invalid QR feedback
  void _showError(BuildContext context) {
    final t = T.get(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red.shade700,
        content: Text(
          t['invalid_qr'] ??
              'Invalid QR code. Please scan a Yeyo driver badge.',
          style: const TextStyle(color: Colors.white),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Opens camera scanner
  void _openCameraScanner(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (_) {
        _scannerController = MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          facing: CameraFacing.back,
        );

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.92,
          child: Stack(
            children: [
              MobileScanner(
                controller: _scannerController,
                fit: BoxFit.cover,
                onDetect: (capture) {
                  final barcodes = capture.barcodes;
                  if (barcodes.isNotEmpty) {
                    final code = barcodes.first.rawValue ?? '';
                    _scannerController?.stop();
                    Navigator.pop(context);
                    _handleScan(context, code);
                  }
                },
              ),

              Positioned(
                top: 40,
                right: 20,
                child: GestureDetector(
                  onTap: () {
                    _scannerController?.stop();
                    Navigator.pop(context);
                  },
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.close, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).whenComplete(() {
      _scannerController?.dispose();
      _scannerController = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 16),

            Text(
              t['scan_instruction'] ??
                  'Position the code within the frame to scan',
              style: AppTextStyle.body.copyWith(color: Colors.white70),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 32),

            GestureDetector(
              onTap: () => _openCameraScanner(context),
              child: Container(
                width: 260,
                height: 260,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppColors.green, width: 3),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/qr_placeholder.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Image.asset('assets/barcode.png'),
                  ),
                ),
              ),
            ),

            const Spacer(),

            const BottomNavBar(active: BottomTab.scan),
          ],
        ),
      ),
    );
  }
}
