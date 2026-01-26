# pickup_code_front

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 发送短信
```
adb devices #查看设备
adb -s emulator-5554 emu sms send 10086 "【菜鸟驿站】您的包裹已到达：申通快递 7890123456789，取件码 6732，请凭此码至【XX小区南门菜鸟驿站】（营业时间 09:00-21:00）领取。如有疑问请联系站长：1385678。"
```

## 短信权限
```
adb -s emulator-5554 shell dumpsys package com.example.pickup_code_front | rg "android.permission.(READ_SMS|RECEIVE_SMS): granted"
#如果是 granted=false，Receiver 根本收不到 SMS_RECEIVED（自然页面没结果）。


是否真的收到广播：adb -s emulator-5554 logcat -d | rg "PickupSms"  #看到 SMS received 说明 Receiver 已触发

```