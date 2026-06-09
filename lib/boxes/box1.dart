

import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app_with_hive/Models/notes_model.dart';

class Box1 {

  static Box<NotesModel> getData() => Hive.box<NotesModel>('notes');
}