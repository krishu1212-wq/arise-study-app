class Subject {
  final String id;
  final String name;
  final String icon;
  final int level;
  final int progressPercent;
  final String colorHex;

  Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.level,
    required this.progressPercent,
    required this.colorHex,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'icon': icon,
    'level': level,
    'progressPercent': progressPercent,
    'colorHex': colorHex,
  };

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    id: json['id'],
    name: json['name'],
    icon: json['icon'],
    level: json['level'],
    progressPercent: json['progressPercent'],
    colorHex: json['colorHex'],
  );
}
