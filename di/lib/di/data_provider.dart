import 'package:data/service/biometrics_service_impl.dart';
import 'package:domain/repository/favorite_service_repository.dart';
import 'package:domain/repository/preference_repository.dart';
import 'package:domain/repository/server_profile_repository.dart';
import 'package:domain/repository/pinned_folder_repository.dart';
import 'package:domain/repository/file_repository.dart';
import 'package:data/preferences/preference_repository_impl.dart';
import 'package:data/repository/favorite_service_repository_impl.dart';
import 'package:data/repository/server_profile_repository_impl.dart';
import 'package:data/repository/pinned_folder_repository_impl.dart';
import 'package:data/repository/file_repository_impl.dart';
import 'package:domain/service/biometrics_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        Provider<PinnedFolderRepository>(create: (context) => (PinnedFolderRepositoryImpl(dao: context.read()))),
        Provider<FileRepository>(create: (_) => (FileRepositoryImpl())),
        Provider<PreferenceRepository>(create: (_) => (PreferenceRepositoryImpl())),
        Provider<BiometricsService>(
          create: (context) => (
            BiometricsServiceImpl(
              serverProfileRepository: context.read()
            )
          )
        )
      ],
      child: child
    );
  }
}