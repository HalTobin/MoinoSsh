import 'package:domain/service/biometrics_service.dart';
import 'package:domain/use_case/check_biometrics_availability_use_case.dart';

class CheckBiometricsAvailabilityUseCaseImpl implements CheckBiometricsAvailabilityUseCase {
    final BiometricsService biometricsService;
    CheckBiometricsAvailabilityUseCaseImpl({
        required this.biometricsService
    });

    @override
    Future<bool> execute() async {
        return biometricsService.isBiometricsSupported();
    }

}