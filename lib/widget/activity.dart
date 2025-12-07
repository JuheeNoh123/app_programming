import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brandme/widget/activity_data.dart';

const Color kBrandRed = Color(0xFFBB271A);
const Color kLightGray = Color(0xFFFBFBFB);
const Color kBgDark = Color(0xFF202123);

class ActivityPage extends StatefulWidget {
  const ActivityPage({super.key});

  @override
  State<ActivityPage> createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage>
    with TickerProviderStateMixin {
  String? resultType;
  Map<String, int> scores = {};
  int selectedIndex = 0;

  late AnimationController _animationController;
  late Animation<Offset> _animation;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _loadUserScores();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _animation = Tween<Offset>(begin: const Offset(0, 1.5), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeInOutCubic,
          ),
        );

    // 처음부터 카드가 위에 떠 있도록 설정
    _animationController.value = 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _loadUserScores() async {
    final prefs = await SharedPreferences.getInstance();
    final type = prefs.getString("brandme_result_type");
    final scoreJson = prefs.getString("brandme_result_scores");
    if (type == null || scoreJson == null) return;

    final cleanType = type
        .replaceAll(RegExp(r'\\n|\n'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final mappedType = _mapResultTypeToKey(cleanType);

    setState(() {
      resultType = mappedType;
      scores = Map<String, int>.from(jsonDecode(scoreJson));
    });
  }

  String _mapResultTypeToKey(String text) {
    if (text.contains("감성적으로 세상을 해석하는")) return "창의형";
    if (text.contains("끊임없이 성장하는")) return "도전형";
    if (text.contains("논리적으로 계획하는")) return "집중형";
    return "창의형";
  }

  @override
  Widget build(BuildContext context) {
    if (resultType == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final data = ActivityData.activityByType[resultType];
    if (data == null || data.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text("어울리는 활동 추천")),
        body: const Center(child: Text("테스트 유형에 맞는 데이터가 없습니다.")),
      );
    }

    final activities = List<String>.from(data["activities"] ?? []);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70), // AppBar 전체 높이
        child: Padding(
          padding: const EdgeInsets.only(top: 30), // 위쪽 여백 (아이콘+제목 둘 다 내려감)
          child: AppBar(
            backgroundColor: kLightGray,
            elevation: 0,
            centerTitle: true,
            foregroundColor: kBgDark,
            title: const Text(
              "어울리는 활동 추천",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
      backgroundColor: kLightGray,
      body: Padding(
        padding: EdgeInsets.only(top: 20, right: 32, left: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(thickness: 1.2, color: Color(0xFFE0E0E0)),

            _buildScoreBars(),
            const Divider(thickness: 1.2, color: Color(0xFFE0E0E0)),

            const SizedBox(height: 15),
            const Text(
              "활동 리스트",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 15),

            // 활동 리스트
            ...List.generate(activities.length, (i) {
              final selected = selectedIndex == i;
              return GestureDetector(
                onTap: () async {
                  if (_isAnimating || selectedIndex == i) return;
                  _isAnimating = true;

                  // 카드 내려감
                  await _animationController.reverse(from: 1.0);
                  setState(() => selectedIndex = i);

                  // 새 카드 올라감
                  await _animationController.forward(from: 0.0);
                  _isAnimating = false;
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 14,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFFFF4F4)
                        : Colors.grey[200],
                    border: Border.all(
                      color: selected ? kBrandRed : Colors.transparent,
                      width: 1.2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    activities[i],
                    style: TextStyle(
                      color: selected ? kBrandRed : Colors.grey.shade800,
                      fontWeight: selected
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),

            // 애니메이션 카드
            Expanded(
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.75, // 👈 화면의 90%만 차지
                  child: SlideTransition(
                    position: _animation,
                    child: _buildTutorialCard(
                      activities[selectedIndex],
                      List<String>.from(
                        data["tutorials"][activities[selectedIndex]] ?? [],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        ...scores.entries.map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: 70,
                  child: Text(
                    _translateTrait(e.key),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: e.value / 15.0,
                        child: Container(
                          height: 8,
                          decoration: BoxDecoration(
                            color: kBrandRed,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text("${((e.value / 15.0) * 100).round()}%"),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _translateTrait(String key) {
    switch (key) {
      case 'creativity':
        return '창의성';
      case 'challenge':
        return '도전성';
      case 'focus':
        return '집중력';
      case 'emotion_logic':
        return '감성/논리';
      case 'execution':
        return '실행력';
      default:
        return key;
    }
  }

  Widget _buildTutorialCard(String title, List<String> list) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.only(top: 30, left: 25, right: 25, bottom: 13),
      decoration: BoxDecoration(
        color: kBrandRed,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16), // 위쪽만 둥글게
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "오늘은 이거 어때요?",
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          ...list.map(
            (t) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                "• $t",
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
