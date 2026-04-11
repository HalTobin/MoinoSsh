import 'package:domain/use_case/check_biometrics_availability_use_case.dart';

import 'delete_key_use_case.dart';

class SettingsUseCases {
    final DeleteKeyUseCase deleteKeyUseCase;
    final CheckBiometricsAvailabilityUseCase checkBiometricsAvailabilityUseCase;

    SettingsUseCases({
        required this.deleteKeyUseCase,
        required this.checkBiometricsAvailabilityUseCase
    });

}