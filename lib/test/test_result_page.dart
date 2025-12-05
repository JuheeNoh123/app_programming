import 'dart:convert';
import 'package:brandme/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const Color kBrandRed = Color(0xFFBB271A);
const Color kBgDark = Color(0xFF202123);

String getResultType(Map<String, int> scores) {
  final c = scores['creativity'] ?? 0;
  final ch = scores['challenge'] ?? 0;
  final f = scores['focus'] ?? 0;
  final e = scores['emotion_logic'] ?? 0;
  final ex = scores['execution'] ?? 0;

  // trait별 최고 점수 찾기
  final Map<String, int> scoreMap = {
    'creativity': c,
    'challenge': ch,
    'focus': f,
    'emotion_logic': e,
    'execution': ex,
  };

  final highest = scoreMap.entries
      .reduce((a, b) => a.value >= b.value ? a : b)
      .key;

  switch (highest) {
    case 'challenge':
    case 'execution':
      return '끊임없이\n성장하는 탐험가';
    case 'creativity':
    case 'emotion_logic':
      return '감성적으로\n세상을 해석하는\n크리에이터';
    case 'focus':
      return '논리적으로\n계획하는 전략가';
    default:
      return '감성적으로\n세상을 해석하는\n크리에이터';
  }
}

class BrandTestResultPage extends StatefulWidget {
  final Map<String, int> scores;
  const BrandTestResultPage({super.key, required this.scores});

  @override
  State<BrandTestResultPage> createState() => _BrandTestResultPageState();
}

class _BrandTestResultPageState extends State<BrandTestResultPage> {
  late String resultType;
  late Map<String, double> percentScores;

  @override
  void initState() {
    super.initState();
    resultType = getResultType(widget.scores);
    percentScores = _calculatePercents(widget.scores);
    _saveResult();
  }

  Map<String, double> _calculatePercents(Map<String, int> scores) {
    const maxScore = 15.0;
    return scores.map((key, value) {
      final p = (value / maxScore) * 100;
      return MapEntry(key, p.clamp(0, 100));
    });
  }

  Future<void> _saveResult() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('brandme_result_type', resultType);
    await prefs.setString('brandme_result_scores', jsonEncode(widget.scores));
  }

  String _getResultImage(String type) {
    switch (type) {
      case '끊임없이\n성장하는 탐험가':
        return 'assets/explorer.png';
      case '감성적으로\n세상을 해석하는\n크리에이터':
        return 'assets/creator.png';
      case '논리적으로\n계획하는 전략가':
        return 'assets/strategist.png';
      default:
        return 'assets/explorer.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalSteps = 15;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text(
                        'STEP $totalSteps',
                        style: const TextStyle(
                          color: kBrandRed,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'STEP $totalSteps',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: const LinearProgressIndicator(
                      value: 1.0,
                      minHeight: 6,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(kBrandRed),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 90),
            // 결과 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 90),
              child: Container(
                height: 260,
                decoration: BoxDecoration(
                  color: kBgDark,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 15,
                      child: SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.asset(
                          _getResultImage(resultType),
                          width: 150,
                          height: 150,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 20,
                      child: Text(
                        resultType.replaceAll(r'\n', '\n'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          //height: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),
            // 지표 바
            _traitBar('창의성', percentScores['creativity'] ?? 0),
            _traitBar('도전성', percentScores['challenge'] ?? 0),
            _traitBar('집중력', percentScores['focus'] ?? 0),
            _traitBar('감성/논리', percentScores['emotion_logic'] ?? 0),
            _traitBar('실행력', percentScores['execution'] ?? 0),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 90),
              child: SizedBox(
                width: 200,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kBrandRed),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const BottomNavController(
                          initialIndex: 0,
                        ), // 0: 프로필 탭
                      ),
                      (route) => false, // 이전 스택 모두 제거
                    );
                  },
                  child: const Text(
                    '프로필 보기',
                    style: TextStyle(
                      color: kBrandRed,
                      fontWeight: FontWeight.bold,
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

  Widget _traitBar(String label, double value) {
    final int percent = value.round();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 70,
            child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: percent / 100.0,
                minHeight: 10,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(kBrandRed),
              ),
            ),
          ),
          const SizedBox(width: 15),
          Text(
            '$percent%',
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 165, 163, 163),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
