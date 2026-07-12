import 'package:domain/model/preferences/app_contrast.dart';

extension AppContrastText on AppContrast {
    String getText() {
        switch (this) {
            case AppContrast.low:
                return "Low";
            case AppContrast.medium:
                return "Medium";
            case AppContrast.high:
                return "High";
        }
    }
}