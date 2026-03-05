import 'package:final_exam_project/data/model/song.dart';
import 'package:final_exam_project/l10n/app_localizations.dart';
import 'package:final_exam_project/ui/home/viewmodel.dart';
import 'package:final_exam_project/ui/now_playing/playing.dart';
import 'package:flutter/material.dart';

class DiscoveryTab extends StatefulWidget {
  const DiscoveryTab({super.key});

  @override
  State<DiscoveryTab> createState() => _DiscoveryTabState();
}

class _DiscoveryTabState extends State<DiscoveryTab> {
  late MusicAppViewModel _viewModel;
  final List<Song> _allSongs = [];
  final List<_Playlist> _playlists = [];
  final List<_AlbumGroup> _albums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _viewModel = MusicAppViewModel();
    _viewModel.loadSongs();
    _observeSongs();
  }

  @override
  void dispose() {
    _viewModel.songStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.discoveryTitle), centerTitle: true),
      body: _isLoading
          ? _buildLoading(context)
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  _buildSectionTitle(
                    context,
                    Localizations.localeOf(context).languageCode == 'vi'
                        ? 'Playlist'
                        : 'Playlists',
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 160,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _playlists.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemBuilder: (context, index) {
                        final playlist = _playlists[index];
                        return _PlaylistCard(
                          playlist: playlist,
                          onTap: () => _openSongList(
                            title: playlist.name,
                            songs: playlist.songs,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionTitle(
                    context,
                    Localizations.localeOf(context).languageCode == 'vi'
                        ? 'Album'
                        : 'Albums',
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _albums.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final album = _albums[index];
                      return _AlbumTile(
                        album: album,
                        onTap: () => _openSongList(
                          title: album.name,
                          songs: album.songs,
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLoading(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: cs.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: const SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium,
    );
  }

  void _observeSongs() {
    _viewModel.songStream.stream.listen((songs) {
      _allSongs.clear();
      _allSongs.addAll(songs);
      _buildPlaylists();
      _buildAlbums();
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _buildPlaylists() {
    if (_allSongs.isEmpty) return;

    // Playlist 1: Top hits (theo counter cao nhất nếu có trong JSON, fallback dùng id).
    final topSongs = List<Song>.from(_allSongs.take(10));
    _playlists.clear();
    _playlists.addAll([
      _Playlist(
        name: Localizations.localeOf(context).languageCode == 'vi'
            ? 'Top Hits'
            : 'Top Hits',
        songs: topSongs,
      ),
      _Playlist(
        name: Localizations.localeOf(context).languageCode == 'vi'
            ? 'Ngẫu nhiên'
            : 'Random mix',
        songs: _allSongs..shuffle(),
      ),
    ]);
  }

  void _buildAlbums() {
    _albums.clear();
    final Map<String, List<Song>> byAlbum = {};
    for (final song in _allSongs) {
      byAlbum.putIfAbsent(song.album, () => <Song>[]).add(song);
    }
    byAlbum.forEach((name, songs) {
      _albums.add(_AlbumGroup(name: name, songs: songs));
    });
  }

  void _openSongList({required String title, required List<Song> songs}) {
    if (songs.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => _SongListPage(title: title, songs: songs),
      ),
    );
  }
}

class _Playlist {
  _Playlist({required this.name, required this.songs});

  final String name;
  final List<Song> songs;
}

class _AlbumGroup {
  _AlbumGroup({required this.name, required this.songs});

  final String name;
  final List<Song> songs;
}

class _PlaylistCard extends StatelessWidget {
  const _PlaylistCard({required this.playlist, required this.onTap});

  final _Playlist playlist;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cover = playlist.songs.isNotEmpty ? playlist.songs.first.image : null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        decoration: BoxDecoration(
          color: cs.surfaceContainer,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: cover != null
                  ? FadeInImage.assetNetwork(
                      placeholder: 'assets/itunes.jpg',
                      image: cover,
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/itunes.jpg',
                      height: 100,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    playlist.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${playlist.songs.length} ' +
                        (Localizations.localeOf(context).languageCode == 'vi'
                            ? 'bài hát'
                            : 'songs'),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AlbumTile extends StatelessWidget {
  const _AlbumTile({required this.album, required this.onTap});

  final _AlbumGroup album;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final cover = album.songs.isNotEmpty ? album.songs.first.image : null;
    return ListTile(
      onTap: onTap,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: cover != null
            ? FadeInImage.assetNetwork(
                placeholder: 'assets/itunes.jpg',
                image: cover,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              )
            : Image.asset(
                'assets/itunes.jpg',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
      ),
      title: Text(
        album.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        '${album.songs.length} ' +
            (Localizations.localeOf(context).languageCode == 'vi'
                ? 'bài hát'
                : 'songs'),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: cs.onSurfaceVariant,
            ),
      ),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}

class _SongListPage extends StatelessWidget {
  const _SongListPage({required this.title, required this.songs});

  final String title;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        itemCount: songs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final song = songs[index];
          final cs = Theme.of(context).colorScheme;
          return Material(
            color: cs.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NowPlaying(
                      songs: songs,
                      playingSong: song,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/itunes.jpg',
                        image: song.image,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
