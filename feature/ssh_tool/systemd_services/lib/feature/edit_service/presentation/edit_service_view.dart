import 'package:collection/collection.dart';
import 'package:domain/model/moino_ssh_icon.dart';
import 'package:feature_systemd_services/feature/edit_service/presentation/component/service_deletion_confirmation_modal.dart';
import 'package:flutter/material.dart';
import 'package:ui/component/shaking_widget.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ui/icons/moino_ssh_icon_data.dart';
import 'package:ui/screen_format/screen_format_helper.dart';

import 'component/icon_selector.dart';
import 'component/save_service_button.dart';
import 'edit_service_event.dart';
import 'edit_service_state.dart';

class EditServiceView extends StatefulWidget {
  final EditServiceState state;
  final Function(EditServiceEvent) onEvent;

  const EditServiceView({
    super.key,
    required this.state,
    required this.onEvent,
  });

  @override
  State<StatefulWidget> createState() => _EditServiceState();
}

class _EditServiceState extends State<EditServiceView> {
  late final TextEditingController aliasController;

  @override
  void initState() {
    super.initState();

    aliasController = TextEditingController(text: widget.state.alias);
  }

  @override
  void didUpdateWidget(covariant EditServiceView oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.state.alias != aliasController.text && aliasController.text.isEmpty) {
      aliasController.text = widget.state.alias;
    }
  }

  @override
  Widget build(BuildContext context) {
    MoinoSshIcon? moinoIcon = MoinoSshIcon.values.firstWhereOrNull((icon) => icon.id == widget.state.iconId);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(LucideIcons.arrowLeft),
        ),
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Icon(LucideIcons.pen),
            Text("Edit Service")
          ],
        ),
        actions: [
          if (widget.state.serviceId != -1)
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (builder) {
                    return ServiceDeletionConfirmationModal(
                      onDismiss: () => Navigator.of(context).pop,
                      onDelete: () => widget.onEvent(DeleteService())
                    );
                  }
                );
              },
              icon: Icon(
                LucideIcons.trash,
                color: Theme.of(context).colorScheme.error,
              )
            )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: LayoutBuilder(
          builder: (context, constraints) {
            bool isNarrow = ScreenFormatHelper.isNarrow(constraints);
            if (isNarrow) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  TextFormField(
                    controller: aliasController,
                    enabled: !widget.state.loading,
                    decoration: InputDecoration(
                      labelText: "Alias (optional)",
                      border: const OutlineInputBorder(),
                      suffixIcon: (moinoIcon != null) ? Icon(moinoIcon.icon) : SizedBox(width: 48)
                    ),
                  ),

                  IconSelector(
                    currentIconId: widget.state.iconId,
                    onIconSelected: (icon) => {
                      widget.onEvent(SelectIcon(iconId: icon?.id))
                    }
                  ),

                  Expanded(child: SizedBox()),

                  SaveServiceButton(
                    centered: false,
                    onPressed: () => widget.onEvent(SaveService(alias: aliasController.text))
                  ),

                ],
              );
            }
            else {
              return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 16,
                children: [
                  SizedBox(
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 16,
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: aliasController,
                            enabled: !widget.state.loading,
                            decoration: InputDecoration(
                              labelText: "Alias (optional)",
                              border: const OutlineInputBorder(),
                              suffixIcon: (moinoIcon != null) ? Icon(moinoIcon.icon) : SizedBox(width: 48)
                            ),
                          )
                        ),

                        IconSelector(
                          currentIconId: widget.state.iconId,
                          onIconSelected: (icon) => {
                            widget.onEvent(SelectIcon(iconId: icon?.id))
                          }
                        ),
                      ],
                    ),
                  ),

                  Expanded(child: SizedBox.shrink()),

                  SaveServiceButton(
                    centered: true,
                    onPressed: () => widget.onEvent(SaveService(alias: aliasController.text))
                  )
                ],
              );
            }
          },
        ),
      )
    );
  }
}