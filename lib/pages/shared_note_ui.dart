import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:easy_localization/easy_localization.dart';

import '../model/notes_model.dart';
import '../servises/prefs_service.dart';

class SharedNoteUI extends StatefulWidget {
  const SharedNoteUI({Key? key}) : super(key: key);

  static const id = "/shared_note_ui";

  @override
  _SharedNoteUIState createState() => _SharedNoteUIState();
}

class _SharedNoteUIState extends State<SharedNoteUI> {
  final _textController = TextEditingController();
  bool isNotDark = true;
  late bool _isCreating;
  int _count = 0;
  bool haveSelected = false;

  void _save() {
    Note note = Note(
      date: {"ru_RU": DateFormat.MMMMd('ru_RU').format(DateTime.now()), "en_US": DateFormat.MMMMd('en_US').format(DateTime.now())},
      text: _textController.text.toString().trim(),
    );
    notes.add(note);

    Prefs.storeNoteList(notes);

    _textController.clear();
    setState(() {});
  }

  Future<void> _showDialog([int index = -1]) async {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) => ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 2,
            sigmaY: 2,
          ),
          child: AlertDialog(
            backgroundColor: Colors.white.withOpacity(0.6),
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              _isCreating ? "New".tr() : "Edit".tr(),
              style: const TextStyle(color: Colors.black),
            ),
            content: TextField(
              controller: _textController,
              decoration: InputDecoration(
                focusedBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    borderSide: BorderSide(
                      color: Colors.black,
                    )),
                hintText: "text".tr(),
                hintStyle: TextStyle(color: Colors.grey.shade700),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              maxLines: 12,
              cursorHeight: 24,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
                child: Text(
                  "cancel".tr(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (_isCreating) {
                    _save();
                  } else {
                    if (index >= 0) {
                      notes[index].text = _textController.text.toString().trim();
                      Prefs.storeNoteList(notes);
                    }
                    _textController.clear();
                    setState(() {});
                  }
                  Navigator.pop(context);
                },
                child: Text(
                  _isCreating ? "save".tr() : "edit".tr(),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Prefs.loadDark().then((value) => isNotDark = value ?? true);
    Prefs.loadNoteList().then((value) {
      setState(() {
        if (value != null) notes = value;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _count = 0;
    for (var element in notes) {
      if (element.isSelected) {
        _count++;
      }
    }

    if (_count != 0) {
      haveSelected = true;
    }

    return WillPopScope(
      onWillPop: () async {
        if (haveSelected) {
          for (var element in notes) {
            if (element.isSelected) {
              element.isSelected = false;
            }
          }
          haveSelected = false;
          setState(() {

          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: isNotDark ? Colors.white : Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            "notes".tr(),
            style: TextStyle(
              color: isNotDark ? Colors.black : Colors.white.withOpacity(0.8),
            ),
          ),
          actions: [
            haveSelected
                ? IconButton(
                    onPressed: () {
                      List<Note> selects = [];
                      for (var e in notes) {
                        if (!e.isSelected) {
                          selects.add(e);
                        }
                      }
                      notes = selects;
                      Prefs.storeNoteList(notes);
                      setState(() {});
                    },
                    icon: Icon(
                      Icons.delete,
                      color: isNotDark ? Colors.teal : Colors.white.withOpacity(0.8),
                    ),
                  )
                : const SizedBox.shrink(),
            IconButton(
              splashRadius: 26,
              onPressed: () {
                setState(() {
                  isNotDark = !isNotDark;
                });
                Prefs.storeDark(isNotDark);
              },

              //for change theme
              icon: Icon(
                isNotDark ? CupertinoIcons.moon_fill : CupertinoIcons.sun_min_fill,
                color: isNotDark ? Colors.black : Colors.white.withOpacity(0.4),
              ),
            ),
          ],
        ),
        body: ListView.builder(
          itemBuilder: (context, index) => buildNotes(index),
          itemCount: notes.length,
        ),
        bottomNavigationBar: BottomAppBar(
          color: isNotDark ?  Colors.teal : Colors.white.withOpacity(0.4),
          //color: Colors.teal,
          shape: const CircularNotchedRectangle(),
          notchMargin: 5,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                splashRadius: 24,
                icon: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white70,
                  child: Text(
                    "US",
                    style: TextStyle(
                      color: isNotDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                onPressed: () {
                  context.setLocale(const Locale('en', 'US'));
                },
              ),
              IconButton(
                splashRadius: 24,
                icon: CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white70,
                  child: Text(
                    "RU",
                    style: TextStyle(
                      color: isNotDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
                onPressed: () {
                  context.setLocale(const Locale('ru', 'RU'));
                },
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: isNotDark ? Colors.white70 : Colors.white.withOpacity(0.4),
          onPressed: () {
            _isCreating = true;
            _textController.clear();
            _showDialog();
          },
          child: const Text(
            "+",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w300,
              color: Colors.teal,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildNotes(int index) {
    return ClipRRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 2,
          sigmaY: 2,
        ),
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 5),
          decoration: BoxDecoration(
            color: isNotDark ? Colors.grey.shade200 : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Slidable(
            key: const ValueKey(0),
            enabled: !haveSelected,
            /// * onStart
            startActionPane: ActionPane(
              extentRatio: 0.2,
              motion: const ScrollMotion(),
              children: [
                const SizedBox(
                  width: 20,
                ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.teal.shade400,
                  child: IconButton(
                    splashRadius: 22,
                    onPressed: () {
                      _isCreating = false;
                      _textController.text = notes[index].text;
                      _showDialog(index = index);
                    },
                    icon: Icon(
                      Icons.edit,
                      color: isNotDark ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.only(left: 10, right: 10, top: 5),
              minLeadingWidth: 10,
              onTap: () {
                setState(() {
                  if (haveSelected) {
                    notes[index].isSelected = !notes[index].isSelected;
                  }
                });
              },
              onLongPress: () {
                setState(() {
                  notes[index].isSelected = !notes[index].isSelected;
                });
              },
              leading: const Icon(
                Icons.circle,
                color: Colors.teal,
                size: 16,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notes[index].date[EasyLocalization.of(context)!.locale.toString()],
                    style: const TextStyle(color: Colors.black38, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    notes[index].text,
                    style: TextStyle(
                        color: isNotDark ? Colors.black : Colors.black,
                        fontSize: 20),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
              trailing: haveSelected
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          if (haveSelected) {
                            notes[index].isSelected = !notes[index].isSelected;
                          }
                        });
                      },
                      icon: notes[index].isSelected
                          ? Icon(
                              Icons.check_circle,
                              color: isNotDark ? Colors.white : Colors.black,
                            )
                          : Icon(
                              Icons.circle_outlined,
                              color: isNotDark ? Colors.white : Colors.black,
                            ),
                    )
                  : const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
