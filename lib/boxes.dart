import 'package:hive/hive.dart';
import 'package:hive_demo/model.dart';

class Boxes {
  static Box<Details> getDetailsBox() => Hive.box('details');
}
