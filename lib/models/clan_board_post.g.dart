// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'clan_board_post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClanBoardPostImpl _$$ClanBoardPostImplFromJson(Map<String, dynamic> json) =>
    _$ClanBoardPostImpl(
      id: json['id'] as String,
      clanId: json['clanId'] as String,
      authorId: json['authorId'] as String,
      authorName: json['authorName'] as String,
      content: json['content'] as String,
      pinned: json['pinned'] as bool? ?? false,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ClanBoardPostImplToJson(_$ClanBoardPostImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clanId': instance.clanId,
      'authorId': instance.authorId,
      'authorName': instance.authorName,
      'content': instance.content,
      'pinned': instance.pinned,
      'likes': instance.likes,
      'createdAt': instance.createdAt.toIso8601String(),
    };
