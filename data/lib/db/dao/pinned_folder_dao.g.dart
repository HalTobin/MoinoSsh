// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pinned_folder_dao.dart';

// ignore_for_file: type=lint
mixin _$PinnedFolderDaoMixin on DatabaseAccessor<ServerProfileDatabase> {
  $ServerProfilesTable get serverProfiles => attachedDatabase.serverProfiles;
  $PinnedFolderTable get pinnedFolder => attachedDatabase.pinnedFolder;
  PinnedFolderDaoManager get managers => PinnedFolderDaoManager(this);
}

class PinnedFolderDaoManager {
  final _$PinnedFolderDaoMixin _db;
  PinnedFolderDaoManager(this._db);
  $$ServerProfilesTableTableManager get serverProfiles =>
      $$ServerProfilesTableTableManager(
        _db.attachedDatabase,
        _db.serverProfiles,
      );
  $$PinnedFolderTableTableManager get pinnedFolder =>
      $$PinnedFolderTableTableManager(_db.attachedDatabase, _db.pinnedFolder);
}
