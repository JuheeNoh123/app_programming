import 'package:brandme/main.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const textColor = Color(0xFFFBFBFB);

    return Scaffold(
      backgroundColor: const Color(0xFF202123),
      body: SafeArea(
        child: Column(
          children: [
            // 🔥 2) 중앙 레이아웃
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "Brand.Me",
                      style: TextStyle(
                        fontSize: 30,
                        color: Color(0xFFBB271A),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 사용자 이름 입력 필드
                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: "사용자 이름",
                          labelStyle: TextStyle(
                            color: textColor.withValues(alpha: 0.8),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: textColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: textColor),
                          ),
                        ),
                        style: TextStyle(color: textColor),
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: 250,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: "비밀번호",
                          labelStyle: TextStyle(
                            color: textColor.withValues(alpha: 0.8),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: textColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: textColor),
                          ),
                        ),
                        style: TextStyle(color: textColor),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // 🔥 로그인 버튼
                    SizedBox(
                      width: 250,
                      height: 45,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          overlayColor: Colors.white24,
                          backgroundColor: const Color(0xFFBB271A),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          final prefs = await SharedPreferences.getInstance();
                          final name = _nameController.text.trim();
                          final password = _passwordController.text.trim();

                          if (name.isEmpty || password.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("이름과 비밀번호를 모두 입력해주세요."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                            return;
                          }

                          //유저네임 저장
                          await prefs.setString("userName", name);

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BottomNavController(
                                initialIndex: 1, //홈화면으로 이동
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          "로그인",
                          style: TextStyle(
                            color: textColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
