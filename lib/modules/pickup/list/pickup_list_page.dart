import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/app/routes/app_routes.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';
import 'package:pickup_code_front/modules/pickup/list/pickup_list_controller.dart';

class PickupListPage extends GetView<PickupListController> {
  const PickupListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modeController = Get.find<ModeController>();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          if (controller.selectionMode.value) {
            return Text('已选 ${controller.selectedCount} 项');
          }
          return const Text('待取件');
        }),
        actions: [
          Obx(() {
            if (controller.selectionMode.value) {
              return Row(
                children: [
                  IconButton(
                    onPressed: controller.selectAllFiltered,
                    icon: const Icon(Icons.select_all),
                    tooltip: '全选',
                  ),
                  IconButton(
                    onPressed: () => _confirmBatchDelete(context, controller),
                    icon: const Icon(Icons.delete_outline),
                    tooltip: '删除',
                  ),
                  IconButton(
                    onPressed: controller.exitSelectionMode,
                    icon: const Icon(Icons.close),
                    tooltip: '取消',
                  ),
                  SizedBox(width: 8.w),
                ],
              );
            }
            return Row(
              children: [
                IconButton(
                  onPressed: controller.enterSelectionMode,
                  icon: const Icon(Icons.delete_sweep_outlined),
                  tooltip: '批量删除',
                ),
                IconButton(
                  onPressed: () => Get.toNamed(Routes.templates),
                  icon: const Icon(Icons.rule_folder_outlined),
                  tooltip: '模板管理',
                ),
                IconButton(
                  onPressed: () => Get.toNamed(Routes.settings),
                  icon: const Icon(Icons.settings_outlined),
                  tooltip: '设置',
                ),
                SizedBox(width: 8.w),
              ],
            );
          }),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
            child: Row(
              children: [
                Obx(() {
                  return _ModeChip(label: modeController.current.value.label);
                }),
                SizedBox(width: 8.w),
                Obx(() {
                  return Text(
                    '待取 ${controller.pendingCount} 件',
                    style: Theme.of(context).textTheme.titleSmall,
                  );
                }),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 4.h),
            child: Obx(() {
              return TextField(
                onChanged: controller.updateKeyword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: controller.keyword.value.isEmpty
                      ? null
                      : IconButton(
                          onPressed: controller.clearKeyword,
                          icon: const Icon(Icons.close),
                        ),
                  hintText: '搜索取件码/驿站/备注',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 4.h),
          Obx(() {
            final filters = PickupFilter.values;
            return SizedBox(
              height: 36.h,
              child: ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  final filter = filters[index];
                  final selected = controller.filter.value == filter;
                  final count = controller.countForFilter(filter);
                  return ChoiceChip(
                    label: Text('${_filterLabel(filter)} $count'),
                    selected: selected,
                    onSelected: (_) => controller.changeFilter(filter),
                  );
                },
                separatorBuilder: (context, index) => SizedBox(width: 8.w),
                itemCount: filters.length,
              ),
            );
          }),
          SizedBox(height: 6.h),
          Expanded(
            child: Obx(() {
              final selectionMode = controller.selectionMode.value;
              final selectedCodes = controller.selectedCodes.toSet();
              if (controller.pickups.isEmpty) {
                return Center(
                  child: Text(
                    '暂无取件记录',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
                itemCount: controller.pickups.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final pickup = controller.pickups[index];
                  final selected = selectedCodes.contains(pickup.code);
                  return _PickupCard(
                    pickup: pickup,
                    status: controller.effectiveStatus(pickup, DateTime.now()),
                    selectionMode: selectionMode,
                    selected: selected,
                    onTap: () {
                      if (selectionMode) {
                        controller.toggleSelected(pickup);
                      } else {
                        Get.toNamed(Routes.pickupDetail, arguments: pickup);
                      }
                    },
                    onSelect: () => controller.toggleSelected(pickup),
                    onCopy: () => controller.copyCode(pickup),
                    onPicked: () => controller.markPicked(pickup),
                    onAbnormal: () => controller.markAbnormal(pickup),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(Routes.pickupDetail),
        icon: const Icon(Icons.add),
        label: const Text('新建'),
      ),
    );
  }
}

String _filterLabel(PickupFilter filter) {
  switch (filter) {
    case PickupFilter.all:
      return '全部';
    case PickupFilter.pending:
      return '待取';
    case PickupFilter.picked:
      return '已取';
    case PickupFilter.expired:
      return '逾期';
    case PickupFilter.abnormal:
      return '异常';
  }
}

class _ModeChip extends StatelessWidget {
  const _ModeChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 31),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }
}

class _PickupCard extends StatelessWidget {
  const _PickupCard({
    required this.pickup,
    required this.status,
    required this.selectionMode,
    required this.selected,
    required this.onTap,
    required this.onSelect,
    required this.onCopy,
    required this.onPicked,
    required this.onAbnormal,
  });

  final Pickup pickup;
  final PickupStatus status;
  final bool selectionMode;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onSelect;
  final VoidCallback onCopy;
  final VoidCallback onPicked;
  final VoidCallback onAbnormal;

  @override
  Widget build(BuildContext context) {
    final statusText = _statusLabel(status);
    final statusColor = _statusColor(context, status);
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pickup.stationName ?? '未知驿站',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 31),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      statusText,
                      style: Theme.of(
                        context,
                      ).textTheme.labelSmall?.copyWith(color: statusColor),
                    ),
                  ),
                  if (selectionMode) ...[
                    SizedBox(width: 6.w),
                    Checkbox(value: selected, onChanged: (_) => onSelect()),
                  ],
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '取件码 ${pickup.code}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (!selectionMode)
                    IconButton(
                      onPressed: onCopy,
                      icon: const Icon(Icons.copy_rounded),
                      tooltip: '复制取件码',
                    ),
                ],
              ),
              Text(
                pickup.expireAt == null
                    ? '未设置到期时间'
                    : '到期 ${_formatDate(pickup.expireAt!)}',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.black54),
              ),
              if ((pickup.note ?? '').trim().isNotEmpty) ...[
                SizedBox(height: 6.h),
                Text(
                  pickup.note!,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
              ],
              if (!selectionMode) ...[
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 8.w,
                  children: [
                    TextButton(onPressed: onPicked, child: const Text('标记已取')),
                    TextButton(
                      onPressed: onAbnormal,
                      child: const Text('标记异常'),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$month-$day $hour:$minute';
  }

  String _statusLabel(PickupStatus status) {
    switch (status) {
      case PickupStatus.pending:
        return '待取';
      case PickupStatus.picked:
        return '已取';
      case PickupStatus.expired:
        return '已逾期';
      case PickupStatus.abnormal:
        return '异常';
    }
  }

  Color _statusColor(BuildContext context, PickupStatus status) {
    switch (status) {
      case PickupStatus.pending:
        return Theme.of(context).colorScheme.primary;
      case PickupStatus.picked:
        return const Color(0xFF2E7D32);
      case PickupStatus.expired:
        return const Color(0xFFD32F2F);
      case PickupStatus.abnormal:
        return const Color(0xFF6A1B9A);
    }
  }
}

Future<void> _confirmBatchDelete(
  BuildContext context,
  PickupListController controller,
) async {
  if (controller.selectedCount == 0) {
    Get.snackbar('未选择记录', '请选择要删除的取件记录');
    return;
  }
  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('批量删除'),
            content: Text('确认删除已选 ${controller.selectedCount} 条记录吗？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('取消'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('删除'),
              ),
            ],
          );
        },
      ) ??
      false;
  if (confirmed) {
    await controller.deleteSelected();
  }
}
