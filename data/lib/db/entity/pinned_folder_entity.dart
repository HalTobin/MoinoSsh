import 'package:data/db/entity/server_profile_entity.dart';
import 'package:drift/drift.dart';

@DataClassName('PinnedFolderEntity')
class PinnedFolder extends Table {
    IntColumn get id => integer().autoIncrement()();
    IntColumn get profileId => integer().references(ServerProfiles, #id)();
    TextColumn get path => text()();
    TextColumn get alias => text().nullable()();
    IntColumn get customIndex => integer()();
    IntColumn get iconId => integer().nullable()();
}