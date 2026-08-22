import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/driver_model.dart';
import '../data/driver_repository.dart';
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
    with WidgetsBindingObserver, TickerProviderStateMixin {
  MobileScannerController? _scannerController;

  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _cameraOpen = false;
  bool _cameraVisible = false;
  bool _isScanning = false;
  bool _cooldown = false;
  bool _torchOn = false;

  Timer? _autoTorchTimer;

  bool _showInlineError = false;
  bool _showSuccessOverlay = false;
  String _errorMessage = '';

  late AnimationController _scanLineController;
  late AnimationController _successController;

  static const double _frameSize = 220;
  static const double _closedSize = 260;
  static const double _openHeight = 420;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _scanLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    _autoTorchTimer?.cancel();

    _scannerController?.dispose();

    _scanLineController.dispose();
    _successController.dispose();

    _audioPlayer.dispose();

    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // QR VALIDATION
  // ---------------------------------------------------------------------------

  bool _isValidDriverQr(String value) {
    final cleaned = value.trim().toUpperCase();

    if (cleaned.isEmpty) {
      return false;
    }

    /*
     * IMPORTANT:
     *
     * The actual Yeyo driver card QR contains the driver code directly.
     *
     * Example from your card:
     *
     * YY458658
     *
     * It does NOT contain:
     *
     * YEYO-DRIVER-YY458658
     *
     * Therefore we must NOT require the YEYO-DRIVER- prefix.
     */

    final driverCodeRegex = RegExp(r'^[A-Z0-9]{3,}$');

    return driverCodeRegex.hasMatch(cleaned);
  }

  // ---------------------------------------------------------------------------
  // HANDLE QR SCAN
  // ---------------------------------------------------------------------------

  Future<void> _handleScan(String rawValue) async {
    if (_isScanning || _cooldown) {
      return;
    }

    _autoTorchTimer?.cancel();

    final code = rawValue.trim().toUpperCase();

    if (code.isEmpty) {
      return;
    }

    // ---------------------------------------------------------------
    // Validate QR
    // ---------------------------------------------------------------

    if (!_isValidDriverQr(code)) {
      _cooldown = true;

      if (mounted) {
        setState(() {
          _showInlineError = true;
          _errorMessage =
              T.get(context)['invalid_qr'] ?? 'Invalid Yeyo driver QR code';
        });
      }

      await ScanFeedback.onError();

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) {
        return;
      }

      setState(() {
        _showInlineError = false;
        _cooldown = false;
      });

      return;
    }

    // ---------------------------------------------------------------
    // Start API request
    // ---------------------------------------------------------------

    _isScanning = true;

    // Stop scanner so the same QR isn't detected multiple times.
    await _scannerController?.stop();

    await ScanFeedback.onSuccess();

    await _playCustomBeepIfEnabled();

    if (mounted) {
      setState(() {
        _showSuccessOverlay = true;
      });

      _successController.forward(from: 0);
    }

    Driver? driver;

    try {
      /*
       * API:
       *
       * GET /drivers/{driver_code}
       *
       * Example:
       *
       * GET /drivers/YY458658
       *
       * The repository handles the actual HTTP request.
       */

      driver = await DriverRepository.instance.getDriverByBadge(code);
    } catch (e) {
      if (!mounted) {
        return;
      }

      setState(() {
        _showSuccessOverlay = false;
        _showInlineError = true;
        _errorMessage = _getApiErrorMessage(e);
      });

      await ScanFeedback.onError();

      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) {
        return;
      }

      setState(() {
        _showInlineError = false;
        _isScanning = false;
        _cooldown = false;
      });

      // Restart scanner after error.
      await _scannerController?.start();

      return;
    }

    await Future.delayed(const Duration(milliseconds: 450));

    if (!mounted) {
      return;
    }

    // ---------------------------------------------------------------
    // Driver not found
    // ---------------------------------------------------------------

    if (driver == null) {
      setState(() {
        _showSuccessOverlay = false;
        _isScanning = false;
      });

      Navigator.pushNamed(context, '/not-approved');

      return;
    }

    // ---------------------------------------------------------------
    // Check API status
    // ---------------------------------------------------------------

    final bool isApproved = driver.status.toLowerCase().trim() == 'approved';

    setState(() {
      _showSuccessOverlay = false;
      _isScanning = false;
    });

    // ---------------------------------------------------------------
    // Approved driver
    // ---------------------------------------------------------------

    if (isApproved) {
      Navigator.pushNamed(context, '/approved', arguments: driver);
    }
    // ---------------------------------------------------------------
    // Not approved driver
    // ---------------------------------------------------------------
    else {
      Navigator.pushNamed(context, '/not-approved', arguments: driver);
    }
  }

  // ---------------------------------------------------------------------------
  // API ERROR
  // ---------------------------------------------------------------------------

  String _getApiErrorMessage(Object error) {
    final message = error.toString();

    if (message.contains('404')) {
      return T.get(context)['no_driver_info'] ?? 'No driver information found';
    }

    if (message.contains('SocketException')) {
      return T.get(context)['network_error'] ??
          'Please check your internet connection';
    }

    if (message.contains('Timeout')) {
      return T.get(context)['network_error'] ??
          'Please check your internet connection';
    }

    return T.get(context)['error_loading_driver'] ?? 'Unable to verify driver';
  }

  // ---------------------------------------------------------------------------
  // SUCCESS BEEP
  // ---------------------------------------------------------------------------

  Future<void> _playCustomBeepIfEnabled() async {
    final prefs = await SharedPreferences.getInstance();

    final beep = prefs.getBool('beep') ?? false;

    if (!beep) {
      return;
    }

    await _audioPlayer.stop();

    await _audioPlayer.play(
      AssetSource('sounds/scan_success.mp3'),
      volume: 1.0,
    );
  }

  // ---------------------------------------------------------------------------
  // OPEN CAMERA
  // ---------------------------------------------------------------------------

  void _openCamera() {
    if (_cameraOpen) {
      return;
    }

    setState(() {
      _cameraOpen = true;

      _scannerController = MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        facing: CameraFacing.back,
      );
    });

    Future.delayed(const Duration(milliseconds: 120), () {
      if (!mounted) {
        return;
      }

      setState(() {
        _cameraVisible = true;
      });
    });

    _autoTorchTimer?.cancel();

    _autoTorchTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted || _isScanning || _scannerController == null || _torchOn) {
        return;
      }

      _scannerController?.toggleTorch();

      setState(() {
        _torchOn = true;
      });
    });
  }

  // ---------------------------------------------------------------------------
  // CLOSE CAMERA
  // ---------------------------------------------------------------------------

  void _closeCamera() {
    if (!_cameraOpen) {
      return;
    }

    _autoTorchTimer?.cancel();

    _scannerController?.stop();
    _scannerController?.dispose();

    _scannerController = null;

    setState(() {
      _cameraOpen = false;
      _cameraVisible = false;
      _showInlineError = false;
      _showSuccessOverlay = false;
      _torchOn = false;
      _isScanning = false;
      _cooldown = false;
    });
  }

  // ---------------------------------------------------------------------------
  // BUILD
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final t = T.get(context);

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // ---------------------------------------------------------------
            // BACKGROUND TAP TO CLOSE
            // ---------------------------------------------------------------
            if (_cameraOpen)
              Positioned.fill(
                child: GestureDetector(
                  onTap: _closeCamera,
                  behavior: HitTestBehavior.opaque,
                ),
              ),

            Column(
              children: [
                const Spacer(),

                const SizedBox(height: 16),

                // -------------------------------------------------------------
                // INSTRUCTION
                // -------------------------------------------------------------
                Text(
                  t['scan_instruction'] ??
                      'Position the code within the frame to scan',
                  style: AppTextStyle.body.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 24),

                // -------------------------------------------------------------
                // SCANNER
                // -------------------------------------------------------------
                GestureDetector(
                  onTap: _openCamera,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutCubic,
                    width: _cameraOpen ? screenWidth * 0.92 : _closedSize,
                    height: _cameraOpen ? _openHeight : _closedSize,
                    margin: EdgeInsets.only(top: _cameraOpen ? 16 : 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: AppColors.green, width: 3),
                      color: AppColors.darkCard,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          // ---------------------------------------------------
                          // CLOSED CAMERA
                          // ---------------------------------------------------
                          if (!_cameraOpen)
                            Container(
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    'assets/qr_placeholder.png',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Center(
                                child: Image.asset(
                                  'assets/barcode.png',
                                  width: 160,
                                ),
                              ),
                            ),

                          // ---------------------------------------------------
                          // LIVE CAMERA
                          // ---------------------------------------------------
                          if (_cameraOpen)
                            AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: _cameraVisible ? 1 : 0,
                              child: MobileScanner(
                                controller: _scannerController,
                                fit: BoxFit.cover,
                                onDetect: (capture) {
                                  if (capture.barcodes.isEmpty) {
                                    return;
                                  }

                                  final code =
                                      capture.barcodes.first.rawValue ?? '';

                                  _handleScan(code);
                                },
                              ),
                            ),

                          // ---------------------------------------------------
                          // SCAN LINE
                          // ---------------------------------------------------
                          if (_cameraOpen)
                            AnimatedBuilder(
                              animation: _scanLineController,
                              builder: (_, __) {
                                return Positioned(
                                  top:
                                      (_openHeight - _frameSize) / 2 +
                                      _scanLineController.value * _frameSize,
                                  left: (screenWidth * 0.92 - _frameSize) / 2,
                                  child: Container(
                                    width: _frameSize,
                                    height: 2,
                                    color: AppColors.green,
                                  ),
                                );
                              },
                            ),

                          // ---------------------------------------------------
                          // SUCCESS OVERLAY
                          // ---------------------------------------------------
                          if (_showSuccessOverlay)
                            FadeTransition(
                              opacity: _successController,
                              child: Container(
                                color: Colors.green.withOpacity(0.35),
                                child: const Center(
                                  child: Icon(
                                    Icons.check_circle,
                                    color: Colors.white,
                                    size: 96,
                                  ),
                                ),
                              ),
                            ),

                          // ---------------------------------------------------
                          // ERROR
                          // ---------------------------------------------------
                          if (_showInlineError)
                            Positioned(
                              bottom: 12,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.red.shade700,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    _errorMessage,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                // -------------------------------------------------------------
                // FLASHLIGHT
                // -------------------------------------------------------------
                AnimatedPadding(
                  duration: const Duration(milliseconds: 420),
                  curve: Curves.easeOutCubic,
                  padding: EdgeInsets.only(top: _cameraOpen ? 40 : 16),
                  child: GestureDetector(
                    onTap: () {
                      if (!_cameraOpen) {
                        _openCamera();
                        return;
                      }

                      _scannerController?.toggleTorch();

                      setState(() {
                        _torchOn = !_torchOn;
                      });
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF2A3442),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.flashlight_on,
                          size: 28,
                          color: _torchOn
                              ? AppColors.green
                              : AppColors.green.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                // -------------------------------------------------------------
                // BOTTOM NAVIGATION
                // -------------------------------------------------------------
                const BottomNavBar(active: BottomTab.scan),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
