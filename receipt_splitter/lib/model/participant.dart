class Participant {
  final int id;
  final String name;

  Participant({
    required this.id,
    required this.name,
  });

  Participant copyWith({
    int? id,
    String? name,
  }) {
    return Participant(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}