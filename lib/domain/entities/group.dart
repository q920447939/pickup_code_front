import 'package:pickup_code_front/domain/entities/pickup.dart';

class GroupSession {
  const GroupSession({
    required this.userId,
    required this.nickname,
    required this.signedInAt,
  });

  final String userId;
  final String nickname;
  final DateTime signedInAt;
}

class GroupInfo {
  const GroupInfo({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.memberCount,
    required this.createdAt,
  });

  final String id;
  final String name;
  final String inviteCode;
  final int memberCount;
  final DateTime createdAt;

  GroupInfo copyWith({
    String? id,
    String? name,
    String? inviteCode,
    int? memberCount,
    DateTime? createdAt,
  }) {
    return GroupInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      inviteCode: inviteCode ?? this.inviteCode,
      memberCount: memberCount ?? this.memberCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class GroupShareRecord {
  const GroupShareRecord({
    required this.id,
    required this.groupId,
    required this.pickup,
    required this.sharedAt,
    required this.sharedBy,
  });

  final String id;
  final String groupId;
  final Pickup pickup;
  final DateTime sharedAt;
  final String sharedBy;
}
