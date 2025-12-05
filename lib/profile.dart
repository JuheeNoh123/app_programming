import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kBrandRed = Color(0xFFBB271A);
const Color kBgDark = Color(0xFF202123);

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String userName = "";
  String resultType = "";
  Map<String, int> scores = {};
  List<String> topTags = [];
  List<String> brandGoals = [];
  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();

    final name = prefs.getString("userName") ?? "사용자";
    final type = prefs.getString("brandme_result_type") ?? "";
    final scoreJson = prefs.getString("brandme_result_scores");
    final storedGoals = prefs.getStringList("brand_goals") ?? []; //저장된 목표 불러오기

    // 첫 번째 '\n'은 그대로 두고, 두 번째 '\n'만 공백으로 변환
    final formattedType = type
        .replaceAll(r'\n', '\n') // 실제 줄바꿈으로 변환
        .replaceFirstMapped(RegExp(r'(\n)(.*)\n'), (match) {
          // match[1] = 첫 번째 줄바꿈
          // match[2] = 두 번째 줄 내용
          return '${match[1]}${match[2]} '; // 두 번째 줄바꿈만 공백으로 바꿈
        });
    Map<String, int> loadedScores = {};
    List<String> tags = [];

    if (scoreJson != null) {
      loadedScores = Map<String, int>.from(jsonDecode(scoreJson));
      final sorted = loadedScores.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      tags = sorted.take(3).map((e) => _translateTrait(e.key)).toList();
    }

    setState(() {
      userName = name;
      resultType = formattedType.trim();
      scores = loadedScores;
      topTags = tags;
      brandGoals = storedGoals;
    });
  }

  Future<void> _editBrandGoal() async {
    final controller = TextEditingController();
    final prefs = await SharedPreferences.getInstance();

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              title: const Text("브랜드 목표 관리", style: TextStyle(fontSize: 18)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ✅ 기존 목표 목록 (수정 및 삭제)
                    ...brandGoals.map((goal) {
                      final editController = TextEditingController(text: goal);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            // 수정 가능한 텍스트필드
                            Expanded(
                              child: TextField(
                                controller: editController,
                                style: const TextStyle(fontSize: 14),
                                decoration: const InputDecoration(
                                  //border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    //horizontal: 4,
                                  ),
                                ),
                                onChanged: (val) {
                                  setStateDialog(() {
                                    final idx = brandGoals.indexOf(goal);
                                    brandGoals[idx] = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            // 삭제 버튼
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                setStateDialog(() {
                                  brandGoals.remove(goal);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    }),

                    const Divider(height: 20),
                    // 새 목표 추가 입력창
                    TextField(
                      controller: controller,
                      style: const TextStyle(fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: "새 브랜드 목표 추가...",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("취소"),
                ),
                TextButton(
                  onPressed: () async {
                    // 새 목표 추가
                    if (controller.text.trim().isNotEmpty) {
                      brandGoals.add(controller.text.trim());
                    }
                    // ✅ 저장
                    await prefs.setStringList("brand_goals", brandGoals);
                    setState(() {}); // 메인 화면 갱신
                    Navigator.pop(context);
                  },
                  child: const Text("저장", style: TextStyle(color: kBrandRed)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _translateTrait(String key) {
    switch (key) {
      case 'creativity':
        return '창의형';
      case 'challenge':
        return '도전형';
      case 'focus':
        return '집중형';
      case 'emotion_logic':
        return '감성형';
      case 'execution':
        return '실행형';
      default:
        return key;
    }
  }

  double _percent(String key) {
    if (!scores.containsKey(key)) return 0;
    return (scores[key]! / 15.0) * 100;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      //appBar: AppBar(backgroundColor: const Color(0xFFFBFBFB), elevation: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Profile",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Icon(Icons.settings_outlined, color: Colors.grey),
                  ],
                ),
              ),
              // 프로필 영역
              Row(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          resultType,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          children: topTags
                              .map(
                                (tag) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      255,
                                      240,
                                      239,
                                      239,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: const TextStyle(
                                      color: kBrandRed,
                                      fontSize: 12,
                                      //fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              // 브랜드 목표
              Row(
                children: [
                  const Text(
                    "브랜드 목표",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: _editBrandGoal,
                    child: const Icon(Icons.edit, size: 18, color: kBrandRed),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: brandGoals.map((goal) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Row(
                      children: [
                        const Text(
                          "• ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            goal,
                            style: const TextStyle(fontSize: 14, height: 1.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 35),

              // 브랜드 지수
              const Text(
                "브랜딩 지수",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 20),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 15, // 가로 간격
                runSpacing: 10, // 세로 간격 (줄 간격 줄이기)

                children: [
                  _buildGauge("창의성", _percent("creativity")),
                  _buildGauge("도전성", _percent("challenge")),
                  _buildGauge("집중력", _percent("focus")),
                  _buildGauge("감성/논리", _percent("emotion_logic")),
                  _buildGauge("실행력", _percent("execution")),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGauge(String label, double percent) {
    final p = percent.clamp(0, 100);
    return SizedBox(
      width: 90, // 기존 100 → 90
      height: 90, // 기존 100 → 90
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 70,
            height: 70,
            child: CircularProgressIndicator(
              value: p / 100,
              strokeWidth: 7,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(kBrandRed),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "${p.toInt()}%",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
