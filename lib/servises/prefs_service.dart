import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/notes_model.dart';

class Prefs {

  /// * Prefs-Note
  static Future<bool> storeNoteList(List<Note> list) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> stringList = list.map((note) => jsonEncode(note.toJson())).toList();
    return await pref.setStringList('noteList', stringList);
  }

  static Future<List<Note>?> loadNoteList() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<Note>? noteList =  pref.getStringList("noteList")?.map((stringNote) => Note.fromJson(jsonDecode(stringNote))).toList();
    return noteList;
  }

  static Future<bool> removeNote() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove("note");
  }

  // * Prefs-isDark
  static storeDark(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('dark', isDark);
  }

  static Future<bool?> loadDark() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("dark");
  }

}