// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MovieDao? _movieDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `MovieEntity` (`id` INTEGER NOT NULL, `title` TEXT NOT NULL, `overview` TEXT NOT NULL, `posterPath` TEXT NOT NULL, `backdropPath` TEXT NOT NULL, `releaseDate` TEXT NOT NULL, `genreIds` TEXT NOT NULL, `genre` TEXT NOT NULL, `videoKey` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MovieDao get movieDao {
    return _movieDaoInstance ??= _$MovieDao(database, changeListener);
  }
}

class _$MovieDao extends MovieDao {
  _$MovieDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _movieEntityInsertionAdapter = InsertionAdapter(
            database,
            'MovieEntity',
            (MovieEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'overview': item.overview,
                  'posterPath': item.posterPath,
                  'backdropPath': item.backdropPath,
                  'releaseDate': item.releaseDate,
                  'genreIds': item.genreIds,
                  'genre': item.genre,
                  'videoKey': item.videoKey
                }),
        _movieEntityUpdateAdapter = UpdateAdapter(
            database,
            'MovieEntity',
            ['id'],
            (MovieEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'overview': item.overview,
                  'posterPath': item.posterPath,
                  'backdropPath': item.backdropPath,
                  'releaseDate': item.releaseDate,
                  'genreIds': item.genreIds,
                  'genre': item.genre,
                  'videoKey': item.videoKey
                }),
        _movieEntityDeletionAdapter = DeletionAdapter(
            database,
            'MovieEntity',
            ['id'],
            (MovieEntity item) => <String, Object?>{
                  'id': item.id,
                  'title': item.title,
                  'overview': item.overview,
                  'posterPath': item.posterPath,
                  'backdropPath': item.backdropPath,
                  'releaseDate': item.releaseDate,
                  'genreIds': item.genreIds,
                  'genre': item.genre,
                  'videoKey': item.videoKey
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MovieEntity> _movieEntityInsertionAdapter;

  final UpdateAdapter<MovieEntity> _movieEntityUpdateAdapter;

  final DeletionAdapter<MovieEntity> _movieEntityDeletionAdapter;

  @override
  Future<List<MovieEntity>> getAllMovies() async {
    return _queryAdapter.queryList('SELECT * FROM MovieEntity',
        mapper: (Map<String, Object?> row) => MovieEntity(
            id: row['id'] as int,
            title: row['title'] as String,
            overview: row['overview'] as String,
            posterPath: row['posterPath'] as String,
            backdropPath: row['backdropPath'] as String,
            releaseDate: row['releaseDate'] as String,
            genreIds: row['genreIds'] as String,
            videoKey: row['videoKey'] as String,
            genre: row['genre'] as String));
  }

  @override
  Future<MovieEntity?> getMovieById(int id) async {
    return _queryAdapter.query('SELECT * FROM MovieEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => MovieEntity(
            id: row['id'] as int,
            title: row['title'] as String,
            overview: row['overview'] as String,
            posterPath: row['posterPath'] as String,
            backdropPath: row['backdropPath'] as String,
            releaseDate: row['releaseDate'] as String,
            genreIds: row['genreIds'] as String,
            videoKey: row['videoKey'] as String,
            genre: row['genre'] as String),
        arguments: [id]);
  }

  @override
  Future<void> deleteAllMovies() async {
    await _queryAdapter.queryNoReturn('DELETE * FROM MovieEntity');
  }

  @override
  Future<void> insertMovies(List<MovieEntity> movies) async {
    await _movieEntityInsertionAdapter.insertList(
        movies, OnConflictStrategy.replace);
  }

  @override
  Future<void> insertMovie(MovieEntity movie) async {
    await _movieEntityInsertionAdapter.insert(movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateMovie(MovieEntity movie) async {
    await _movieEntityUpdateAdapter.update(movie, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteMovie(MovieEntity movie) async {
    await _movieEntityDeletionAdapter.delete(movie);
  }
}
