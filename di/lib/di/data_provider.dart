import 'package:data/service/biometrics_service_impl.dart';
import 'package:domain/repository/favorite_service_repository.dart';
import 'package:domain/repository/preference_repository.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/repository/file_repository.dart';
import 'package:domain/repository/ssh_secrets_repository.dart';
import 'package:data/preferences/preference_repository_impl.dart';
import 'package:data/repository/favorite_service_repository_impl.dart';
import 'package:data/repository/server_profile_repository_impl.dart';
import 'package:data/repository/file_repository_impl.dart';
import 'package:data/repository/ssh_secrets_repository_impl.dart';
import 'package:domain/service/biometrics_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

@internal
class DataProvider extends StatelessWidget {
  final Widget child;

  const DataProvider({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PreferenceRepository>(create: (context) => (PreferenceRepositoryImpl())),
        Provider<ServerProfileRepository>(create: (context) => (ServerProfileRepositoryImpl(dao: context.read()))),
        Provider<FavoriteServiceRepository>(create: (context) => (FavoriteServiceRepositoryImpl(dao: context.read()))),
        Provider<FileRepository>(create: (_) => (FileRepositoryImpl())),
        Provider<SshSecretsRepository>(create: (context) => (SshSecretsRepositoryImpl())),
        Provider<PreferenceRepository>(create: (_) => (PreferenceRepositoryImpl())),
        Provider<BiometricsService>(create: (_) => (BiometricsServiceImpl()))
      ],
      child: child
    );
  }
}