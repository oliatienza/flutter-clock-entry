import 'package:flutter/material.dart';

class DotGrid extends StatelessWidget {
  const DotGrid(
      {Key key,
      this.size,
      this.spacing,
      this.color,
      this.radius,
      this.rows,
      this.columns})
      : super(key: key);

  final int size;
  final int rows;
  final int columns;
  final double spacing;
  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildGrid(),
    );
  }

  Widget _buildGrid() {
    final List<Widget> columnWidgets = <Widget>[];
    final int rowCount = size ?? rows;
    final int columnCount = size ?? columns;

    for (int i = 0; i < rowCount; i++) {
      final List<Widget> rowWidgets = <Widget>[];
      for (int j = 0; j < columnCount; j++) {
        rowWidgets.add(
          Material(
            shape: const CircleBorder(),
            color: color,
            child: SizedBox(
              height: radius,
              width: radius,
            ),
          ),
        );

        if (j < columnCount) {
          rowWidgets.add(SizedBox(
            width: spacing,
          ));
        }
      }

      columnWidgets.add(Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowWidgets,
      ));

      if (i < rowCount) {
        columnWidgets.add(SizedBox(
          height: spacing,
        ));
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: columnWidgets,
    );
  }
}
