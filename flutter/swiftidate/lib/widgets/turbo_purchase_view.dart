import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/consumable_store.dart';
import '../analytics/analytics_manager.dart';
// 請確保你有定義 Product 類型，並且 ConsumableStore 中有 List<Product> turbos 與 purchase(Product product) 方法
import '../models/product.dart';
import '../models/store_error.dart';

class TurboPurchaseView extends StatefulWidget {
  const TurboPurchaseView({Key? key}) : super(key: key);

  @override
  _TurboPurchaseViewState createState() => _TurboPurchaseViewState();
}

class _TurboPurchaseViewState extends State<TurboPurchaseView> {
  bool isPurchased = false;
  String errorTitle = "";
  bool isShowingError = false;
  String selectedOption = "5 Turbo";
  // Product? selectedProduct;

  @override
  void initState() {
    super.initState();
    // 記錄視圖曝光事件
    AnalyticsManager.shared.trackEvent("turbo_purchase_view_appear");
    // 檢查預設選項，假設 ConsumableStore 提供 turbos 列表
    final store = Provider.of<ConsumableStore>(context, listen: false);
    // if (selectedProduct == null && store.turbos.isNotEmpty) {
    //   // 選擇 id 為 "stevenstudio.SwiftiDate.turbo.5" 的產品作為預設，若找不到則使用第一個
    //   final defaultProduct = store.turbos.firstWhere(
    //     (p) => p.id == "stevenstudio.SwiftiDate.turbo.5",
    //     orElse: () => store.turbos.first,
    //   );
    //   setState(() {
    //     selectedProduct = defaultProduct;
    //     selectedOption = "5 Turbo";
    //   });
    //   print("[DEBUG] Default selectedProduct set to: ${defaultProduct.id}");
    // }
  }

  Future<void> buy(Product product) async {
    final store = Provider.of<ConsumableStore>(context, listen: false);
    // print("[DEBUG] buy() called with product.id = ${product.id}");
    try {
      // final result = await store.purchase(product);
      // if (result != null) {
        setState(() {
          isPurchased = true;
        });
        print("[DEBUG] Successfully purchased ${product.id}");
      // }
    } on StoreError catch (e) {
      setState(() {
        errorTitle = "Your purchase could not be verified by the App Store.";
        isShowingError = true;
      });
      print("[ERROR] Purchase verification failed for ${product.id}: $e");
    } catch (error) {
      print("Failed purchase for ${product.id}. $error");
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<ConsumableStore>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Turbo", style: TextStyle(fontSize: 20)),
        centerTitle: true,
        // 如果需要返回動作，可以在 leading 放返回按鈕
        leading: IconButton(
          icon: const Icon(Icons.close, size: 18, color: Colors.grey),
          padding: const EdgeInsets.all(16),
          onPressed: () {
            AnalyticsManager.shared.trackEvent("turbo_purchase_view_dismissed");
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [
          // Header with background image and dismiss button overlay
          Stack(
            children: [
              Image.asset(
                "assets/turbo_header.jpg", // 請替換為實際圖片資源
                width: MediaQuery.of(context).size.width,
                height: 350,
                fit: BoxFit.cover,
              ),
              // X 按鈕已放到 AppBar leading 部分
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "收穫更多喜歡",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "開啟Turbo期間，你的資料將直接置頂到所有人的前面！輕鬆提升10倍配對成功率",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const Spacer(),
          // Turbo options
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                TurboOptionView(
                  title: "10 Turbo",
                  price: "NT\$99 /次",
                  discount: "省 34%",
                  isSelected: selectedOption == "10 Turbo",
                  // product: store.turbos[0],
                  // purchasingEnabled: true,
                  // selectedProduct: selectedProduct,
                  onSelect: () {
                    setState(() {
                      selectedOption = "10 Turbo";
                      // selectedProduct = store.turbos[0];
                    });
                    AnalyticsManager.shared.trackEvent("turbo_option_selected", parameters: {"option": "10 Turbo"});
                  },
                ),
                TurboOptionView(
                  title: "5 Turbo",
                  price: "NT\$138 /次",
                  discount: "省 8%",
                  isSelected: selectedOption == "5 Turbo",
                  // product: store.turbos[1],
                  // purchasingEnabled: true,
                  // selectedProduct: selectedProduct,
                  onSelect: () {
                    setState(() {
                      selectedOption = "5 Turbo";
                      // selectedProduct = store.turbos[1];
                    });
                    AnalyticsManager.shared.trackEvent("turbo_option_selected", parameters: {"option": "5 Turbo"});
                  },
                ),
                TurboOptionView(
                  title: "1 Turbo",
                  price: "NT\$150 /次",
                  discount: "",
                  isSelected: selectedOption == "1 Turbo",
                  // product: store.turbos[2],
                  // purchasingEnabled: true,
                  // selectedProduct: selectedProduct,
                  onSelect: () {
                    setState(() {
                      selectedOption = "1 Turbo";
                      // selectedProduct = store.turbos[2];
                    });
                    AnalyticsManager.shared.trackEvent("turbo_option_selected", parameters: {"option": "1 Turbo"});
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Purchase button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () async {
                AnalyticsManager.shared.trackEvent("turbo_purchase_button_tapped", parameters: {
                  "selected_option": selectedOption,
                });
                // 這裡可以檢查地區代碼，如果是 CN 則使用其他支付方案
                // if (selectedProduct != null) {
                //   await buy(selectedProduct!);
                // } else {
                //   print("尚未選擇產品");
                // }
                print("立即獲取 $selectedOption");
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.all(16),
              ),
              child: const Center(
                child: Text("立即獲取", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "獲得後隨時用，永遠不會過期",
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class TurboOptionView extends StatelessWidget {
  final String title;
  final String price;
  final String discount;
  final bool isSelected;
  // final Product product;
  // final bool purchasingEnabled;
  // final Product? selectedProduct;
  final VoidCallback onSelect;

  const TurboOptionView({
    Key? key,
    required this.title,
    required this.price,
    required this.discount,
    required this.isSelected,
    // required this.product,
    // required this.purchasingEnabled,
    // required this.selectedProduct,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 100,
        height: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.purple.withOpacity(0.3) : Colors.purple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? Colors.purple : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            if (discount.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(discount, style: const TextStyle(fontSize: 12, color: Colors.red)),
              ),
            Text(price, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
