import '../config/app_config.dart';
import '../util/id_generator_util.dart';

class Participant {
  final String uid;
  final String name;

  Participant._({required this.uid, required this.name});

  // Synchronous constructor if id is provided
  Participant({required this.name, required this.uid});

  // Asynchronous factory for auto-generating id
  static Future<Participant> create({required String name}) async {
    final id = await IdGeneratorUtil.generateId(IdentifierType.participant);
    return Participant._(uid: id, name: name);
  }

  Participant copyWith({String? id, String? name}) {
    return Participant(uid: id ?? uid, name: name ?? this.name);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': uid,
      'name': name,
    };
  }

  factory Participant.fromMap(Map<String, dynamic> map) {
    return Participant(
      uid: map['id'],
      name: map['name'],
    );
  }
}
