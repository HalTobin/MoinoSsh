import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ui/navigation/navigation_type.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

import '../presentation/download_tracker_screen.dart';
import '../presentation/download_tracker_view_model.dart';
import '../use_case/cancel_download_use_case.dart';
import '../use_case/download_tracker_use_cases.dart';
import '../use_case/reveal_local_file_use_case.dart';
import '../use_case/watch_download_items_use_case.dart';

class DownloadTrackerProvider extends StatelessWidget {
  final NavigationType navigationType;
  final String title;
  final VoidCallback onBack;
  final List<Widget> actions;

  const DownloadTrackerProvider({
    super.key,
    required this.navigationType,
    required this.title,
    required this.onBack,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => (CancelDownloadUseCase(sftpService: context.read()))),
        Provider(create: (context) => (WatchDownloadItemsUseCase(sftpService: context.read()))),
        Provider(create: (_) => RevealLocalFileUseCase()),
        Provider(
          create: (context) => (
            DownloadTrackerUseCases(
              cancelDownloadUseCase: context.read(),
              watchDownloadItemsUseCase: context.read(),
              revealLocalFileUseCase: context.read(),
            )
          )
        ),
        ChangeNotifierProvider(create: (context) => (
          DownloadTrackerViewModel(downloadTrackerUseCases: context.read())
        ))
      ],
      child: Consumer<DownloadTrackerViewModel>(
        builder: (builder, viewmodel, child) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return DownloadTrackerScreen(
                navigationType: navigationType,
                state: viewmodel.state,
                onEvent: viewmodel.onEvent,
                uiEvent: viewmodel.uiEvent,
                isNarrow: ScreenFormatHelper.isNarrow(constraints),
                title: title,
                onBack: onBack,
                actions: actions,
              );
            }
          );
        }
      ),
    );
  }

}
