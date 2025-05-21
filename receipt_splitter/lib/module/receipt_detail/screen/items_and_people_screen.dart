import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/common/empty_screen.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/items_and_people_cubit/items_and_people_cubit.dart';
import 'package:receipt_splitter/module/receipt_detail/screen/preview_screen.dart';
import 'package:receipt_splitter/module/receipt_detail/screen/receipt_form_screen.dart';

import '../../../common/layout_builder_widget.dart';
import '../../../model/participant.dart';
import '../common/participant_card.dart';
import '../common/participant_stack_widget.dart';
import '../common/table_widget.dart';

class ItemsAndPeopleScreen extends StatelessWidget {
  final Receipt receipt;
  const ItemsAndPeopleScreen({super.key, required this.receipt});
  static const String itemsAndPeople = '/itemsAndPeople';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(receipt.name ?? 'Untitled'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () {
              context.pushNamed(ReceiptFormScreen.receiptForm, extra: ReceiptFormScreenArguments(receipt: receipt, isNew: false));
            },
          ),
        ],
      ),
      body: LayoutBuilderWidget(
        child: Column(
          spacing: 15,
          crossAxisAlignment: receipt.participants.isNotEmpty ? CrossAxisAlignment.start : CrossAxisAlignment.center,
          children: [
            Expanded(
              child: BlocConsumer<ItemsAndPeopleCubit, ItemsAndPeopleState>(
                listener: (context, state) {
                  if (state is AlreadyLinked) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text(PARTICIPANT_ALREADY_LINKED)));
                  }
                },
                builder: (context, state) {
                  if (state is ItemsAndPeopleUpdated) {
                    receipt.items = state.items;
                  }

                  if (receipt.items.isEmpty) {
                    return const EmptyScreen(title: NO_ITEMS);
                  } else {
                    return TableWidget(
                      items: receipt.items,
                      actionName: PEOPLE,
                      actionWidget:
                          (val) =>
                          BlocProvider(
                            create: (context) => context.read<ItemsAndPeopleCubit>(),
                            child: ParticipantStackWidget(
                              menuItem: receipt.items[val],
                              onParticipantDelete: (participant) {
                                BlocProvider.of<ItemsAndPeopleCubit>(context).removeParticipantFromItem(items: receipt.items, itemId: receipt.items[val].uid, participant: participant);
                              },
                            ),
                          ),
                      enableDragTarget: true,
                      onItemDropped: (details, item) {
                        Participant participant = details.data;
                        BlocProvider.of<ItemsAndPeopleCubit>(context).linkParticipantToItem(items: receipt.items, participants: receipt.participants, participant: participant, itemId: item.uid);
                      },
                    );
                  }
                },
              ),
            ),
            const Divider(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    if (receipt.participants.isNotEmpty) ...[
                      DraggableCard(participant: Participant(uid: 'PRT0', name: ALL)),
                      VerticalDivider(width: 30, thickness: 1, indent: 10, endIndent: 10, color: Theme.of(context).colorScheme.outlineVariant),
                      ...receipt.participants.map((participant) {
                        return Row(children: [DraggableCard(participant: participant), SizedBox(width: 15)]);
                      }),
                    ] else
                      SizedBox(height: 120, child: EmptyScreen(title: NO_PARTICIPANTS)),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonalIcon(
                onPressed: () {
                  context.pushNamed(PreviewScreen.preview, extra: receipt);
                },
                label: Text(NEXT, style: Theme.of(context).textTheme.labelLarge),
                icon: const Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
