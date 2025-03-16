import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
// 假設你已經實作這些 class
import '../providers/user_settings.dart';
import '../services/location_manager.dart';

/// 模擬 User 資料模型
class User {
  final String id;
  final String name;
  final int age;
  final String zodiac;
  final String location;
  final int height;
  final List<String> photos;

  User({
    required this.id,
    required this.name,
    required this.age,
    required this.zodiac,
    required this.location,
    required this.height,
    required this.photos,
  });
}

/// SwipeCardView Flutter 版
class SwipeCardView extends StatefulWidget {
  @override
  _SwipeCardViewState createState() => _SwipeCardViewState();
}

class _SwipeCardViewState extends State<SwipeCardView> {
  // Firebase Firestore 實例
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // 假設 LocationManager 實作了授權狀態與請求方法
  late LocationManager locationManager;

  // State Variables
  int currentIndex = 0;
  Offset offset = Offset.zero;
  bool showCircleAnimation = false;
  bool showPrivacySettings = false;
  bool showWelcomePopup = true; // 初始顯示彈跳視窗
  Set<String> swipedIDs = {};
  final String currentUserID = "abc123"; // 當前用戶的 ID

  DocumentSnapshot? lastDocument;
  bool isLoading = false;

  // 記錄最後一次滑動的資訊
  User? lastSwipedUser;
  int? lastSwipedIndex;
  bool? lastSwipedIsRight;
  String? lastSwipedDocID;

  // 模擬使用者資料，初始有幾筆資料
  List<User> users = [
    User(
      id: "userID_2",
      name: "後照鏡被偷",
      age: 20,
      zodiac: "雙魚座",
      location: "桃園市",
      height: 172,
      photos: ["assets/userID_2_photo1.png", "assets/userID_2_photo2.png"],
    ),
    User(
      id: "userID_3",
      name: "小明",
      age: 22,
      zodiac: "天秤座",
      location: "台北市",
      height: 180,
      photos: [
        "assets/userID_3_photo1.png",
        "assets/userID_3_photo2.png",
        "assets/userID_3_photo3.png",
        "assets/userID_3_photo4.png",
        "assets/userID_3_photo5.png",
        "assets/userID_3_photo6.png",
      ],
    ),
    User(
      id: "userID_4",
      name: "小花",
      age: 25,
      zodiac: "獅子座",
      location: "新竹市",
      height: 165,
      photos: [
        "assets/userID_4_photo1.png",
        "assets/userID_4_photo2.png",
        "assets/userID_4_photo3.png",
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    locationManager = LocationManager();
    fetchSwipes();
  }

  // 先抓取已滑過的紀錄
  void fetchSwipes() async {
    final snapshot = await db
        .collection("swipes")
        .where("userID", isEqualTo: currentUserID)
        .get();
    Set<String> swipedSet = {};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      if (data["targetID"] != null) {
        swipedSet.add(data["targetID"]);
      }
    }
    setState(() {
      swipedIDs = swipedSet;
    });
    loadUsers(pageSize: 20, lastDoc: null);
  }

  // 加載更多使用者資料
  void loadUsers({int pageSize = 20, DocumentSnapshot? lastDoc}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });
    Query query = db
        .collection("users")
        .orderBy("createdAt", descending: false)
        .limit(pageSize);
    if (lastDoc != null) {
      query = query.startAfterDocument(lastDoc);
    }
    final snapshot = await query.get();
    setState(() {
      isLoading = false;
    });
    if (snapshot.docs.isEmpty) return;

    List<User> tempUsers = [];
    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      String id = doc.id;
      // 排除已滑過或是自己
      if (swipedIDs.contains(id) || id == currentUserID) continue;
      if (data["name"] != null &&
          data["age"] != null &&
          data["zodiac"] != null &&
          data["location"] != null &&
          data["height"] != null &&
          data["photos"] != null) {
        tempUsers.add(User(
          id: id,
          name: data["name"],
          age: data["age"],
          zodiac: data["zodiac"],
          location: data["location"],
          height: data["height"],
          photos: List<String>.from(data["photos"]),
        ));
      }
    }
    setState(() {
      users.addAll(tempUsers);
      lastDocument = snapshot.docs.last;
    });
  }

  // 處理滑動行為，rightSwipe 為 true 代表喜歡 (右滑)
  void handleSwipe(bool rightSwipe) async {
    DocumentReference newDocRef = db.collection("swipes").doc();
    Map<String, dynamic> data = {
      "userID": currentUserID,
      "targetID": users[currentIndex].id,
      "isLike": rightSwipe,
      "timestamp": FieldValue.serverTimestamp(),
    };
    await newDocRef.set(data).then((_) {
      // 記錄最後一次滑卡資料
      setState(() {
        lastSwipedUser = users[currentIndex];
        lastSwipedIndex = currentIndex;
        lastSwipedIsRight = rightSwipe;
        lastSwipedDocID = newDocRef.id;
      });
      // 更新喜歡數（假設 globalLikeCount 為 UserSettings 的一個欄位）
      final userSettings = Provider.of<UserSettings>(context, listen: false);
      if (rightSwipe) {
        userSettings.globalLikeCount += 1;
      }
      Future.delayed(Duration(milliseconds: 500), () {
        if (currentIndex < users.length - 1) {
          setState(() {
            currentIndex += 1;
            offset = Offset.zero;
          });
        } else {
          setState(() {
            showCircleAnimation = true;
            offset = Offset.zero;
          });
        }
      });
    }).catchError((error) {
      print("寫入 Firestore 失敗: $error");
    });
  }

  // 撤銷上一次滑動
  void undoSwipe() async {
    if (lastSwipedDocID == null) return;
    final docRef = db.collection("swipes").doc(lastSwipedDocID);
    await docRef.delete().then((_) {
      final userSettings = Provider.of<UserSettings>(context, listen: false);
      if (lastSwipedIsRight == true) {
        userSettings.globalLikeCount -= 1;
      }
      setState(() {
        currentIndex = lastSwipedIndex ?? currentIndex;
        showCircleAnimation = false;
        offset = Offset.zero;
        lastSwipedUser = null;
        lastSwipedIndex = null;
        lastSwipedIsRight = null;
        lastSwipedDocID = null;
      });
    }).catchError((error) {
      print("撤銷失敗: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final userSettings = Provider.of<UserSettings>(context);
    // 檢查位置權限，假設 locationManager.authorizationStatus 為枚舉型態
    bool locationAuthorized =
        locationManager.authorizationStatus == LocationPermission.whileInUse ||
        locationManager.authorizationStatus == LocationPermission.always;

    return Scaffold(
      body: Stack(
        children: [
          locationAuthorized ? mainSwipeCardView() : locationPermissionPromptView(),
          // 右上角的隱私設定按鈕
          Positioned(
            top: 50,
            right: 20,
            child: IconButton(
              icon: Icon(Icons.settings, size: 30, color: Colors.grey),
              onPressed: () {
                setState(() {
                  showPrivacySettings = true;
                });
                // 你可以改用 Navigator.push 進入隱私設定頁面
              },
            ),
          ),
          // 顯示歡迎彈跳視窗
          if (showWelcomePopup) welcomePopupView(),
        ],
      ),
    );
  }

  /// 主滑動卡片區域
  Widget mainSwipeCardView() {
    return Stack(
      children: [
        if (showCircleAnimation)
          // 這裡用一個簡單的圓形來模擬動畫效果
          Center(child: CircleAvatar(radius: 100, backgroundColor: Colors.blue)),
        if (!showCircleAnimation)
          ...users
              .asMap()
              .entries
              .where((entry) => entry.key >= currentIndex && entry.key < currentIndex + 3)
              .map((entry) {
            int index = entry.key;
            User user = entry.value;
            bool isCurrentCard = index == currentIndex;
            double yOffset = (index - currentIndex) * 10.0;
            double rotationAngle = isCurrentCard ? offset.dx / 10 : 0;
            double scaleValue = isCurrentCard ? 1.0 : 0.95;
            double xOffset = isCurrentCard ? offset.dx : 0;
            return Positioned(
              top: 100 + yOffset,
              left: xOffset,
              right: 0,
              child: Draggable(
                axis: Axis.horizontal,
                feedback: Material(
                  color: Colors.transparent,
                  child: SwipeCard(user: user),
                ),
                childWhenDragging: Container(),
                onDragUpdate: (details) {
                  setState(() {
                    offset = details.delta;
                  });
                },
                onDragEnd: (details) {
                  setState(() {
                    if (offset.dx > 120) {
                      handleSwipe(true);
                    } else if (offset.dx < -150) {
                      handleSwipe(false);
                    } else {
                      offset = Offset.zero;
                    }
                  });
                },
                child: Transform.rotate(
                  angle: rotationAngle,
                  child: Transform.scale(
                    scale: scaleValue,
                    child: SwipeCard(user: user),
                  ),
                ),
              ),
            );
          }).toList(),
      ],
    );
  }

  /// 位置權限提示頁面
  Widget locationPermissionPromptView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 80, color: Colors.green),
            SizedBox(height: 16),
            Text("來認識附近的新朋友吧",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text("SwiftiDate 需要你的位置權限才能幫你找到附近好友哦",
                textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                locationManager.requestPermission();
              },
              child: Text("前往設置"),
            ),
          ],
        ),
      ),
    );
  }

  /// 歡迎彈跳視窗
  Widget welcomePopupView() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: Container(
            width: 300,
            height: 400,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
            ),
            child: Column(
              children: [
                SizedBox(height: 40),
                Icon(Icons.person, size: 80, color: Colors.green),
                SizedBox(height: 20),
                Text("你喜歡什麼樣類型的？",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    "我們會根據你的左滑和右滑了解你喜歡的類型，為你推薦更優質的用戶。",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showWelcomePopup = false;
                    });
                  },
                  child: Text("知道了，開始吧！"),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// 單一卡片元件
class SwipeCard extends StatelessWidget {
  final User user;
  const SwipeCard({required this.user});

  @override
  Widget build(BuildContext context) {
    // 這裡僅示範用第一張圖片作為卡片背景，
    // 你可以使用 PageView 或 GestureDetector 實作圖片切換效果
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      height: MediaQuery.of(context).size.height - 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: DecorationImage(
          image: AssetImage(user.photos.isNotEmpty ? user.photos[0] : 'assets/placeholder.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // 用戶資訊與標籤區域
          Container(
            color: Colors.black54,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${user.name}, ${user.age}",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(user.zodiac, style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.location_on, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text(user.location, style: TextStyle(color: Colors.white)),
                    SizedBox(width: 8),
                    Icon(Icons.height, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text("${user.height} cm", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          // 底部功能按鈕 (例如：撤銷、喜歡、訊息等)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 撤銷按鈕
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.yellow, size: 30),
                  onPressed: () {
                    // 透過事件或 Provider 通知父層執行 undoSwipe
                    // 這裡示範簡單調用
                    final state = context.findAncestorStateOfType<_SwipeCardViewState>();
                    state?.undoSwipe();
                  },
                ),
                // 不喜歡按鈕
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red, size: 30),
                  onPressed: () {
                    // 根據需求執行 Dislike 行為
                  },
                ),
                // 訊息按鈕
                IconButton(
                  icon: Icon(Icons.message, color: Colors.white, size: 30),
                  onPressed: () {
                    // 執行 Message 行為
                  },
                ),
                // 喜歡按鈕
                IconButton(
                  icon: Icon(Icons.favorite, color: Colors.green, size: 30),
                  onPressed: () {
                    // 執行 Like 行為
                  },
                ),
                // 特殊功能按鈕
                IconButton(
                  icon: Icon(Icons.star, size: 30,
                      color: Provider.of<UserSettings>(context).globalUserGender == Gender.male ? Colors.blue : Colors.pink),
                  onPressed: () {
                    // 特殊功能行為
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}