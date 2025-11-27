import 'package:brandme/activity.dart';
import 'package:brandme/widget/jobpage.dart';
import 'package:brandme/loginpage.dart';
import 'package:brandme/home/mainhomepage.dart';
import 'package:brandme/widget/profile.dart';
import 'package:brandme/widget/strategy.dart';
import 'package:brandme/testpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const LoginPage(),
    );
  }
}

class BottomNavController extends StatefulWidget {
  final int initialIndex;
  const BottomNavController({super.key, this.initialIndex = 0});

  @override
  State<BottomNavController> createState() => _BottomNavControllerState();
}

class _BottomNavControllerState extends State<BottomNavController> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex; // 로그인 시 1로 설정 가능
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const Profile(),
      const MainHomePage(), //메인 AI 추천 탭
      TestPage(), //직업 추천탭
    ];
    return Scaffold(
      body: pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF202123).withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomNavigationBar(
            iconSize: 32, // 원하는 크기
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: Color(0xFFBB271A),
            unselectedItemColor: Colors.grey,
            showSelectedLabels: false, // 선택된 라벨 숨기기
            showUnselectedLabels: false, // 선택 안된 라벨 숨기기
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.person), label: '프로필'),
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.troubleshoot),
                label: '테스트',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
