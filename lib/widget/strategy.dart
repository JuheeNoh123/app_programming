import 'package:brandme/main.dart';
import 'package:brandme/widget/strategy_data.dart';
import 'package:flutter/material.dart';

const Color kBrandRed = Color(0xFFBB271A);
const Color kLightGray = Color(0xFFFBFBFB);
const Color kBgDark = Color(0xFF202123);

class StrategyPage extends StatelessWidget {
  final String resultType;
  const StrategyPage({super.key, required this.resultType});

  @override
  Widget build(BuildContext context) {
    final strategy = getStrategy(resultType);

    return Scaffold(
      backgroundColor: kLightGray,
      extendBodyBehindAppBar: false, // AppBar 뒤로 body가 안 겹치게
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
              "나에게 맞는 성장 전략",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 핵심 성장 방향
            const Text(
              "핵심 성장 방향",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF2F2),
                borderRadius: BorderRadius.circular(8),
                //border: Border.all(color: kBrandRed, width: 1),
              ),
              child: buildColoredText(strategy.coreDirection),
            ),

            const SizedBox(height: 25),

            // 지금 바로 실천할 전략
            const Text(
              "지금 바로 실천할 전략",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            ..._buildStrategyCards(strategy.immediateStrategies),

            const SizedBox(height: 25),

            // 장기 성장 로드맵
            const Text(
              "장기 성장 로드맵",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),
            ..._buildRoadmap(
              strategy.longTermRoadmap,
              strategy.longTermDetails,
            ),
          ],
        ),
      ),
      //bottomNavigationBar: const BottomNavController(),
    );
  }

  RichText buildColoredText(String text) {
    // 정규식으로 [ ] 안의 텍스트 추출
    final RegExp regExp = RegExp(r'\[(.*?)\]');
    final matches = regExp.allMatches(text);

    // 기본 텍스트 스타일
    final baseStyle = const TextStyle(
      color: kBgDark,
      fontSize: 15,
      fontWeight: FontWeight.w600,
      height: 1.4,
    );

    // 결과 조립용 리스트
    final spans = <TextSpan>[];
    int lastIndex = 0;

    for (final match in matches) {
      // 대괄호 전 일반 텍스트
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }

      // 대괄호 안 텍스트 (빨간색 강조)
      final highlighted = match.group(1)!;
      spans.add(
        TextSpan(
          text: highlighted,
          style: const TextStyle(color: kBrandRed, fontWeight: FontWeight.bold),
        ),
      );

      lastIndex = match.end;
    }

    // 마지막 부분 남은 일반 텍스트
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return RichText(
      textAlign: TextAlign.left,
      text: TextSpan(style: baseStyle, children: spans),
    );
  }

  // 전략 카드 UI (전략 1~5)
  List<Widget> _buildStrategyCards(List<Map<String, String>> list) {
    return list.asMap().entries.map((entry) {
      final idx = entry.key + 1;
      final title = entry.value.keys.first;
      final detail = entry.value.values.first;

      bool isExpanded = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return Theme(
            data: ThemeData().copyWith(
              dividerColor: Colors.transparent,
            ), // Divider 제거
            child: ExpansionTile(
              visualDensity: const VisualDensity(
                horizontal: 0, // 가로 간격 그대로
                vertical: -2, // 세로 간격 줄이기 (기본 0, 음수로 줄임)
              ),
              tilePadding: const EdgeInsets.symmetric(horizontal: 5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              collapsedShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              // ✅ 상태 토글 아이콘
              trailing: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: Colors.grey,
                size: 20,
              ),
              onExpansionChanged: (expanded) {
                setState(() => isExpanded = expanded);
              },

              // 제목 부분
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF2F2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      "전략 $idx",
                      style: const TextStyle(
                        color: kBrandRed,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // ✅ 펼쳐진 내용 부분
              children: [
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 10, right: 10),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    detail,
                    style: const TextStyle(
                      fontSize: 12,
                      color: kBgDark,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }).toList();
  }

  // 장기 성장 로드맵
  List<Widget> _buildRoadmap(
    List<Map<String, String>> roadmap,
    List<Map<String, String>> details,
  ) {
    return roadmap.asMap().entries.map((entry) {
      final idx = entry.key;
      final title = roadmap[idx].keys.first;
      final desc = roadmap[idx].values.first;
      final detailText = details[idx].values.first;
      bool isExpanded = false;

      return StatefulBuilder(
        builder: (context, setState) {
          return Theme(
            data: ThemeData().copyWith(dividerColor: Colors.transparent),
            child: Container(
              //margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: kLightGray,
                borderRadius: BorderRadius.circular(10),
              ),
              clipBehavior: Clip.hardEdge, // 내부 회색박스가 튀어나오지 않도록
              child: ExpansionTile(
                visualDensity: const VisualDensity(
                  horizontal: 0, // 가로 간격 그대로
                  vertical: -2, // 세로 간격 줄이기 (기본 0, 음수로 줄임)
                ),
                backgroundColor: Colors.transparent,
                collapsedBackgroundColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                collapsedShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                tilePadding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  //vertical: 8,
                ),
                onExpansionChanged: (v) => setState(() => isExpanded = v),
                trailing: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: Colors.grey,
                  size: 20,
                ),

                // 제목줄
                title: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          height: 1.3,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        desc,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  ],
                ),

                // 펼쳐졌을 때 내용
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      top: 4,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      detailText,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: kBgDark,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    }).toList();
  }
}
