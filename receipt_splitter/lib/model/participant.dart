import '../config/app_config.dart';
import '../util/id_generator_util.dart';

class Participant {
  final String id;
  final String name;

  Participant._({required this.id, required this.name});

  // Synchronous constructor if id is provided
  Participant({required this.name, required this.id});

  // Asynchronous factory for auto-generating id
  static Future<Participant> create({required String name}) async {
    final id = await IdGeneratorUtil.generateId(IdentifierType.participant);
    return Participant._(id: id, name: name);
  }

  Participant copyWith({String? id, String? name}) {
    return Participant(id: id ?? this.id, name: name ?? this.name);
  }
}
