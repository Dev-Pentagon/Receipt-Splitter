import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:receipt_splitter/config/shared_pref.dart';
import 'package:receipt_splitter/module/settings/cubit/theme_cubit.dart';
import 'package:receipt_splitter/module/settings/screens/currency_list_screen.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});
  static const String tag = '/setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text('Setting', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.secondaryContainer)),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(color: Theme.of(context).colorScheme.secondaryContainer, Icons.arrow_back_ios, size: 18),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: Icon(Icons.money, color: Theme.of(context).colorScheme.secondaryContainer),
              title: Text('Currency', style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer)),
              trailing: Icon(Icons.play_arrow, size: 12, color: Theme.of(context).colorScheme.secondaryContainer),
              onTap: () {
                context.pushNamed(CurrencyListView.tag);
              },
            ),
            Divider(color: Colors.blueGrey),
            ListTile(
              leading: Icon(Icons.nights_stay, color: Theme.of(context).colorScheme.secondaryContainer),
              title: Text('Dark mode', style: TextStyle(color: Theme.of(context).colorScheme.secondaryContainer)),
              trailing: SizedBox(
                height: 45,
                width: 45,
                child: FittedBox(
                  child: Switch(
                    trackOutlineWidth: WidgetStateProperty.all(2),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    thumbColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                      final isDarkMode = Preferences().getDarkMode() == ThemeMode.dark;
                      if (!states.contains(WidgetState.selected)) {
                        return isDarkMode ? const Color.fromRGBO(148, 143, 153, 1) : const Color.fromRGBO(115, 119, 127, 1);
                      }
                      return isDarkMode ? Colors.blueGrey.shade300 : Colors.blue.shade300;
                    }),

                    // Track Color (Dark and Light Mode)
                    trackColor: WidgetStateProperty.resolveWith<Color?>((Set<WidgetState> states) {
                      final isDarkMode = Preferences().getDarkMode() == ThemeMode.dark;
                      if (states.contains(WidgetState.selected)) {
                        return isDarkMode
                            ? Colors
                                .blueGrey
                                .shade800 // Dark mode track color (active)
                            : Colors.blue.shade200; // Light mode track color (active)
                      }
                      return isDarkMode
                          ? Colors
                              .grey
                              .shade800 // Dark mode track color (inactive)
                          : Colors.grey.shade300; // Light mode track color (inactive)
                    }),

                    value: Preferences().getDarkMode() == ThemeMode.dark,
                    onChanged: (value) => context.read<ThemeCubit>().toggleTheme(),
                  ),
                ),
              ),
            ),
            Divider(color: Colors.blueGrey),
          ],
        ),
      ),
    );
  }
}
