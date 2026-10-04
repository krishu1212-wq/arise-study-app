import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class GateDungeonModal extends StatelessWidget {
  final VoidCallback onEnterGate;
  const GateDungeonModal({Key? key, required this.onEnterGate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF080D21),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: AriseColors.neonCyan, width: 2),
          boxShadow: [
            BoxShadow(
              color: AriseColors.neonCyan.withOpacity(0.35),
              blurRadius: 35,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Glowing portal icon
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF041228),
                border: Border.all(color: AriseColors.neonCyan, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: AriseColors.neonCyan.withOpacity(0.4),
                    blurRadius: 16,
                  ),
                ],
              ),
              child: const Center(
                child: Text("⛩️", style: TextStyle(fontSize: 28)),
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: AriseColors.neonCyan.withOpacity(0.12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AriseColors.neonCyan.withOpacity(0.4)),
              ),
              child: const Text(
                "RANK A DUNGEON DETECTED",
                style: TextStyle(
                  color: AriseColors.neonCyan,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "THE MONARCH'S GATE",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Entering this Gate will begin a 50-Minute Deep Work Study Dungeon. Monsters will fall with every question solved!",
              style: TextStyle(color: AriseColors.textMuted, fontSize: 12, height: 1.4),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Reward Cards
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF050917),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildRewardItem("+500", "HUNTER XP", AriseColors.neonCyan),
                  Container(width: 1, height: 28, color: Colors.white12),
                  _buildRewardItem("+150", "MANA COINS", AriseColors.neonGold),
                  Container(width: 1, height: 28, color: Colors.white12),
                  _buildRewardItem("EPIC", "SHADOW LOOT", AriseColors.neonPurple),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AriseColors.textMuted,
                      side: const BorderSide(color: Colors.white24),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("RETREAT", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AriseColors.neonCyan,
                      foregroundColor: const Color(0xFF050814),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 8,
                      shadowColor: AriseColors.neonCyan.withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      onEnterGate();
                    },
                    child: const Text("ENTER GATE ⚔️", style: TextStyle(fontWeight: FontWeight.w900)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: AriseColors.textMuted,
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
