import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/app/routes/app_routes.dart';
import 'package:pickup_code_front/domain/entities/template_rule.dart';
import 'package:pickup_code_front/modules/templates/templates_controller.dart';

class TemplatesPage extends GetView<TemplatesController> {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('识别模板')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Obx(() {
          if (controller.rules.isEmpty) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('暂无模板', style: Theme.of(context).textTheme.titleSmall),
                SizedBox(height: 8.h),
                Text(
                  '识别失败时可从短信示例创建模板，提升后续命中率。',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: Colors.black54),
                ),
                SizedBox(height: 16.h),
                FilledButton.icon(
                  onPressed: () => Get.toNamed(Routes.pickupDetail),
                  icon: const Icon(Icons.add),
                  label: const Text('去粘贴导入'),
                ),
              ],
            );
          }
          return ListView.separated(
            itemCount: controller.rules.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final rule = controller.rules[index];
              return _TemplateCard(
                rule: rule,
                onToggle: (value) => controller.toggleEnabled(rule, value),
                onDelete: () => _confirmDelete(context, rule, controller),
              );
            },
          );
        }),
      ),
    );
  }
}

class _TemplateCard extends StatelessWidget {
  const _TemplateCard({
    required this.rule,
    required this.onToggle,
    required this.onDelete,
  });

  final TemplateRule rule;
  final ValueChanged<bool> onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final name = rule.name?.trim();
    return Card(
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    name == null || name.isEmpty ? '用户模板' : name,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                Switch(value: rule.isEnabled, onChanged: onToggle),
              ],
            ),
            Text(
              rule.sampleText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Text(
                  rule.isEnabled ? '已启用' : '已停用',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.black54),
                ),
                const Spacer(),
                IconButton(
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline),
                  tooltip: '删除模板',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> _confirmDelete(
  BuildContext context,
  TemplateRule rule,
  TemplatesController controller,
) async {
  final name = rule.name?.trim();
  final confirmed =
      await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('删除模板'),
            content: Text(
              '确认删除「${name == null || name.isEmpty ? '用户模板' : name}」吗？',
            ),
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
    await controller.deleteRule(rule);
  }
}
