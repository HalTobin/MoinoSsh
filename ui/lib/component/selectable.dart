import 'package:flutter/material.dart';

class Selectable extends StatelessWidget {
  final bool selectionEnable;
  final bool selected;
  final Function() onSelect;
  final Widget child;

  const Selectable({
    super.key,
    required this.selectionEnable,
    required this.selected,
    required this.onSelect,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedCrossFade(
        firstChild: _SelectableDecoration(
          enable: false,
          child: child
        ),
        secondChild: _SelectableDecoration(
          enable: true,
          child: child
        ),
        crossFadeState: !selected ? CrossFadeState.showFirst : CrossFadeState.showSecond,
        duration: Duration(milliseconds: 300)
      )
    );
  }

}

class _SelectableDecoration extends StatelessWidget {
  final bool enable;
  final Widget child;

  const _SelectableDecoration({
    super.key,
    required this.enable,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: enable ? Theme.of(context).colorScheme.primary : Colors.transparent,
          width: 3
        ),
        borderRadius: BorderRadius.circular(16)
      ),
      child: Padding(
        padding: EdgeInsets.all(8),
        child: child
      )
    );
  }

}