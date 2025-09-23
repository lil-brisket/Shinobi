import 'package:freezed_annotation/freezed_annotation.dart';

part 'clan_board_post.freezed.dart';
part 'clan_board_post.g.dart';

@freezed
class ClanBoardPost with _$ClanBoardPost {
  const factory ClanBoardPost({
    required String id,
    required String clanId,
    required String authorId,
    required String authorName,
    required String content,
    @Default(false) bool pinned,
    @Default(0) int likes,
    required DateTime createdAt,
  }) = _ClanBoardPost;

  factory ClanBoardPost.fromJson(Map<String, dynamic> json) => _$ClanBoardPostFromJson(json);
}
