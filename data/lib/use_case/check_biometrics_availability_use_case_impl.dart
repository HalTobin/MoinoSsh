import 'package:biometric_storage/biometric_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:domain/use_case/check_biometrics_availability_use_case.dart';

class CheckBiometricsAvailabilityUseCaseImpl implements CheckBiometricsAvailabilityUseCase {

    @override
    Future<bool> execute() async {
        final response = await BiometricStorage().canAuthenticate();
        if (kDebugMode) {
            print('Quick authentication status: $response');
        }
        return response == CanAuthenticateResponse.success;
    }

}