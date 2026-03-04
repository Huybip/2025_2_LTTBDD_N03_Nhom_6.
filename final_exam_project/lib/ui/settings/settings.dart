import 'package:flutter/material.dart';
import 'package:final_exam_project/l10n/app_localizations.dart';
import 'package:final_exam_project/app/app_locale.dart';
import 'package:final_exam_project/app/app_theme.dart';
import 'package:final_exam_project/ui/settings/group_info.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        children: [
          _SectionTitle(text: l10n.language),
          Card(
            elevation: 0,
            color: cs.surfaceContainer,
            child: ValueListenableBuilder<Locale?>(
              valueListenable: AppLocaleController.locale,
              builder: (context, locale, _) {
                final isVietnamese = locale?.languageCode == 'vi';
                return SwitchListTile(
                  title: Text(l10n.language),
                  subtitle: Text(
                    isVietnamese
                        ? l10n.languageVietnamese
                        : l10n.languageEnglish,
                  ),
                  value: isVietnamese,
                  onChanged: (value) {
                    if (value) {
                      AppLocaleController.setVietnamese();
                    } else {
                      AppLocaleController.setEnglish();
                    }
                  },
                  secondary: const Icon(Icons.language),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(text: l10n.appearance),
          Card(
            elevation: 0,
            color: cs.surfaceContainer,
            child: ValueListenableBuilder<ThemeMode>(
              valueListenable: AppThemeController.themeMode,
              builder: (context, mode, _) {
                return Column(
                  children: [
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.system,
                      groupValue: mode,
                      title: Text(l10n.themeSystem),
                      onChanged: (_) => AppThemeController.setSystem(),
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.light,
                      groupValue: mode,
                      title: Text(l10n.themeLight),
                      onChanged: (_) => AppThemeController.setLight(),
                    ),
                    RadioListTile<ThemeMode>(
                      value: ThemeMode.dark,
                      groupValue: mode,
                      title: Text(l10n.themeDark),
                      onChanged: (_) => AppThemeController.setDark(),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          _SectionTitle(text: l10n.groupInfo),
          Card(
            elevation: 0,
            color: cs.surfaceContainer,
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.groups)),
              title: Text(l10n.groupInfo),
              subtitle: Text(l10n.groupInfoTitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GroupInfoPage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: cs.onSurfaceVariant,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
