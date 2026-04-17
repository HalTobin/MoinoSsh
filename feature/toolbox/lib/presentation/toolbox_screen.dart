import 'package:feature_toolbox/presentation/tool_screen.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../data/ssh_tool.dart';
import './component/tool_card.dart';

class ToolboxScreen extends StatelessWidget {

  const ToolboxScreen({super.key});

  void _onToolSelected(BuildContext context, SshTool tool) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ToolScreen(
          tool: tool,
          onExit: () => Navigator.of(context).pop(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(LucideIcons.hammer),
        title: Text(
          "Toolbox",
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1.0,
            ),
            itemCount: SshTool.values.length,
            itemBuilder: (context, index) {
              final tool = SshTool.values[index];
              return ToolCard(
                tool: tool,
                onTap: () => _onToolSelected(context, tool),
              );
            },
          );
        }
      )
    );
  }

}