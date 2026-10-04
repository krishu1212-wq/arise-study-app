import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/mission_model.dart';
import '../models/subject_model.dart';
import '../theme/app_theme.dart';
import '../widgets/particle_background.dart';
import '../widgets/mission_card.dart';
import '../widgets/subject_card.dart';
import 'focus_timer_dialog.dart';
import 'gate_dungeon_modal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Player Stats
  String playerName = "Kishan";
  int playerLevel = 28;
  int currentXp = 1240;
  int maxXp = 2000;
  int gems = 2450;
  int coins = 320;
  int streakDays = 12;

  // Selected Nav Tab
  int _selectedTabIndex = 0;

  // Missions
  List<Mission> missions = [
    Mission(id: '1', title: 'Read 1 NCERT Book', icon: '📖', xpReward: 150, coinReward: 25, colorHex: '#00E5FF', isCompleted: true),
    Mission(id: '2', title: 'Watch 1 Maths Lecture', icon: '▶', xpReward: 180, coinReward: 30, colorHex: '#FFB703', isCompleted: true),
    Mission(id: '3', title: 'Learn 1 Page Vocab', icon: 'Aa', xpReward: 120, coinReward: 20, colorHex: '#A855F7', isCompleted: true),
    Mission(id: '4', title: 'Solve 30 Practice Qs', icon: '📝', xpReward: 250, coinReward: 40, colorHex: '#F43F5E', isCompleted: false),
    Mission(id: '5', title: 'Make English Notes', icon: '📑', xpReward: 200, coinReward: 35, colorHex: '#10B981', isCompleted: false),
    Mission(id: '6', title: 'Revision Task (Sat)', icon: '🎯', xpReward: 300, coinReward: 50, colorHex: '#EAB308', isCompleted: false, isLocked: true),
  ];

  // Subjects
  List<Subject> subjects = [
    Subject(id: 'maths', name: 'Maths', icon: '➗', level: 24, progressPercent: 72, colorHex: '#F43F5E'),
    Subject(id: 'english', name: 'English', icon: '📖', level: 18, progressPercent: 56, colorHex: '#00E5FF'),
    Subject(id: 'computer', name: 'Computer', icon: '💻', level: 12, progressPercent: 34, colorHex: '#10B981'),
    Subject(id: 'reasoning', name: 'Reasoning', icon: '🧠', level: 10, progressPercent: 28, colorHex: '#A855F7'),
  ];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
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

  void _onToggleMission(Mission mission) {
    setState(() {
      mission.isCompleted = !mission.isCompleted;
      if (mission.isCompleted) {
        _addXp(mission.xpReward);
        coins += mission.coinReward;
        _showToast("Quest Completed! +${mission.xpReward} XP, +${mission.coinReward} Coins");
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

  int get completedMissionCount => missions.where((m) => m.isCompleted).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AriseColors.background,
      body: ParticleBackground(
        child: SafeArea(
          bottom: false,
          child: Stack(
            children: [
              // Scrollable Body
              SingleChildScrollView(
                padding: const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 90),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 14),
                    _buildHeroBanner(),
                    const SizedBox(height: 18),
                    _buildMissionsSection(),
                    const SizedBox(height: 18),
                    _buildSubjectProgressSection(),
                    const SizedBox(height: 16),
                    _buildFeatureActionGrid(),
                    const SizedBox(height: 16),
                    _buildNextBestActionCard(),
                    const SizedBox(height: 16),
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

  // Header: Profile, XP Bar, Gems, Coins, Streak
  Widget _buildHeader() {
    double xpProgress = (currentXp / maxXp).clamp(0.0, 1.0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Avatar + Name + Level + XP Bar
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AriseColors.neonCyan, AriseColors.neonBlue, AriseColors.neonPurple],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AriseColors.neonCyan.withOpacity(0.5),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Center(
                child: CircleAvatar(
                  radius: 22,
                  backgroundColor: Color(0xFF070E24),
                  child: Text("⚡", style: TextStyle(fontSize: 20)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      playerName,
                      style: const TextStyle(
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
                          backgroundColor: Colors.black45,
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
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Streak
            GestureDetector(
              onTap: () => _showToast("🔥 $streakDays-Day Streak! 1.2x Daily XP multiplier"),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF451A03), Color(0xFF78350F)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AriseColors.neonGold.withOpacity(0.5)),
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

  // Hero Banner: ARISE STUDY SYSTEM
  Widget _buildHeroBanner() {
    double phaseProgress = 0.68;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF09142E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AriseColors.neonCyan.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: AriseColors.neonCyan.withOpacity(0.15),
            blurRadius: 18,
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("👑", style: TextStyle(fontSize: 18)),
            ],
          ),
          const Text(
            "ARISE",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 6,
            ),
          ),
          const Text(
            "STUDY SYSTEM",
            style: TextStyle(
              color: AriseColors.neonCyan,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 3,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF050B1B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    "“A SMALL STEP TODAY\nA BIGGER YOU TOMORROW.”",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ),
                Container(
                  width: 140,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B1736),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AriseColors.neonCyan.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "CURRENT PHASE",
                        style: TextStyle(color: AriseColors.neonCyan, fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                      const Text(
                        "THE AWAKENING",
                        style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Progress", style: TextStyle(color: AriseColors.textMuted, fontSize: 8)),
                          Text("${(phaseProgress * 100).toInt()}%", style: const TextStyle(color: AriseColors.neonCyan, fontSize: 8, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: phaseProgress,
                          backgroundColor: Colors.black45,
                          valueColor: const AlwaysStoppedAnimation<Color>(AriseColors.neonCyan),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Today's Missions
  Widget _buildMissionsSection() {
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
                  "$completedMissionCount / ${missions.length} Completed",
                  style: const TextStyle(color: AriseColors.neonGreen, fontSize: 11, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 4),
                const Text("View All →", style: TextStyle(color: AriseColors.neonCyan, fontSize: 10, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: missions.length,
            itemBuilder: (ctx, idx) => MissionCard(
              mission: missions[idx],
              onToggle: () => _onToggleMission(missions[idx]),
            ),
          ),
        ),
      ],
    );
  }

  // Subject Progress
  Widget _buildSubjectProgressSection() {
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
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.85,
          ),
          itemCount: subjects.length,
          itemBuilder: (ctx, idx) => SubjectCard(
            subject: subjects[idx],
            onTap: () => _showToast("📚 ${subjects[idx].name} Mastery: ${subjects[idx].progressPercent}%"),
          ),
        ),
      ],
    );
  }

  // Action Features Grid: Quests, Practice, Training, Inventory, System Core
  Widget _buildFeatureActionGrid() {
    final features = [
      {'title': 'Quests', 'sub': 'Daily & Sp.', 'icon': '📜', 'color': AriseColors.neonGold},
      {'title': 'Practice', 'sub': 'Solve & Grow', 'icon': '⚔️', 'color': AriseColors.neonPurple},
      {'title': 'Training', 'sub': 'Your Journey', 'icon': '🗺️', 'color': AriseColors.neonCyan},
      {'title': 'Inventory', 'sub': 'Items & Rew.', 'icon': '🎁', 'color': AriseColors.neonGold},
      {'title': 'System Core', 'sub': 'Stats & Ana.', 'icon': '💠', 'color': AriseColors.neonCyan},
    ];

    return Row(
      children: features.map((f) {
        Color c = f['color'] as Color;
        return Expanded(
          child: GestureDetector(
            onTap: () => _showToast("✨ Opening ${f['title']}"),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.5),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: AriseColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: c.withOpacity(0.35)),
              ),
              child: Column(
                children: [
                  Text(f['icon'] as String, style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(
                    f['title'] as String,
                    style: TextStyle(color: c, fontSize: 9.5, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    f['sub'] as String,
                    style: const TextStyle(color: AriseColors.textMuted, fontSize: 7),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Next Best Action Card
  Widget _buildNextBestActionCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF09142E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AriseColors.neonCyan.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AriseColors.neonGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AriseColors.neonGold.withOpacity(0.4)),
                ),
                child: const Center(child: Text("🎯", style: TextStyle(fontSize: 20))),
              ),
              const SizedBox(width: 12),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "NEXT BEST ACTION",
                    style: TextStyle(color: AriseColors.neonGold, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 2),
                  Text(
                    "Watch Percentage - Class 1",
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "(Careerwill) • Est. 45 mins",
                    style: TextStyle(color: AriseColors.textMuted, fontSize: 9.5),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AriseColors.neonCyan,
              foregroundColor: const Color(0xFF050814),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            onPressed: () {
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
            child: const Row(
              children: [
                Icon(Icons.play_arrow, size: 16),
                SizedBox(width: 2),
                Text("Start Now", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Boss Battle Banner
  Widget _buildBossBattleBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF160A26),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AriseColors.neonPurple.withOpacity(0.5)),
        boxShadow: [
          BoxShadow(
            color: AriseColors.neonPurple.withOpacity(0.15),
            blurRadius: 14,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B0764),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  "SATURDAY",
                  style: TextStyle(color: AriseColors.neonPurple, fontSize: 8, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                "BOSS BATTLE",
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w900, letterSpacing: 1),
              ),
              const Text(
                "Complete your weekly revision to unlock!",
                style: TextStyle(color: AriseColors.textMuted, fontSize: 9.5),
              ),
            ],
          ),
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black45,
              border: Border.all(color: AriseColors.neonPurple.withOpacity(0.4)),
            ),
            child: const Center(child: Text("🔒", style: TextStyle(fontSize: 14))),
          ),
        ],
      ),
    );
  }

  // Bottom Navigation Bar
  Widget _buildBottomNavBar() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xFF040816).withOpacity(0.96),
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
              const SizedBox(width: 50), // Spacer for central Gate button
              _buildNavItem(2, Icons.shield_outlined, "Practice"),
              _buildNavItem(3, Icons.note_alt_outlined, "Notes"),
            ],
          ),

          // Glowing central GATE button
          Positioned(
            top: -18,
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
              child: Column(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AriseColors.neonBlue, AriseColors.neonCyan],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AriseColors.neonCyan.withOpacity(0.6),
                          blurRadius: 18,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text("⛩️", style: TextStyle(fontSize: 26)),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    "GATE",
                    style: TextStyle(
                      color: AriseColors.neonCyan,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
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
