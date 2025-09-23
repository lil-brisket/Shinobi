// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'clan_board_post.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClanBoardPost _$ClanBoardPostFromJson(Map<String, dynamic> json) {
  return _ClanBoardPost.fromJson(json);
}

/// @nodoc
mixin _$ClanBoardPost {
  String get id => throw _privateConstructorUsedError;
  String get clanId => throw _privateConstructorUsedError;
  String get authorId => throw _privateConstructorUsedError;
  String get authorName => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  bool get pinned => throw _privateConstructorUsedError;
  int get likes => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this ClanBoardPost to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ClanBoardPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ClanBoardPostCopyWith<ClanBoardPost> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClanBoardPostCopyWith<$Res> {
  factory $ClanBoardPostCopyWith(
          ClanBoardPost value, $Res Function(ClanBoardPost) then) =
      _$ClanBoardPostCopyWithImpl<$Res, ClanBoardPost>;
  @useResult
  $Res call(
      {String id,
      String clanId,
      String authorId,
      String authorName,
      String content,
      bool pinned,
      int likes,
      DateTime createdAt});
}

/// @nodoc
class _$ClanBoardPostCopyWithImpl<$Res, $Val extends ClanBoardPost>
    implements $ClanBoardPostCopyWith<$Res> {
  _$ClanBoardPostCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ClanBoardPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clanId = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? content = null,
    Object? pinned = null,
    Object? likes = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clanId: null == clanId
          ? _value.clanId
          : clanId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      pinned: null == pinned
          ? _value.pinned
          : pinned // ignore: cast_nullable_to_non_nullable
              as bool,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClanBoardPostImplCopyWith<$Res>
    implements $ClanBoardPostCopyWith<$Res> {
  factory _$$ClanBoardPostImplCopyWith(
          _$ClanBoardPostImpl value, $Res Function(_$ClanBoardPostImpl) then) =
      __$$ClanBoardPostImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String clanId,
      String authorId,
      String authorName,
      String content,
      bool pinned,
      int likes,
      DateTime createdAt});
}

/// @nodoc
class __$$ClanBoardPostImplCopyWithImpl<$Res>
    extends _$ClanBoardPostCopyWithImpl<$Res, _$ClanBoardPostImpl>
    implements _$$ClanBoardPostImplCopyWith<$Res> {
  __$$ClanBoardPostImplCopyWithImpl(
      _$ClanBoardPostImpl _value, $Res Function(_$ClanBoardPostImpl) _then)
      : super(_value, _then);

  /// Create a copy of ClanBoardPost
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? clanId = null,
    Object? authorId = null,
    Object? authorName = null,
    Object? content = null,
    Object? pinned = null,
    Object? likes = null,
    Object? createdAt = null,
  }) {
    return _then(_$ClanBoardPostImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      clanId: null == clanId
          ? _value.clanId
          : clanId // ignore: cast_nullable_to_non_nullable
              as String,
      authorId: null == authorId
          ? _value.authorId
          : authorId // ignore: cast_nullable_to_non_nullable
              as String,
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      pinned: null == pinned
          ? _value.pinned
          : pinned // ignore: cast_nullable_to_non_nullable
              as bool,
      likes: null == likes
          ? _value.likes
          : likes // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClanBoardPostImpl implements _ClanBoardPost {
  const _$ClanBoardPostImpl(
      {required this.id,
      required this.clanId,
      required this.authorId,
      required this.authorName,
      required this.content,
      this.pinned = false,
      this.likes = 0,
      required this.createdAt});

  factory _$ClanBoardPostImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClanBoardPostImplFromJson(json);

  @override
  final String id;
  @override
  final String clanId;
  @override
  final String authorId;
  @override
  final String authorName;
  @override
  final String content;
  @override
  @JsonKey()
  final bool pinned;
  @override
  @JsonKey()
  final int likes;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'ClanBoardPost(id: $id, clanId: $clanId, authorId: $authorId, authorName: $authorName, content: $content, pinned: $pinned, likes: $likes, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClanBoardPostImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.clanId, clanId) || other.clanId == clanId) &&
            (identical(other.authorId, authorId) ||
                other.authorId == authorId) &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.pinned, pinned) || other.pinned == pinned) &&
            (identical(other.likes, likes) || other.likes == likes) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, clanId, authorId, authorName,
      content, pinned, likes, createdAt);

  /// Create a copy of ClanBoardPost
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ClanBoardPostImplCopyWith<_$ClanBoardPostImpl> get copyWith =>
      __$$ClanBoardPostImplCopyWithImpl<_$ClanBoardPostImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClanBoardPostImplToJson(
      this,
    );
  }
}

abstract class _ClanBoardPost implements ClanBoardPost {
  const factory _ClanBoardPost(
      {required final String id,
      required final String clanId,
      required final String authorId,
      required final String authorName,
      required final String content,
      final bool pinned,
      final int likes,
      required final DateTime createdAt}) = _$ClanBoardPostImpl;

  factory _ClanBoardPost.fromJson(Map<String, dynamic> json) =
      _$ClanBoardPostImpl.fromJson;

  @override
  String get id;
  @override
  String get clanId;
  @override
  String get authorId;
  @override
  String get authorName;
  @override
  String get content;
  @override
  bool get pinned;
  @override
  int get likes;
  @override
  DateTime get createdAt;

  /// Create a copy of ClanBoardPost
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ClanBoardPostImplCopyWith<_$ClanBoardPostImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
