import 'package:flutter/material.dart';
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
  // Currency? selected = CurrencyService().findByCode('MMK');

  TextEditingController? _searchController;

  @override
  void initState() {
    _searchController = TextEditingController();
    String currencyCode = Preferences().getCurrencyCode();
    selectedCurrency.value = _currencyService.findByCode(currencyCode);
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
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        centerTitle: true,
        title: Text('Currency',style: TextStyle(
          fontSize: 18, color: Theme.of(context).colorScheme.secondaryContainer
        ),),
        leading: IconButton(
          onPressed: (){
          Navigator.of(context).pop();
        }, icon: Icon(
          color: Theme.of(context).colorScheme.secondaryContainer,
          Icons.arrow_back_ios,size: 18,
        )),
      ),
      body: Column(
        children: <Widget>[
          // const SizedBox(height: 12),
          Padding(
  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
  child: TextField(
    controller: _searchController,
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      hintText: 'Search currency',
      prefix: SizedBox(width: 10,),
      suffixIcon: Icon(Icons.search, color: Theme.of(context).colorScheme.secondaryContainer),
      
      // Rounded border with dynamic color
      filled: true,
      fillColor:Preferences().getDarkMode() == ThemeMode.dark ?Colors.blueGrey :Colors.grey.shade200,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      
      // Focus border style
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
      ),

      // Placeholder (hint) style
      hintStyle: TextStyle(
        color: Theme.of(context).colorScheme.onSurfaceVariant,
        fontSize: 16,
      ),
    ),
    onChanged: _filterSearchResults,
  ),
),

          Expanded(
            child: ListView(
              // physics: widget.physics,
              children: [
                if (_favoriteList != null) ...[
                  ..._favoriteList!.map<Widget>((currency) => _listRow(currency)),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 20.0), child: Divider(thickness: 1)),
                ],
                ..._filteredList.map<Widget>((currency) => _listRow(currency)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _listRow(Currency currency) {
    final TextStyle titleTextStyle = _defaultTitleTextStyle; //widget.theme?.titleTextStyle ??
    final TextStyle subtitleTextStyle = _defaultSubtitleTextStyle; //widget.theme?.subtitleTextStyle ??
    final currencySignTextStyle = _defaultCurrencySignTextStyle; //widget.theme?.currencySignTextStyle ??

    return ValueListenableBuilder(
      valueListenable: selectedCurrency,
      builder: (context,select,child) {
        return InkWell(
          onTap: () {
              selectedCurrency.value = currency; 
              Preferences().setCurrencyCode(currency.code);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 9.0, horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 15),
                      _flagWidget(currency),
                      const SizedBox(width: 15),
                      // if (widget.showFlag) ...[
        
                      // ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // if (widget.showCurrencyCode) ...[
                            Text(currency.code, style: titleTextStyle,),
                            // ],
                            // if (widget.showCurrencyName) ...[
                            Text(
                              currency.name,
                              style: subtitleTextStyle,
                              // : titleTextStyle,
                            ),
                            // ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(currency.symbol, style: currencySignTextStyle)),
                Radio(
                  value: currency,
                  groupValue: select,
                  onChanged: (Currency? value) {
                    selectedCurrency.value = value;
                    Preferences().setCurrencyCode(value!.code);
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget _flagWidget(Currency currency) {
    if (currency.flag == null) {
      return Text(
        'NF',
        style: TextStyle(
          fontSize: 25, // widget.theme?.flagSize ??
        ),
      );
    }

    return Text(
      CurrencyUtils.currencyToEmoji(currency),
      style: TextStyle(
        fontSize: 25, // widget.theme?.flagSize ??
      ),
    );
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

  TextStyle get _defaultTitleTextStyle => TextStyle(fontSize: 17,color: Theme.of(context).colorScheme.secondaryContainer);
  TextStyle get _defaultSubtitleTextStyle => TextStyle(fontSize: 15, color: Theme.of(context).hintColor);
  TextStyle get _defaultCurrencySignTextStyle => TextStyle(fontSize: 11,color: Theme.of(context).colorScheme.secondaryContainer);
}
