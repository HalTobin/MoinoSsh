import 'package:feature_systemd_services/feature/edit_service/use_case/upsert_service_to_favorite_use_case.dart';

import 'delete_service_from_favorite_use_case.dart';
import 'get_service_use_case.dart';

class EditServiceUseCases {
    final GetServiceUseCase getServiceUseCase;
    final UpsertServiceToFavoriteUseCase upsertServiceToFavoriteUseCase;
    final DeleteServiceFromFavoriteUseCase deleteServiceFromFavoriteUseCase;

    EditServiceUseCases({
        required this.getServiceUseCase,
        required this.upsertServiceToFavoriteUseCase,
        required this.deleteServiceFromFavoriteUseCase
    });
}