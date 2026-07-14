import 'package:flutter/material.dart';

// Reproduction of https://themoviebox.xyz/ home page, built by reading the
// site's real HTML/CSS (attached_assets/page_(1)_1784001367125.html) rather
// than guessing from screenshots. Key tokens taken directly from that CSS:
//  - background       #101114
//  - card background  #2b2e39
//  - header border    #ffffff1a
//  - search bg        #fff3 (white 20%), radius .5rem, height 2.5rem, max-width 35rem
//  - logo icon        2rem x 2.25rem
//  - sidebar nav item width 12.5rem, radius .5rem, active bg #fff3
//  - active nav label: linear-gradient(91deg,#1cb7ff 1.22%,#2ff58b 50.24%)
//    clipped to text — the "brush" gradient effect on the selected tab.
//  - hero bottom blend: 100px gradient, transparent -> #101114

const _bg = Color(0xFF101114);
const _cardBg = Color(0xFF2B2E39);
const _borderColor = Color(0x1AFFFFFF);
const _searchBg = Color(0x33FFFFFF);
const _brushBlue = Color(0xFF1CB7FF);
const _brushGreen = Color(0xFF2FF58B);

void main() => runApp(const MovieBoxApp());

class MovieBoxApp extends StatelessWidget {
  const MovieBoxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieBox — reproduction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _bg,
        fontFamily: 'Roboto',
      ),
      home: const HomePage(),
    );
  }
}

class NavItem {
  final IconData icon;
  final String label;
  const NavItem(this.icon, this.label);
}

const _navItems = [
  NavItem(Icons.home_rounded, 'Home'),
  NavItem(Icons.live_tv_rounded, 'TV show'),
  NavItem(Icons.movie_creation_rounded, 'Movie'),
  NavItem(Icons.pets_rounded, 'Animation'),
  NavItem(Icons.bar_chart_rounded, 'Most Watched'),
  NavItem(Icons.phone_android_rounded, 'MovieBox App'),
  NavItem(Icons.tv_rounded, 'Moviebox TV APK'),
  NavItem(Icons.file_download_rounded, 'FM Download'),
  NavItem(Icons.sports_esports_rounded, 'Games'),
  NavItem(Icons.history_rounded, 'Old Moviebox'),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNav = 0;
  int _slide = 0;

  final _slides = const [
    _Hero(title: 'The Furious', meta: '2026 · Action, Crime, Thriller', colors: [Color(0xFF3A1414), Color(0xFF101114)]),
    _Hero(title: 'Ikka [Version française]', meta: '2026 · Drame', colors: [Color(0xFF7A1F2B), Color(0xFF101114)]),
    _Hero(title: 'Human Vapor', meta: '2026 · Drama', colors: [Color(0xFF12386B), Color(0xFF101114)]),
  ];

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      backgroundColor: _bg,
      body: Column(
        children: [
          _Header(isDesktop: isDesktop),
          Expanded(
            child: Row(
              children: [
                if (isDesktop) _Sidebar(selected: _selectedNav, onSelect: (i) => setState(() => _selectedNav = i)),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHero(),
                        _buildSection('Popular Series', _seriesPosters),
                        _buildSection('Popular Movie', _moviePosters),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHero() {
    final s = _slides[_slide];
    return SizedBox(
      height: 460,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Container(
              key: ValueKey(_slide),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: s.colors,
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
              ),
            ),
          ),
          // Bottom blend into the page background — taken directly from the
          // site's `bg-gradient-to-b from-transparent to-[#101114]` overlay.
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00101114), _bg],
                ),
              ),
            ),
          ),
          Positioned(
            left: 32,
            bottom: 40,
            right: 32,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.title,
                    style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(s.meta, style: const TextStyle(color: Colors.white70, fontSize: 14)),
              ],
            ),
          ),
          Positioned(
            left: 12,
            top: 0,
            bottom: 0,
            child: Center(child: _arrowButton(Icons.chevron_left, () => setState(() => _slide = (_slide - 1 + _slides.length) % _slides.length))),
          ),
          Positioned(
            right: 12,
            top: 0,
            bottom: 0,
            child: Center(child: _arrowButton(Icons.chevron_right, () => setState(() => _slide = (_slide + 1) % _slides.length))),
          ),
          Positioned(
            right: 24,
            bottom: 24,
            child: Row(
              children: List.generate(_slides.length, (i) {
                final active = i == _slide;
                return Container(
                  margin: const EdgeInsets.only(left: 4),
                  width: active ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? Colors.white : Colors.white38,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _arrowButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: Colors.black.withOpacity(0.45), shape: BoxShape.circle),
        child: Icon(icon, color: Colors.white70),
      ),
    );
  }

  Widget _buildSection(String title, List<_Poster> posters) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          SizedBox(
            height: 210,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: posters.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) => _posterCard(posters[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _posterCard(_Poster p) {
    return Container(
      width: 140,
      decoration: BoxDecoration(color: _cardBg, borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: p.colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: p.badge == null
                  ? null
                  : Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.all(6),
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(3)),
                        child: Text(p.badge!, style: const TextStyle(color: Colors.white, fontSize: 10)),
                      ),
                    ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(p.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  final _seriesPosters = const [
    _Poster('Avatar: The Last Airbender', [Color(0xFF1E3A5F), Color(0xFF12386B)], badge: null),
    _Poster('House of the Dragon', [Color(0xFF2A2A2A), Color(0xFF101114)]),
    _Poster('Agent Kim Reactivated', [Color(0xFF1C1E21), Color(0xFF000000)], badge: 'English'),
    _Poster('Kwa Baba', [Color(0xFF6B5A1E), Color(0xFF2A2422)]),
    _Poster('Love Island USA', [Color(0xFFFD3AB4), Color(0xFF7A1F2B)]),
    _Poster('Human Vapor', [Color(0xFF12386B), Color(0xFF1E3A5F)], badge: 'English'),
  ];

  final _moviePosters = const [
    _Poster('The Last Airbender', [Color(0xFFB2431E), Color(0xFF6B1212)]),
    _Poster('Golden Kamuy', [Color(0xFF6B5A1E), Color(0xFF3A2A1E)]),
    _Poster('Elle', [Color(0xFFFD3AB4), Color(0xFF2A2422)], badge: 'New'),
    _Poster('The Furious', [Color(0xFF3A1414), Color(0xFF101114)]),
  ];
}

class _Hero {
  final String title;
  final String meta;
  final List<Color> colors;
  const _Hero({required this.title, required this.meta, required this.colors});
}

class _Poster {
  final String title;
  final List<Color> colors;
  final String? badge;
  const _Poster(this.title, this.colors, {this.badge});
}

/// Top header: hamburger + logo/name (left), search bar, download button
/// (right) — matches `.pc-header` / `.pc-header-inner` from the real site.
class _Header extends StatelessWidget {
  final bool isDesktop;
  const _Header({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(bottom: BorderSide(color: _borderColor, width: 1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.menu, color: Colors.white70, size: 26),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 36,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [_brushBlue, _brushGreen]),
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: const Icon(Icons.play_arrow, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 4),
          const Text('MovieBox', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
          Container(
            margin: const EdgeInsets.only(left: 28),
            constraints: const BoxConstraints(maxWidth: 560),
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: _searchBg, borderRadius: BorderRadius.circular(8)),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.white54, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Search movies/ TV Shows',
                      style: TextStyle(color: Colors.white54, fontSize: 14)),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (isDesktop)
            Container(
              height: 32,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              margin: const EdgeInsets.only(left: 16),
              decoration: BoxDecoration(color: _searchBg, borderRadius: BorderRadius.circular(30)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.file_download_outlined, color: Colors.white, size: 16),
                  SizedBox(width: 6),
                  Text('Download App', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

/// Left vertical nav — matches `.left-slider` / `.pc-nav-item`. The selected
/// item's label uses a clipped linear-gradient (blue -> green) exactly like
/// `.title[data-v-2197f34b]{background:linear-gradient(91deg,#1cb7ff 1.22%,
/// #2ff58b 50.24%);-webkit-background-clip:text;color:transparent}` on the
/// real site — this is the "brush" gradient effect.
class _Sidebar extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onSelect;
  const _Sidebar({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 224,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: const BoxDecoration(
        color: _bg,
        border: Border(right: BorderSide(color: _borderColor, width: 1)),
      ),
      child: ListView.builder(
        itemCount: _navItems.length,
        itemBuilder: (context, i) {
          final item = _navItems[i];
          final active = i == selected;
          return GestureDetector(
            onTap: () => onSelect(i),
            child: Container(
              width: 200,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: active ? _searchBg : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(item.icon, color: active ? _brushGreen : Colors.white70, size: 20),
                  const SizedBox(width: 10),
                  active
                      ? ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [_brushBlue, _brushGreen],
                          ).createShader(bounds),
                          child: Text(item.label,
                              style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
                        )
                      : Text(item.label,
                          style: const TextStyle(color: Colors.white70, fontSize: 15, fontWeight: FontWeight.w400)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
