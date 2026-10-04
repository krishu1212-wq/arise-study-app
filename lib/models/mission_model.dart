class Mission {
  final String id;
  final String title;
  final String icon;
  final int xpReward;
  final int coinReward;
  final String colorHex;
  bool isCompleted;
  final bool isLocked;

  Mission({
    required this.id,
    required this.title,
    required this.icon,
    required this.xpReward,
    required this.coinReward,
    required this.colorHex,
    this.isCompleted = false,
    this.isLocked = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'icon': icon,
    'xpReward': xpReward,
    'coinReward': coinReward,
    'colorHex': colorHex,
    'isCompleted': isCompleted,
    'isLocked': isLocked,
  };

  factory Mission.fromJson(Map<String, dynamic> json) => Mission(
    id: json['id'],
    title: json['title'],
    icon: json['icon'],
    xpReward: json['xpReward'],
    coinReward: json['coinReward'],
    colorHex: json['colorHex'],
    isCompleted: json['isCompleted'] ?? false,
    isLocked: json['isLocked'] ?? false,
  );
}
