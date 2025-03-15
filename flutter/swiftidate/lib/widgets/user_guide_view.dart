import 'package:flutter/material.dart';
import '../analytics/analytics_manager.dart';
import '../widgets/social_training_view.dart';

class UserGuideView extends StatefulWidget {
  const UserGuideView({Key? key}) : super(key: key);

  @override
  State<UserGuideView> createState() => _UserGuideViewState();
}

class _UserGuideViewState extends State<UserGuideView> {
  final ScrollController _scrollController = ScrollController();
  bool showSocialCourse = false;

  Widget _buildRichText(String boldText, String normalText) {
    return RichText(
      text: TextSpan(
        style: Theme.of(context).textTheme.bodyMedium,
        children: [
          TextSpan(text: boldText, style: const TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: normalText),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    // 設定滾動監控
    _scrollController.addListener(() {
      // 取得當前滾動的 offset
      final offset = _scrollController.offset;
      // 如果 offset 超過某個閾值，觸發 Analytics 事件
      if (offset > 200) {
        AnalyticsManager.shared.trackEvent("user_guide_scrolled_past_intro");
      }
    });

    // 當頁面顯示時觸發 onAppear 事件
    AnalyticsManager.shared.trackEvent("user_guide_view_appear");
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // 顯示社交課程的 Modal Bottom Sheet
  void _showSocialCourse() {
    AnalyticsManager.shared.trackEvent("social_course_button_tapped");
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(
                "想提升你的搭訕技巧？我們提供專業的社交課程，幫助你更自然地與異性互動。立即學習如何提升你的魅力！",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            // 按鈕：顯示社交課程
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: ElevatedButton(
                onPressed: _showSocialCourse,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // 背景色
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
            // Group 1: 了解「讚美」與「超級喜歡」的搭訕技巧
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("1. 了解「讚美」與「超級喜歡」的搭訕技巧", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        const TextSpan(text: "• 讚美：", style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: "就像您在街上看到一位吸引您的女生，鼓起勇氣向她說「妳好，我覺得妳很有魅力」，這樣的動作。按下「讚美」讓對方知道您對她有興趣，是開啟對話的第一步。"),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
                      children: [
                        const TextSpan(text: "• 超級喜歡：", style: TextStyle(fontWeight: FontWeight.bold)),
                        const TextSpan(text: "就像是您遇到一個非常吸引您的女生，迫不及待地想要引起她的注意，您直接上前說：「我覺得妳真的是我見過最美的人。」按下「超級喜歡」就是這樣的強烈表達方式，能讓對方立刻知道您對她的高度興趣，但請謹慎使用。"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Group 2: 如何有效地搭訕並使用「讚美」功能
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("2. 如何有效地搭訕並使用「讚美」功能", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyMedium,
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
            // Group 3: 有效運用「超級喜歡」的搭訕技巧
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("3. 有效運用「超級喜歡」的搭訕技巧", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  _buildRichText("• 謹慎選擇對象：", "「超級喜歡」就像是大膽地向心儀的女生表達您的強烈興趣。每天可以使用的次數有限，請務必在確定她是您真正想認識的人後，再使用這個功能。對那些個人資料豐富且和您有共同興趣的對象使用，效果最好."),
                  const SizedBox(height: 8),
                  _buildRichText("• 把握好時機：", "在搭訕的時候，時機很重要。當您感覺她的個性、興趣與您非常契合，或是她的特質正是您在尋找的，這時按下「超級喜歡」，就能引起她的注意，增加成功的機率."),
                  const SizedBox(height: 8),
                  _buildRichText("• 展現真誠與獨特性：", "與其泛泛而談，讓對方感受到您的真心更重要。搭訕成功後，請說出對方個人簡介中的特點，表達您對她的興趣，這樣她才會覺得您與其他人不同."),
                ],
              ),
            ),
            // Group 4: 完善自己的「搭訕形象」
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("4. 完善自己的「搭訕形象」：提升讚美與超級喜歡的效果", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  _buildRichText("• 選擇好照片：", "第一印象很重要！展示自己最佳狀態的照片，就像在搭訕時穿著得體。讓對方看到您的多面性，例如愛好、興趣等，增加吸引力."),
                  const SizedBox(height: 8),
                  _buildRichText("• 精心撰寫個人簡介：", "就像在搭訕時，簡單有趣地介紹自己，個人簡介是讓對方快速了解您的機會。請真誠地描述自己的興趣與生活，這樣才更有機會吸引到對方."),
                ],
              ),
            ),
            // Group 5: 主動與對方互動
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("5. 主動與對方互動，讓搭訕更有效", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  _buildRichText("• 迅速回應：", "在現實中，搭訕後若對方回應，您也應該快速地接續對話。同樣地，在 SwiftiDate 上，當配對成功後，主動開啟聊天，讓對方知道您對她有興趣."),
                  const SizedBox(height: 8),
                  _buildRichText("• 保持尊重與幽默：", "幽默感是搭訕的好工具，但也要尊重對方的界限。避免問太私人或敏感的問題，先從對方的興趣開始，讓對話自然展開."),
                  const SizedBox(height: 8),
                  _buildRichText("• 利用對方興趣展開話題：", "對方的興趣是您搭訕的最佳起點，根據她的興趣提出問題或分享經驗，會讓她感受到您的真誠，並且增加對話的趣味性."),
                ],
              ),
            ),
            // Group 6: 如何應對不合適的對象
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("6. 如何應對不合適的對象", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  _buildRichText("• 尊重對方的選擇：", "就像現實中的搭訕，對方可能對您不感興趣，這時候尊重對方是最重要的。若對方沒有進一步互動的意願，請禮貌地結束對話."),
                  const SizedBox(height: 8),
                  _buildRichText("• 繼續尋找適合您的對象：", "如果感覺不對，那就不要浪費時間，專注尋找下一個更適合您的對象。這樣才更容易找到真正心儀的人."),
                ],
              ),
            ),
            // Group 7: 使用 SwiftiDate 的其他搭訕技巧
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("7. 使用 SwiftiDate 的其他搭訕技巧", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  _buildRichText("• 經常更新資料：", "隨時保持最新狀態，讓對方看到您的生活動態，這樣可以引起更多人的興趣."),
                  const SizedBox(height: 8),
                  _buildRichText("• 參加活動或話題：", "SwiftiDate 會定期推出各種活動或話題，參加這些活動，能讓更多人注意到您，並增加搭訕的機會."),
                  const SizedBox(height: 8),
                  _buildRichText("• 保持耐心：", "就像在現實生活中找到合適的對象需要時間，請耐心等待，找到適合您的對象."),
                ],
              ),
            ),
            // Group 8: 最後的建議
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("8. 最後的建議", style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 8),
                  _buildRichText("• 真誠與誠實：", "搭訕的過程中，真誠是最有力量的。請如實地展示自己，這樣才有機會遇到真正欣賞您的對象."),
                  const SizedBox(height: 8),
                  _buildRichText("• 大膽嘗試不同搭訕方式：", "不同的對象可能需要不同的搭訕方式，請大膽嘗試，並找到最適合自己的方法."),
                ],
              ),
            ),
            // Group 9: 使用 ChatGPT 來回應訊息
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text("9. 使用 ChatGPT 來回應訊息", style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                "SwiftiDate 目前整合了 ChatGPT 功能，您可以在對話中使用 ChatGPT 來生成回應。這個功能非常適合在您不知道該如何回應時，讓 ChatGPT 提供一些建議性的對話回應。",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text("結語", style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Text(
                "SwiftiDate 就像是一個提供給您搭訕的舞台，讓您有機會結識更多優質的對象。希望您在運用「讚美」和「超級喜歡」時，能像現實中勇敢搭訕那樣，找到屬於自己的幸福。",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}