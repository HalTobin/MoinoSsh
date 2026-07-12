import 'package:drift/drift.dart';

@DataClassName('ServerProfileEntity')
class ServerProfiles extends Table {
    IntColumn get id => integer().autoIncrement()();
    TextColumn get serverName => text().nullable()();
    TextColumn get url => text()();
    TextColumn get port => text()();
    TextColumn get sessionUser => text()();
    TextColumn get keyPath => text()();
    TextColumn get securedSshKeyPassword => text().nullable()();
    TextColumn get securedSessionPassword => text().nullable()();
}