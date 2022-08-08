import 'dart:convert';

class Note {
  late String text;
  late Map<String, dynamic> date;
  bool isSelected = false;

  Note({required this.date, required this.text});

  Note.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'date': date
  };

  static String encode(List<Note> notes) => json.encode(
    notes.map<Map<String, dynamic>>((note) => note.toJson()).toList(),
  );

  static List<Note> decode(String notes) =>
      json.decode(notes).map<Note>((item) => Note.fromJson(item)).toList();
}

List<Note> notes = [];