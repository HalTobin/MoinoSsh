import 'package:data/service/sftp/sftp_service_impl.dart';
import 'package:data/service/ssh_client_service_impl.dart';
import 'package:domain/service/sftp_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:domain/service/ssh_service.dart';
import 'package:domain/service/ssh_client_service.dart';
import 'package:data/service/ssh/ssh_service_impl.dart';

class ServiceProvider extends StatelessWidget {
  final Widget child;

  const ServiceProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final SshClientServiceImpl sshClientService = SshClientServiceImpl();
    return MultiProvider(
      providers: [
        Provider<SshClientService>(create: (_) => (sshClientService)),
        Provider<SftpService>(create: (_) => (SftpServiceImpl(sshClientService))),
        Provider<SshService>(create: (_) => (SshServiceImpl(sshClientService))),
      ],
      child: child
    );
  }
}