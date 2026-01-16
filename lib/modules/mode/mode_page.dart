import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';

class ModePage extends GetView<ModeController> {
  const ModePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('模式切换')),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('请选择模式', style: Theme.of(context).textTheme.titleMedium),
            SizedBox(height: 12.h),
            Obx(() {
              return Column(
                children: AppMode.values.map((mode) {
                  return _ModeCard(
                    mode: mode,
                    selected: controller.current.value == mode,
                    onTap: () => controller.switchMode(mode),
                  );
                }).toList(),
              );
            }),
            SizedBox(height: 16.h),
            Text(
              'AI 模式当前仅提供入口与说明，功能将在后续版本接入。',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.selected,
    required this.onTap,
  });

  final AppMode mode;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.black54,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  mode.label,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (selected)
                Text(
                  '当前',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(color: Colors.black54),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
