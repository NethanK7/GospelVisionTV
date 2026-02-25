import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/search_controller.dart';
import '../../models/content_model.dart';
import '../../theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = Provider.of<HomeController>(context);
    final searchController = Provider.of<ContentSearchController>(context);
    final isDesktop = MediaQuery.of(context).size.width >= 800;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 16,
                vertical: 12,
              ),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    Icon(
                      Icons.search,
                      color: Colors.white.withValues(alpha: 0.5),
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search sermons, movies, worship...',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 16,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (query) {
                          searchController.search(
                            query,
                            homeController.allContent,
                          );
                        },
                      ),
                    ),
                    if (_textController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white54, size: 20),
                        onPressed: () {
                          _textController.clear();
                          searchController.clear();
                          setState(() {});
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.mic_outlined, color: Colors.white54, size: 22),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),

            // Content
            Expanded(
              child: searchController.isSearching
                  ? _buildSearchResults(searchController, isDesktop)
                  : _buildCategoryGrid(homeController, isDesktop),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(
      ContentSearchController searchController, bool isDesktop) {
    if (searchController.results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.white.withValues(alpha: 0.2),
            ),
            const SizedBox(height: 16),
            Text(
              'No results found for "${searchController.query}"',
              style: const TextStyle(color: AppTheme.textGrey, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text(
              'Try different keywords or browse categories below',
              style: TextStyle(color: AppTheme.textDimGrey, fontSize: 13),
            ),
          ],
        ),
      );
    }

    final crossAxisCount = isDesktop ? 4 : 3;

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 48 : 16,
        vertical: 12,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: searchController.results.length,
      itemBuilder: (context, index) {
        final item = searchController.results[index];
        return _SearchResultCard(item: item);
      },
    );
  }

  Widget _buildCategoryGrid(HomeController controller, bool isDesktop) {
    final categories = controller.categories;
    final crossAxisCount = isDesktop ? 4 : 2;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Searches section
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 48 : 16,
              vertical: 8,
            ),
            child: const Text(
              'Top Searches',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          // Top search items
          ...controller.trending.take(4).map((item) {
            return _TopSearchItem(item: item);
          }),

          const SizedBox(height: 24),

          // Browse Categories
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 48 : 16,
              vertical: 8,
            ),
            child: const Text(
              'Browse All',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 44 : 12,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                childAspectRatio: 16 / 9,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return _CategoryCard(category: categories[index]);
              },
            ),
          ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _TopSearchItem extends StatelessWidget {
  final ContentModel item;

  const _TopSearchItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/detail/${item.id}'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: Image.network(
                item.imageUrl,
                width: 140,
                height: 78,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => Container(
                  width: 140,
                  height: 78,
                  color: Colors.grey[900],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            // Play icon
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white38, width: 1),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final ContentModel item;

  const _SearchResultCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/detail/${item.id}'),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              item.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(color: Colors.grey[900]),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withValues(alpha: 0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 8,
              left: 8,
              right: 8,
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (item.isBrandNew)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryOrange,
                    borderRadius: BorderRadius.circular(2),
                  ),
                  child: const Text(
                    'NEW',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;

  const _CategoryCard({required this.category});

  @override
  Widget build(BuildContext context) {
    // Generate unique colors for each category
    final colors = [
      [const Color(0xFF8B1A1A), const Color(0xFFCC3333)],
      [const Color(0xFF1A3A5C), const Color(0xFF2E6DA4)],
      [const Color(0xFF4A148C), const Color(0xFF7B1FA2)],
      [const Color(0xFF1B5E20), const Color(0xFF388E3C)],
      [const Color(0xFFE65100), const Color(0xFFF57C00)],
      [const Color(0xFF006064), const Color(0xFF00838F)],
      [const Color(0xFF311B92), const Color(0xFF512DA8)],
      [const Color(0xFF880E4F), const Color(0xFFC2185B)],
      [const Color(0xFF33691E), const Color(0xFF558B2F)],
      [const Color(0xFFBF360C), const Color(0xFFE64A19)],
    ];

    final colorIndex =
        int.tryParse(category.id.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    final colorPair = colors[colorIndex % colors.length];

    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colorPair.map((c) => c).toList(),
              ),
            ),
          ),
          // Image overlay
          Positioned(
            right: -20,
            bottom: -10,
            child: Transform.rotate(
              angle: 0.15,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.network(
                  category.imageUrl,
                  width: 90,
                  height: 90,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => const SizedBox(),
                ),
              ),
            ),
          ),
          // Title
          Positioned(
            top: 10,
            left: 10,
            right: 40,
            child: Text(
              category.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
