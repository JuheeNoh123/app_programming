import 'package:brandme/home/checklist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<String> items;
  final bool dark;
  final bool showArrow;
  final VoidCallback? onArrowPressed; // 콜백 추가
  final int missionCount; // 미션/활동용 개수 데이터 (기본값 0)
  final int activityCount;

  const InfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.items,
    this.dark = false,
    this.showArrow = false,
    this.onArrowPressed, // ✅ 생성자에도 추가
    this.missionCount = 0,
    this.activityCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = dark ? const Color(0xFF202123) : Colors.white;
    final textColor = dark ? Colors.white : Colors.black;

    return Container(
          width: 160,
          height: 250,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(2, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 위쪽 내용 (텍스트 그대로 유지)
              Padding(
                padding: const EdgeInsets.all(6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //제목
                    Text(
                      title,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    //부제목
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.8),
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 20),

                    //항목리스트
                    for (var i = 0; i < items.length; i++) ...[
                      Text(
                        items[i],
                        style: TextStyle(
                          color: textColor.withValues(alpha: 0.9),
                          fontSize: 14,
                        ),
                      ),
                      if (title == "미션/활동" && i == 0)
                        Text(
                          "✔️ $missionCount개",
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.7),
                            fontSize: 15,
                          ),
                        ),

                      if (title == "미션/활동" && i == 1)
                        Text(
                          "✔️ $activityCount개",
                          style: TextStyle(
                            color: textColor.withValues(alpha: 0.7),
                            fontSize: 15,
                          ),
                        ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
              ),
              if (showArrow)
                Positioned(
                  bottom: 12,
                  right: 0,
                  child:
                      ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                            ),
                            onPressed: onArrowPressed,
                            child: Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: const Color(0xFFBB271A),
                                borderRadius: BorderRadius.circular(90),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color(
                                      0xFF202123,
                                    ).withValues(alpha: 0.3),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.arrow_forward,
                                color: Color(0xFFFBFBFB),
                              ),
                            ),
                          )
                          .animate(onPlay: (c) => c.repeat(reverse: true))
                          .moveX(
                            begin: 0,
                            end: 4, // → 오른쪽으로 8px 이동
                            duration: 1200.ms,
                            curve: Curves.easeInOut,
                          ),
                ),
            ],
          ),
        )
        .animate()
        .slideY(
          begin: 0.4,
          end: 0,
          duration: 1000.ms,
          curve: Curves.easeOutCubic,
        )
        .fadeIn(duration: 1500.ms);
  }
}
