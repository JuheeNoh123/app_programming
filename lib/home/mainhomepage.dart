import 'package:brandme/main.dart';
import 'package:brandme/home/slidingcontentbox.dart';
import 'package:brandme/testpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MainHomePage extends StatelessWidget {
  const MainHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF202123),
      body: SafeArea(
        child: Column(
          children: [
            // 🔥 상단 전체를 중앙 배치
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 80, 0, 60),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min, // ← Row를 최소 너비로!
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        // 1) 첫째 줄
                        Text(
                              "나를, 브랜드로",
                              style: const TextStyle(
                                color: Color(0xFFFBFBFB),
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                                letterSpacing: 2,
                              ),
                            )
                            .animate()
                            .slideX(
                              begin: -0.4,
                              end: 0,
                              duration: 1000.ms,
                              curve: Curves.easeOutCubic,
                            )
                            .fadeIn(duration: 1500.ms)
                            .shimmer(
                              duration: 4000.ms,
                              colors: [
                                Color(0xFF202123).withValues(alpha: 0.1),
                                Color(0xFF202123).withValues(alpha: 0.5),
                                Color(0xFF202123).withValues(alpha: 0.1),
                              ],
                              blendMode: BlendMode.srcATop,
                            ),

                        const SizedBox(height: 6),

                        // 2) 둘째 줄
                        Text(
                              "완성하는 공간",
                              style: const TextStyle(
                                color: Color(0xFFFBFBFB),
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                                letterSpacing: 2,
                              ),
                            )
                            .animate()
                            .slideX(
                              begin: -0.4,
                              end: 0,
                              duration: 1500.ms,
                              curve: Curves.easeOutCubic,
                            )
                            .fadeIn(duration: 2000.ms)
                            .shimmer(
                              duration: 4000.ms,
                              colors: [
                                Color(0xFF202123).withValues(alpha: 0.1),
                                Color(0xFF202123).withValues(alpha: 0.5),
                                Color(0xFF202123).withValues(alpha: 0.1),
                              ],
                              blendMode: BlendMode.srcATop,
                            ),
                      ],
                    ),
                    const SizedBox(width: 80),
                    // 3) 화살표 버튼 (중앙)
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                BottomNavController(initialIndex: 2),
                          ),
                        );
                      },
                      child:
                          Container(
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
                              )
                              .animate()
                              .slideX(
                                begin: 0.4,
                                end: 0,
                                duration: 1000.ms,
                                curve: Curves.easeOutCubic,
                              )
                              .fadeIn(duration: 1500.ms)
                              .animate(onPlay: (c) => c.repeat(reverse: true))
                              .shimmer(
                                duration: 4000.ms,
                                colors: [
                                  Color(0xFFFBFBFB).withValues(alpha: 0.1),
                                  Color(0xFFFBFBFB).withValues(alpha: 0.5),
                                  Color(0xFFFBFBFB).withValues(alpha: 0.1),
                                ],
                                blendMode: BlendMode.srcATop,
                              ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔥 아래 흰색 박스
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SlidingContentBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
