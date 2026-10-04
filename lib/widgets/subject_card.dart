import 'package:flutter/material.dart';
import '../models/subject_model.dart';
import '../theme/app_theme.dart';

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final VoidCallback onTap;

  const SubjectCard({
    Key? key,
    required this.subject,
    required this.onTap,
  }) : super(key: key);

  Color _getAccentColor() {
    try {
      return Color(int.parse(subject.colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AriseColors.neonCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: AriseColors.cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: accentColor.withOpacity(0.35), width: 1),
          boxShadow: [
            BoxShadow(
              color: accentColor.withOpacity(0.08),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentColor.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(subject.icon, style: const TextStyle(fontSize: 14)),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subject.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Lv. ${subject.level}",
              style: const TextStyle(
                color: AriseColors.textMuted,
                fontSize: 9,
              ),
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: subject.progressPercent / 100.0,
                backgroundColor: Colors.white12,
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "${subject.progressPercent}%",
              style: TextStyle(
                color: accentColor,
                fontSize: 8.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
