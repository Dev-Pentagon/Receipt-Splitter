import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/common/empty_screen.dart';
import 'package:receipt_splitter/common/layout_builder_widget.dart';
import 'package:receipt_splitter/constants/strings.dart';
import 'package:receipt_splitter/model/receipt.dart';
import 'package:receipt_splitter/module/receipt_detail/cubit/receipt_form_cubit/receipt_form_cubit.dart';
import 'package:receipt_splitter/module/receipt_detail/screen/receipt_form_screen.dart';
import 'package:receipt_splitter/module/receipt_list/common/receipt_item.dart';
import 'package:receipt_splitter/module/receipt_list/cubit/fab_cubit.dart';
import 'package:receipt_splitter/module/receipt_list/cubit/receipt_list_cubit/receipt_list_cubit.dart';
import 'package:receipt_splitter/module/settings/screens/setting_screen.dart';
import 'package:receipt_splitter/services/dialog_service.dart';

class ReceiptListScreen extends StatelessWidget {
  const ReceiptListScreen({super.key});

  static const String receiptSplit = '/receiptSplit';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(RECEIPT_SPLITTER, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              context.pushNamed(SettingScreen.tag);
            },
          ),
        ],
        centerTitle: true,
      ),
      body: LayoutBuilderWidget(
        child: BlocListener<ReceiptFormCubit, ReceiptFormState>(
          listener: (context, state) {
            context.pop();
            if (state is ReceiptDeletedSuccessfully) {
              context.read<ReceiptListCubit>().loadReceipts();
              DialogService.showSuccessDialog(context: context, title: DELETE, message: DELETE_SUCCESS);
            } else if (state is ReceiptDeletedFailed) {
              DialogService.showErrorDialog(context: context, title: DELETE, message: DELETE_FAILED);
            }
          },
          child: BlocBuilder<ReceiptListCubit, ReceiptListState>(
            builder: (context, state) {
              if (state is ReceiptListLoadFailed) {
                return Center(child: Text(state.message));
              } else if (state is ReceiptListLoaded) {
                List<Receipt> receiptList = state.receipts;
                return ListView.separated(
                  itemCount: receiptList.length,
                  itemBuilder: (context, index) {
                    return ReceiptItem(
                      receipt: receiptList[index],
                      onDelete: () {
                        DialogService.showConfirmationDialog(
                          context: context,
                          title: DELETE_RECEIPT,
                          message: deleteReceiptMessage(receiptList[index].name!),
                          onConfirm: () {
                            context.read<ReceiptFormCubit>().deleteForm(receiptList[index].uid!);
                          },
                          confirmText: DELETE,
                          cancelText: CANCEL,
                        );
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(height: 30);
                  },
                );
              } else if (state is ReceiptListEmpty) {
                return const EmptyScreen(title: NO_RECEIPT_FOUND, description: START_SCANNING_RECEIPT);
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "create_receipt_fab",
        onPressed: () {
          context.read<FabCubit>().toggle();
          context.pushNamed(ReceiptFormScreen.receiptForm, extra: ReceiptFormScreenArguments(isNew: true)).then((value) {
            if (context.mounted) {
              context.read<ReceiptListCubit>().loadReceipts();
            }
          });
        },
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: Icon(Icons.add),
      ),

      /// NOTE: remove temporarily as we don't support ML receipt scanner yet
      // floatingActionButton: BlocBuilder<FabCubit, bool>(
      //   builder: (context, state) {
      //     return Column(
      //       mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         Visibility(
      //           visible: state,
      //           child: Column(
      //             children: [
      //               // First FAB Button (bottom right)
      //               FloatingActionButton(
      //                 heroTag: "create_receipt_fab",
      //                 onPressed: () {
      //                   context.read<FabCubit>().toggle();
      //                   context.pushNamed(
      //                     ReceiptFormScreen.receiptForm,
      //                     extra: ReceiptFormScreenArguments(isNew: true),
      //                   );
      //                 },
      //                 backgroundColor:
      //                     Theme.of(context).colorScheme.primaryContainer,
      //                 child: Icon(Icons.add),
      //               ),
      //               SizedBox(height: 10),
      //               // Second FAB Button (slightly above the first one)
      //               FloatingActionButton(
      //                 heroTag: "scan_receipt_fab",
      //                 onPressed: () {
      //                   context.read<FabCubit>().toggle();
      //                   context.pushNamed(ReceiptScannerScreen.scan);
      //                 },
      //                 backgroundColor:
      //                     Theme.of(context).colorScheme.primaryContainer,
      //                 child: Icon(Icons.document_scanner_outlined),
      //               ),
      //               SizedBox(height: 10),
      //             ],
      //           ),
      //         ),
      //
      //         // Main Floating Action Button
      //         FloatingActionButton(
      //           heroTag: "main_fab",
      //           onPressed: () {
      //             context.read<FabCubit>().toggle();
      //           },
      //           backgroundColor:
      //               state
      //                   ? Theme.of(context).colorScheme.inversePrimary
      //                   : Theme.of(context).colorScheme.primaryContainer,
      //           child: Icon(state ? Icons.close : Icons.arrow_upward_outlined),
      //         ),
      //       ],
      //     );
      //   },
      // ),
    );
  }
}
