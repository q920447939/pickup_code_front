import 'package:pickup_code_front/domain/entities/group.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';

abstract class GroupSyncApi {
  Stream<GroupSession?> watchSession();
  Future<GroupSession?> fetchSession();
  Future<GroupSession> signIn({required String nickname});
  Future<void> signOut();

  Stream<List<GroupInfo>> watchGroups();
  Future<List<GroupInfo>> fetchGroups();
  Future<GroupInfo> createGroup(String name);
  Future<GroupInfo?> joinGroup(String inviteCode);

  Stream<List<GroupShareRecord>> watchShares(String groupId);
  Future<GroupShareRecord> sharePickup(String groupId, Pickup pickup);
}
