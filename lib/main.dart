import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:note_crud_app_task/pages/shared_note_ui.dart';

void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await EasyLocalization.ensureInitialized();

 runApp(
   EasyLocalization(
     supportedLocales: const [Locale('en', 'US'), Locale('ru', 'RU')],
     path: 'assets/translations',
     fallbackLocale: const Locale('en', 'US'),
     child: const MyApp(),
   ),
 );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Note App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       primarySwatch: Colors.blue,
      ),
      home: const SharedNoteUI(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
