import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/domain/entities/pickup.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';
import 'package:pickup_code_front/modules/pickup/detail/pickup_detail_controller.dart';

class PickupDetailPage extends GetView<PickupDetailController> {
  const PickupDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final modeController = Get.find<ModeController>();
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.isEditing.value ? '编辑取件' : '新建取件')),
        actions: [
          Obx(() {
            if (!controller.isEditing.value) {
              return const SizedBox.shrink();
            }
            return IconButton(
              onPressed: controller.deletePickup,
              icon: const Icon(Icons.delete_outline),
              tooltip: '删除',
            );
          }),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          Row(
            children: [
              Expanded(
                child: _InputTile(
                  title: '取件码',
                  hint: '必填',
                  controller: controller.codeController,
                  suffixIcon: IconButton(
                    onPressed: controller.copyCode,
                    icon: const Icon(Icons.copy_rounded),
                    tooltip: '复制取件码',
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              OutlinedButton.icon(
                onPressed: controller.pasteImport,
                icon: const Icon(Icons.content_paste),
                label: const Text('粘贴导入'),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          _InputTile(
            title: '驿站/站点',
            hint: '可选',
            controller: controller.stationController,
          ),
          SizedBox(height: 12.h),
          Text('到期时间', style: theme.textTheme.titleSmall),
          SizedBox(height: 8.h),
          Obx(() {
            return InkWell(
              borderRadius: BorderRadius.circular(18.r),
              onTap: () => controller.selectExpireAt(context),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(18.r),
                  border: Border.all(color: theme.colorScheme.outline),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        controller.expireAtLabel,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    IconButton(
                      onPressed: controller.clearExpireAt,
                      icon: const Icon(Icons.close),
                      tooltip: '清除到期时间',
                    ),
                  ],
                ),
              ),
            );
          }),
          SizedBox(height: 12.h),
          _InputTile(
            title: '备注',
            hint: '可选',
            controller: controller.noteController,
            maxLines: 2,
          ),
          SizedBox(height: 12.h),
          Text('状态', style: theme.textTheme.titleSmall),
          SizedBox(height: 8.h),
          Obx(() {
            return InputDecorator(
              decoration: const InputDecoration(),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<PickupStatus>(
                  value: controller.status.value,
                  isExpanded: true,
                  items: PickupStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(_statusLabel(status)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.status.value = value;
                    }
                  },
                ),
              ),
            );
          }),
          SizedBox(height: 12.h),
          Text('来源', style: theme.textTheme.titleSmall),
          SizedBox(height: 6.h),
          Obx(() {
            return Text(
              _sourceLabel(controller.source.value),
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
            );
          }),
          SizedBox(height: 16.h),
          Obx(() {
            final importedText = controller.importedText.value.trim();
            if (importedText.isEmpty) {
              return const SizedBox.shrink();
            }
            final result = controller.parseResult.value;
            final statusColor = result == null
                ? const Color(0xFFD32F2F)
                : const Color(0xFF2E7D32);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('解析预览', style: theme.textTheme.titleSmall),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: theme.colorScheme.outline),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: 20),
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: theme.colorScheme.outlineVariant,
                                width: 1,
                              ),
                            ),
                            child: Text(
                              result == null ? '识别失败' : '识别成功',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: statusColor,
                              ),
                            ),
                          ),
                          if (result != null) ...[
                            SizedBox(width: 8.w),
                            Text(
                              result.ruleName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              '置信度 ${(result.confidence * 100).round()}%',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (result != null) ...[
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 6.h,
                          children: [
                            _PreviewChip(
                              label: '取件码',
                              value: result.code ?? '-',
                            ),
                            _PreviewChip(
                              label: '驿站',
                              value: result.stationName ?? '未识别',
                            ),
                            _PreviewChip(
                              label: '到期',
                              value: result.expireAt == null
                                  ? '未识别'
                                  : controller.expireAtLabel,
                            ),
                          ],
                        ),
                      ] else ...[
                        SizedBox(height: 8.h),
                        Text(
                          '未识别到取件信息，可手动修正后保存模板。',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.black54,
                          ),
                        ),
                      ],
                      SizedBox(height: 10.h),
                      Text('短信内容', style: theme.textTheme.labelSmall),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.all(10.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: theme.colorScheme.outline),
                        ),
                        child: SelectableText(
                          importedText,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '保存为模板',
                                  style: theme.textTheme.titleSmall,
                                ),
                                Text(
                                  '用于提升后续识别命中率',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(() {
                            return Switch(
                              value: controller.saveAsTemplate.value,
                              onChanged: (value) =>
                                  controller.saveAsTemplate.value = value,
                            );
                          }),
                        ],
                      ),
                      Obx(() {
                        if (!controller.saveAsTemplate.value) {
                          return const SizedBox.shrink();
                        }
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: TextField(
                              controller: controller.templateNameController,
                              decoration: const InputDecoration(
                                hintText: '模板名称（可选）',
                              ),
                            ),
                          );
                        }),
                    ],
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => controller.quickMark(PickupStatus.picked),
                  child: const Text('标记已取'),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => controller.quickMark(PickupStatus.abnormal),
                  child: const Text('标记异常'),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Obx(() {
            if (modeController.current.value != AppMode.ai) {
              return const SizedBox.shrink();
            }
            return OutlinedButton.icon(
              onPressed: controller.shareToGroup,
              icon: const Icon(Icons.share_outlined),
              label: const Text('分享至小组'),
            );
          }),
          SizedBox(height: 16.h),
          FilledButton(onPressed: controller.save, child: const Text('保存')),
        ],
      ),
    );
  }
}

class _InputTile extends StatelessWidget {
  const _InputTile({
    required this.title,
    required this.hint,
    required this.controller,
    this.maxLines = 1,
    this.suffixIcon,
  });

  final String title;
  final String hint;
  final TextEditingController controller;
  final int maxLines;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Text(
        '$label：$value',
        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface),
      ),
    );
  }
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

String _sourceLabel(PickupSource source) {
  switch (source) {
    case PickupSource.smsAuto:
      return '短信自动';
    case PickupSource.pasteImport:
      return '粘贴导入';
    case PickupSource.manual:
      return '手动补录';
  }
}
