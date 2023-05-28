import 'dart:async';

import 'package:floor/floor.dart';
// ignore: depend_on_referenced_packages
import 'package:sqflite/sqflite.dart' as sqflite;
import 'movie_dao.dart';
import 'movie_entity.dart';

part 'database.g.dart';

@Database(version: 1, entities: [MovieEntity])
abstract class AppDatabase extends FloorDatabase {
  MovieDao get movieDao;
}
