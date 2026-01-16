import 'dart:async';
import 'dart:math';

import 'package:pickup_code_front/domain/apis/group_sync_api.dart';
import 'package:pickup_code_front/domain/entities/group.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';

class FakeGroupSyncApi implements GroupSyncApi {
  FakeGroupSyncApi();

  final StreamController<GroupSession?> _sessionController =
      StreamController<GroupSession?>.broadcast();
  final StreamController<List<GroupInfo>> _groupController =
      StreamController<List<GroupInfo>>.broadcast();
  final Map<String, StreamController<List<GroupShareRecord>>>
  _shareControllers = {};

  GroupSession? _session;
  final List<GroupInfo> _groups = [];
  final Map<String, List<GroupShareRecord>> _shares = {};

  @override
  Stream<GroupSession?> watchSession() async* {
    yield _session;
    yield* _sessionController.stream;
  }

  @override
  Future<GroupSession?> fetchSession() async {
    return _session;
  }

  @override
  Future<GroupSession> signIn({required String nickname}) async {
    final trimmed = nickname.trim();
    final session = GroupSession(
      userId: _randomId(prefix: 'user'),
      nickname: trimmed.isEmpty ? '匿名用户' : trimmed,
      signedInAt: DateTime.now(),
    );
    _session = session;
    _sessionController.add(session);
    return session;
  }

  @override
  Future<void> signOut() async {
    _session = null;
    _sessionController.add(null);
  }

  @override
  Stream<List<GroupInfo>> watchGroups() async* {
    yield List<GroupInfo>.from(_groups);
    yield* _groupController.stream;
  }

  @override
  Future<List<GroupInfo>> fetchGroups() async {
    return List<GroupInfo>.from(_groups);
  }

  @override
  Future<GroupInfo> createGroup(String name) async {
    final trimmed = name.trim();
    final group = GroupInfo(
      id: _randomId(prefix: 'group'),
      name: trimmed.isEmpty ? '我的小组' : trimmed,
      inviteCode: _makeInviteCode(),
      memberCount: 1,
      createdAt: DateTime.now(),
    );
    _groups.insert(0, group);
    _groupController.add(List<GroupInfo>.from(_groups));
    return group;
  }

  @override
  Future<GroupInfo?> joinGroup(String inviteCode) async {
    final trimmed = inviteCode.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    final index = _groups.indexWhere(
      (group) => group.inviteCode.toLowerCase() == trimmed.toLowerCase(),
    );
    if (index < 0) {
      return null;
    }
    final updated = _groups[index].copyWith(
      memberCount: _groups[index].memberCount + 1,
    );
    _groups[index] = updated;
    _groupController.add(List<GroupInfo>.from(_groups));
    return updated;
  }

  @override
  Stream<List<GroupShareRecord>> watchShares(String groupId) async* {
    yield List<GroupShareRecord>.from(_shares[groupId] ?? []);
    yield* _shareController(groupId).stream;
  }

  @override
  Future<GroupShareRecord> sharePickup(String groupId, Pickup pickup) async {
    final session = _session;
    final record = GroupShareRecord(
      id: _randomId(prefix: 'share'),
      groupId: groupId,
      pickup: pickup,
      sharedAt: DateTime.now(),
      sharedBy: session?.nickname ?? '匿名用户',
    );
    final list = _shares.putIfAbsent(groupId, () => []);
    list.insert(0, record);
    _shareController(groupId).add(List<GroupShareRecord>.from(list));
    return record;
  }

  StreamController<List<GroupShareRecord>> _shareController(String groupId) {
    return _shareControllers.putIfAbsent(
      groupId,
      () => StreamController<List<GroupShareRecord>>.broadcast(),
    );
  }

  String _randomId({required String prefix}) {
    final millis = DateTime.now().millisecondsSinceEpoch;
    final rand = Random().nextInt(8999) + 1000;
    return '$prefix-$millis-$rand';
  }

  String _makeInviteCode() {
    final rand = Random();
    final letters = List.generate(
      4,
      (_) => String.fromCharCode(65 + rand.nextInt(26)),
    ).join();
    final digits = rand.nextInt(9000) + 1000;
    return '$letters-$digits';
  }
}
