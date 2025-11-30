import 'package:flutter/material.dart';

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("활동 추천")),
      body: const Center(child: Text("활동 추천 탭 UI 예정 자리")),
    );
  }
}
