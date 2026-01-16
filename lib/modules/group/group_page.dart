import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/domain/entities/group.dart';
import 'package:pickup_code_front/modules/group/group_controller.dart';

class GroupPage extends GetView<GroupController> {
  const GroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('代取协作')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Obx(() {
            if (controller.isAiMode) {
              return const SizedBox.shrink();
            }
            return _InfoCard(
              title: '当前为离线模式',
              description: '协作功能需在 AI 模式下演示使用。',
              actionLabel: '切换到 AI 模式',
              onAction: controller.switchToAiMode,
            );
          }),
          Text('登录状态', style: theme.textTheme.titleSmall),
          SizedBox(height: 8.h),
          Obx(() {
            final session = controller.session.value;
            if (session == null) {
              return _LoginCard(controller: controller);
            }
            return _SessionCard(session: session, controller: controller);
          }),
          SizedBox(height: 16.h),
          Text('小组管理', style: theme.textTheme.titleSmall),
          SizedBox(height: 8.h),
          _GroupActions(controller: controller),
          SizedBox(height: 12.h),
          Obx(() {
            if (controller.groups.isEmpty) {
              return _InfoCard(title: '暂无小组', description: '创建或加入小组后可共享代取记录。');
            }
            return Column(
              children: controller.groups
                  .map(
                    (group) => _GroupCard(
                      group: group,
                      selected: controller.selectedGroup.value?.id == group.id,
                      onTap: () => controller.selectGroup(group),
                      onCopy: () => controller.copyInviteCode(group.inviteCode),
                    ),
                  )
                  .toList(),
            );
          }),
          SizedBox(height: 16.h),
          Text('共享记录', style: theme.textTheme.titleSmall),
          SizedBox(height: 8.h),
          Obx(() {
            final selected = controller.selectedGroup.value;
            if (selected == null) {
              return _InfoCard(title: '未选择小组', description: '请选择一个小组查看共享记录。');
            }
            if (controller.shares.isEmpty) {
              return _InfoCard(title: '暂无共享', description: '可在取件详情页点击“分享至小组”。');
            }
            return Column(
              children: controller.shares
                  .map((share) => _ShareCard(record: share))
                  .toList(),
            );
          }),
          SizedBox(height: 12.h),
          Text(
            '说明：协作功能为本地模拟流程，不会与云端同步。',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.controller});

  final GroupController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('尚未登录', style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 8.h),
            TextField(
              controller: controller.nicknameController,
              decoration: InputDecoration(
                hintText: '昵称（可选）',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 10.h),
            FilledButton.icon(
              onPressed: controller.signIn,
              icon: const Icon(Icons.login),
              label: const Text('模拟登录'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session, required this.controller});

  final GroupSession session;
  final GroupController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              child: Text(_initialOf(session.nickname)),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.nickname,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  Text(
                    '已登录 · ${_formatDate(session.signedInAt)}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                  ),
                ],
              ),
            ),
            TextButton(onPressed: controller.signOut, child: const Text('退出')),
          ],
        ),
      ),
    );
  }
}

class _GroupActions extends StatelessWidget {
  const _GroupActions({required this.controller});

  final GroupController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('创建小组', style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 8.h),
                TextField(
                  controller: controller.groupNameController,
                  decoration: InputDecoration(
                    hintText: '小组名称（例如：家庭代取）',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                FilledButton.icon(
                  onPressed: controller.createGroup,
                  icon: const Icon(Icons.group_add_outlined),
                  label: const Text('创建小组'),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 12.h),
        Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('加入小组', style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 8.h),
                TextField(
                  controller: controller.inviteCodeController,
                  decoration: InputDecoration(
                    hintText: '邀请码（例如：ABCD-1234）',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                FilledButton.icon(
                  onPressed: controller.joinGroup,
                  icon: const Icon(Icons.group_outlined),
                  label: const Text('加入小组'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({
    required this.group,
    required this.selected,
    required this.onTap,
    required this.onCopy,
  });

  final GroupInfo group;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onCopy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(group.name, style: theme.textTheme.titleSmall),
                  ),
                  if (selected)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(alpha: 25),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Text(
                        '当前',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 8.h),
              Text(
                '成员 ${group.memberCount} · 创建于 ${_formatDate(group.createdAt)}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '邀请码 ${group.inviteCode}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy_rounded),
                    tooltip: '复制邀请码',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShareCard extends StatelessWidget {
  const _ShareCard({required this.record});

  final GroupShareRecord record;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pickup = record.pickup;
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('取件码 ${pickup.code}', style: theme.textTheme.titleSmall),
            SizedBox(height: 6.h),
            Text(
              pickup.stationName ?? '未知驿站',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
            SizedBox(height: 6.h),
            Text(
              '分享人 ${record.sharedBy} · ${_formatDate(record.sharedAt)}',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.title,
    required this.description,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String description;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleSmall),
            SizedBox(height: 6.h),
            Text(
              description,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: 10.h),
              OutlinedButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime value) {
  final month = value.month.toString().padLeft(2, '0');
  final day = value.day.toString().padLeft(2, '0');
  final hour = value.hour.toString().padLeft(2, '0');
  final minute = value.minute.toString().padLeft(2, '0');
  return '$month-$day $hour:$minute';
}

String _initialOf(String value) {
  final trimmed = value.trim();
  if (trimmed.isEmpty) {
    return '?';
  }
  return trimmed.substring(0, 1);
}
