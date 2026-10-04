import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class FocusTimerDialog extends StatefulWidget {
  final VoidCallback onSessionComplete;
  const FocusTimerDialog({Key? key, required this.onSessionComplete}) : super(key: key);

  @override
  State<FocusTimerDialog> createState() => _FocusTimerDialogState();
}

class _FocusTimerDialogState extends State<FocusTimerDialog> {
  int _secondsLeft = 45 * 60;
  bool _isRunning = true;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft > 0) {
        setState(() {
          _secondsLeft--;
        });
      } else {
        _timer?.cancel();
        widget.onSessionComplete();
        Navigator.pop(context);
      }
    });
  }

  void _toggleTimer() {
    if (_isRunning) {
      _timer?.cancel();
    } else {
      _startTimer();
    }
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int minutes = _secondsLeft ~/ 60;
    int seconds = _secondsLeft % 60;
    double progress = (45 * 60 - _secondsLeft) / (45 * 60);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF080D21),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AriseColors.neonCyan.withOpacity(0.5)),
          boxShadow: [
            BoxShadow(
              color: AriseColors.neonCyan.withOpacity(0.3),
              blurRadius: 30,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "FOCUS STUDY DUNGEON",
              style: TextStyle(
                color: AriseColors.neonCyan,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              "Watch Percentage - Class 1",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Circular countdown ring
            SizedBox(
              width: 170,
              height: 170,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 170,
                    height: 170,
                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 8,
                      backgroundColor: Colors.white12,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AriseColors.neonCyan,
                      ),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 34,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "MANA FLOWING",
                        style: TextStyle(
                          color: AriseColors.textCyan,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isRunning
                          ? AriseColors.neonCyan
                          : AriseColors.neonGreen,
                      foregroundColor: const Color(0xFF050814),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: _toggleTimer,
                    child: Text(
                      _isRunning ? "PAUSE" : "RESUME",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: AriseColors.neonRed,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text("END", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
