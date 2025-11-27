import 'package:flutter/material.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("테스트탭")),
      body: const Center(child: Text("성장 전략 탭 UI 예정 자리")),
    );
  }
}
