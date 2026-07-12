import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'entity/favorite_service_entity.dart';
import 'entity/server_profile_entity.dart';
import 'entity/pinned_folder_entity.dart';

part "server_profile_database.g.dart";

@DriftDatabase(
    tables: [ServerProfiles, FavoriteServices, PinnedFolder]
)
class ServerProfileDatabase extends _$ServerProfileDatabase {
    ServerProfileDatabase() : super(_openConnection());

    @override
    int get schemaVersion => 3;

    @override
    MigrationStrategy get migration {
        return MigrationStrategy(
            onCreate: (m) async {
                await m.createAll();
            },
            onUpgrade: (m, from, to) async {
                if (from < 2) {
                    await m.createTable(pinnedFolder);
                }
                if (from < 3) {
                    await m.addColumn(pinnedFolder, pinnedFolder.iconId);
                }
            },
            beforeOpen: (details) async {
                await customStatement('PRAGMA foreign_keys = ON');
            },
        );
    }

    static const String dbFile = "server_profile_db.db";
}

LazyDatabase _openConnection() {
    return LazyDatabase(() async {
        final dbFolder = await getApplicationDocumentsDirectory();
        final file = File(p.join(dbFolder.path, ServerProfileDatabase.dbFile));
        return NativeDatabase.createInBackground(file);
    });
}