import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/common/custom_text_field_widget.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/menu_item.dart';
import 'package:receipt_splitter/model/participant.dart';
import 'package:receipt_splitter/module/receipt_detail/common/participant_avatar.dart';
import 'package:receipt_splitter/module/receipt_detail/common/table_widget.dart';

class ParticipantsItemWidget extends StatefulWidget {
  const ParticipantsItemWidget({super.key});

  @override
  State<ParticipantsItemWidget> createState() => _ParticipantsItemWidgetState();
}

class _ParticipantsItemWidgetState extends State<ParticipantsItemWidget> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Participant> participants = [
    Participant(id: 1, name: 'Wunna Kyaw'),
    Participant(id: 2, name: 'Kayy'),
    Participant(id: 3, name: 'Kyaw Lwin Soe'),
    Participant(id: 4, name: 'Nyein Chan Moe'),
    Participant(id: 5, name: 'Wai Yan Kyaw'),
    Participant(id: 6, name: 'Ye Thurein Kyaw'),
  ];
  final List<MenuItem> items = [
    MenuItem(id: 1, name: 'Margarita', quantity: 1, price: 10.0),
    MenuItem(id: 2, name: 'Mojito', quantity: 2, price: 20.0),
    MenuItem(id: 3, name: 'Old Fashioned', quantity: 1, price: 15.0),
    MenuItem(id: 1, name: 'Margarita', quantity: 1, price: 10.0),
    MenuItem(id: 2, name: 'Mojito', quantity: 2, price: 20.0),
    MenuItem(id: 3, name: 'Old Fashioned', quantity: 1, price: 15.0),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  Future<T?> _showEditBottomSheet<T>({required T? data, required int index, bool isParticipant = false}) {
    Participant? participant;
    MenuItem? item;

    if (data is Participant) {
      participant = data;
    } else if (data is MenuItem){
      item = data;
    }

    TextEditingController participantNameController = TextEditingController(text: participant?.name);
    TextEditingController nameController = TextEditingController(text: item?.name);
    TextEditingController qtyController = TextEditingController(text: item?.quantity.toString());
    TextEditingController priceController = TextEditingController(text: item?.price.toString());

    return showModalBottomSheet<T?>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(left: 16, right: 16, bottom: MediaQuery.of(context).viewInsets.bottom + 16, top: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(height: 10,),
              (participant != null || isParticipant)
                  ? CustomTextFieldWidget(label: NAME, controller: participantNameController)
                  : Column(
                    children: [
                      CustomTextFieldWidget(label: NAME, controller: nameController),
                      const SizedBox(height: 16),
                      CustomTextFieldWidget(label: QTY, controller: qtyController),
                      const SizedBox(height: 16),
                      CustomTextFieldWidget(label: PRICE, controller: priceController),
                    ],
                  ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      if (participant != null || isParticipant) {
                        // Update participant data
                        participant = participant?.copyWith(
                          name: participantNameController.text,
                        );
                        Navigator.pop(context, participant); // Return updated participant
                      } else if (item != null) {
                        // Update item data
                        item = item?.copyWith(
                          name: nameController.text,
                          quantity: int.tryParse(qtyController.text) ?? item!.quantity,
                          price: double.tryParse(priceController.text) ?? item!.price,
                        );
                        Navigator.pop(context, item); // Return updated item
                      }
                    },
                    child: Container(
                      width: 107,
                      height: 40,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary, borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.save_alt, color: Theme.of(context).colorScheme.onTertiary),
                          const SizedBox(width: 10),
                          Text(SAVE, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onTertiary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16,),
                  InkWell(
                    onTap: () {
                      return context.pop(null);
                    },
                    child: Container(
                      width: 107,
                      height: 40,
                      decoration: BoxDecoration(color: Theme.of(context).colorScheme.tertiary, borderRadius: BorderRadius.all(Radius.circular(100))),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Theme.of(context).colorScheme.onTertiary),
                          const SizedBox(width: 10),
                          Text(DELETE, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onTertiary)),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void _addNewItem(String tab) async{

    Participant? participant;
    MenuItem? menuItem;

    if (tab == "Participants") {
       participant = await _showEditBottomSheet<Participant>(data: null, index: 0, isParticipant: true);
    } else {
       menuItem = await _showEditBottomSheet<MenuItem>(data: null, index: 0);
    }

    setState(() {
      if (tab == "Participants" && participant != null) {
        participants.add(participant);
      } else if(tab == "Items" && menuItem != null) {
        items.add(menuItem);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TabBar(controller: _tabController, tabs: const [Tab(text: "Participants"), Tab(text: "Items")]),
          Expanded(child: TabBarView(controller: _tabController, children: [_buildParticipantsListView(participants, "Participants"), _buildListView(items, "Items")])),
        ],
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          String tabName = _tabController.index == 0 ? "Participants" : "Items";
          return SizedBox(
            height: 30, // Set custom height
            width: 78,
            child: FloatingActionButton(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100))),
              onPressed: () => _addNewItem(tabName),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Theme.of(context).colorScheme.onPrimaryContainer),
                  const SizedBox(width: 8),
                  Text(ADD_ITEM, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.onPrimaryContainer)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildListView(List<MenuItem> list, String tab) {
    return Column(
      children: [
        SizedBox(height: 10),
        TableWidget(
          items: list,
          actionName: ACTION,
          actionWidget: (index) => IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditBottomSheet<MenuItem>(data: list[index], index: index)),
        ),
      ],
    );
  }

  Widget _buildParticipantsListView(List<Participant> participants, String tab) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ListView.separated(
        itemBuilder:
            (context, index) => Row(
              children: [
                ParticipantAvatar(participant: participants[index], width: 40, height: 40),
                SizedBox(width: 16),
                Text(participants[index].name),
                Spacer(),
                IconButton(icon: const Icon(Icons.edit), onPressed: () => _showEditBottomSheet<Participant>(data: participants[index], index: index)),
              ],
            ),
        separatorBuilder: (context, index) => Divider(),
        itemCount: participants.length,
      ),
    );
  }
}
