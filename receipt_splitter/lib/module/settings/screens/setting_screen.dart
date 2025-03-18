import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/common/layout_builder_widget.dart';
import 'package:receipt_splitter/config/shared_pref.dart';
import 'package:receipt_splitter/module/settings/cubit/theme_cubit.dart';
import 'package:receipt_splitter/module/settings/screens/currency_list_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  static const String tag = '/setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Setting', style: Theme.of(context).textTheme.titleLarge),
        centerTitle: true,
      ),
      body: LayoutBuilderWidget(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(
                Icons.money,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                'Currency',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: Icon(
                Icons.play_arrow,
                size: 12,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              onTap: () {
                context.pushNamed(CurrencyListView.tag);
              },
            ),
            Divider(color: Theme.of(context).colorScheme.outlineVariant),
            ListTile(
              leading: Icon(
                Icons.nights_stay,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              title: Text(
                'Dark mode',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: SizedBox(
                height: 45,
                width: 45,
                child: FittedBox(
                  child: Switch(
                    trackOutlineWidth: WidgetStateProperty.all(2),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    value: Preferences().getThemeMode() == ThemeMode.dark,
                    onChanged:
                        (value) => context.read<ThemeCubit>().toggleTheme(),
                  ),
                ),
              ),
            ),
            Divider(color: Theme.of(context).colorScheme.outlineVariant),
          ],
        ),
      ),
    );
  }
}
