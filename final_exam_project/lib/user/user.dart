import 'package:final_exam_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class AccountTab extends StatelessWidget {
  const AccountTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.accountTitle),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildStatCards(context),
            const SizedBox(height: 24),
            Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Tài khoản'
                  : 'Account',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildAccountSection(context),
            const SizedBox(height: 24),
            Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Cài đặt khác'
                  : 'More settings',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _buildOtherSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [cs.primary, cs.secondary],
            ),
          ),
          child: Center(
            child: Text(
              'A',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: cs.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'User Name',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'user@example.com',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            Localizations.localeOf(context).languageCode == 'vi'
                ? 'Chỉnh sửa'
                : 'Edit',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCards(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.favorite, size: 20),
                const SizedBox(height: 8),
                Text(
                  '24',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  Localizations.localeOf(context).languageCode == 'vi'
                      ? 'Bài hát yêu thích'
                      : 'Liked songs',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cs.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: cs.outlineVariant),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.history, size: 20),
                const SizedBox(height: 8),
                Text(
                  '120',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  Localizations.localeOf(context).languageCode == 'vi'
                      ? 'Giờ đã nghe'
                      : 'Hours listened',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Thông tin cá nhân'
                  : 'Profile information',
            ),
            subtitle: Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Tên, avatar, giới thiệu'
                  : 'Name, avatar, bio',
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.lock_outline),
            title: Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Bảo mật & đăng nhập'
                  : 'Security & sign-in',
            ),
            subtitle: Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Mật khẩu, đăng nhập thiết bị'
                  : 'Password, device sign-in',
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.notifications_outlined),
            title: Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Thông báo'
                  : 'Notifications',
            ),
            subtitle: Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Cài đặt thông báo của ứng dụng'
                  : 'App notification preferences',
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildOtherSection(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.help_outline),
            title: Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Trợ giúp & hỗ trợ'
                  : 'Help & support',
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Điều khoản & quyền riêng tư'
                  : 'Terms & privacy',
            ),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(
              Localizations.localeOf(context).languageCode == 'vi'
                  ? 'Đăng xuất'
                  : 'Sign out',
              style: TextStyle(color: cs.error),
            ),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
