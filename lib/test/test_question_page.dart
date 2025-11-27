import 'package:brandme/test/test_result_page.dart';
import 'package:flutter/material.dart';

const Color kBrandRed = Color(0xFFBB271A);

const String TRAIT_CREATIVITY = 'creativity';
const String TRAIT_CHALLENGE = 'challenge';
const String TRAIT_FOCUS = 'focus';
const String TRAIT_EMOTION_LOGIC = 'emotion_logic';
const String TRAIT_EXECUTION = 'execution';

class AnswerOption {
  final String text;
  final String trait;

  AnswerOption({required this.text, required this.trait});
}

class Question {
  final String text;
  final List<AnswerOption> options;

  Question({required this.text, required this.options});
}

final List<Question> brandTestQuestions = [
  Question(
    text: '새로운 프로젝트를\n맡았을 때 나는?',
    options: [
      AnswerOption(text: '바로 시작해본다', trait: TRAIT_EXECUTION),
      AnswerOption(text: '계획부터 세운다', trait: TRAIT_FOCUS),
      AnswerOption(text: '주변 의견을 듣는다', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '새로운 시도를 해본다', trait: TRAIT_CHALLENGE),
    ],
  ),
  Question(
    text: '아이디어가 떠오를 때 나는?',
    options: [
      AnswerOption(text: '머릿속으로 그려본다', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '바로 메모한다', trait: TRAIT_FOCUS),
      AnswerOption(text: '사람들과 나눈다', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '바로 실행한다', trait: TRAIT_EXECUTION),
    ],
  ),
  Question(
    text: '주어진 과제가 너무 어렵다면?',
    options: [
      AnswerOption(text: '일단 도전해본다', trait: TRAIT_CHALLENGE),
      AnswerOption(text: '원인을 분석하고 쪼갠다', trait: TRAIT_FOCUS),
      AnswerOption(text: '다른 접근법을 떠올린다', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '도움을 요청한다', trait: TRAIT_EMOTION_LOGIC),
    ],
  ),
  Question(
    text: '중요한 결정을 앞두고 나는?',
    options: [
      AnswerOption(text: '감에 따라 결정한다', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '데이터와 근거를 모은다', trait: TRAIT_FOCUS),
      AnswerOption(text: '새로운 선택지를 만들어본다', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '한 번 정하면 밀어붙인다', trait: TRAIT_EXECUTION),
    ],
  ),
  Question(
    text: '팀 프로젝트에서 나는 주로?',
    options: [
      AnswerOption(text: '아이디어를 쏟아낸다', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '분위기를 만든다', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '실행을 주도한다', trait: TRAIT_EXECUTION),
      AnswerOption(text: '전체 계획을 세운다', trait: TRAIT_FOCUS),
    ],
  ),
  Question(
    text: '시간에 쫓길 때 나는?',
    options: [
      AnswerOption(text: '우선순위를 빠르게 정한다', trait: TRAIT_FOCUS),
      AnswerOption(text: '일단 시작하고 보며 조정한다', trait: TRAIT_EXECUTION),
      AnswerOption(text: '새로운 단축 방법을 찾는다', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '주변과 조율하며 진행한다', trait: TRAIT_EMOTION_LOGIC),
    ],
  ),
  Question(
    text: '실패했을 때 나는?',
    options: [
      AnswerOption(text: '원인을 분석해 기록한다', trait: TRAIT_FOCUS),
      AnswerOption(text: '다시 도전할 방법을 찾는다', trait: TRAIT_CHALLENGE),
      AnswerOption(text: '스스로를 위로하고 정리한다', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '다른 시도를 떠올린다', trait: TRAIT_CREATIVITY),
    ],
  ),
  Question(
    text: '아이디어 회의 중 나는?',
    options: [
      AnswerOption(text: '다양한 시도를 제안한다', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '모두의 의견을 정리한다', trait: TRAIT_FOCUS),
      AnswerOption(text: '팀 분위기를 올린다', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '당장 해볼 것을 정한다', trait: TRAIT_EXECUTION),
    ],
  ),
  Question(
    text: '나에게 더 중요한 것은?',
    options: [
      AnswerOption(text: '새로운 시도와 도전', trait: TRAIT_CHALLENGE),
      AnswerOption(text: '완성도 있는 결과물', trait: TRAIT_FOCUS),
      AnswerOption(text: '나만의 색과 개성', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '함께하는 사람들', trait: TRAIT_EMOTION_LOGIC),
    ],
  ),
  Question(
    text: '새로운 기술을\n접했을 때 나는?',
    options: [
      AnswerOption(text: '바로 써보면서 익힌다', trait: TRAIT_EXECUTION),
      AnswerOption(text: '공부부터 차근차근 한다', trait: TRAIT_FOCUS),
      AnswerOption(text: '어디에 응용할지 떠올린다', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '필요성과 효율을 따져본다', trait: TRAIT_EMOTION_LOGIC),
    ],
  ),
  Question(
    text: '의견 충돌이 생기면?',
    options: [
      AnswerOption(text: '논리적으로 설득한다', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '새로운 타협안을 찾는다', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '상대의 입장을 먼저 듣는다', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '결단을 내려 정리한다', trait: TRAIT_EXECUTION),
    ],
  ),
  Question(
    text: '목표를 달성한 후 나는?',
    options: [
      AnswerOption(text: '다음 목표를 바로 설정한다', trait: TRAIT_CHALLENGE),
      AnswerOption(text: '과정을 복기하고 정리한다', trait: TRAIT_FOCUS),
      AnswerOption(text: '주변 사람들과 나눈다', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '새로운 아이디어를 구상한다', trait: TRAIT_CREATIVITY),
    ],
  ),
  Question(
    text: '하루를 마무리할 때 나는?',
    options: [
      AnswerOption(text: '오늘을 감정적으로 정리한다', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '내일의 계획을 세운다', trait: TRAIT_FOCUS),
      AnswerOption(text: '새로운 영감을 찾는다', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '다음 도전을 상상한다', trait: TRAIT_CHALLENGE),
    ],
  ),
  Question(
    text: '나에게 “일”은?',
    options: [
      AnswerOption(text: '나를 표현하는 무대', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '성취감을 느끼는 수단', trait: TRAIT_EXECUTION),
      AnswerOption(text: '사람들과 연결되는 통로', trait: TRAIT_EMOTION_LOGIC),
      AnswerOption(text: '문제를 해결하는 과정', trait: TRAIT_FOCUS),
    ],
  ),
  Question(
    text: '변화 앞에서 나는?',
    options: [
      AnswerOption(text: '두렵지만 시도해본다', trait: TRAIT_CHALLENGE),
      AnswerOption(text: '일단 정보를 수집한다', trait: TRAIT_FOCUS),
      AnswerOption(text: '새로운 기회를 떠올린다', trait: TRAIT_CREATIVITY),
      AnswerOption(text: '주변 사람들과 상의한다', trait: TRAIT_EMOTION_LOGIC),
    ],
  ),
];

class BrandTestQuestionPage extends StatefulWidget {
  const BrandTestQuestionPage({super.key});

  @override
  State<BrandTestQuestionPage> createState() => _BrandTestQuestionPageState();
}

class _BrandTestQuestionPageState extends State<BrandTestQuestionPage> {
  int currentIndex = 0;
  int? selectedIndex;
  final Map<String, int> scores = {
    TRAIT_CREATIVITY: 0,
    TRAIT_CHALLENGE: 0,
    TRAIT_FOCUS: 0,
    TRAIT_EMOTION_LOGIC: 0,
    TRAIT_EXECUTION: 0,
  };

  void _onNext() {
    if (selectedIndex == null) return;
    final currentQuestion = brandTestQuestions[currentIndex];
    final selectedOption = currentQuestion.options[selectedIndex!];

    scores[selectedOption.trait] = (scores[selectedOption.trait] ?? 0) + 1;

    if (currentIndex == brandTestQuestions.length - 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => BrandTestResultPage(scores: scores)),
      );
    } else {
      setState(() {
        currentIndex++;
        selectedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = brandTestQuestions[currentIndex];
    final totalSteps = brandTestQuestions.length;
    final step = currentIndex + 1;
    final progress = step / totalSteps;

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
                        'STEP $step',
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
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        kBrandRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 80),
            const Text(
              'Q',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 26),
              child: Text(
                question.text.replaceAll(r'\n', '\n'), // 문자열로 읽힌 경우 대비
                textAlign: TextAlign.center,
                softWrap: true, // ✅ 줄바꿈 허용
                maxLines: 3, // ✅ 혹시 길어도 3줄까지 표시

                style: const TextStyle(
                  fontSize: 20,
                  height: 1.5,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF202123),
                ),
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                itemCount: question.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isSelected = selectedIndex == index;
                  return GestureDetector(
                    onTap: () => setState(() => selectedIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 13,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFFFF0EE)
                            : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? kBrandRed : Colors.transparent,
                          width: 1.5,
                        ),
                      ),
                      child: Text(
                        option.text,
                        style: TextStyle(
                          color: const Color(0xFF202123),
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 150, left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ⬅️ 이전 버튼
                  if (currentIndex > 0)
                    SizedBox(
                      width: 100,
                      height: 45,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: kBrandRed),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            currentIndex--;
                            selectedIndex = null; // ✅ 이전 문항으로 돌아가면 선택 초기화
                          });
                        },
                        child: const Text(
                          '이전',
                          style: TextStyle(
                            color: kBrandRed,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  if (currentIndex > 0) const SizedBox(width: 20),

                  // ➡️ 다음 버튼
                  SizedBox(
                    width: 100,
                    height: 45,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedIndex == null
                            ? Colors.grey
                            : kBrandRed,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      onPressed: selectedIndex == null ? null : _onNext,
                      child: Text(
                        step == totalSteps ? '완료' : '다음',

                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
