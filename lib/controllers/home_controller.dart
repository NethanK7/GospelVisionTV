import 'package:flutter/material.dart';
import '../models/content_model.dart';

class HomeController extends ChangeNotifier {
  bool isLoading = false;

  // --- FEATURED CAROUSEL ---
  final List<ContentModel> featuredContent = [
    ContentModel(
      id: 'f1',
      title: 'The Chosen',
      description:
          'Experience the life of Jesus through the eyes of those who knew Him. A groundbreaking multi-season series that brings the Gospels to life like never before.',
      imageUrl:
          'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=1200&q=80',
      backdropUrl:
          'https://images.unsplash.com/photo-1560448204-603b3fc33ddc?w=1600&q=80',
      category: 'Drama',
      genres: ['Drama', 'Faith', 'Historical'],
      maturityRating: 'PG-13',
      year: '2024',
      seasons: 4,
      episodes: 32,
      matchPercentage: 98,
      isOriginal: true,
      isBrandNew: true,
      type: ContentType.series,
      cast: 'Jonathan Roumie, Elizabeth Tabish, Shahar Isaac',
      director: 'Dallas Jenkins',
    ),
    ContentModel(
      id: 'f2',
      title: 'Unbroken Faith',
      description:
          'The untold story of persecuted believers who held onto hope against impossible odds. A powerful documentary journey across three continents.',
      imageUrl:
          'https://images.unsplash.com/photo-1473679408190-0693dd22fe6a?w=1200&q=80',
      category: 'Documentary',
      genres: ['Documentary', 'Inspirational', 'True Story'],
      maturityRating: 'PG',
      year: '2025',
      duration: '2h 12m',
      matchPercentage: 96,
      isOriginal: true,
      type: ContentType.documentary,
      director: 'Andrew Morgan',
    ),
    ContentModel(
      id: 'f3',
      title: 'Worship Nights Live',
      description:
          'Join millions of believers worldwide for an unforgettable night of worship, prayer, and the presence of God.',
      imageUrl:
          'https://images.unsplash.com/photo-1510590337019-5ef8d3d32116?w=1200&q=80',
      category: 'Worship',
      genres: ['Worship', 'Music', 'Live Event'],
      maturityRating: 'G',
      year: '2025',
      duration: '3h 30m',
      matchPercentage: 99,
      isOriginal: true,
      isBrandNew: true,
      type: ContentType.worship,
    ),
  ];

  // --- CONTINUE WATCHING ---
  final List<ContentModel> continueWatching = [
    ContentModel(
      id: 'cw1',
      title: 'Faith in Action',
      description: 'S2:E5 - The power of community prayer.',
      imageUrl:
          'https://images.unsplash.com/photo-1507692049790-de58290a4334?w=400&q=80',
      category: 'Sermons',
      genres: ['Sermon', 'Teaching'],
      maturityRating: 'G',
      year: '2024',
      duration: '45m',
      progress: 0.65,
      type: ContentType.sermon,
    ),
    ContentModel(
      id: 'cw2',
      title: 'Historical Discoveries',
      description: 'E3 - Dead Sea Scrolls: The Hidden Truth',
      imageUrl:
          'https://images.unsplash.com/photo-1627916606041-0bfac94d50ff?w=400&q=80',
      category: 'Documentaries',
      genres: ['Documentary', 'History'],
      maturityRating: 'PG',
      year: '2024',
      duration: '55m',
      progress: 0.20,
      type: ContentType.documentary,
    ),
    ContentModel(
      id: 'cw3',
      title: 'Grace Unplugged',
      description: 'A talented singer must choose between fame and faith.',
      imageUrl:
          'https://images.unsplash.com/photo-1493225457124-a3eb161ffa5f?w=400&q=80',
      category: 'Movies',
      genres: ['Drama', 'Music', 'Faith'],
      maturityRating: 'PG',
      year: '2023',
      duration: '1h 42m',
      progress: 0.45,
      type: ContentType.movie,
    ),
    ContentModel(
      id: 'cw4',
      title: 'Kingdom Builders',
      description: 'S1:E8 - Building churches in remote villages',
      imageUrl:
          'https://images.unsplash.com/photo-1529070538774-1843cb3265df?w=400&q=80',
      category: 'Documentary',
      genres: ['Documentary', 'Missions'],
      maturityRating: 'G',
      year: '2024',
      duration: '50m',
      progress: 0.80,
      type: ContentType.documentary,
    ),
  ];

  // --- TOP 10 ---
  final List<ContentModel> top10 = [
    ContentModel(
      id: 'top1',
      title: 'The Revelation Road',
      description: 'An apocalyptic journey through the book of Revelation.',
      imageUrl:
          'https://images.unsplash.com/photo-1509316785289-025f5b846b35?w=400&q=80',
      category: 'Drama',
      genres: ['Action', 'Drama', 'Prophecy'],
      maturityRating: 'PG-13',
      year: '2025',
      duration: '2h 5m',
      matchPercentage: 97,
      type: ContentType.movie,
      rank: 1,
    ),
    ContentModel(
      id: 'top2',
      title: 'Miracles from Heaven',
      description: 'Based on the incredible true story of the Beam family.',
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
      category: 'Drama',
      genres: ['Drama', 'True Story', 'Miracle'],
      maturityRating: 'PG',
      year: '2024',
      duration: '1h 49m',
      matchPercentage: 95,
      type: ContentType.movie,
      rank: 2,
    ),
    ContentModel(
      id: 'top3',
      title: 'Hillsong: Let Hope Rise',
      description: 'Behind the scenes of the world-famous worship movement.',
      imageUrl:
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400&q=80',
      category: 'Documentary',
      genres: ['Documentary', 'Music', 'Worship'],
      maturityRating: 'G',
      year: '2024',
      duration: '1h 32m',
      matchPercentage: 93,
      type: ContentType.documentary,
      rank: 3,
    ),
    ContentModel(
      id: 'top4',
      title: 'War Room',
      description: 'A seemingly perfect family discovers the power of prayer.',
      imageUrl:
          'https://images.unsplash.com/photo-1504052434569-70ad5836ab65?w=400&q=80',
      category: 'Drama',
      genres: ['Drama', 'Faith', 'Family'],
      maturityRating: 'PG',
      year: '2023',
      duration: '2h 0m',
      matchPercentage: 96,
      type: ContentType.movie,
      rank: 4,
    ),
    ContentModel(
      id: 'top5',
      title: 'Courageous',
      description: 'Four men, one calling: to be the fathers God intended.',
      imageUrl:
          'https://images.unsplash.com/photo-1475721027785-f74eccf877e2?w=400&q=80',
      category: 'Drama',
      genres: ['Drama', 'Action', 'Family'],
      maturityRating: 'PG-13',
      year: '2023',
      duration: '2h 9m',
      matchPercentage: 94,
      type: ContentType.movie,
      rank: 5,
    ),
    ContentModel(
      id: 'top6',
      title: 'The Bible',
      description: 'An epic miniseries covering Genesis to Revelation.',
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=400&q=80',
      category: 'Series',
      genres: ['Drama', 'Historical', 'Epic'],
      maturityRating: 'PG-13',
      year: '2024',
      seasons: 1,
      episodes: 10,
      matchPercentage: 97,
      type: ContentType.series,
      rank: 6,
    ),
    ContentModel(
      id: 'top7',
      title: 'Overcomer',
      description: 'A basketball coach discovers what identity really means.',
      imageUrl:
          'https://images.unsplash.com/photo-1546519638-68e109498ffc?w=400&q=80',
      category: 'Drama',
      genres: ['Drama', 'Sports', 'Faith'],
      maturityRating: 'PG',
      year: '2023',
      duration: '1h 59m',
      matchPercentage: 92,
      type: ContentType.movie,
      rank: 7,
    ),
    ContentModel(
      id: 'top8',
      title: 'I Can Only Imagine',
      description: 'The story behind the best-selling Christian song of all time.',
      imageUrl:
          'https://images.unsplash.com/photo-1507838153414-b4b713384a76?w=400&q=80',
      category: 'Drama',
      genres: ['Biography', 'Drama', 'Music'],
      maturityRating: 'PG',
      year: '2024',
      duration: '1h 50m',
      matchPercentage: 98,
      type: ContentType.movie,
      rank: 8,
    ),
    ContentModel(
      id: 'top9',
      title: 'Son of God',
      description: 'The life of Jesus Christ from birth to resurrection.',
      imageUrl:
          'https://images.unsplash.com/photo-1544427920-c49ccf111be1?w=400&q=80',
      category: 'Drama',
      genres: ['Drama', 'Historical', 'Faith'],
      maturityRating: 'PG-13',
      year: '2024',
      duration: '2h 18m',
      matchPercentage: 95,
      type: ContentType.movie,
      rank: 9,
    ),
    ContentModel(
      id: 'top10',
      title: 'Fireproof',
      description: 'A firefighter must save his marriage before it burns out.',
      imageUrl:
          'https://images.unsplash.com/photo-1469474968028-56623f02e42e?w=400&q=80',
      category: 'Drama',
      genres: ['Drama', 'Romance', 'Faith'],
      maturityRating: 'PG',
      year: '2023',
      duration: '2h 2m',
      matchPercentage: 91,
      type: ContentType.movie,
      rank: 10,
    ),
  ];

  // --- GOSPELVISION ORIGINALS ---
  final List<ContentModel> originals = [
    ContentModel(
      id: 'o1',
      title: 'The Last Apostle',
      description: 'The untold story of John on the island of Patmos.',
      imageUrl:
          'https://images.unsplash.com/photo-1518709268805-4e9042af9f23?w=400&q=80',
      category: 'Series',
      genres: ['Drama', 'Historical'],
      maturityRating: 'PG-13',
      year: '2025',
      seasons: 2,
      matchPercentage: 97,
      isOriginal: true,
      type: ContentType.series,
    ),
    ContentModel(
      id: 'o2',
      title: 'Redeemed',
      description: 'A prodigal son returns home to face his past and find grace.',
      imageUrl:
          'https://images.unsplash.com/photo-1490730141103-6cac27aaab94?w=400&q=80',
      category: 'Drama',
      genres: ['Drama', 'Faith'],
      maturityRating: 'PG',
      year: '2025',
      duration: '1h 55m',
      matchPercentage: 96,
      isOriginal: true,
      isBrandNew: true,
      type: ContentType.movie,
    ),
    ContentModel(
      id: 'o3',
      title: 'Praise & Glory',
      description: 'A worship leader battles doubt while leading thousands.',
      imageUrl:
          'https://images.unsplash.com/photo-1415201364774-f6f0bb35f28f?w=400&q=80',
      category: 'Drama',
      genres: ['Drama', 'Music', 'Worship'],
      maturityRating: 'PG',
      year: '2025',
      duration: '2h 10m',
      matchPercentage: 94,
      isOriginal: true,
      type: ContentType.movie,
    ),
    ContentModel(
      id: 'o4',
      title: 'Missionaries',
      description: 'Follow five families risking everything to spread the Gospel.',
      imageUrl:
          'https://images.unsplash.com/photo-1488521787991-ed7bbaae773c?w=400&q=80',
      category: 'Documentary',
      genres: ['Documentary', 'Missions', 'Adventure'],
      maturityRating: 'PG',
      year: '2025',
      seasons: 3,
      matchPercentage: 98,
      isOriginal: true,
      type: ContentType.documentary,
    ),
    ContentModel(
      id: 'o5',
      title: 'The Armor of God',
      description: 'An animated epic teaching kids about spiritual warfare.',
      imageUrl:
          'https://images.unsplash.com/photo-1519340333755-56e9c1d04579?w=400&q=80',
      category: 'Kids',
      genres: ['Animation', 'Kids', 'Adventure'],
      maturityRating: 'G',
      year: '2025',
      seasons: 1,
      matchPercentage: 99,
      isOriginal: true,
      isBrandNew: true,
      type: ContentType.kids,
    ),
  ];

  // --- SERMONS & PREACHING ---
  final List<ContentModel> sermons = [
    ContentModel(
      id: 's1',
      title: 'The Grace Message',
      description: 'Pastor John reveals the depth of God\'s unmerited favor.',
      imageUrl:
          'https://images.unsplash.com/photo-1438232992991-995b7058bbb3?w=400&q=80',
      category: 'Sermons',
      genres: ['Sermon', 'Grace', 'Teaching'],
      maturityRating: 'G',
      year: '2025',
      duration: '52m',
      type: ContentType.sermon,
    ),
    ContentModel(
      id: 's2',
      title: 'Mountain Top Moments',
      description: 'Finding God in the highs and lows of life.',
      imageUrl:
          'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?w=400&q=80',
      category: 'Sermons',
      genres: ['Sermon', 'Inspirational'],
      maturityRating: 'G',
      year: '2025',
      duration: '48m',
      type: ContentType.sermon,
    ),
    ContentModel(
      id: 's3',
      title: 'Pray Without Ceasing',
      description: 'A practical guide to a powerful prayer life.',
      imageUrl:
          'https://images.unsplash.com/photo-1529390079861-591de354faf5?w=400&q=80',
      category: 'Sermons',
      genres: ['Sermon', 'Prayer'],
      maturityRating: 'G',
      year: '2024',
      duration: '55m',
      type: ContentType.sermon,
    ),
    ContentModel(
      id: 's4',
      title: 'The Beatitudes Today',
      description: 'Ancient wisdom for modern challenges.',
      imageUrl:
          'https://images.unsplash.com/photo-1501785888041-af3ef285b470?w=400&q=80',
      category: 'Sermons',
      genres: ['Sermon', 'Bible Study'],
      maturityRating: 'G',
      year: '2024',
      duration: '1h 5m',
      type: ContentType.sermon,
    ),
  ];

  // --- WORSHIP & MUSIC ---
  final List<ContentModel> worship = [
    ContentModel(
      id: 'w1',
      title: 'Bethel Music Live',
      description: 'An intimate night of worship from Bethel Church.',
      imageUrl:
          'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?w=400&q=80',
      category: 'Worship',
      genres: ['Worship', 'Live'],
      maturityRating: 'G',
      year: '2025',
      duration: '2h 15m',
      type: ContentType.worship,
    ),
    ContentModel(
      id: 'w2',
      title: 'Hymns Reimagined',
      description: 'Classic hymns performed with a modern twist.',
      imageUrl:
          'https://images.unsplash.com/photo-1507838153414-b4b713384a76?w=400&q=80',
      category: 'Worship',
      genres: ['Worship', 'Music'],
      maturityRating: 'G',
      year: '2024',
      duration: '1h 45m',
      type: ContentType.worship,
    ),
    ContentModel(
      id: 'w3',
      title: 'Gospel Choir Celebration',
      description: 'The best gospel choirs united for one incredible night.',
      imageUrl:
          'https://images.unsplash.com/photo-1517457373958-b7bdd4587205?w=400&q=80',
      category: 'Worship',
      genres: ['Gospel', 'Choir', 'Live'],
      maturityRating: 'G',
      year: '2025',
      duration: '1h 55m',
      isBrandNew: true,
      type: ContentType.worship,
    ),
    ContentModel(
      id: 'w4',
      title: 'Acoustic Worship Sessions',
      description: 'Stripped-back worship songs for quiet reflection.',
      imageUrl:
          'https://images.unsplash.com/photo-1510915361894-db8b60106cb1?w=400&q=80',
      category: 'Worship',
      genres: ['Worship', 'Acoustic'],
      maturityRating: 'G',
      year: '2024',
      duration: '1h 20m',
      type: ContentType.worship,
    ),
  ];

  // --- BIBLE DOCUMENTARIES ---
  final List<ContentModel> documentaries = [
    ContentModel(
      id: 'd1',
      title: 'Patterns of Evidence',
      description: 'Archaeological proof of the biblical Exodus.',
      imageUrl:
          'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=400&q=80',
      category: 'Documentary',
      genres: ['Documentary', 'Archaeology', 'History'],
      maturityRating: 'PG',
      year: '2024',
      duration: '1h 55m',
      matchPercentage: 95,
      type: ContentType.documentary,
    ),
    ContentModel(
      id: 'd2',
      title: 'The Holy Land',
      description: 'A breathtaking journey through Israel and Palestine.',
      imageUrl:
          'https://images.unsplash.com/photo-1547483238-2cbf881a759f?w=400&q=80',
      category: 'Documentary',
      genres: ['Documentary', 'Travel', 'History'],
      maturityRating: 'G',
      year: '2024',
      duration: '2h 20m',
      matchPercentage: 93,
      type: ContentType.documentary,
    ),
    ContentModel(
      id: 'd3',
      title: 'Early Church Fathers',
      description: 'Who were the leaders that shaped Christianity?',
      imageUrl:
          'https://images.unsplash.com/photo-1544427920-c49ccf111be1?w=400&q=80',
      category: 'Documentary',
      genres: ['Documentary', 'History', 'Teaching'],
      maturityRating: 'PG',
      year: '2023',
      duration: '1h 40m',
      matchPercentage: 91,
      type: ContentType.documentary,
    ),
    ContentModel(
      id: 'd4',
      title: 'Creation Wonders',
      description: 'Exploring the marvels of God\'s creation worldwide.',
      imageUrl:
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400&q=80',
      category: 'Documentary',
      genres: ['Documentary', 'Nature', 'Science'],
      maturityRating: 'G',
      year: '2025',
      duration: '1h 30m',
      matchPercentage: 97,
      isBrandNew: true,
      type: ContentType.documentary,
    ),
  ];

  // --- KIDS & FAMILY ---
  final List<ContentModel> kidsContent = [
    ContentModel(
      id: 'k1',
      title: 'VeggieTales Classics',
      description: 'Beloved animated tales teaching biblical values.',
      imageUrl:
          'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=400&q=80',
      category: 'Kids',
      genres: ['Animation', 'Kids', 'Comedy'],
      maturityRating: 'G',
      year: '2024',
      seasons: 5,
      type: ContentType.kids,
    ),
    ContentModel(
      id: 'k2',
      title: 'Bible Heroes',
      description: 'Animated adventures of David, Moses, and more.',
      imageUrl:
          'https://images.unsplash.com/photo-1485546246426-74dc88dec4d9?w=400&q=80',
      category: 'Kids',
      genres: ['Animation', 'Adventure', 'Bible'],
      maturityRating: 'G',
      year: '2025',
      seasons: 3,
      isBrandNew: true,
      type: ContentType.kids,
    ),
    ContentModel(
      id: 'k3',
      title: 'Kids Worship Party',
      description: 'Sing-along worship for the whole family.',
      imageUrl:
          'https://images.unsplash.com/photo-1474511320723-9a56873571b7?w=400&q=80',
      category: 'Kids',
      genres: ['Kids', 'Music', 'Worship'],
      maturityRating: 'G',
      year: '2024',
      duration: '1h 10m',
      type: ContentType.kids,
    ),
    ContentModel(
      id: 'k4',
      title: 'Noah\'s Ark Adventure',
      description: 'Join Noah and the animals on the greatest voyage ever.',
      imageUrl:
          'https://images.unsplash.com/photo-1535930749574-1399327ce78f?w=400&q=80',
      category: 'Kids',
      genres: ['Animation', 'Adventure', 'Kids'],
      maturityRating: 'G',
      year: '2025',
      duration: '1h 25m',
      isOriginal: true,
      type: ContentType.kids,
    ),
  ];

  // --- TRENDING NOW ---
  final List<ContentModel> trending = [
    ContentModel(
      id: 'tr1',
      title: 'Grace & Truth',
      description: 'Understanding the biblical foundations of grace.',
      imageUrl:
          'https://images.unsplash.com/photo-1438283173091-5dbf5c5a3206?w=400&q=80',
      category: 'Trending',
      genres: ['Teaching', 'Bible Study'],
      maturityRating: 'G',
      year: '2025',
      duration: '48m',
      type: ContentType.sermon,
    ),
    ContentModel(
      id: 'tr2',
      title: 'Testimonies',
      description: 'Real stories of lives changed by faith.',
      imageUrl:
          'https://images.unsplash.com/photo-1473679408190-0693dd22fe6a?w=400&q=80',
      category: 'Trending',
      genres: ['Testimonies', 'Inspirational'],
      maturityRating: 'G',
      year: '2025',
      seasons: 2,
      type: ContentType.series,
    ),
    ContentModel(
      id: 'tr3',
      title: 'The Gospel Vision Experience',
      description: 'Join us live for an incredible journey of faith.',
      imageUrl:
          'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&q=80',
      category: 'Trending',
      genres: ['Live Event', 'Worship'],
      maturityRating: 'G',
      year: '2025',
      duration: '3h 0m',
      isOriginal: true,
      type: ContentType.liveEvent,
    ),
    ContentModel(
      id: 'tr4',
      title: 'David & Goliath',
      description: 'A modern retelling of the classic biblical battle.',
      imageUrl:
          'https://images.unsplash.com/photo-1534447677768-be436bb09401?w=400&q=80',
      category: 'Trending',
      genres: ['Drama', 'Action', 'Bible'],
      maturityRating: 'PG-13',
      year: '2025',
      duration: '1h 58m',
      isBrandNew: true,
      type: ContentType.movie,
    ),
    ContentModel(
      id: 'tr5',
      title: 'Unseen Realm',
      description: 'Exploring the supernatural world of the Bible.',
      imageUrl:
          'https://images.unsplash.com/photo-1454789548928-9efd52dc4031?w=400&q=80',
      category: 'Trending',
      genres: ['Documentary', 'Supernatural', 'Bible'],
      maturityRating: 'PG',
      year: '2024',
      duration: '1h 45m',
      type: ContentType.documentary,
    ),
  ];

  // --- NEW RELEASES ---
  final List<ContentModel> newReleases = [
    ContentModel(
      id: 'nr1',
      title: 'The Upper Room',
      description: 'A dramatization of the Last Supper and its aftermath.',
      imageUrl:
          'https://images.unsplash.com/photo-1500462918059-b1a0cb512f1d?w=400&q=80',
      category: 'New Releases',
      genres: ['Drama', 'Historical'],
      maturityRating: 'PG-13',
      year: '2025',
      duration: '2h 30m',
      isBrandNew: true,
      isOriginal: true,
      type: ContentType.movie,
    ),
    ContentModel(
      id: 'nr2',
      title: 'Beyond the Veil',
      description: 'Near-death experiences that defy explanation.',
      imageUrl:
          'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=400&q=80',
      category: 'New Releases',
      genres: ['Documentary', 'Supernatural'],
      maturityRating: 'PG',
      year: '2025',
      duration: '1h 38m',
      isBrandNew: true,
      type: ContentType.documentary,
    ),
    ContentModel(
      id: 'nr3',
      title: 'The Psalm Project',
      description: 'Artists bring the Psalms to life through music and art.',
      imageUrl:
          'https://images.unsplash.com/photo-1511379938547-c1f69419868d?w=400&q=80',
      category: 'New Releases',
      genres: ['Music', 'Art', 'Worship'],
      maturityRating: 'G',
      year: '2025',
      duration: '1h 15m',
      isBrandNew: true,
      type: ContentType.worship,
    ),
    ContentModel(
      id: 'nr4',
      title: 'Faithful',
      description: 'When faith is tested, will love prevail?',
      imageUrl:
          'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=400&q=80',
      category: 'New Releases',
      genres: ['Romance', 'Drama', 'Faith'],
      maturityRating: 'PG',
      year: '2025',
      duration: '1h 52m',
      isBrandNew: true,
      isOriginal: true,
      type: ContentType.movie,
    ),
  ];

  // --- BROWSE CATEGORIES ---
  final List<CategoryModel> categories = [
    CategoryModel(
      id: 'cat1',
      name: 'Christian Movies',
      imageUrl: 'https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?w=400&q=80',
    ),
    CategoryModel(
      id: 'cat2',
      name: 'Sermons & Preaching',
      imageUrl: 'https://images.unsplash.com/photo-1438232992991-995b7058bbb3?w=400&q=80',
    ),
    CategoryModel(
      id: 'cat3',
      name: 'Worship & Music',
      imageUrl: 'https://images.unsplash.com/photo-1510590337019-5ef8d3d32116?w=400&q=80',
    ),
    CategoryModel(
      id: 'cat4',
      name: 'Bible Documentaries',
      imageUrl: 'https://images.unsplash.com/photo-1558618666-fcd25c85f82e?w=400&q=80',
    ),
    CategoryModel(
      id: 'cat5',
      name: 'Kids & Family',
      imageUrl: 'https://images.unsplash.com/photo-1503454537195-1dcabb73ffb9?w=400&q=80',
    ),
    CategoryModel(
      id: 'cat6',
      name: 'Testimonies',
      imageUrl: 'https://images.unsplash.com/photo-1473679408190-0693dd22fe6a?w=400&q=80',
    ),
    CategoryModel(
      id: 'cat7',
      name: 'Live Events',
      imageUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=400&q=80',
    ),
    CategoryModel(
      id: 'cat8',
      name: 'Bible Studies',
      imageUrl: 'https://images.unsplash.com/photo-1504052434569-70ad5836ab65?w=400&q=80',
    ),
    CategoryModel(
      id: 'cat9',
      name: 'Christian Podcasts',
      imageUrl: 'https://images.unsplash.com/photo-1478737270239-2f02b77fc618?w=400&q=80',
    ),
    CategoryModel(
      id: 'cat10',
      name: 'Animated Classics',
      imageUrl: 'https://images.unsplash.com/photo-1535930749574-1399327ce78f?w=400&q=80',
    ),
  ];

  // --- PROFILES ---
  final List<ProfileModel> profiles = [
    ProfileModel(
      id: 'p1',
      name: 'Dad',
      color: const Color(0xFFF37A20),
      icon: Icons.person,
    ),
    ProfileModel(
      id: 'p2',
      name: 'Mom',
      color: const Color(0xFF46D369),
      icon: Icons.person,
    ),
    ProfileModel(
      id: 'p3',
      name: 'Sarah',
      color: const Color(0xFFE50914),
      icon: Icons.person,
    ),
    ProfileModel(
      id: 'p4',
      name: 'Kids',
      color: const Color(0xFF1CE783),
      icon: Icons.child_care,
      isKids: true,
    ),
  ];

  HomeController() {
    _loadData();
  }

  Future<void> _loadData() async {
    isLoading = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading = false;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await _loadData();
  }

  // Get all content for search
  List<ContentModel> get allContent => [
        ...continueWatching,
        ...top10,
        ...originals,
        ...sermons,
        ...worship,
        ...documentaries,
        ...kidsContent,
        ...trending,
        ...newReleases,
        ...featuredContent,
      ];

  ContentModel? getContentById(String id) {
    try {
      return allContent.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }
}
