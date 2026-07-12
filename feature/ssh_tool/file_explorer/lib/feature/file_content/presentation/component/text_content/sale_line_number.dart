import 'package:flutter/material.dart';

class SaleLineNumber extends StatelessWidget {
  final int index;
  final bool highlight;
  final double textSize;
  final EdgeInsets padding;

  const SaleLineNumber({
    super.key,
    required this.index,
    required this.highlight,
    required this.textSize,
    this.padding = const EdgeInsets.only(right: 2, top: 2.35)
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      alignment: Alignment.centerRight,
      padding: padding,
      color: highlight ? Theme.of(context).colorScheme.primaryContainer : null,
      child: Text(
        '$index',
        style: TextStyle(
          color: highlight ? Theme.of(context).colorScheme.onPrimaryContainer : Colors.grey.withValues(alpha: 0.9),
          fontSize: textSize - 1,
          height: 1.5,
          fontFeatures: [ FontFeature.tabularFigures() ],
        ),
        strutStyle: StrutStyle(
          fontSize: textSize,
          height: 1.5,
          forceStrutHeight: true,
        ),
      ),
    );
  }
}