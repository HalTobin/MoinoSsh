import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../presentation/edit_service_view.dart';
import '../presentation/edit_service_viewmodel.dart';
import '../use_case/delete_service_from_favorite_use_case.dart';
import '../use_case/edit_service_use_cases.dart';
import '../use_case/get_service_use_case.dart';
import '../use_case/upsert_service_to_favorite_use_case.dart';

class EditServiceProvider extends StatelessWidget {
  final String serviceName;

  const EditServiceProvider({
    super.key,
    required this.serviceName,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => (
          UpsertServiceToFavoriteUseCase(
            favoriteServiceRepository: context.read(),
            serverProfileRepository: context.read(),
            sshService: context.read()
          )
        )),
        Provider(create: (context) => (
          GetServiceUseCase(
            favoriteServiceRepository: context.read(),
            serverProfileRepository: context.read(),
            sshService: context.read()
          )
        )),
        Provider(create: (context) => (DeleteServiceFromFavoriteUseCase(favoriteServiceRepository: context.read()))),
        Provider(create: (context) => (
          EditServiceUseCases(
            getServiceUseCase: context.read(),
            upsertServiceToFavoriteUseCase: context.read(),
            deleteServiceFromFavoriteUseCase: context.read(),
          )
        )),
        ChangeNotifierProvider(create: (context) => (
          EditServiceViewModel(
            serviceName: serviceName,
            editServiceUseCases: context.read(),
            uiEvent: (event) => {
              switch (event) {
                ExitDialog() => Navigator.of(context, rootNavigator: true).pop(),
              }
            }
          )
        ))
      ],
      child: Consumer<EditServiceViewModel>(
        builder: (builder, viewmodel, child) {
          return EditServiceView(
            state: viewmodel.state,
            onEvent: viewmodel.onEvent,
          );
        }
      ),
    );
  }
}