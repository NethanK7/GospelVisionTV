import 'package:isar/isar.dart';

part 'user_profile.g.dart';

@collection
class UserProfile {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String email;

  late String displayName;

  List<String> favoriteMovieIds = [];
}
