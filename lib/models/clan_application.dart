import 'package:freezed_annotation/freezed_annotation.dart';

part 'clan_application.freezed.dart';
part 'clan_application.g.dart';

enum ApplicationStatus {
  @JsonValue('PENDING')
  pending,
  @JsonValue('APPROVED')
  approved,
  @JsonValue('REJECTED')
  rejected,
  @JsonValue('WITHDRAWN')
  withdrawn,
}

@freezed
class ClanApplication with _$ClanApplication {
  const factory ClanApplication({
    required String id,
    required String clanId,
    required String userId,
    required ApplicationStatus status,
    String? message,
    required DateTime createdAt,
    DateTime? updatedAt,
  }) = _ClanApplication;

  factory ClanApplication.fromJson(Map<String, dynamic> json) => _$ClanApplicationFromJson(json);
}

@freezed
class ClanApplicationWithDetails with _$ClanApplicationWithDetails {
  const factory ClanApplicationWithDetails({
    required ClanApplication application,
    required String userName,
    required String clanName,
  }) = _ClanApplicationWithDetails;

  factory ClanApplicationWithDetails.fromJson(Map<String, dynamic> json) => _$ClanApplicationWithDetailsFromJson(json);
}

extension ApplicationStatusExtension on ApplicationStatus {
  String get displayName {
    switch (this) {
      case ApplicationStatus.pending:
        return 'Pending';
      case ApplicationStatus.approved:
        return 'Approved';
      case ApplicationStatus.rejected:
        return 'Rejected';
      case ApplicationStatus.withdrawn:
        return 'Withdrawn';
    }
  }
}
