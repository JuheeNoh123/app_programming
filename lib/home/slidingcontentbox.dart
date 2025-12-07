import 'package:brandme/widget/activity.dart';
import 'package:brandme/home/checklist.dart';
import 'package:brandme/widget/jobpage.dart';
import 'package:brandme/widget/palette.dart';
import 'package:brandme/widget/strategy.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:brandme/home/infocard.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';

//메인 페이지 ai 추천+브랜딩 기록 하얀 컨테이너 박스 내부
class SlidingContentBox extends StatefulWidget {
  const SlidingContentBox({super.key});

  @override
  State<SlidingContentBox> createState() => _SlidingContentBoxState();
}

class _SlidingContentBoxState extends State<SlidingContentBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  bool _showChecklist = false;
  int _selectedTab = 0; // 0 = AI 추천, 1 = 브랜딩 기록
  int _missionCnt = 0;
  int _activityCnt = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 450),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 1.0), // 화면 아래
      end: const Offset(0, 0), // 제자리
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(const Duration(milliseconds: 150), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleChecklist() async {
    setState(() {
      _showChecklist = !_showChecklist;
    });

    // ✅ 체크리스트에서 돌아올 때 개수 다시 갱신
    if (!_showChecklist) {
      debugPrint("[SlidingContentBox] 체크리스트 닫힘 → 개수 다시 읽기");
      await _loadChecklistCounts(); // rebuild → FutureBuilder 다시 실행됨
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Stack(
        children: [
          // 기본 콘텐츠 (AI 추천 / 브랜딩 기록)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            left: _showChecklist ? -MediaQuery.of(context).size.width : 0,
            right: _showChecklist ? MediaQuery.of(context).size.width : 0,
            child: _mainContent(context),
          ),

          // 체크리스트 화면
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOutCubic,
            left: _showChecklist ? 0 : MediaQuery.of(context).size.width,
            child: ChecklistTab(onBack: _toggleChecklist),
          ),
        ],
      ),
    );
  }

  Widget _mainContent(BuildContext context) {
    return Container(
      //width: double.infinity,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.only(right: 5, left: 5, top: 15),
      decoration: const BoxDecoration(
        color: Color(0xFFFBFBFB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),

      child: Column(
        children: [
          // 탭 메뉴
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _topTab("AI 추천", 0),

                const SizedBox(width: 30), // 탭 간격 크게 조절 (사진 느낌)
                _topTab("브랜딩 기록", 1),
              ],
            ),
          ),

          const SizedBox(height: 5),

          // 탭 컨텐츠 ai추천/브랜딩기록
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: _selectedTab == 0 ? _aiContent() : brandingContent(),
            ),
          ),
        ],
      ),
    );
  }

  // 탭 버튼 위젯
  Widget _topTab(String title, int index) {
    final isSelected = _selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),

      child: SizedBox(
        width: 140,
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Color(0xFF202123) : Colors.grey,
              ),
            ),
            if (isSelected)
              Container(
                margin: const EdgeInsets.only(top: 5),
                width: 120,
                height: 5,
                color: const Color(0xFFBB271A),
              ),
          ],
        ),
      ),
    );
  }

  // AI 추천 UI
  Widget _aiContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  activityCard(),
                  const SizedBox(height: 18),
                  jobCard(),
                ],
              ),
            ),
            const SizedBox(width: 18),

            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 60),

                  growthCard(),
                  const SizedBox(height: 18),

                  paletteCard(),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 브랜딩 기록 UI
  Widget brandingContent() {
    return Align(
      alignment: Alignment.topCenter,
      child: SingleChildScrollView(
        //padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                // 이번 달 브랜드 변화
                const Text(
                  "이번 달 브랜드 변화",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 13),
                Container(
                  height: 140,
                  width: 160,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  // child: Center(
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       const Icon(
                  //         Icons.trending_up,
                  //         color: Color(0xFFBB271A),
                  //         size: 28,
                  //       ),
                  //       const SizedBox(width: 8),
                  //       const Text(
                  //         "브랜드 지수",
                  //         style: TextStyle(
                  //           fontWeight: FontWeight.bold,
                  //           fontSize: 16,
                  //           color: Color(0xFFBB271A),
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1200),
                      curve: Curves.easeInOutCubic,
                      builder: (context, animationValue, child) {
                        return LineChart(
                          LineChartData(
                            gridData: FlGridData(show: false),
                            titlesData: FlTitlesData(show: false),
                            borderData: FlBorderData(
                              show: true,
                              border: const Border(
                                bottom: BorderSide(
                                  color: Colors.black87,
                                  width: 1,
                                ),
                                left: BorderSide(
                                  color: Colors.black87,
                                  width: 1,
                                ),
                              ),
                            ),
                            minX: 0,
                            maxX: 5,
                            minY: 0,
                            maxY: 10,
                            lineBarsData: [
                              LineChartBarData(
                                spots: _animatedSpots(animationValue),
                                isCurved: false, // ❗꺾은선 그래프 유지
                                color: const Color(0xFFBB271A),
                                barWidth: 2.5,
                                isStrokeCapRound: true,
                                dotData: FlDotData(show: false),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 30),
                InfoCard(
                  title: "성장 기록",
                  subtitle: "강점 : 실행력\n약점 : 감성/논리",
                  items: ["⭐브랜드 슬로건", "# 빠른 실행", "# 꾸준 중심", "# 문제 해결"],
                  dark: true,
                ),
                SizedBox(height: 100),
              ],
            ),

            Column(
              children: [
                SizedBox(height: 10),
                const Text(
                  "",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                //const SizedBox(height: 10),
                SizedBox(
                  height: 160,
                  width: 155,

                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        const Text.rich(
                          TextSpan(
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 15,
                            ),
                            children: [
                              TextSpan(text: "도전성 "),
                              TextSpan(
                                text: "+3",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: "   집중력 "),
                              TextSpan(
                                text: "-2",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(text: "   \n창의성 "),
                              TextSpan(
                                text: "+1",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFBB271A),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 10,
                              ),
                            ),
                            child: const Text(
                              "월간 리포트 보기",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // 성장 기록 & 미션 활동 카드
                InfoCard(
                  title: "미션/활동",
                  subtitle: "오늘의 미션 확인하기",
                  items: ["최근 실행한 미션", "최근 완료한 활동"],
                  dark: true,
                  showArrow: true,
                  onArrowPressed: _toggleChecklist,
                  missionCount: _missionCnt,
                  activityCount: _activityCnt,
                ),

                SizedBox(height: 100),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// ⚙️ 애니메이션에 따라 점을 부드럽게 보간
  List<FlSpot> _animatedSpots(double t) {
    final base = [
      const FlSpot(0, 3),
      const FlSpot(1, 5),
      const FlSpot(2, 4),
      const FlSpot(3, 7),
      const FlSpot(4, 6),
      const FlSpot(5, 8),
    ];

    final count = (base.length * t).clamp(1, base.length).toInt();
    return base.take(count).toList();
  }

  Future<void> _loadChecklistCounts() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString("userName");
    if (userName == null) return;

    final missionData = prefs.getString("missionItems_$userName");
    final activityData = prefs.getString("activityItems_$userName");

    int missionCnt = 0;
    int activityCnt = 0;

    if (missionData != null) {
      final decoded = json.decode(missionData);
      if (decoded is List) {
        missionCnt = decoded.where((e) => e is Map && e["done"] == true).length;
      }
    }

    if (activityData != null) {
      final decoded = json.decode(activityData);
      if (decoded is List) {
        activityCnt = decoded
            .where((e) => e is Map && e["done"] == true)
            .length;
      }
    }

    debugPrint("[SlidingContentBox] 완료된 미션: $missionCnt, 활동: $activityCnt");

    // ✅ 전역 변수 업데이트
    setState(() {
      _missionCnt = missionCnt;
      _activityCnt = activityCnt;
    });
  }

  //활동
  Widget activityCard() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        final resultType = prefs.getString('brandme_result_type');
        final scoreJson = prefs.getString('brandme_result_scores');

        if (resultType == null || scoreJson == null) {
          // ❗ 테스트 결과가 없으면 Snackbar 표시 + 이동 차단
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("아직 테스트 결과가 없습니다."),
              backgroundColor: const Color(0xFF3B2F2F),
              behavior: SnackBarBehavior.floating,
              //margin: const EdgeInsets.only(bottom: 70, left: 20, right: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }

        // ✅ 테스트 결과가 있으면 페이지 이동
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ActivityPage()),
        );
      },
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          color: const Color(0xFFBB271A),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: 18,
              bottom: 18,
              child: const Text(
                "어울리는\n활동 추천",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFBFBFB),
                  height: 1.3,
                  letterSpacing: 1,
                ),
              ),
            ),
            Positioned(
              right: -30,
              top: 5,
              child: Image.asset(
                "assets/activity.png",
                width: 150,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //성장전략
  Widget growthCard() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () async {
        final prefs = await SharedPreferences.getInstance();
        final resultType = prefs.getString('brandme_result_type');

        if (resultType == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("아직 테스트 결과가 없습니다."),
              backgroundColor: const Color(0xFF3B2F2F),
              behavior: SnackBarBehavior.floating,
              //margin: const EdgeInsets.only(bottom: 70, left: 20, right: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              duration: const Duration(seconds: 2),
            ),
          );
          return;
        }

        // push로 페이지 띄우기 (bottom bar 유지됨)
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StrategyPage(resultType: resultType),
          ),
        );
      },
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          color: Color(0xFF202123),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: 18,
              top: 18,
              child: const Text(
                "나에게 맞는\n성장 전략",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFBFBFB),
                  height: 1.3,
                  letterSpacing: 1,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 5,
              child: Image.asset(
                "assets/strategy.png",
                width: 140,
                height: 140,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //직업추천
  Widget jobCard() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const JobPage()),
        );
      },
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          color: Color(0xFFFBFBFB),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.5),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: 18,
              top: 18,
              child: const Text(
                "브랜드 타입\n기반 직업 추천",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202123),
                  height: 1.2,
                  letterSpacing: 1,
                ),
              ),
            ),
            Positioned(
              right: -20,
              bottom: -40,
              child: Image.asset("assets/job.png", width: 200, height: 200),
            ),
          ],
        ),
      ),
    );
  }

  //팔레트
  Widget paletteCard() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PalettePage()),
        );
      },
      child: Container(
        height: 230,
        decoration: BoxDecoration(
          color: const Color(0xFFBB271A),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(40, 0, 0, 0.5),
              blurRadius: 14,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.hardEdge,
          children: [
            Positioned(
              left: 18,
              top: 18,
              child: const Text(
                "브랜드 팔레트\n& 아이덴티티",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFBFBFB),
                  height: 1.2,
                  letterSpacing: 1,
                ),
              ),
            ),
            Positioned(
              right: -50,
              bottom: -30,
              child: Image.asset("assets/palette.png", width: 220, height: 220),
            ),
          ],
        ),
      ),
    );
  }
}
