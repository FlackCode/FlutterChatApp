import 'package:chatapp/themes/theme_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        //iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
        title: const Text(
          'Settings',
          style: TextStyle(
              //color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(25),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Dark Mode"),
            CupertinoSwitch(
                value: Provider.of<ThemeProvider>(context, listen: false)
                    .isDarkMode,
                onChanged: (value) =>
                    Provider.of<ThemeProvider>(context, listen: false)
                        .toggleTheme())
          ],
        ),
      ),
    );
  }
}
