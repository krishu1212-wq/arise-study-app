import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/app_theme.dart';
import '../widgets/particle_background.dart';
import 'focus_timer_dialog.dart';
import 'gate_dungeon_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Player Stats
  int playerLevel = 28;
  int currentXp = 1240;
  int maxXp = 2000;
  int gems = 2450;
  int coins = 320;
  int streakDays = 12;

  // Selected Nav Tab
  int _selectedTabIndex = 0;

  // Animation controller for pulsing glow
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  // Mission completion state
  List<bool> missionCompleted = [true, true, true, false, false, false];
  final List<int> missionXp = [150, 180, 120, 250, 200, 300];

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _loadPreferences();
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      playerLevel = prefs.getInt('playerLevel') ?? 28;
      currentXp = prefs.getInt('currentXp') ?? 1240;
      gems = prefs.getInt('gems') ?? 2450;
      coins = prefs.getInt('coins') ?? 320;
    });
  }

  Future<void> _savePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('playerLevel', playerLevel);
    await prefs.setInt('currentXp', currentXp);
    await prefs.setInt('gems', gems);
    await prefs.setInt('coins', coins);
  }

  void _onToggleMission(int index) {
    if (index == 5) {
      _showToast("🔒 Locked! Unlocks on Saturday revision day.");
      return;
    }

    setState(() {
      missionCompleted[index] = !missionCompleted[index];
      if (missionCompleted[index]) {
        int xp = missionXp[index];
        _addXp(xp);
        coins += 30;
        _showToast("⚡ Quest Completed! +$xp XP, +30 Coins");
      }
    });
    _savePreferences();
  }

  void _addXp(int amount) {
    setState(() {
      currentXp += amount;
      if (currentXp >= maxXp) {
        _triggerLevelUp();
      }
    });
  }

  void _triggerLevelUp() {
    setState(() {
      playerLevel += 1;
      currentXp = currentXp - maxXp;
      gems += 100;
      coins += 200;
    });
    _savePreferences();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF080D21),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: const BorderSide(color: AriseColors.neonGold, width: 2),
        ),
        title: const Column(
          children: [
            Text("👑", style: TextStyle(fontSize: 40)),
            SizedBox(height: 6),
            Text(
              "LEVEL UP!",
              style: TextStyle(
                color: AriseColors.neonGold,
                fontWeight: FontWeight.w900,
                fontSize: 22,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Hunter Kishan Reached Level $playerLevel!",
              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              "All core stats resonated with the System. Intelligence +5, Stamina +4!",
              style: TextStyle(color: AriseColors.textMuted, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("💎 +100 Gems", style: TextStyle(color: AriseColors.neonCyan, fontWeight: FontWeight.bold)),
                  Text("🪙 +200 Coins", style: TextStyle(color: AriseColors.neonGold, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AriseColors.neonGold,
              foregroundColor: Colors.black,
              minimumSize: const Size.fromHeight(45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text("CLAIM REWARDS ⚡", style: TextStyle(fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  void _showToast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF0A1533),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AriseColors.neonCyan, width: 1),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  int get completedMissionCount => missionCompleted.where((c) => c).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF030712),
      body: ParticleBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Scrollable Body
              SingleChildScrollView(
                padding: const EdgeInsets.only(left: 12, right: 12, top: 8, bottom: 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 12),
                    _buildHeroBannerWithCharacter(),
                    const SizedBox(height: 14),
                    _buildMissionsSection(),
                    const SizedBox(height: 14),
                    _buildSubjectProgressSection(),
                    const SizedBox(height: 14),
                    _buildFeatureActionGrid(),
                    const SizedBox(height: 14),
                    _buildNextBestActionCard(),
                    const SizedBox(height: 14),
                    _buildBossBattleBanner(),
                  ],
                ),
              ),

              // Bottom Navigation Bar with glowing center GATE
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _buildBottomNavBar(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Header: Exact Avatar with glowing eyes, XP Bar, Gems, Coins, Flame Streak
  Widget _buildHeader() {
    double xpProgress = (currentXp / maxXp).clamp(0.0, 1.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar + Name + Level + XP Bar
        Row(
          children: [
            AnimatedBuilder(
              animation: _glowAnimation,
              builder: (ctx, child) => Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AriseColors.neonCyan.withOpacity(0.5 * _glowAnimation.value),
                      blurRadius: 14 * _glowAnimation.value,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.asset(
                    "assets/images/avatar.png",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Kishan",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFF172554),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: AriseColors.neonCyan.withOpacity(0.5)),
                      ),
                      child: Text(
                        "Lv. $playerLevel",
                        style: const TextStyle(
                          color: AriseColors.neonCyan,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // XP Bar
                SizedBox(
                  width: 120,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$currentXp / $maxXp XP",
                        style: const TextStyle(color: AriseColors.neonCyan, fontSize: 9, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: xpProgress,
                          backgroundColor: Colors.black54,
                          valueColor: const AlwaysStoppedAnimation<Color>(AriseColors.neonCyan),
                          minHeight: 5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),

        // Currencies & Streak
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              children: [
                // Gems
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B132B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AriseColors.neonCyan.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Text("💎", style: TextStyle(fontSize: 11)),
                      const SizedBox(width: 4),
                      Text(
                        "$gems",
                        style: const TextStyle(color: AriseColors.textWhite, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 2),
                      const Text("+", style: TextStyle(color: AriseColors.neonCyan, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                // Coins
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B132B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AriseColors.neonGold.withOpacity(0.4)),
                  ),
                  child: Row(
                    children: [
                      const Text("🪙", style: TextStyle(fontSize: 11)),
                      const SizedBox(width: 4),
                      Text(
                        "$coins",
                        style: const TextStyle(color: AriseColors.neonGold, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 2),
                      const Text("+", style: TextStyle(color: AriseColors.neonGold, fontSize: 10, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Streak with animated flame
            GestureDetector(
              onTap: () => _showToast("🔥 $streakDays-Day Streak! Daily XP multiplier active"),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF451A03), Color(0xFF78350F)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AriseColors.neonGold.withOpacity(0.5)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.amber.withOpacity(0.2),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Text("🔥", style: TextStyle(fontSize: 12)),
                    const SizedBox(width: 4),
                    Text(
                      "$streakDays Days Streak >",
                      style: const TextStyle(color: Color(0xFFFDE68A), fontSize: 10.5, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Hero Banner: Exact Artwork with Castle, Glowing Blue Gate, and Character Silhouette
  Widget _buildHeroBannerWithCharacter() {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (ctx, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AriseColors.neonCyan.withOpacity(0.4 * _glowAnimation.value),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AriseColors.neonCyan.withOpacity(0.25 * _glowAnimation.value),
              blurRadius: 16,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset(
            "assets/images/hero_banner.png",
            fit: BoxFit.contain,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  // Today's Missions: Exact Visual Cards with Interactive Checkbox
  Widget _buildMissionsSection() {
    final missionImages = [
      "assets/images/mission_ncert.png",
      "assets/images/mission_maths.png",
      "assets/images/mission_vocab.png",
      "assets/images/mission_practice.png",
      "assets/images/mission_notes.png",
      "assets/images/mission_revision.png",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Text("✦", style: TextStyle(color: AriseColors.neonCyan, fontSize: 14)),
                SizedBox(width: 6),
                Text(
                  "TODAY'S MISSIONS",
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  "$completedMissionCount / 6 Completed",
                  style: const TextStyle(color: AriseColors.neonGreen, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                const Text("View All →", style: TextStyle(color: AriseColors.neonCyan, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 116,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: missionImages.length,
            itemBuilder: (ctx, idx) => GestureDetector(
              onTap: () => _onToggleMission(idx),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    if (missionCompleted[idx])
                      BoxShadow(
                        color: AriseColors.neonGreen.withOpacity(0.3),
                        blurRadius: 8,
                      ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    missionImages[idx],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Subject Progress: Exact 4-Column Subject Cards
  Widget _buildSubjectProgressSection() {
    final subjectImages = [
      "assets/images/subject_maths.png",
      "assets/images/subject_english.png",
      "assets/images/subject_computer.png",
      "assets/images/subject_reasoning.png",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("✦", style: TextStyle(color: AriseColors.neonCyan, fontSize: 14)),
                SizedBox(width: 6),
                Text(
                  "SUBJECT PROGRESS",
                  style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ],
            ),
            Text("View Details →", style: TextStyle(color: AriseColors.neonCyan, fontSize: 10, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: subjectImages.map((imgPath) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imgPath,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // 5 Action Tiles: Quests, Practice, Training, Inventory, System Core (Exact 3D Artworks)
  Widget _buildFeatureActionGrid() {
    final actionImages = [
      {"img": "assets/images/card_quests.png", "title": "Quests"},
      {"img": "assets/images/card_practice.png", "title": "Practice"},
      {"img": "assets/images/card_training.png", "title": "Training"},
      {"img": "assets/images/card_inventory.png", "title": "Inventory"},
      {"img": "assets/images/card_system_core.png", "title": "System Core"},
    ];

    return Row(
      children: actionImages.map((item) {
        return Expanded(
          child: GestureDetector(
            onTap: () => _showToast("✨ Opening ${item['title']}"),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  item["img"]!,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Next Best Action Card (Exact Artwork with Start Now Button)
  Widget _buildNextBestActionCard() {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (ctx) => FocusTimerDialog(
            onSessionComplete: () {
              _addXp(400);
              setState(() => coins += 100);
              _showToast("🏆 Focus Session Finished! +400 XP, +100 Coins");
            },
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          "assets/images/next_action.png",
          fit: BoxFit.contain,
          width: double.infinity,
        ),
      ),
    );
  }

  // Saturday Boss Battle Banner (Exact Artwork with Shadow Monarch Beast)
  Widget _buildBossBattleBanner() {
    return GestureDetector(
      onTap: () => _showToast("🔒 Complete weekly revision to unlock Boss Battle!"),
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (ctx, child) => Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AriseColors.neonPurple.withOpacity(0.3 * _glowAnimation.value),
                blurRadius: 14 * _glowAnimation.value,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              "assets/images/boss_battle.png",
              fit: BoxFit.contain,
              width: double.infinity,
            ),
          ),
        ),
      ),
    );
  }

  // Bottom Navigation Bar with exact glowing central GATE portal
  Widget _buildBottomNavBar() {
    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: const Color(0xFF040816).withOpacity(0.97),
        border: Border(top: BorderSide(color: AriseColors.neonCyan.withOpacity(0.25))),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, "Home"),
              _buildNavItem(1, Icons.play_circle_outline, "Classes"),
              const SizedBox(width: 60), // Spacer for central Gate button
              _buildNavItem(2, Icons.shield_outlined, "Practice"),
              _buildNavItem(3, Icons.note_alt_outlined, "Notes"),
            ],
          ),

          // Glowing central GATE button with exact portal artwork
          Positioned(
            top: -24,
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (ctx) => GateDungeonModal(
                    onEnterGate: () {
                      showDialog(
                        context: context,
                        builder: (c) => FocusTimerDialog(
                          onSessionComplete: () {
                            _addXp(500);
                            setState(() => coins += 150);
                            _showToast("⚔️ Monarch Dungeon Conquered! +500 XP");
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              child: AnimatedBuilder(
                animation: _glowAnimation,
                builder: (ctx, child) => Container(
                  width: 68,
                  height: 68,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AriseColors.neonCyan.withOpacity(0.7 * _glowAnimation.value),
                        blurRadius: 20 * _glowAnimation.value,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      "assets/images/gate_portal.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    bool isSelected = _selectedTabIndex == index;
    Color color = isSelected ? AriseColors.neonCyan : AriseColors.textMuted;

    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
