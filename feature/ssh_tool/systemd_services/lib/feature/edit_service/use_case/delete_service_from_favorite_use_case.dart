import 'package:domain/repository/favorite_service_repository.dart';

class DeleteServiceFromFavoriteUseCase {
    DeleteServiceFromFavoriteUseCase({
        required FavoriteServiceRepository favoriteServiceRepository
    })
        : _favoriteServiceRepository = favoriteServiceRepository;

    final FavoriteServiceRepository _favoriteServiceRepository;

    void execute({required int serviceId}) async {
        _favoriteServiceRepository.unmarkService(serviceId);
    }
}