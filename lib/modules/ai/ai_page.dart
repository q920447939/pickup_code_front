import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/modules/ai/ai_controller.dart';

class AiPage extends GetView<AiController> {
  const AiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('AI 模式')),
      body: ListView(
        padding: EdgeInsets.all(16.w),
        children: [
          _InfoCard(title: 'AI 识别演示', description: '当前为本地模拟版本，不会发起任何联网请求。'),
          Obx(() {
            if (controller.isAiMode) {
              return const SizedBox.shrink();
            }
            return _InfoCard(
              title: '当前为离线模式',
              description: '切换到 AI 模式后可使用模拟识别与协作占位。',
              actionLabel: '切换到 AI 模式',
              onAction: controller.switchToAiMode,
            );
          }),
          SizedBox(height: 12.h),
          Text('短信内容', style: theme.textTheme.titleSmall),
          SizedBox(height: 8.h),
          TextField(
            controller: controller.textController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: '粘贴短信正文，用于 AI 识别演示',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              OutlinedButton.icon(
                onPressed: controller.pasteFromClipboard,
                icon: const Icon(Icons.content_paste),
                label: const Text('粘贴'),
              ),
              OutlinedButton.icon(
                onPressed: controller.fillSample,
                icon: const Icon(Icons.auto_awesome_outlined),
                label: const Text('示例文本'),
              ),
              Obx(() {
                return FilledButton.icon(
                  onPressed: controller.isLoading.value
                      ? null
                      : controller.extract,
                  icon: const Icon(Icons.smart_toy_outlined),
                  label: Text(controller.isLoading.value ? '识别中...' : 'AI 识别'),
                );
              }),
            ],
          ),
          SizedBox(height: 14.h),
          Obx(() {
            if (!controller.hasTried.value) {
              return const SizedBox.shrink();
            }
            final result = controller.result.value;
            if (result == null || !result.isValid) {
              return _InfoCard(
                title: '识别失败',
                description: '未识别到取件信息，可尝试修改文本或使用示例。',
              );
            }
            final statusColor = const Color(0xFF2E7D32);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('解析预览', style: theme.textTheme.titleSmall),
                SizedBox(height: 8.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.black12),
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
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: Text(
                              '识别成功',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: statusColor,
                              ),
                            ),
                          ),
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
                      ),
                      SizedBox(height: 10.h),
                      Wrap(
                        spacing: 8.w,
                        runSpacing: 6.h,
                        children: [
                          _PreviewChip(label: '取件码', value: result.code ?? '-'),
                          _PreviewChip(
                            label: '驿站',
                            value: result.stationName ?? '未识别',
                          ),
                          _PreviewChip(
                            label: '到期',
                            value: result.expireAt == null
                                ? '未识别'
                                : _formatDate(result.expireAt!),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Obx(() {
                        return FilledButton.icon(
                          onPressed: controller.isAiMode
                              ? controller.saveAsPickup
                              : null,
                          icon: const Icon(Icons.save_outlined),
                          label: const Text('保存到 AI 待取'),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: 16.h),
          Text(
            '说明：AI 模式为后续扩展预留位点，当前展示为本地模拟流程。',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ],
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

class _PreviewChip extends StatelessWidget {
  const _PreviewChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F7),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        '$label：$value',
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: Colors.black87),
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
