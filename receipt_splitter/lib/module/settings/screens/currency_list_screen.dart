import 'package:flutter/material.dart';
import 'package:receipt_splitter/common/layout_builder_widget.dart';
import 'package:receipt_splitter/config/shared_pref.dart';
import 'package:receipt_splitter/model/currency.dart';
import 'package:receipt_splitter/services/currency_service.dart';

class CurrencyListView extends StatefulWidget {
  static const String tag = '/currencyList';

  const CurrencyListView({super.key});

  @override
  State<CurrencyListView> createState() => _CurrencyListViewState();
}

class _CurrencyListViewState extends State<CurrencyListView> {
  final CurrencyService _currencyService = CurrencyService();

  late List<Currency> _filteredList;
  late List<Currency> _currencyList;
  List<Currency>? _favoriteList;
  ValueNotifier<Currency?> selectedCurrency = ValueNotifier(CurrencyService().findByCode('MMK'));
  TextEditingController? _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    Currency currencyCode = Preferences().getCurrencyCode();
    selectedCurrency.value = _currencyService.findByCode(currencyCode.code);
    _currencyList = _currencyService.getAll();

    _filteredList = <Currency>[];

    _filteredList.addAll(_currencyList);
    super.initState();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: Text('Currency', style: Theme.of(context).textTheme.titleLarge)),
      body: LayoutBuilderWidget(
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
                hintText: 'Search currency',
                suffixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.onSurfaceVariant),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceContainerHigh,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 16),
              ),
              onChanged: _filterSearchResults,
            ),
            SizedBox(height: 15),
            Expanded(
              child: ListView(
                // physics: widget.physics,
                children: [
                  if (_favoriteList != null) ...[..._favoriteList!.map<Widget>((currency) => _listRow(currency)), Divider(thickness: 1)],
                  ..._filteredList.map<Widget>((currency) => _listRow(currency)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _listRow(Currency currency) {
    return ValueListenableBuilder(
      valueListenable: selectedCurrency,
      builder: (context, select, child) {
        return InkWell(
          onTap: () {
            selectedCurrency.value = currency;
            Preferences().setCurrencyCode(currency);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              spacing: 16,
              children: <Widget>[
                _flagWidget(currency),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(currency.code, style: Theme.of(context).textTheme.bodyLarge),
                      Text(
                        currency.name,
                        style: Theme.of(context).textTheme.bodySmall,
                        // : titleTextStyle,
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Text(currency.symbol, style: Theme.of(context).textTheme.bodySmall),
                    Radio(
                      value: currency,
                      groupValue: select,
                      onChanged: (Currency? value) {
                        selectedCurrency.value = value;
                        Preferences().setCurrencyCode(value!);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _flagWidget(Currency currency) {
    if (currency.flag == null) {
      return Text('NF', style: TextStyle(fontSize: 25));
    }

    return Text(CurrencyUtils.currencyToEmoji(currency), style: TextStyle(fontSize: 25));
  }

  void _filterSearchResults(String query) {
    List<Currency> searchResult = <Currency>[];

    if (query.isEmpty) {
      searchResult.addAll(_currencyList);
    } else {
      searchResult = _currencyList.where((c) => c.name.toLowerCase().contains(query.toLowerCase().trim()) || c.code.toLowerCase().contains(query.toLowerCase().trim())).toList();
    }

    setState(() => _filteredList = searchResult);
  }
}
