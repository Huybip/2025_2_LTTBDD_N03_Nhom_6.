import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:final_exam_project/ui/discovery/discovery.dart';
import 'package:final_exam_project/ui/home/viewmodel.dart';
import 'package:final_exam_project/ui/settings/settings.dart';
import 'package:final_exam_project/ui/user/user.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:final_exam_project/app/app_locale.dart';
import 'package:final_exam_project/app/app_theme.dart';
import 'package:final_exam_project/l10n/app_localizations.dart';

import '../../data/model/song.dart';
import '../now_playing/playing.dart';

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale?>(
      valueListenable: AppLocaleController.locale,
      builder: (context, locale, _) {
        return ValueListenableBuilder<ThemeMode>(
          valueListenable: AppThemeController.themeMode,
          builder: (context, themeMode, __) {
            return MaterialApp(
              title: 'Music App',
              debugShowCheckedModeBanner: false,
              locale: locale,
              supportedLocales: const [Locale('en'), Locale('vi')],
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              themeMode: themeMode,
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF6D28D9),
                  brightness: Brightness.light,
                ),
                useMaterial3: true,
              ),
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF6D28D9),
                  brightness: Brightness.dark,
                ),
                useMaterial3: true,
              ),
              home: const MusicHomePage(),
            );
          },
        );
      },
    );
  }
}

class MusicHomePage extends StatefulWidget {
  const MusicHomePage({super.key});

  @override
  State<MusicHomePage> createState() => _MusicHomePageState();
}

class _MusicHomePageState extends State<MusicHomePage> {
  final List<Widget> _tabs = const [
    HomeTab(),
    DiscoveryTab(),
    AccountTab(),
    SettingsTab(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.appTitle)),
      child: CupertinoTabScaffold(
        tabBar: CupertinoTabBar(
          backgroundColor: Theme.of(context).colorScheme.onInverseSurface,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: l10n.tabHome,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.album),
              label: l10n.tabDiscovery,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: l10n.tabAccount,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.settings),
              label: l10n.tabSettings,
            ),
          ],
        ),
        tabBuilder: (BuildContext context, int index) {
          return _tabs[index];
        },
      ),
    );
  }
}

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeTabPage();
  }
}

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({super.key});

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  final List<Song> _allSongs = [];
  List<Song> _displayedSongs = [];
  late MusicAppViewModel _viewModel;
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    observeData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabHome), centerTitle: true),
      body: getBody(),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _viewModel.songStream.close();
    super.dispose();
  }

  Widget getBody() {
    if (_isLoading) {
      return getProgressBar();
    } else {
      return SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => _applyFilter(),
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: Localizations.localeOf(context).languageCode == 'vi'
                      ? 'Tìm kiếm bài hát'
                      : 'Search songs',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(child: getListView()),
          ],
        ),
      );
    }
  }

  Widget getProgressBar() {
    final l10n = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: cs.primary),
            const SizedBox(height: 12),
            Text(
              l10n.loadingSongs,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  ListView getListView() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      itemBuilder: (context, position) {
        return getRow(position);
      },
      separatorBuilder: (context, index) {
        return const SizedBox(height: 12);
      },
      itemCount: _displayedSongs.length,
      shrinkWrap: true,
    );
  }

  Widget getRow(int index) {
    return _SongItemSection(parent: this, song: _displayedSongs[index]);
  }

  void observeData() {
    _viewModel.songStream.stream.listen((songList) {
      _allSongs.addAll(songList);
      _isLoading = false;
      _applyFilter();
    });
  }

  void _applyFilter() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _displayedSongs = List<Song>.from(_allSongs);
      } else {
        _displayedSongs = _allSongs
            .where(
              (song) =>
                  song.title.toLowerCase().contains(query) ||
                  song.artist.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  void showBottomSheet() {
    final cs = Theme.of(context).colorScheme;
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: cs.surface,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.queue_music),
                  title: const Text('Add to queue'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite_border),
                  title: const Text('Like'),
                  onTap: () => Navigator.pop(context),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void navigate(Song song) {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) {
          return NowPlaying(songs: _displayedSongs, playingSong: song);
        },
      ),
    );
  }
}

class _SongItemSection extends StatelessWidget {
  const _SongItemSection({required this.parent, required this.song});

  final _HomeTabPageState parent;
  final Song song;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainer,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => parent.navigate(song),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/itunes.jpg',
                  image: song.image,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/itunes.jpg',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      song.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      song.artist,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.more_horiz),
                onPressed: parent.showBottomSheet,
                tooltip: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
