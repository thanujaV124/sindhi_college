
class Subjects {
  final String? id;
  final String? name;
  final String? desc;
  final List<String> modules;
  final List<String> notes;

  Subjects(
      {required this.id,
      required this.name,
      required this.desc,
      required this.modules,
      required this.notes});

  factory Subjects.fromJson(Map<String, dynamic> json) {
    return Subjects(
        id: json['id'],
        name: json['name'],
        desc: json['description'],
        modules: parseModules(json['modules']),
        notes: parseNotes(json['notes']));
  }

  get description => null;

  static List<String> parseModules(modulesJson) {
    List<String> modulesList = List<String>.from(modulesJson);

    return modulesList;
  }

  static List<String> parseNotes(notesJson) {
    List<String> notesList = List<String>.from(notesJson);

    return notesList;
  }
}
