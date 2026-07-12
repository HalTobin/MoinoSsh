// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_service_dao.dart';

// ignore_for_file: type=lint
mixin _$FavoriteServiceDaoMixin on DatabaseAccessor<ServerProfileDatabase> {
  $ServerProfilesTable get serverProfiles => attachedDatabase.serverProfiles;
  $FavoriteServicesTable get favoriteServices =>
      attachedDatabase.favoriteServices;
  FavoriteServiceDaoManager get managers => FavoriteServiceDaoManager(this);
}

class FavoriteServiceDaoManager {
  final _$FavoriteServiceDaoMixin _db;
  FavoriteServiceDaoManager(this._db);
  $$ServerProfilesTableTableManager get serverProfiles =>
      $$ServerProfilesTableTableManager(
        _db.attachedDatabase,
        _db.serverProfiles,
      );
  $$FavoriteServicesTableTableManager get favoriteServices =>
      $$FavoriteServicesTableTableManager(
        _db.attachedDatabase,
        _db.favoriteServices,
      );
}
