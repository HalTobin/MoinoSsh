import 'package:domain/model/ssh/favorite_service.dart';
import 'package:domain/repository/favorite_service_repository.dart';
import 'package:drift/drift.dart';

import '../db/dao/favorite_service_dao.dart';
import '../db/server_profile_database.dart';

class FavoriteServiceRepositoryImpl implements FavoriteServiceRepository {

    final FavoriteServiceDao _dao;

    static FavoriteServiceRepositoryImpl? _instance;

    factory FavoriteServiceRepositoryImpl({
      required FavoriteServiceDao dao,
    }) {
      _instance ??= FavoriteServiceRepositoryImpl._internal(dao);
      return _instance!;
    }

    FavoriteServiceRepositoryImpl._internal(this._dao);

    @override
    Future<int> saveService(NewFavoriteService service) async {
        final FavoriteServicesCompanion serviceEntity = FavoriteServicesCompanion(
            id: Value.absent(),
            profileId: Value(service.profileId),
            serviceName: Value(service.name),
            alias: Value(service.alias),
            iconId: (service.iconId != null) ? Value(service.iconId!) : Value.absent()
        );
        return await _dao.insertService(serviceEntity);
    }

    @override
    Future<bool> updateService(UpdateFavoriteService service) async {
        final FavoriteServiceEntity serviceEntity = FavoriteServiceEntity(
            id: service.id,
            profileId: service.profileId,
            serviceName: service.name,
            alias: service.alias,
            iconId: service.iconId
        );
        return await _dao.updateService(serviceEntity);
    }

    @override
    Future<int> unmarkService(int id) async {
        return await _dao.deleteService(id);
    }

    @override
    Future<List<FavoriteService>> getFavoriteServicesByProfileId(int profileId) async {
        final List<FavoriteServiceEntity> services = await _dao.getServicesForProfile(profileId);
        return services.map((service) {
            return service.toFavoriteService();
        }).toList();
    }

    @override
    Future<FavoriteService?> getFavoriteServiceById(int serviceId) async {
        final service = await _dao.getServiceById(serviceId);
        return service?.toFavoriteService();
    }

    @override
    Future<FavoriteService?> getFavoriteServiceByTitleAndProfileId({
        required int profileId,
        required String serviceName
    }) async {
        final service = await _dao.getServiceByTitleAndProfile(serviceName, profileId);
        return service?.toFavoriteService();
    }

    @override
    Future<FavoriteService?> getFavoriteServiceByName(String name) async {
        final service = await _dao.getServiceByTitle(name);
        return service?.toFavoriteService();
    }

    @override
    Stream<List<FavoriteService>> watchServicesByProfileId(int profileId) {
        return _dao.getServicesByProfileIdAsStream(profileId)
            .map((entities) =>
                entities
                    .map((entity) =>
                        entity.toFavoriteService()
                    ).toList()
            )
        ;
    }
}

extension ServiceEntityMapper on FavoriteServiceEntity {
    FavoriteService toFavoriteService() {
        return FavoriteService(
            id: id,
            profileId: profileId,
            name: serviceName,
            alias: alias,
            iconId: iconId,
        );
    }
}