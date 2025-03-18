import 'package:flutter/material.dart';
import 'package:receipt_splitter/config/app_config.dart';
import 'package:receipt_splitter/model/menu_item.dart';
import 'package:receipt_splitter/model/participant.dart';

import '../../../constants/strings.dart';

class TableWidget extends StatelessWidget {
  final List<MenuItem> items;
  final String actionName;
  final Widget Function(int index) actionWidget;
  final bool enableDragTarget;
  final bool showTotal;
  final void Function(DragTargetDetails<Participant> details, MenuItem item)? onItemDropped; // Type-safe drop handler
  const TableWidget({super.key, required this.items, required this.actionName, required this.actionWidget, this.enableDragTarget = false, this.showTotal = false, this.onItemDropped})
    : assert(enableDragTarget == (onItemDropped != null), 'onItemDropped must be provided if enableDragTarget is true');

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: columnWithPadding(
                child: Text(QTY, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: TextAlign.end),
                vertical: 0,
              ),
            ),
            Expanded(
              flex: 3,
              child: columnWithPadding(
                child: Text(NAME, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: TextAlign.start),
                vertical: 0,
              ),
            ),
            Expanded(
              flex: 2,
              child: columnWithPadding(
                child: Text(TOTAL, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: TextAlign.center),
                vertical: 0,
              ),
            ),
            Expanded(
              flex: 2,
              child: columnWithPadding(
                child: Text(actionName, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant), textAlign: TextAlign.end),
                vertical: 0,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        const Divider(height: 1),

        // List Items (Scrollable)
        Expanded(
          child: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return enableDragTarget
                  ? DragTarget<Participant>(
                    onAcceptWithDetails: (details) => onItemDropped!(details, item),
                    builder: (context, candidateItems, rejectedItems) {
                      return buildRow(context, candidateItems.isNotEmpty, item, index);
                    },
                  )
                  : buildRow(context, false, item, index);
            },
          ),
        ),
      ],
    );
  }

  Widget buildRow(BuildContext context, bool isHighlighted, MenuItem item, int index) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(color: isHighlighted ? Theme.of(context).colorScheme.surfaceContainer : null),
          child: Row(
            children: [
              Expanded(flex: 1, child: columnWithPadding(child: Text(qtyFormatter.format(item.quantity), style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.end))),
              Expanded(flex: 3, child: columnWithPadding(child: Text(item.name, style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.start))),
              Expanded(flex: 2, child: columnWithPadding(child: Text(amountFormatter.format(item.total), style: Theme.of(context).textTheme.labelSmall, textAlign: TextAlign.center))),
              Expanded(flex: 2, child: actionWidget(index)),
            ],
          ),
        ),
        const Divider(height: 1),
      ],
    );
  }

  Widget columnWithPadding({required Widget child, double vertical = 15.0, double horizontal = 8.0}) {
    return Padding(padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical), child: child);
  }
}
