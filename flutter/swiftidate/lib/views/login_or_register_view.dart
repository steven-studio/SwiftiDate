import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_settings.dart';

class LoginOrRegisterView extends StatelessWidget {
  const LoginOrRegisterView({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<UserSettings>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Login or Register')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // 模擬登入動作，更新使用者資料
            userSettings.globalPhoneNumber = '0972516868';
            userSettings.globalUserName = '玩玩';
            // 呼叫 notifyListeners() 可以在 update 方法中執行（或自行呼叫）
            userSettings.notifyListeners();
          },
          child: const Text('模擬登入'),
        ),
      ),
    );
  }
}
