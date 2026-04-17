import 'package:flutter/material.dart';

class ServicePresentation {
    final bool active;
    final bool favorite;
    final String title;
    final String? alias;
    final IconData? icon;

    const ServicePresentation({
        required this.active,
        required this.favorite,
        required this.title,
        required this.alias,
        required this.icon
    });

    ServicePresentation copyWith({
        bool? active,
        bool? favorite,
        String? title,
        Object? alias = _unset,
        Object? icon = _unset,
    }) {
        return ServicePresentation(
            active: active ?? this.active,
            favorite: favorite ?? this.favorite,
            title: title ?? this.title,
            alias: alias == _unset ? this.alias : alias as String?,
            icon: icon == _unset ? this.icon : icon as IconData?,
        );
    }

    static const _unset = Object();
}