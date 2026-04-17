import 'package:flutter/material.dart';
import 'package:ui/component/shaking_widget.dart';

import '../../../../data/icon_set.dart';

class IconSelector extends StatelessWidget {
  final int currentIconId;
  final List<ServiceIconType> iconSets;
  final void Function(ServiceIconType?) onIconSelected;
  final bool deleteMode;
  final int lines;

  const IconSelector({
    super.key,
    required this.currentIconId,
    required this.iconSets,
    required this.onIconSelected,
    required this.deleteMode,
    this.lines = 1
  });

  @override
  Widget build(BuildContext context) {
    final double iconSize = 48;
    final double spacing = 8;
    final double height = (iconSize + spacing) * lines;

    return SizedBox(
      height: height,
      child: ClipRect(
        child: Stack(
          children: [
            // Fading edge effect
            ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: const [
                    Colors.transparent,
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.05, 0.95, 1.0],
                ).createShader(bounds);
              },
              blendMode: BlendMode.dstIn,
              child: GridView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16), // Prevent icon clipping
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: lines,
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  childAspectRatio: 1,
                ),
                itemCount: iconSets.length,
                itemBuilder: (context, index) {
                  final iconType = iconSets[index];
                  final isSelected = iconType.id == currentIconId;

                  return GestureDetector(
                    onTap: () {
                      onIconSelected(
                        iconType.id != currentIconId ? iconType : null,
                      );
                    },
                    child: ShakingWidget(
                      shake: deleteMode,
                      radius: 10,
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 200),
                        crossFadeState: isSelected
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        firstChild: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            iconType.icon,
                            size: iconSize / 1.5,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        secondChild: Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: Icon(
                            iconType.icon,
                            size: iconSize / 1.5,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        layoutBuilder: (topChild, topKey, bottomChild, bottomKey) {
                          return Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned(
                                key: bottomKey,
                                child: bottomChild,
                              ),
                              Positioned(
                                key: topKey,
                                child: topChild,
                              ),
                            ],
                          );
                        },
                      )
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}