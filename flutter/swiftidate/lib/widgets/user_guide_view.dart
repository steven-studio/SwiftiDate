import 'package:flutter/material.dart';

class UserGuideView extends StatefulWidget {
  const UserGuideView({Key? key}) : super(key: key);

  @override
  State<UserGuideView> createState() => _UserGuideViewState();
}

class _UserGuideViewState extends State<UserGuideView> {
  final ScrollController _scrollController = ScrollController();
  bool showSocialCourse = false;

  @override
  void initState() {
    super.initState();

    // 設定滾動監控
    _scrollController.addListener(() {
      // 取得當前滾動的 offset
      final offset = _scrollController.offset;
      // 如果 offset 超過某個閾值，觸發 Analytics 事件
      // if (offset > 200) {
      //   AnalyticsManager.shared.trackEvent("user_guide_scrolled_past_intro");
      // }
    });

    // 當頁面顯示時觸發 onAppear 事件
    // AnalyticsManager.shared.trackEvent("user_guide_view_appear");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 顯示社交課程的 Modal Bottom Sheet
  void _showSocialCourse() {
    // AnalyticsManager.shared.trackEvent("social_course_button_tapped");
    showModalBottomSheet(
      context: context,
      builder: (_) => const SocialTrainingView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("使用說明"),
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 範例文字區塊
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                "歡迎來到 SwiftiDate！在這裡，使用「讚美」與「超級喜歡」的功能，就好比在現實生活中向女生搭訕，表達您的興趣和好感。在這份指南中，我們將引導您如何運用這些功能，讓您能更自然地向心儀的對象搭訕，並增加互動機會。",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                "想提升你的搭訕技巧？我們提供專業的社交課程，幫助你更自然地與異性互動。立即學習如何提升你的魅力！",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            // 按鈕：顯示社交課程
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: _showSocialCourse,
                style: ElevatedButton.styleFrom(
                  primary: Colors.orange, // 背景色
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "🎓 進入社交課程",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // 以下用 Padding 與 Column 模擬多個 Group 區塊
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("1. 了解「讚美」與「超級喜歡」的搭訕技巧", style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        const TextSpan(text: "• 讚美：", style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: "就像您在街上看到一位吸引您的女生，鼓起勇氣向她說「妳好，我覺得妳很有魅力」，這樣的動作。按下「讚美」讓對方知道您對她有興趣，是開啟對話的第一步。"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        const TextSpan(text: "• 超級喜歡：", style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: "就像是您遇到一個非常吸引您的女生，迫不及待地想要引起她的注意，您直接上前說：「我覺得妳真的是我見過最美的人。」按下「超級喜歡」就是這樣的強烈表達方式，能讓對方立刻知道您對她的高度興趣，但請謹慎使用。"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // 接著可以依此模式繼續增加其他區塊...
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("2. 如何有效地搭訕並使用「讚美」功能", style: Theme.of(context).textTheme.headline6),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText1,
                      children: [
                        const TextSpan(text: "• 仔細觀察對方：", style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: "就像在現實中搭訕前，您會觀察對方的舉止、穿著與氣質，來判斷是否適合交談。使用 SwiftiDate 時，請仔細閱讀對方的個人資料，了解她的興趣和喜好。"),
                      ],
                    ),
                  ),
                  // 更多內容...
                ],
              ),
            ),
            // 其他區塊... 例如第三、第四組等等
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text("9. 使用 ChatGPT 來回應訊息", style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                "SwiftiDate 目前整合了 ChatGPT 功能，您可以在對話中使用 ChatGPT 來生成回應。這個功能非常適合在您不知道該如何回應時，讓 ChatGPT 提供一些建議性的對話回應。",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text("結語", style: Theme.of(context).textTheme.headline6),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                "SwiftiDate 就像是一個提供給您搭訕的舞台，讓您有機會結識更多優質的對象。希望您在運用「讚美」和「超級喜歡」時，能像現實中勇敢搭訕那樣，找到屬於自己的幸福。",
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}