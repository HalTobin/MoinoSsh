import 'package:domain/model/ssh/favorite_service.dart';

abstract interface class FavoriteServiceRepository {

    Future<int> saveService(NewFavoriteService service);

    Future<bool> updateService(UpdateFavoriteService service);

    Future<int> unmarkService(int id);

    Future<List<FavoriteService>> getFavoriteServicesByProfileId(int profileId);

    Future<FavoriteService?> getFavoriteServiceById(int serviceId);

    Future<FavoriteService?> getFavoriteServiceByTitleAndProfileId({
        required int profileId,
        required String serviceName
    });

    Future<FavoriteService?> getFavoriteServiceByName(String name);

    Stream<List<FavoriteService>> watchServicesByProfileId(int profileId);

}