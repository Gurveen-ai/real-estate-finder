import 'package:flutter/material.dart';

void main() => runApp(const EstateEaseApp());

const ink = Color(0xFF17233C);
const muted = Color(0xFF778197);
const navy = Color(0xFF203A63);
const mint = Color(0xFF20B894);
const page = Color(0xFFF6F8FB);

class EstateEaseApp extends StatelessWidget {
  const EstateEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EstateEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: page,
        colorScheme: ColorScheme.fromSeed(seedColor: navy, brightness: Brightness.light),
        fontFamily: 'DM Sans',
      ),
      home: const HomePage(),
    );
  }
}

class Property {
  final String title, location, image, type, beds, baths, area;
  final int price;
  final bool featured;
  final String description;
  final List<String> amenities;

  const Property({
    required this.title,
    required this.location,
    required this.image,
    required this.type,
    required this.beds,
    required this.baths,
    required this.area,
    required this.price,
    this.featured = false,
    this.description = 'A thoughtfully designed home in a well-connected neighbourhood, offering comfortable spaces for everyday living.',
    this.amenities = const ['Covered parking', '24/7 security', 'Power backup', 'Water supply'],
  });
}

const properties = [
  Property(title: 'The Willow Residence', location: 'Jubilee Hills, Hyderabad',
    image: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1000&q=85',
    type: 'Villa', beds: '4 Beds', baths: '3 Baths', area: '2,450 sqft', price: 28500000, featured: true),
  Property(title: 'Skyline Penthouse', location: 'Financial District, Hyderabad',
    image: 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=1000&q=85',
    type: 'Apartment', beds: '3 Beds', baths: '3 Baths', area: '1,850 sqft', price: 16200000, featured: true),
  Property(title: 'Palm Grove Villa', location: 'Kokapet, Hyderabad',
    image: 'https://images.unsplash.com/photo-1600047509807-ba8f99d2cdde?auto=format&fit=crop&w=1000&q=85',
    type: 'Villa', beds: '4 Beds', baths: '4 Baths', area: '3,100 sqft', price: 34200000),
  Property(title: 'Urban Nest Apartment', location: 'Gachibowli, Hyderabad',
    image: 'https://images.unsplash.com/photo-1600210492486-724fe5c67fb0?auto=format&fit=crop&w=1000&q=85',
    type: 'Apartment', beds: '2 Beds', baths: '2 Baths', area: '1,240 sqft', price: 8950000),
  Property(title: 'The Courtyard House', location: 'Manikonda, Hyderabad',
    image: 'https://images.unsplash.com/photo-1600566753086-00f18fb6b3ea?auto=format&fit=crop&w=1000&q=85',
    type: 'House', beds: '3 Beds', baths: '2 Baths', area: '1,960 sqft', price: 12800000),
  Property(title: 'Lakeview Heights', location: 'Kondapur, Hyderabad',
    image: 'https://images.unsplash.com/photo-1600607687920-4e2a09cf159d?auto=format&fit=crop&w=1000&q=85',
    type: 'Apartment', beds: '3 Beds', baths: '2 Baths', area: '1,540 sqft', price: 11400000),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final searchController = TextEditingController();
  final Set<String> favorites = {};
  String selectedType = 'All';
  String selectedPurpose = 'Buy';
  String sort = 'Recommended';
  String currentPage = 'Explore';

  List<Property> get visibleProperties {
    var list = properties.where((p) {
      final q = searchController.text.toLowerCase();
      final matchesQuery = p.title.toLowerCase().contains(q) || p.location.toLowerCase().contains(q);
      final matchesType = selectedType == 'All' || p.type == selectedType;
      return matchesQuery && matchesType;
    }).toList();
    if (sort == 'Price: Low to high') list.sort((a,b) => a.price.compareTo(b.price));
    if (sort == 'Price: High to low') list.sort((a,b) => b.price.compareTo(a.price));
    return list;
  }

  String money(int value) => '₹${(value / 10000000).toStringAsFixed(2)} Cr';

  @override
  void dispose() { searchController.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 760;
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          _header(compact),
          Expanded(child: _pageContent(compact)),
        ]),
      ),
    );
  }


  Widget _pageContent(bool compact) {
    if (currentPage == 'Saved homes') return _savedHomesPage(compact);
    if (currentPage == 'About us') return _aboutUsPage(compact);
    return _explorePage(compact);
  }

  Widget _pageShell(bool compact, Widget child) => SingleChildScrollView(
    child: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1240),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 34, vertical: 26),
          child: child,
        ),
      ),
    ),
  );

  Widget _explorePage(bool compact) {
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 1180 ? 3 : width > 760 ? 2 : 1;
    return _pageShell(compact, Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _hero(compact),
        const SizedBox(height: 28),
        _searchPanel(compact),
        const SizedBox(height: 34),
        Row(children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Handpicked homes for you',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800, color: ink)),
              const SizedBox(height: 5),
              Text('${visibleProperties.length} properties matching your search',
                style: const TextStyle(color: muted, fontSize: 13)),
            ],
          )),
          if (!compact) _sortDropdown(),
        ]),
        const SizedBox(height: 18),
        _typeFilters(),
        const SizedBox(height: 20),
        if (visibleProperties.isEmpty)
          const Padding(
            padding: EdgeInsets.all(40),
            child: Center(child: Text('No properties found. Try another search.')),
          )
        else
          LayoutBuilder(builder: (context, constraints) {
            const gap = 18.0;
            final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: visibleProperties.map((p) =>
                SizedBox(width: cardWidth, child: _propertyCard(p))).toList(),
            );
          }),
        const SizedBox(height: 36),
        _bottomBanner(compact),
        const SizedBox(height: 26),
        const Center(child: Text('© 2026 EstateEase  •  Find a place to call home',
          style: TextStyle(color: muted, fontSize: 12))),
        const SizedBox(height: 12),
      ],
    ));
  }

  Widget _savedHomesPage(bool compact) {
    final savedProperties = properties.where((p) => favorites.contains(p.title)).toList();
    final width = MediaQuery.sizeOf(context).width;
    final columns = width > 1180 ? 3 : width > 760 ? 2 : 1;

    return _pageShell(compact, Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Saved homes',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: ink)),
        const SizedBox(height: 6),
        Text(
          savedProperties.isEmpty
            ? 'Your favourite properties will appear here.'
            : '${savedProperties.length} ${savedProperties.length == 1 ? 'home' : 'homes'} saved',
          style: const TextStyle(color: muted, fontSize: 13),
        ),
        const SizedBox(height: 24),
        if (savedProperties.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 52),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                Icon(Icons.favorite_border_rounded, size: 52, color: navy.withOpacity(.45)),
                const SizedBox(height: 14),
                const Text('No saved homes yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: ink)),
                const SizedBox(height: 7),
                const Text('Tap the heart on any property to save it here.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: muted, fontSize: 13)),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: () => setState(() => currentPage = 'Explore'),
                  style: FilledButton.styleFrom(backgroundColor: navy),
                  child: const Text('Explore homes'),
                ),
              ],
            ),
          )
        else
          LayoutBuilder(builder: (context, constraints) {
            const gap = 18.0;
            final cardWidth = (constraints.maxWidth - gap * (columns - 1)) / columns;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: savedProperties.map((p) =>
                SizedBox(width: cardWidth, child: _propertyCard(p))).toList(),
            );
          }),
        const SizedBox(height: 30),
        const Center(child: Text('© 2026 EstateEase  •  Find a place to call home',
          style: TextStyle(color: muted, fontSize: 12)),
        ),
        const SizedBox(height: 12),
      ],
    ));
  }

  Widget _aboutUsPage(bool compact) => _pageShell(compact, Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        width: double.infinity,
        padding: EdgeInsets.all(compact ? 24 : 38),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [navy, Color(0xFF467A8A)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ABOUT ESTATEEASE',
              style: TextStyle(color: Color(0xFFD7F4EC), fontSize: 11,
                fontWeight: FontWeight.w800, letterSpacing: 1.2)),
            const SizedBox(height: 14),
            Text('Finding a place to call home, made easier.',
              style: TextStyle(color: Colors.white,
                fontSize: compact ? 27 : 36, height: 1.2, fontWeight: FontWeight.w800)),
            const SizedBox(height: 12),
            const Text(
              'EstateEase helps people explore thoughtfully selected residential properties across Hyderabad.',
              style: TextStyle(color: Color(0xFFD8E2EE), fontSize: 14, height: 1.6),
            ),
          ],
        ),
      ),
      const SizedBox(height: 28),
      const Text('Who we are',
        style: TextStyle(fontSize: 23, fontWeight: FontWeight.w800, color: ink)),
      const SizedBox(height: 10),
      const Text(
        'EstateEase is a real estate discovery experience designed to make browsing homes simple and convenient. '
        'We bring property information together in one place so that you can explore different home types, '
        'compare basic details and shortlist the places that interest you.',
        style: TextStyle(color: muted, fontSize: 14, height: 1.8),
      ),
      const SizedBox(height: 24),
      const Text('What you can do with EstateEase',
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: ink)),
      const SizedBox(height: 14),
      _aboutPoint(Icons.search_rounded, 'Explore properties',
        'Browse homes across Hyderabad and search by property name or locality.'),
      _aboutPoint(Icons.tune_rounded, 'Find what fits',
        'Filter listings by property type and sort them by price.'),
      _aboutPoint(Icons.favorite_border_rounded, 'Save your favourites',
        'Keep the homes you like together in your Saved homes section.'),
      const SizedBox(height: 28),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Start exploring',
              style: TextStyle(color: ink, fontSize: 18, fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            const Text('Your next chapter could start with the right home.',
              style: TextStyle(color: muted, fontSize: 13)),
            const SizedBox(height: 14),
            FilledButton(
              onPressed: () => setState(() => currentPage = 'Explore'),
              style: FilledButton.styleFrom(backgroundColor: mint),
              child: const Text('Explore homes'),
            ),
          ],
        ),
      ),
      const SizedBox(height: 26),
      const Center(child: Text('© 2026 EstateEase  •  Find a place to call home',
        style: TextStyle(color: muted, fontSize: 12))),
      const SizedBox(height: 12),
    ],
  ));

  Widget _aboutPoint(IconData icon, String title, String description) => Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(color: const Color(0xFFEAF4F2),
            borderRadius: BorderRadius.circular(12)),
          child: Icon(icon, color: mint, size: 21),
        ),
        const SizedBox(width: 13),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: ink,
              fontWeight: FontWeight.w800, fontSize: 14)),
            const SizedBox(height: 4),
            Text(description, style: const TextStyle(color: muted,
              fontSize: 12, height: 1.5)),
          ],
        )),
      ],
    ),
  );

  Widget _header(bool compact) => Container(
    color: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: compact ? 18 : 34, vertical: 17),
    child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1240),
      child: Row(children: [
        Container(width: 38, height: 38, decoration: BoxDecoration(color: navy, borderRadius: BorderRadius.circular(12)),
          child: const Icon(Icons.apartment_rounded, color: Colors.white, size: 22)),
        const SizedBox(width: 10),
        const Text('EstateEase', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800, color: ink, letterSpacing: -.6)),
        const Spacer(),
        if (!compact) ...[
          _navItem('Explore'), const SizedBox(width: 28), _navItem('Saved homes'),
          const SizedBox(width: 28), _navItem('About us'), const SizedBox(width: 30),
        ] else
          PopupMenuButton<String>(
            tooltip: 'Navigate',
            icon: const Icon(Icons.menu_rounded, color: navy),
            onSelected: (value) => setState(() => currentPage = value),
            itemBuilder: (context) => ['Explore', 'Saved homes', 'About us']
              .map((item) => PopupMenuItem<String>(value: item, child: Text(item)))
              .toList(),
          ),
        OutlinedButton.icon(onPressed: () => _message('Sign in screen coming soon!'),
          icon: const Icon(Icons.person_outline, size: 18), label: Text(compact ? 'Sign in' : 'Sign in'),
          style: OutlinedButton.styleFrom(foregroundColor: navy, side: const BorderSide(color: Color(0xFFDCE2EA)),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)))),
      ]),
    )),
  );

  Widget _navItem(String text) {
    final active = currentPage == text;
    return InkWell(
      onTap: () => setState(() => currentPage = text),
      borderRadius: BorderRadius.circular(6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(text, style: TextStyle(
          color: active ? navy : muted,
          fontWeight: active ? FontWeight.w700 : FontWeight.w500,
          fontSize: 13,
        )),
      ),
    );
  }

  Widget _hero(bool compact) => Container(
    width: double.infinity, padding: EdgeInsets.all(compact ? 24 : 38),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(24),
      gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
        colors: [Color(0xFF203A63), Color(0xFF315782), Color(0xFF467A8A)]),
    ),
    child: Stack(children: [
      Positioned(right: -10, top: -22, child: Icon(Icons.home_work_outlined, size: compact ? 115 : 190, color: Colors.white.withOpacity(.08))),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
          decoration: BoxDecoration(color: Colors.white.withOpacity(.13), borderRadius: BorderRadius.circular(30)),
          child: const Text('YOUR NEXT CHAPTER STARTS HERE', style: TextStyle(color: Color(0xFFD7F4EC), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2))),
        const SizedBox(height: 17),
        Text('Find a place\nyou’ll love to call home.', style: TextStyle(color: Colors.white, fontSize: compact ? 29 : 39, height: 1.13, fontWeight: FontWeight.w800, letterSpacing: -1.1)),
        const SizedBox(height: 12),
        const Text('Discover thoughtfully selected homes across Hyderabad.', style: TextStyle(color: Color(0xFFD8E2EE), fontSize: 13)),
        const SizedBox(height: 22),
        Row(children: [
          _stat('2,400+', 'Homes listed'), const SizedBox(width: 25), _stat('850+', 'Happy families'), const SizedBox(width: 25), _stat('25+', 'Neighbourhoods'),
        ]),
      ]),
    ]),
  );

  Widget _stat(String value, String label) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 17)),
    Text(label, style: const TextStyle(color: Color(0xFFC9D6E5), fontSize: 10)),
  ]);

  Widget _searchPanel(bool compact) => Container(
    padding: EdgeInsets.all(compact ? 16 : 20),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18),
      boxShadow: [BoxShadow(color: const Color(0xFF233B5D).withOpacity(.06), blurRadius: 24, offset: const Offset(0, 8))]),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [
        _purposeTab('Buy'), const SizedBox(width: 8), _purposeTab('Rent'), const SizedBox(width: 8), _purposeTab('Commercial'),
      ]),
      const SizedBox(height: 17),
      compact ? Column(children: [
        _searchField(),
        const SizedBox(height: 10),
        SizedBox(width: double.infinity, child: _searchButton()),
      ]) : Row(children: [
        Expanded(child: _searchField()), const SizedBox(width: 12), SizedBox(width: 145, child: _searchButton()),
      ]),
      const SizedBox(height: 10),
      const Row(children: [Icon(Icons.location_on_outlined, color: mint, size: 15), SizedBox(width: 4),
        Text('Popular: ', style: TextStyle(color: muted, fontSize: 11)),
        Text('Gachibowli  •  Jubilee Hills  •  Kokapet  •  Kondapur', style: TextStyle(color: navy, fontSize: 11, fontWeight: FontWeight.w600))]),
    ]),
  );

  Widget _purposeTab(String label) {
    final active = selectedPurpose == label;
    return InkWell(onTap: () => setState(() => selectedPurpose = label),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        decoration: BoxDecoration(color: active ? const Color(0xFFEAF1F8) : Colors.transparent, borderRadius: BorderRadius.circular(9)),
        child: Text(label, style: TextStyle(color: active ? navy : muted, fontSize: 12, fontWeight: FontWeight.w700))));
  }

  Widget _searchField() => TextField(controller: searchController, onChanged: (_) => setState(() {}),
    decoration: InputDecoration(
      prefixIcon: const Icon(Icons.search, color: muted), hintText: 'Search by location or property name',
      hintStyle: const TextStyle(color: Color(0xFFA3ACBA), fontSize: 12),
      filled: true, fillColor: const Color(0xFFF7F9FC), contentPadding: const EdgeInsets.symmetric(vertical: 14),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    ));

  Widget _searchButton() => FilledButton.icon(onPressed: () => setState(() {}),
    icon: const Icon(Icons.search, size: 17), label: const Text('Find homes'),
    style: FilledButton.styleFrom(backgroundColor: mint, foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))));

  Widget _sortDropdown() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE4E8EF))),
    child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: sort, icon: const Icon(Icons.keyboard_arrow_down, color: muted),
      style: const TextStyle(color: ink, fontSize: 12), items: ['Recommended','Price: Low to high','Price: High to low']
        .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(), onChanged: (v) => setState(() => sort = v!))),
  );

  Widget _typeFilters() => Wrap(spacing: 9, runSpacing: 8, children: ['All','Apartment','Villa','House'].map((type) {
    final active = selectedType == type;
    return InkWell(onTap: () => setState(() => selectedType = type),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
        decoration: BoxDecoration(color: active ? navy : Colors.white, borderRadius: BorderRadius.circular(30),
          border: Border.all(color: active ? navy : const Color(0xFFE3E8EF))),
        child: Text(type, style: TextStyle(color: active ? Colors.white : muted, fontWeight: FontWeight.w700, fontSize: 11))));
  }).toList());

  Widget _propertyCard(Property p) {
    final saved = favorites.contains(p.title);
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(17),
        boxShadow: [BoxShadow(color: const Color(0xFF243B5B).withOpacity(.045), blurRadius: 18, offset: const Offset(0, 6))]),
      clipBehavior: Clip.antiAlias,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Stack(children: [
          SizedBox(height: 190, width: double.infinity, child: Image.network(p.image, fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(color: const Color(0xFFE6ECF2), child: const Center(child: Icon(Icons.home_work, size: 48, color: muted))))),
          Positioned(left: 13, top: 13, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(7)),
            child: Text(p.featured ? 'FEATURED' : p.type.toUpperCase(), style: const TextStyle(color: navy, fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .5)))),
          Positioned(right: 12, top: 12, child: InkWell(onTap: () => setState(() {
            saved ? favorites.remove(p.title) : favorites.add(p.title);
          }), child: Container(width: 34, height: 34, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Icon(saved ? Icons.favorite : Icons.favorite_border, color: saved ? Colors.redAccent : navy, size: 18)))),
        ]),
        Padding(padding: const EdgeInsets.fromLTRB(16, 14, 16, 16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(p.title, style: const TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 15)),
          const SizedBox(height: 5),
          Row(children: [const Icon(Icons.location_on_outlined, color: mint, size: 14), const SizedBox(width: 3),
            Expanded(child: Text(p.location, style: const TextStyle(color: muted, fontSize: 11), overflow: TextOverflow.ellipsis))]),
          const SizedBox(height: 14),
          Row(children: [
            _detail(Icons.bed_outlined, p.beds), const SizedBox(width: 13),
            _detail(Icons.bathtub_outlined, p.baths), const SizedBox(width: 13),
            _detail(Icons.square_foot, p.area),
          ]),
          const SizedBox(height: 14),
          const Divider(height: 1, color: Color(0xFFEDF0F4)),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(money(p.price), style: const TextStyle(color: navy, fontSize: 18, fontWeight: FontWeight.w800)),
              const Text('Starting price', style: TextStyle(color: muted, fontSize: 10)),
            ])),
            OutlinedButton(onPressed: () => _showProperty(p), style: OutlinedButton.styleFrom(
              foregroundColor: navy, side: const BorderSide(color: Color(0xFFDDE4EC)),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9))),
              child: const Text('View details', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700))),
          ]),
        ])),
      ]),
    );
  }

  Widget _detail(IconData icon, String label) => Row(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, size: 14, color: muted), const SizedBox(width: 4),
    Text(label, style: const TextStyle(color: muted, fontSize: 10, fontWeight: FontWeight.w600)),
  ]);

  Widget _bottomBanner(bool compact) => Container(
    width: double.infinity, padding: EdgeInsets.all(compact ? 20 : 26),
    decoration: BoxDecoration(color: const Color(0xFFEAF4F2), borderRadius: BorderRadius.circular(18)),
    child: Row(children: [
      const Icon(Icons.support_agent_rounded, size: 38, color: mint), const SizedBox(width: 15),
      const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Need a little help finding the right home?', style: TextStyle(color: ink, fontWeight: FontWeight.w800, fontSize: 14)),
        SizedBox(height: 4),
        Text('Our property experts are just a message away.', style: TextStyle(color: muted, fontSize: 11)),
      ])),
      if (!compact) FilledButton(onPressed: () => _message('An expert will contact you soon.'),
        style: FilledButton.styleFrom(backgroundColor: navy, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        child: const Text('Talk to an expert', style: TextStyle(fontSize: 11))),
    ]),
  );

  void _showProperty(Property p) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => PropertyDetailsPage(
        property: p,
        money: money,
      ),
    ));
  }

  void _message(String message) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message), behavior: SnackBarBehavior.floating, backgroundColor: navy));
}


class PropertyDetailsPage extends StatelessWidget {
  final Property property;
  final String Function(int) money;

  const PropertyDetailsPage({
    super.key,
    required this.property,
    required this.money,
  });

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 760;
    return Scaffold(
      backgroundColor: page,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
        title: const Text('Property details', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1120),
            child: Padding(
              padding: EdgeInsets.all(compact ? 16 : 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: AspectRatio(
                      aspectRatio: compact ? 1.35 : 2.35,
                      child: Image.network(
                        property.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFE6ECF2),
                          child: const Icon(Icons.home_work_rounded, size: 64, color: muted),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(property.title, style: TextStyle(color: ink, fontSize: compact ? 23 : 30, fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Row(children: [
                              const Icon(Icons.location_on_outlined, color: mint, size: 18),
                              const SizedBox(width: 5),
                              Expanded(child: Text(property.location, style: const TextStyle(color: muted, fontSize: 14))),
                            ]),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(money(property.price), style: TextStyle(color: navy, fontSize: compact ? 18 : 23, fontWeight: FontWeight.w800)),
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                    child: Wrap(
                      alignment: WrapAlignment.spaceAround,
                      runSpacing: 16,
                      children: [
                        _detailItem(Icons.bed_outlined, property.beds, 'Bedrooms'),
                        _detailItem(Icons.bathtub_outlined, property.baths, 'Bathrooms'),
                        _detailItem(Icons.square_foot_rounded, property.area, 'Built-up area'),
                        _detailItem(Icons.home_work_outlined, property.type, 'Property type'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 26),
                  _sectionTitle('About this property'),
                  const SizedBox(height: 10),
                  Text(property.description, style: const TextStyle(color: muted, fontSize: 14, height: 1.7)),
                  const SizedBox(height: 26),
                  _sectionTitle('Amenities'),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: property.amenities.map((amenity) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFE4E8EF))),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        const Icon(Icons.check_circle_outline, color: mint, size: 16),
                        const SizedBox(width: 7),
                        Text(amenity, style: const TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w600)),
                      ]),
                    )).toList(),
                  ),
                  const SizedBox(height: 26),
                  _sectionTitle('Location'),
                  const SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
                    child: Row(children: [
                      const Icon(Icons.place_outlined, color: mint, size: 22),
                      const SizedBox(width: 10),
                      Expanded(child: Text(property.location, style: const TextStyle(color: ink, fontWeight: FontWeight.w600))),
                    ]),
                  ),
                  const SizedBox(height: 26),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFE7EBF1))),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Starting price', style: TextStyle(color: muted, fontSize: 12)),
                      const SizedBox(height: 4),
                      Text(money(property.price), style: const TextStyle(color: navy, fontSize: 25, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 5),
                      const Text('Price shown is indicative for this demonstration listing.', style: TextStyle(color: muted, fontSize: 11)),
                    ]),
                  ),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: const TextStyle(color: ink, fontSize: 20, fontWeight: FontWeight.w800),
  );

  Widget _detailItem(IconData icon, String value, String label) => SizedBox(
    width: 125,
    child: Column(children: [
      Icon(icon, color: navy, size: 21),
      const SizedBox(height: 6),
      Text(value, style: const TextStyle(color: ink, fontSize: 13, fontWeight: FontWeight.w800)),
      const SizedBox(height: 3),
      Text(label, style: const TextStyle(color: muted, fontSize: 10)),
    ]),
  );
}
