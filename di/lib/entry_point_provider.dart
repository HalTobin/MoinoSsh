import 'package:di/di/db_provider.dart';
import 'package:di/di/domain_provider.dart';
import 'package:flutter/material.dart';
import 'di/data_provider.dart';
import 'di/service_provider.dart';

class EntryPointProvider extends StatelessWidget {
  final Widget child;

  const EntryPointProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DbProvider(
      child: DataProvider(
        child: ServiceProvider(
          child: DomainProvider(
            child: child
          )
        )
      )
    );
  }

}