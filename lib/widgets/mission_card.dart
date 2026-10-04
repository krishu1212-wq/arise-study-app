import 'package:flutter/material.dart';
import '../models/mission_model.dart';
import '../theme/app_theme.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;
  final VoidCallback onToggle;

  const MissionCard({
    Key? key,
    required this.mission,
    required this.onToggle,
  }) : super(key: key);

  Color _getAccentColor() {
    try {
      return Color(int.parse(mission.colorHex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return AriseColors.neonCyan;
    }
  }

  @override
  Widget build(BuildContext context) {
    final accentColor = _getAccentColor();

    return GestureDetector(
      onTap: mission.isLocked ? null : onToggle,
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AriseColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: mission.isCompleted
                ? AriseColors.neonGreen.withOpacity(0.5)
                : accentColor.withOpacity(0.4),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: (mission.isCompleted ? AriseColors.neonGreen : accentColor)
                  .withOpacity(0.12),
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon Container
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: accentColor.withOpacity(0.3)),
              ),
              child: Center(
                child: Text(
                  mission.icon,
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Title
            Expanded(
              child: Text(
                mission.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: mission.isLocked
                      ? AriseColors.textMuted
                      : AriseColors.textWhite,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Status Checkbox / Lock
            if (mission.isLocked)
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black38,
                  border: Border.all(color: AriseColors.neonGold.withOpacity(0.4)),
                ),
                child: const Center(
                  child: Text("🔒", style: TextStyle(fontSize: 10)),
                ),
              )
            else if (mission.isCompleted)
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AriseColors.neonGreen,
                ),
                child: const Center(
                  child: Icon(Icons.check, size: 14, color: Color(0xFF050814)),
                ),
              )
            else
              Container(
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: accentColor.withOpacity(0.6), width: 2),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
