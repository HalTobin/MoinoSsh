import 'dart:ui';

import 'package:feature_auth/di/auth_provider.dart';
import 'package:feature_systemd_services/feature/services_manager/di/service_manager_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:ui/component/app_dialog_layout.dart';
import 'package:ui/component/password_required_dialog.dart';
import 'package:ls_server_app/presentation/component/status_bar/connection_status_bar.dart';
import 'package:ls_server_app/presentation/main_event.dart';
import 'package:ls_server_app/presentation/main_state.dart';

class MainScreen extends StatefulWidget {
  final MainState state;
  final Function(MainEvent) onEvent;
  final Future<String?> Function()? onFetchPasswordBiometrics;

  const MainScreen({
    super.key,
    required this.state,
    required this.onEvent,
    required this.onFetchPasswordBiometrics
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final AppLifecycleListener _listener;
  bool _dialogShown = false;
  late AppLifecycleState? _state;

  @override
  void initState() {
    super.initState();

    _state = SchedulerBinding.instance.lifecycleState;
    _listener = AppLifecycleListener(
      onExitRequested: () => _handleExit(),
    );

    widget.onEvent(
      SetOnPasswordRequest(
        onPasswordRequest: () => _showPasswordDialog(
          context: context,
          biometricsAvailable: widget.state.biometricsAvailable,
          savePassword: (password) async {
            widget.onEvent(SaveSshUserPassword(password: password));
          },
          onBiometricsRequest: widget.onFetchPasswordBiometrics
        )
      )
    );
  }

  Future<AppExitResponse> _handleExit() async {
    if (kDebugMode) {
      print('Closing SSH connection');
    }
    widget.onEvent(SshLogOut());
    await Future.delayed(const Duration(seconds: 1));
    if (kDebugMode) {
      print('App is closed');
    }
    return AppExitResponse.exit;
    // you can call AppExitResponse.cancel to cancel the app exit
  }

  @override
  void didUpdateWidget(covariant MainScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.state.isConnected && _dialogShown) {
      _dialogShown = false;
      Navigator.of(context, rootNavigator: true).pop(); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ConnectionStatusBar(
        state: widget.state,
        logOut: () => widget.onEvent(SshLogOut())
      ),
      body: Flex(
        direction: Axis.vertical,
        children: [
          Expanded(
            child: AnimatedCrossFade(
              firstChild: SizedBox.expand(
                child: AuthProvider()
              ),
              secondChild: SizedBox.expand(
                child: ServiceManagerProvider()
              ),
              crossFadeState: widget.state.isConnected
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300)
            )
          )
        ]
      ),
    );
  }

  Future<String?> _showPasswordDialog({
    required BuildContext context,
    required bool biometricsAvailable,

    Future<void> Function(String)? savePassword,
    Future<String?> Function()? onBiometricsRequest
  }) async {
    if (kDebugMode) {
      print("_showAuthDialog()");
    }

    final NavigatorState navigator = Navigator.of(context);

    final password = await showDialog<String?>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AppDialogLayout(
        padding: EdgeInsets.all(12),
        child: PasswordRequiredDialog(
          onPasswordEntered: (password, save) async {
            if (kDebugMode) {
              print("password entered(secret, $save)");
            }
            if (save && savePassword != null) {
              if (kDebugMode) {
                print("saving password");
              }
              await savePassword(password);
            }
            //if (!context.mounted) return;
            navigator.pop(password);
          },
          onDismiss: () => navigator.pop(null),
          biometricsAvailable: biometricsAvailable,
          onBiometricsRequest: (onBiometricsRequest != null) ? () async {
            if (kDebugMode) {
              print("onBiometricsRequest()");
            }
            final password = await onBiometricsRequest();
            //if (!context.mounted) return;
            navigator.pop(password);
          } : null,
        ),
      )
    );
    return password;
  }

}