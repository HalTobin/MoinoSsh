import 'package:flutter/material.dart';
import 'package:ui/component/shaking_widget.dart';
import 'package:ui/component/title_header.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../data/icon_set.dart';
import 'component/ask_deletion_button.dart';
import 'component/delete_service_button.dart';
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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: 386,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          spacing: 16,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: (widget.state.serviceId == -1)
                      ? const TitleHeader(
                        icon: Icons.save,
                        title: "Save Service"
                      )
                      : AnimatedCrossFade(
                          crossFadeState: widget.state.deleteMode
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                          firstChild: const TitleHeader(
                              icon: LucideIcons.pencil,
                              title: "Edit Service"
                          ),
                          secondChild: const TitleHeader(
                              icon: LucideIcons.trash,
                              title: "Delete Service"
                          ),
                      ),
                  ),
                ),
                if (widget.state.serviceId != -1)
                  AskDeletionButton(
                      deleteMode: widget.state.deleteMode,
                      onClick: () {
                        if (widget.state.deleteMode) {
                          widget.onEvent(ExitDeleteMode());
                        }
                        else {
                          widget.onEvent(AskDeleteService());
                        }
                      }
                  ),
                IconButton(
                  onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                  icon: const Icon(LucideIcons.x)
                )
              ],
            ),

            ShakingWidget(
              shake: widget.state.deleteMode,
              child: TextFormField(
                controller: aliasController,
                enabled: !widget.state.loading,
                decoration: InputDecoration(
                  labelText: "Alias (optional)",
                  border: const OutlineInputBorder(),
                ),
              )
            ),

            IconSelector(
              deleteMode: widget.state.deleteMode,
              currentIconId: widget.state.iconId,
              iconSets: ServiceIconType.values,
              onIconSelected: (icon) => {
                widget.onEvent(SelectIcon(iconId: icon?.id))
              }
            ),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              child: AnimatedCrossFade(
                firstChild: SaveServiceButton(
                  onPressed: () => widget.onEvent(SaveService(alias: aliasController.text))
                ),
                secondChild: DeleteServiceButton(
                  onPressed: () => widget.onEvent(ConfirmDeleteService())
                ),
                crossFadeState: widget.state.deleteMode
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300)
              ),
            )
          ],
        ),
      )
    );
  }
}