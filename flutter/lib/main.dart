import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MovieBoxHomeApp());
}

class MovieBoxHomeApp extends StatelessWidget {
  const MovieBoxHomeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MovieBox Home — reproduction',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        fontFamily: 'Roboto',
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _tabs = const [
    'FightZone',
    'World Cup',
    'Tendance',
    'Film',
    'TV',
    'Anime',
    'TV courte',
  ];
  int _selectedTab = 2;

  // Each hero "slide" carries the two gradient colors used for its
  // placeholder banner + the bottom-left ambient blur color, mirroring the
  // BlurredSectorView glow found in the decompiled fragment_home.xml.
  final _slides = const [
    _HeroSlide(
      colors: [Color(0xFFEA6A3E), Color(0xFFF2C9C0)],
      glow: Color(0x99512F2F),
      title: 'Coupe du Monde de la FIFA',
      subtitle: 'REJOIGNEZ-NOUS',
    ),
    _HeroSlide(
      colors: [Color(0xFF7A1F2B), Color(0xFF2A2A2A)],
      glow: Color(0x99512F2F),
      title: 'Ikka [Version française]',
      subtitle: 'Drame · 2026',
    ),
    _HeroSlide(
      colors: [Color(0xFF3A2A1E), Color(0xFF120A08)],
      glow: Color(0x99512F2F),
      title: 'Animés japonais',
      subtitle: 'Record of Ragnarok',
    ),
  ];
  int _slideIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        extendBody: true,
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHero(context)),
            SliverToBoxAdapter(child: _buildPromoStrip()),
            SliverToBoxAdapter(child: _buildFifaSection()),
            SliverToBoxAdapter(child: _buildCategories()),
            SliverToBoxAdapter(child: _buildRankings()),
            const SliverToBoxAdapter(child: SizedBox(height: 90)),
          ],
        ),
        bottomNavigationBar: const _BottomNav(),
      ),
    );
  }

  // ---- Hero carousel + scrim + tab row -----------------------------------
  Widget _buildHero(BuildContext context) {
    final slide = _slides[_slideIndex];
    return SizedBox(
      height: 430,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Full-bleed banner, one per PageView page.
          PageView.builder(
            itemCount: _slides.length,
            onPageChanged: (i) => setState(() => _slideIndex = i),
            itemBuilder: (context, i) {
              final s = _slides[i];
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: s.colors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              );
            },
          ),
          // Bottom-left ambient glow (BlurredSectorView equivalent):
          // a soft, blurred translucent half-circle anchored bottom-left.
          Positioned(
            left: -60,
            bottom: -40,
            child: _BlurredGlow(color: slide.glow),
          ),
          // Top scrim: dark-to-transparent gradient sitting above the
          // banner and below the status bar / search / tab row, so the
          // tab labels stay legible regardless of the banner's own colors.
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xB3000000),
                  Color(0x40000000),
                  Color(0x00000000),
                ],
                stops: [0.0, 0.4, 1.0],
              ),
            ),
          ),
          // Title/subtitle overlay near the bottom of the banner.
          Positioned(
            left: 16,
            right: 16,
            bottom: 96,
            child: Text(
              slide.subtitle,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
                shadows: [Shadow(blurRadius: 12, color: Colors.black54)],
              ),
            ),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                _buildSearchBar(),
                const SizedBox(height: 10),
                _buildTabRow(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        height: 40,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.35),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: const [
            Icon(Icons.search, color: Colors.white70, size: 20),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                "Rechercher un film/une série/un audio",
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ),
            Text(
              'Recherche',
              style: TextStyle(
                color: Color(0xFF4CD964),
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabRow() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 18),
        itemBuilder: (context, i) {
          final selected = i == _selectedTab;
          return GestureDetector(
            onTap: () => setState(() => _selectedTab = i),
            child: Container(
              alignment: Alignment.center,
              padding:
                  selected ? const EdgeInsets.symmetric(horizontal: 10) : null,
              decoration: selected
                  ? BoxDecoration(
                      color: const Color(0xFFCFEA3A),
                      borderRadius: BorderRadius.circular(14),
                    )
                  : null,
              child: Text(
                _tabs[i],
                style: TextStyle(
                  color: selected ? Colors.black : Colors.white,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 14,
                  shadows: selected
                      ? null
                      : const [Shadow(blurRadius: 6, color: Colors.black54)],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ---- Promo strip (two cards under the hero) ----------------------------
  Widget _buildPromoStrip() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      child: Row(
        children: [
          Expanded(child: _promoCard('Rejoignez-nous !', const Color(0xFFEA6A3E), trailingIcon: Icons.play_circle_fill)),
          const SizedBox(width: 10),
          Expanded(child: _promoCard('Ikka [Version française]', const Color(0xFF7A1F2B), subtitle: '2026 · Drame')),
        ],
      ),
    );
  }

  Widget _promoCard(String title, Color color, {String? subtitle, IconData? trailingIcon}) {
    return Container(
      height: 64,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF1D1D1D),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(subtitle, style: const TextStyle(color: Colors.white54, fontSize: 10)),
                  ),
              ],
            ),
          ),
          if (trailingIcon != null) Icon(trailingIcon, color: const Color(0xFF4CD964), size: 26),
        ],
      ),
    );
  }

  // ---- FIFA section -------------------------------------------------------
  Widget _buildFifaSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Coupe du Monde de la FIFA'),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _matchCard('Prochain · 15:53:33', 'France', 'Spain', const Color(0xFF12386B)),
                const SizedBox(width: 10),
                _matchCard('Prochain · 1 Day à gauche', 'England', 'Argentina', const Color(0xFF6B1212)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _matchCard(String time, String left, String right, Color accent) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [accent, const Color(0xFF1D1D1D)]),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(time, style: const TextStyle(color: Colors.white70, fontSize: 11)),
          const Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _flagVs(left),
              const Text('VS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              _flagVs(right),
            ],
          ),
        ],
      ),
    );
  }

  Widget _flagVs(String name) {
    return Column(
      children: [
        Container(width: 28, height: 20, color: Colors.white24),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(color: Colors.white, fontSize: 11)),
      ],
    );
  }

  // ---- Categories -----------------------------------------------------------
  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Catégories'),
          const SizedBox(height: 10),
          SizedBox(
            height: 60,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _categoryChip('Tous', Icons.tune, const Color(0xFF2E2E2E)),
                _categoryChip('Hollywood', null, const Color(0xFF2A4A3E)),
                _categoryChip('Action', null, const Color(0xFF3E2A2A)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryChip(String label, IconData? icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      width: 130,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          if (icon != null) ...[
            const SizedBox(width: 6),
            Icon(icon, color: Colors.white70, size: 16),
          ],
        ],
      ),
    );
  }

  // ---- Rankings -------------------------------------------------------------
  Widget _buildRankings() {
    const items = ['The Last Airbender', 'Human Vapor', 'Golden Kamuy'];
    const colors = [Color(0xFFB2431E), Color(0xFF1E3A5F), Color(0xFF6B5A1E)];
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 24, 12, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionHeader('Classements'),
          const SizedBox(height: 10),
          Row(
            children: const [
              _RankTab('Tendance', selected: true),
              SizedBox(width: 16),
              _RankTab('Séries'),
              SizedBox(width: 16),
              _RankTab('Films'),
              SizedBox(width: 16),
              _RankTab('Animés'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 190,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, i) => _rankCard(i + 1, items[i], colors[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rankCard(int rank, String title, Color color) {
    return Container(
      width: 120,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 6,
            top: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(4)),
              child: Text('$rank', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ),
          Positioned(
            left: 6,
            right: 6,
            bottom: 8,
            child: Text(title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.w700)),
        const Row(
          children: [
            Text('Tous', style: TextStyle(color: Colors.white54, fontSize: 12)),
            Icon(Icons.chevron_right, color: Colors.white54, size: 16),
          ],
        ),
      ],
    );
  }
}

class _HeroSlide {
  final List<Color> colors;
  final Color glow;
  final String title;
  final String subtitle;
  const _HeroSlide({
    required this.colors,
    required this.glow,
    required this.title,
    required this.subtitle,
  });
}

/// Reproduces the decompiled `BlurredSectorView`: a soft, blurred
/// translucent half-circle anchored to the bottom-left of the hero banner,
/// giving the ambient "glow" seen behind the carousel content.
class _BlurredGlow extends StatelessWidget {
  final Color color;
  const _BlurredGlow({required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}

class _RankTab extends StatelessWidget {
  final String label;
  final bool selected;
  const _RankTab(this.label, {this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        color: selected ? Colors.white : Colors.white54,
        fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
        fontSize: 14,
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      padding: const EdgeInsets.only(top: 6),
      decoration: const BoxDecoration(
        color: Color(0xFF161616),
        border: Border(top: BorderSide(color: Color(0xFF262626))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.home, 'Accueil', selected: true),
          _navItem(Icons.tv, 'TV courte'),
          _freeButton(),
          _navItem(Icons.download, 'Téléchargement'),
          _navItem(Icons.person, 'Moi'),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, {bool selected = false}) {
    final color = selected ? const Color(0xFF4CD964) : Colors.white54;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 2),
        Text(label, style: TextStyle(color: color, fontSize: 10)),
      ],
    );
  }

  Widget _freeButton() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(colors: [Color(0xFF4CD964), Color(0xFF2E9E4A)]),
        border: Border.all(color: const Color(0xFF161616), width: 3),
      ),
      alignment: Alignment.center,
      child: const Text('FREE', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
    );
  }
}
