import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

enum ServiceIconType {
    admin(id: 1),
    public(id: 2),
    user(id: 3),
    web(id: 4),
    database(id: 5),
    mail(id: 6),
    storage(id: 7),
    compute(id: 8),
    analytics(id: 9),
    unknown(id: 10);

    final int id;

    const ServiceIconType({required this.id});

    static ServiceIconType? findById(int? id) {
        if (id != null) {
            try {
                return ServiceIconType.values.firstWhere((icon) => icon.id == id);
            } catch (_) {
                return null;
            }
        }
        else { return null; }
    }
}

extension ServiceIconData on ServiceIconType {
    IconData get icon {
        switch (this) {
            case ServiceIconType.admin:
                return LucideIcons.shieldUser;
            case ServiceIconType.public:
                return LucideIcons.earth;
            case ServiceIconType.user:
                return LucideIcons.user;
            case ServiceIconType.web:
                return LucideIcons.globe;
            case ServiceIconType.database:
                return LucideIcons.database;
            case ServiceIconType.mail:
                return LucideIcons.mail;
            case ServiceIconType.storage:
                return LucideIcons.hardDrive;
            case ServiceIconType.compute:
                return LucideIcons.cpu;
            case ServiceIconType.analytics:
                return LucideIcons.chartColumn;
            case ServiceIconType.unknown:
                return LucideIcons.messageCircleQuestionMark;
        }
    }

    String get label {
        return toString().split('.').last;
    }
}