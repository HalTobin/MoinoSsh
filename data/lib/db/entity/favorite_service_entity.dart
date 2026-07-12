import 'package:data/db/entity/server_profile_entity.dart';
import 'package:drift/drift.dart';

@DataClassName('FavoriteServiceEntity')
class FavoriteServices extends Table {
    IntColumn get id => integer().autoIncrement()();
    IntColumn get profileId => integer().references(ServerProfiles, #id)();
    TextColumn get serviceName => text()();
    TextColumn get alias => text().nullable()();
    IntColumn get iconId => integer().nullable()();
}