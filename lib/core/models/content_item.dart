class ContentItem {
  final String id;
  final String title;
  final String imageUrl;
  final String? subtitle;
  final double? progress;
  final String? videoUrl;
  final String category;

  ContentItem({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.subtitle,
    this.progress,
    this.videoUrl,
    required this.category,
  });
}
