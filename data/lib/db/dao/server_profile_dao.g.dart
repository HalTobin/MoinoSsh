// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'server_profile_dao.dart';

// ignore_for_file: type=lint
mixin _$ServerProfileDaoMixin on DatabaseAccessor<ServerProfileDatabase> {
  $ServerProfilesTable get serverProfiles => attachedDatabase.serverProfiles;
  ServerProfileDaoManager get managers => ServerProfileDaoManager(this);
}

class ServerProfileDaoManager {
  final _$ServerProfileDaoMixin _db;
  ServerProfileDaoManager(this._db);
  $$ServerProfilesTableTableManager get serverProfiles =>
      $$ServerProfilesTableTableManager(
        _db.attachedDatabase,
        _db.serverProfiles,
      );
}
