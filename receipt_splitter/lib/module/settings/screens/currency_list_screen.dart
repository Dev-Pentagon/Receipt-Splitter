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
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  late List<Currency> _filteredList;
  late List<Currency> _currencyList;
  ValueNotifier<Currency?> selectedCurrency = ValueNotifier(CurrencyService().findByCode('MMK'));
  TextEditingController? _searchController;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _searchController = TextEditingController();
    Currency currencyCode = Preferences().getCurrencyCode();
    selectedCurrency.value = _currencyService.findByCode(currencyCode.code);
    _currencyList = _currencyService.getAll();
    _filteredList = <Currency>[];
    _filteredList.addAll(_currencyList);

    // Auto-scroll to selected currency after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedCurrency();
    });

    super.initState();
  }

  @override
  void dispose() {
    _searchController?.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToSelectedCurrency() {
    if (selectedCurrency.value != null) {
      final selectedIndex = _filteredList.indexWhere((currency) => currency.code == selectedCurrency.value!.code);

      if (selectedIndex != -1 && _scrollController.hasClients) {
        // Calculate approximate position (assuming each item is ~72px height)
        final position = selectedIndex * 72.0;
        final maxScroll = _scrollController.position.maxScrollExtent;
        final targetPosition = position > maxScroll ? maxScroll : position;

        _scrollController.animateTo(targetPosition, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Currency', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.of(context).pop(selectedCurrency.value)),
      ),
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

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _filteredList.length,
                itemBuilder: (context, index) {
                  return _listRow(_filteredList[index]);
                },
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
        final isSelected = select?.code == currency.code;

        return AnimatedContainer(
          key: _listKey,
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5), width: 1) : null,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: () {
              selectedCurrency.value = currency;
              Preferences().setCurrencyCode(currency);
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                spacing: 16,
                children: <Widget>[
                  _flagWidget(currency),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currency.code,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Theme.of(context).colorScheme.primary : null),
                        ),
                        Text(currency.name, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: isSelected ? Theme.of(context).colorScheme.primary : null)),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        currency.symbol,
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? Theme.of(context).colorScheme.primary : null),
                      ),
                      const SizedBox(width: 8),
                      AnimatedScale(
                        scale: isSelected ? 1.1 : 1.0,
                        duration: const Duration(milliseconds: 200),
                        child: Radio<Currency>(
                          value: currency,
                          groupValue: select,
                          onChanged: (Currency? value) {
                            selectedCurrency.value = value;
                            Preferences().setCurrencyCode(value!);
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _flagWidget(Currency currency) {
    if (currency.flag == null) {
      return const Text('NF', style: TextStyle(fontSize: 25));
    }

    return Text(CurrencyUtils.currencyToEmoji(currency), style: const TextStyle(fontSize: 25));
  }

  void _filterSearchResults(String query) {
    List<Currency> searchResult = <Currency>[];

    if (query.isEmpty) {
      searchResult.addAll(_currencyList);
    } else {
      searchResult = _currencyList.where((c) => c.name.toLowerCase().contains(query.toLowerCase().trim()) || c.code.toLowerCase().contains(query.toLowerCase().trim())).toList();
    }

    setState(() {
      _filteredList = searchResult;
      // Re-scroll to selected currency after filtering
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedCurrency();
      });
    });
  }
}
