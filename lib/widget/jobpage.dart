import 'package:flutter/material.dart';

enum JobType { backend, frontend, ai }

const Color kBrandRed = Color(0xFFBB271A);
const Color kLightGray = Color(0xFFFBFBFB);
const Color kBgDark = Color(0xFF202123);

class JobPage extends StatefulWidget {
  const JobPage({super.key});

  @override
  State<JobPage> createState() => _JobPageState();
}

class _JobPageState extends State<JobPage> with SingleTickerProviderStateMixin {
  JobType selectedJob = JobType.backend;
  late TabController _tabController;
  String get jobTitle {
    switch (selectedJob) {
      case JobType.backend:
        return "백엔드 개발자";
      case JobType.frontend:
        return "프론트엔드 개발자";
      case JobType.ai:
        return "AI 직무";
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              "브랜드 타입 기반 직업 추천",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: kBrandRed,
        elevation: 8,
        shape: const CircleBorder(),
        onPressed: () {
          // TODO: PDF 내보내기 로직
        },
        child: Image.asset(
          "assets/Export Pdf.png",
          width: 30,
          height: 30,
          color: Colors.white, // 흰색으로 통일 (필요 없으면 제거)
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(right: 22, left: 22, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 추천 직업 카드
              const Text(
                "추천 직업 카드",
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 160,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _jobCard(
                      title: "백엔드 개발자",
                      selected: selectedJob == JobType.backend,
                      color: selectedJob == JobType.backend
                          ? kBrandRed
                          : const Color.fromARGB(255, 250, 232, 232),
                      onTap: () {
                        setState(() {
                          selectedJob = JobType.backend;
                        });
                      },
                      imagePath: "assets/backend.png",
                    ),
                    _jobCard(
                      title: "프론트엔드\n개발자",
                      selected: selectedJob == JobType.frontend,
                      color: selectedJob == JobType.frontend
                          ? kBrandRed
                          : const Color.fromARGB(255, 250, 232, 232),
                      onTap: () {
                        setState(() {
                          selectedJob = JobType.frontend;
                        });
                      },
                      imagePath: "assets/frontend.png",
                    ),
                    _jobCard(
                      title: "AI 직무",
                      selected: selectedJob == JobType.ai,
                      color: selectedJob == JobType.ai
                          ? kBrandRed
                          : const Color.fromARGB(255, 250, 232, 232),
                      onTap: () {
                        setState(() {
                          selectedJob = JobType.ai;
                        });
                      },
                      imagePath: "assets/backend.png",
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: jobTitle,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: kBrandRed, // 직무는 기존 레드
                      ),
                    ),
                    const TextSpan(
                      text: "   브랜딩 키트",
                      style: TextStyle(
                        fontSize: 14, // 🔽 조금 더 작게
                        fontWeight: FontWeight.bold,
                        color: kBgDark, // 🔽 검정색
                      ),
                    ),
                  ],
                ),
              ),

              /// 탭
              TabBar(
                controller: _tabController,
                labelColor: kBrandRed,
                unselectedLabelColor: Colors.grey,
                indicatorColor: kBrandRed,
                tabs: const [
                  Tab(text: "맞춤 이미지"),
                  Tab(text: "포트폴리오"),
                  Tab(text: "스킬 & 강점"),
                ],
              ),

              const SizedBox(height: 16),

              /// 탭 내용
              SizedBox(
                height: 420,
                child: TabBarView(
                  controller: _tabController,
                  children: [_imageTab(), _portfolioTab(), _skillTab()],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ----------------------------
  /// 위젯 분리
  /// ----------------------------

  Widget _jobCard({
    required String title,
    required bool selected,
    required Color color,
    required VoidCallback onTap,
    required String imagePath,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: selected
              ? [BoxShadow(color: color.withOpacity(0.3), blurRadius: 8)]
              : [],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// 🔹 직무 이미지

              /// 🔹 직무 이름
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: selected ? Colors.white : Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              Image.asset(imagePath, height: 64, fit: BoxFit.contain),
            ],
          ),
        ),
      ),
    );
  }

  /// 맞춤 이미지 탭
  Widget _imageTab() {
    switch (selectedJob) {
      case JobType.backend:
        return Padding(
          padding: const EdgeInsets.only(right: 5.0, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "나의 핵심 키워드",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: kBgDark,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _KeywordCard(
                    title: "구조 중심",
                    desc: "길보다\n구조와 본질을\n다루는 타입",
                    tag: "#신뢰감\n#정확함",
                  ),
                  _KeywordCard(
                    title: "실행 중심",
                    desc: "새로운 것을\n빠르게 시험하고\n개선하는 스타일",
                    tag: "#빠른실행\n#도전성",
                  ),
                  _KeywordCard(
                    title: "조용한 해결사",
                    desc: "보이지 않는\n곳에서 안정성을\n완성하는 사람",
                    tag: "#집중력\n#문제해결",
                  ),
                ],
              ),

              SizedBox(height: 30),
              _BrandSummaryCard(
                color: kBgDark,
                title: "🏷️해당 직무에 어울리는 나의 브랜드 이미지",
                points: const [
                  "보이는 기능보다 시스템의 본질을 설계하는 사람",
                  "조용하지만 끝까지 책임지는 실행형 개발자",
                  "안정성과 신뢰를 우선으로 만드는 타입",
                  "빠르게 시도하고 개선하는 실전형 스타일",
                ],
              ),
            ],
          ),
        );
      case JobType.frontend:
        return Padding(
          padding: const EdgeInsets.only(right: 5.0, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "나의 핵심 키워드",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: kBgDark,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _KeywordCard(
                    title: "경험 중심",
                    desc: "사용자의\n행동과 흐름을\n먼저 생각하는 타입",
                    tag: "#사용자중심\n#공감력",
                  ),

                  _KeywordCard(
                    title: "시각적 완성도",
                    desc: "작은 디테일까지\n신경 쓰는\n디자인 감각",
                    tag: "#UI감각\n#디테일",
                  ),

                  _KeywordCard(
                    title: "협업 연결자",
                    desc: "디자인과 개발\n사이를 잇는\n커뮤니케이터",
                    tag: "#협업\n#소통",
                  ),
                ],
              ),

              SizedBox(height: 30),
              _BrandSummaryCard(
                color: kBgDark,
                title: "🏷️해당 직무에 어울리는 나의 브랜드 이미지",
                points: const [
                  "사용자의 행동 흐름을 기준으로 화면을 설계하는 사람",
                  "보이는 완성도와 사용성을 동시에 고민하는 개발자",
                  "디자이너와 개발 사이를 자연스럽게 연결하는 타입",
                  "작은 불편도 놓치지 않고 개선하는 UX 중심 스타일",
                ],
              ),
            ],
          ),
        );

      case JobType.ai:
        return Padding(
          padding: const EdgeInsets.only(right: 5.0, left: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "나의 핵심 키워드",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: kBgDark,
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _KeywordCard(
                    title: "문제 정의",
                    desc: "데이터와 목적을\n명확히 설정하는\n분석형 사고",
                    tag: "#문제해결\n#논리",
                  ),

                  _KeywordCard(
                    title: "실험 중심",
                    desc: "가설을 세우고\n결과로 검증하는\n연구 스타일",
                    tag: "#실험\n#검증",
                  ),

                  _KeywordCard(
                    title: "해석 능력",
                    desc: "모델 결과를\n이해하고 설명하는\n역량",
                    tag: "#모델이해\n#해석력",
                  ),
                ],
              ),

              SizedBox(height: 30),
              _BrandSummaryCard(
                color: kBgDark,
                title: "🏷️해당 직무에 어울리는 나의 브랜드 이미지",
                points: const [
                  "데이터와 문제를 함께 바라보는 분석형 인재",
                  "모델 성능보다 ‘왜 이런 결과가 나왔는지’를 설명하는 사람",
                  "실험 설계와 비교를 통해 근거를 만드는 타입",
                  "기술을 목적에 맞게 사용하는 현실적인 AI 스타일",
                ],
              ),
            ],
          ),
        );
    }
  }

  /// 포트폴리오 탭
  Widget _portfolioTab() {
    switch (selectedJob) {
      case JobType.backend:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 1️⃣ 안내 문구
              const Text(
                "나의 강점을 포트폴리오로 구성해보세요!",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 131, 131, 131),
                ),
              ),

              const SizedBox(height: 16),

              /// 2️⃣ 나의 브랜드 문구
              const Text(
                "나의 개발 브랜드 무드",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kBgDark,
                    ),
                    children: [
                      TextSpan(text: "“"),
                      TextSpan(
                        text: "실행력",
                        style: TextStyle(color: kBrandRed),
                      ),
                      TextSpan(text: "과 "),
                      TextSpan(
                        text: "문제 해결",
                        style: TextStyle(color: kBrandRed),
                      ),
                      TextSpan(text: "을 기반으로 시스템을 "),
                      TextSpan(
                        text: "안정시키는",
                        style: TextStyle(color: kBrandRed),
                      ),
                      TextSpan(text: "\n백엔드 개발자”"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// 3️⃣ 포트폴리오 구성 전략
              const Text(
                "포트폴리오 구성 전략",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100, // ⭐ 회색 박스
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: const [
                    _CheckItem("빠르게 만들고 개선하는 흐름 강조"),
                    SizedBox(height: 6),
                    _CheckItem("구조·아키텍처를 명확하게 표현"),
                    SizedBox(height: 6),
                    _CheckItem("문제 해결 과정 위주로 서술"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 4️⃣ 예시 프로젝트 구성
              const Text(
                "예시 프로젝트 구성",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _TimelineItem(text: "Intro : 나의 역할 + 기술 철학"),
                    SizedBox(height: 6),
                    _TimelineItem(text: "Architecture : 간단 설계도 + 선택 이유"),
                    SizedBox(height: 6),
                    _TimelineItem(text: "Core Logic : 백엔드 로직 중심 설명"),
                    SizedBox(height: 6),
                    _TimelineItem(
                      text: "Problem Solving : 실제 해결 사례",
                      isLast: true, // ⭐ 마지막
                    ),
                  ],
                ),
              ),
            ],
          ),
        );

      case JobType.frontend:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 1️⃣ 안내 문구
              const Text(
                "나의 강점을 포트폴리오로 구성해보세요!",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 131, 131, 131),
                ),
              ),

              const SizedBox(height: 16),

              /// 2️⃣ 나의 브랜드 문구
              const Text(
                "나의 개발 브랜드 무드",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kBgDark, // 기본 색상
                    ),
                    children: [
                      TextSpan(text: "“"),
                      TextSpan(
                        text: "사용자 경험",
                        style: TextStyle(color: kBrandRed),
                      ),
                      TextSpan(text: "과 "),
                      TextSpan(
                        text: "시각적 완성도",
                        style: TextStyle(color: kBrandRed),
                      ),
                      TextSpan(text: "를 함께 만드는\n프론트엔드 개발자”"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// 3️⃣ 포트폴리오 구성 전략
              const Text(
                "포트폴리오 구성 전략",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100, // ⭐ 회색 박스
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: const [
                    _CheckItem("사용자 흐름과 인터랙션 중심 구성"),
                    SizedBox(height: 6),
                    _CheckItem("UI/UX 개선 전후 비교 강조"),
                    SizedBox(height: 6),
                    _CheckItem("디자인 협업 과정과 의사결정 설명"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 4️⃣ 예시 프로젝트 구성
              const Text(
                "예시 프로젝트 구성",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _TimelineItem(text: "Intro : 사용자 문제 정의"),
                    SizedBox(height: 6),
                    _TimelineItem(text: "UX Flow : 화면 흐름 & 설계 의도"),
                    SizedBox(height: 6),
                    _TimelineItem(text: "UI 구현 : 컴포넌트 구조 설명"),
                    SizedBox(height: 6),
                    _TimelineItem(
                      text: "Improvement : 사용성 개선 사례",
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      case JobType.ai:
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 1️⃣ 안내 문구
              const Text(
                "나의 강점을 포트폴리오로 구성해보세요!",
                style: TextStyle(
                  fontSize: 10,
                  color: Color.fromARGB(255, 131, 131, 131),
                ),
              ),

              const SizedBox(height: 16),

              /// 2️⃣ 나의 브랜드 문구
              const Text(
                "나의 개발 브랜드 무드",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: kBgDark, // 기본 텍스트 색
                    ),
                    children: [
                      TextSpan(text: "“문제를 "),
                      TextSpan(
                        text: "정의",
                        style: TextStyle(color: kBrandRed),
                      ),
                      TextSpan(text: "하고 실험으로 "),
                      TextSpan(
                        text: "검증",
                        style: TextStyle(color: kBrandRed),
                      ),
                      TextSpan(text: "하는 AI 개발자”"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              /// 3️⃣ 포트폴리오 구성 전략
              const Text(
                "포트폴리오 구성 전략",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100, // ⭐ 회색 박스
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: const [
                    _CheckItem("문제 정의 → 가설 → 실험 흐름 명확화"),
                    SizedBox(height: 6),
                    _CheckItem("모델 선택 이유와 비교 실험 강조"),
                    SizedBox(height: 6),
                    _CheckItem("결과 해석과 한계점 정리"),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              /// 4️⃣ 예시 프로젝트 구성
              const Text(
                "예시 프로젝트 구성",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _TimelineItem(text: "Intro : 문제 정의 & 목표 설정"),
                    _TimelineItem(text: "Dataset : 데이터 구성 및 특성"),
                    _TimelineItem(text: "Model & Experiment : 모델 선택과 실험"),
                    _TimelineItem(
                      text: "Result & Analysis : 결과 해석",
                      isLast: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }

  Widget _skillTab() {
    switch (selectedJob) {
      case JobType.backend:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              "강점 기반 스킬 분석",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),

            _SkillStrengthCard(
              title: "UI 설계",
              points: ["컴포넌트 단위 UI 구성", "재사용성과 확장성 고려"],
            ),

            _SkillStrengthCard(
              title: "UX 사고",
              points: ["사용자 행동 기반 개선", "경험 중심 설계"],
            ),

            _SkillStrengthCard(
              title: "디자인 협업",
              points: ["디자이너와 원활한 소통", "의도 해석 능력"],
            ),

            _SkillStrengthCard(
              title: "디테일 감각",
              points: ["작은 불편 요소 발견", "완성도 높은 마감"],
            ),
          ],
        );

      case JobType.frontend:
        return Column(
          children: const [
            _SkillStrengthCard(
              title: "UI 설계",
              points: ["컴포넌트 단위 UI 구성", "재사용성 고려"],
            ),
            _SkillStrengthCard(
              title: "UX 이해",
              points: ["사용자 행동 기반 개선", "경험 중심 설계"],
            ),
          ],
        );

      case JobType.ai:
        return Column(
          children: const [
            _SkillStrengthCard(
              title: "모델 이해",
              points: ["모델 구조와 동작 원리 이해", "선택 근거 설명"],
            ),

            _SkillStrengthCard(
              title: "실험 설계",
              points: ["비교 실험 구성", "하이퍼파라미터 조정"],
            ),

            _SkillStrengthCard(
              title: "결과 해석",
              points: ["수치 기반 분석", "의미 있는 인사이트 도출"],
            ),

            _SkillStrengthCard(
              title: "문제 정의",
              points: ["목표 명확화", "기술 적용 범위 설정"],
            ),
          ],
        );
    }
  }
}

/// ----------------------------
/// 공용 컴포넌트
/// ----------------------------
class _TimelineItem extends StatelessWidget {
  final String text;
  final bool isLast;

  const _TimelineItem({required this.text, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 왼쪽 타임라인 영역
        Column(
          children: [
            // 🔴 빨간 점
            Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: kBrandRed,
                shape: BoxShape.circle,
              ),
            ),

            // 🔴 세로 선 (마지막 항목은 제거)
            if (!isLast) Container(width: 2, height: 26, color: kBrandRed),
          ],
        ),

        const SizedBox(width: 12),

        /// 오른쪽 텍스트
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(text, style: const TextStyle(fontSize: 13)),
          ),
        ),
      ],
    );
  }
}

class _BrandSummaryCard extends StatelessWidget {
  final Color color;
  final String title;
  final List<String> points;

  const _BrandSummaryCard({
    required this.color,
    required this.title,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      // padding: const EdgeInsets.all(16),
      // decoration: BoxDecoration(
      //   color: color.withOpacity(0.08),
      //   borderRadius: BorderRadius.circular(12),
      //   border: Border.all(color: color.withOpacity(0.3)),
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 브랜드 한 줄 요약
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 12),

          /// 브랜드 포인트
          ...points.map(
            (text) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Icon(Icons.circle, size: 6, color: color),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(text, style: const TextStyle(fontSize: 13)),
                  ),
                  //const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _KeywordCard extends StatelessWidget {
  final String title;
  final String desc;
  final String tag;
  const _KeywordCard({
    required this.title,
    required this.desc,
    required this.tag,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 108, // 가로 고정
      height: 160, // 세로 고정
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.only(top: 10, right: 5, left: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade500),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: Color.fromARGB(255, 131, 130, 130),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tag,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _CheckItem extends StatelessWidget {
  final String text;
  const _CheckItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.check, color: kBrandRed, size: 18),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}

class _SkillStrengthCard extends StatelessWidget {
  final String title;
  final List<String> points;

  const _SkillStrengthCard({required this.title, required this.points});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 왼쪽 검은 라벨
          Container(
            width: 90,
            height: 70,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: kBgDark,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(width: 12),
          /// 오른쪽 설명 박스
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: points
                    .map(
                      (text) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("• ", style: TextStyle(fontSize: 14)),
                            Expanded(
                              child: Text(
                                text,
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
