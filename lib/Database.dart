import 'package:reddit_jr/Model/Bookmarks.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
class DatabaseHelper{

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'BookmarkedPost.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async{
    await db.execute('''
      CREATE TABLE bookmarks(
        id INTEGER PRIMARY KEY,
        postID TEXT,
        title TEXT,
        thumbnail TEXT,
        score INTEGER,
        comments INTEGER)''');
  }

  Future<List<Bookmarks>> getBookmarks() async{
    Database db = await instance.database;
    var bookmarks = await db.query('bookmarks', orderBy: 'title');
    List<Bookmarks> bookmarksList= bookmarks.isNotEmpty
      ? bookmarks.map((c) => Bookmarks.fromMap(c)).toList(): [];
    return bookmarksList;
  }

  Future<int> add(Bookmarks bookmarks) async{
    Database db = await instance.database;
    return await db.insert('bookmarks', bookmarks.toMap());
  }

  Future<int> remove(int id) async{
    Database db = await instance.database;
    return await db.delete('bookmarks', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> getCount(String title) async {
    Database db = await instance.database;
    var queryResult = await db.rawQuery("SELECT * FROM bookmarks WHERE title='$title'");
    if(queryResult.isNotEmpty)
      return true;
    else return false;
  }


}