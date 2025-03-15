import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

// 假設你已自行定義了 AppState, UserSettings, ConsumableStore 等類別
import 'providers/app_state.dart';
import 'providers/user_settings.dart';
import 'providers/consumable_store.dart';
import 'views/content_view.dart';
import 'views/login_or_register_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppState()),
        ChangeNotifierProvider(create: (_) => UserSettings()),
        ChangeNotifierProvider(create: (_) => ConsumableStore()),
      ],
      child: const SwiftiDateApp(),
    ),
  );
}

class SwiftiDateApp extends StatelessWidget {
  const SwiftiDateApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SwiftiDate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // 設定背景為白色
          selectedItemColor: Colors.deepPurple, // 選中項目的顏色
          unselectedItemColor: Colors.grey, // 未選中項目的顏色
          type: BottomNavigationBarType.fixed, // 固定型，適合超過三個分頁
        ),
      ),
      home: const HomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    final userSettings = Provider.of<UserSettings>(context);

    // 模擬 onAppear 時設定的預設值
    userSettings.globalPhoneNumber = "0972516868";
    userSettings.globalUserName = "玩玩";
    userSettings.globalUserGender = Gender.male; // 假設你有定義 Gender 枚舉
    userSettings.globalIsUserVerified = true;
    userSettings.globalSelectedGender = "女生";
    userSettings.globalUserBirthday = "1999/07/02";
    userSettings.globalUserID = "userID_1";
    userSettings.globalLikesMeCount = 0;
    userSettings.globalLikeCount = 0;
    userSettings.isPremiumUser = true;
    userSettings.isSupremeUser = true;
    userSettings.globalTurboCount = 1;
    userSettings.globalCrushCount = 10000;
    userSettings.globalPraiseCount = 10000;
    userSettings.isProfilePhotoVerified = true;
    // 同時，將 userSettings 傳給其他管理者（例如 FirebaseAuthManager）也需要自行處理

    return Scaffold(
      body: userSettings.globalPhoneNumber.isNotEmpty
          ? const ContentView()         // 當已註冊則顯示主要內容頁
          : const LoginOrRegisterView(), // 否則顯示登入/註冊頁面
    );
  }
}
