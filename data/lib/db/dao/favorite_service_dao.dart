import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../entity/favorite_service_entity.dart';
import '../server_profile_database.dart';

part 'favorite_service_dao.g.dart';

@DriftAccessor(tables: [FavoriteServices])
class FavoriteServiceDao extends DatabaseAccessor<ServerProfileDatabase> with _$FavoriteServiceDaoMixin {
    FavoriteServiceDao(ServerProfileDatabase db) : super(db);

    Future<List<FavoriteServiceEntity>> getAllServices() => select(favoriteServices).get();

    Stream<List<FavoriteServiceEntity>> watchAllServices() => select(favoriteServices).watch();

    Future<FavoriteServiceEntity?> getServiceById(int id) {
        return (select(favoriteServices)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    }

    Future<FavoriteServiceEntity?> getServiceByTitle(String title) {
        return (select(favoriteServices)..where((tbl) => tbl.serviceName.equals(title))).getSingleOrNull();
    }

    Future<FavoriteServiceEntity?> getServiceByTitleAndProfile(String title, int profileId) {
        return (select(favoriteServices)..where((tbl) =>
            tbl.serviceName.equals(title) &
            tbl.profileId.equals(profileId))
        ).getSingleOrNull();
    }

    Future<int> insertService(FavoriteServicesCompanion entry) => into(favoriteServices).insert(entry);

    Future<bool> updateService(FavoriteServiceEntity entry) => update(favoriteServices).replace(entry);

    Future<int> deleteService(int id) {
        return (delete(favoriteServices)..where((tbl) => tbl.id.equals(id))).go();
    }

    Future<List<FavoriteServiceEntity>> getServicesForProfile(int profileId) {
        return (select(favoriteServices)..where((tbl) => tbl.profileId.equals(profileId))).get();
    }

    Stream<List<FavoriteServiceEntity>> getServicesByProfileIdAsStream(int profileId) {
        return (select(favoriteServices)..where((tbl) => tbl.profileId.equals(profileId))).watch();
    }
}