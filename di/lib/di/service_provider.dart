import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domain/service/ssh_service.dart';
import 'package:data/service/ssh/ssh_service_impl.dart';

class ServiceProvider extends StatelessWidget {
  final Widget child;

  const ServiceProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<SshService>(create: (_) => (SshServiceImpl())),
      ],
      child: child
    );
  }
}