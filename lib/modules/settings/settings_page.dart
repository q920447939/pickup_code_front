import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pickup_code_front/app/routes/app_routes.dart';
import 'package:pickup_code_front/domain/entities/app_mode.dart';
import 'package:pickup_code_front/modules/mode/mode_controller.dart';
import 'package:pickup_code_front/modules/settings/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modeController = Get.find<ModeController>();
    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        children: [
          Obx(() {
            return _SettingsTile(
              title: '当前模式',
              subtitle: modeController.current.value.label,
              onTap: () => Get.toNamed(Routes.mode),
            );
          }),
          Obx(() {
            final hideCode = controller.hideWidgetCode.value;
            return Card(
              margin: EdgeInsets.only(bottom: 12.h),
              child: SwitchListTile(
                value: hideCode,
                onChanged: controller.updateHideWidgetCode,
                title: const Text('小组件隐私展示'),
                subtitle: Text(hideCode ? '仅显示取件码后 4 位' : '显示完整取件码'),
              ),
            );
          }),
          _SettingsTile(
            title: 'AI 识别入口',
            subtitle: '仅展示说明',
            onTap: () => Get.toNamed(Routes.ai),
          ),
          _SettingsTile(
            title: '代取协作',
            subtitle: '规划中',
            onTap: () => Get.toNamed(Routes.group),
          ),
          _SettingsTile(title: '通知与提醒', subtitle: '本地提醒策略', onTap: () {}),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
