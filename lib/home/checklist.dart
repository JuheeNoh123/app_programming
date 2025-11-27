import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ChecklistTab extends StatefulWidget {
  final VoidCallback? onBack; // ← 뒤로가기 콜백 추가

  const ChecklistTab({super.key, this.onBack});
  @override
  State<ChecklistTab> createState() => _ChecklistTabState();
}

class _ChecklistTabState extends State<ChecklistTab> {
  List<Map<String, dynamic>> missionItems = [];
  List<Map<String, dynamic>> activityItems = [];
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    debugPrint("[ChecklistTab] dispose() called — 화면 닫힘");
    _saveUserData(); // ✅ 화면 닫힐 때 강제로 저장
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    userName = prefs.getString("userName");
    if (userName == null) return;

    setState(() {
      missionItems = _decodeList(prefs.getString("missionItems_$userName"));
      activityItems = _decodeList(prefs.getString("activityItems_$userName"));
    });
  }

  List<Map<String, dynamic>> _decodeList(String? jsonStr) {
    if (jsonStr == null) return [];
    final decoded = json.decode(jsonStr);
    if (decoded is List) {
      return decoded.map<Map<String, dynamic>>((e) {
        // ✅ 예전 버전 (문자열 리스트) 호환 처리
        if (e is String) {
          return {"text": e, "done": false};
        }
        // ✅ 올바른 Map 구조일 때
        else if (e is Map) {
          return {"text": e["text"] ?? "", "done": e["done"] ?? false};
        } else {
          return {"text": e.toString(), "done": false};
        }
      }).toList();
    }
    return [];
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    if (userName == null) return;

    await prefs.setString("missionItems_$userName", json.encode(missionItems));
    await prefs.setString(
      "activityItems_$userName",
      json.encode(activityItems),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Color(0xFFFBFBFB),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 상단 제목 + 뒤로가기
          Stack(
            alignment: Alignment.center,
            children: [
              // 왼쪽 화살표
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFF202123),
                  ),
                  onPressed: widget.onBack,
                ),
              ),

              // 가운데 제목
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "미션 / 활동",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF202123),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5),
                    width: 120,
                    height: 5,
                    color: const Color(0xFFBB271A),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 30),

          // 🔹 예시 카드 두 개
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  _buildCard("오늘의 미션", missionItems, (newList) {
                    setState(() => missionItems = newList);
                    _saveUserData();
                  }),
                  const SizedBox(height: 20),
                  _buildCard("오늘의 활동", activityItems, (newList) {
                    setState(() => activityItems = newList);
                    _saveUserData();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(
    String title,
    List<Map<String, dynamic>> items,
    void Function(List<Map<String, dynamic>>) onUpdate,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF202123),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 상단 제목 + 수정 버튼
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () {
                  _editItems(context, title, items, () {
                    onUpdate(List.from(items));
                  });
                }, // ← 수정 콜백 실행
                child: const Icon(
                  Icons.edit,
                  color: Color(0xFFBB271A),
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // 내용 표시 (없으면 안내문)
          if (items.isEmpty)
            const Text(
              "+ 새 항목을 추가해주세요",
              style: TextStyle(color: Colors.white54, fontSize: 14),
            )
          else
            for (var item in items)
              CheckboxListTile(
                dense: true,
                activeColor: const Color(0xFFBB271A),
                checkColor: Colors.white,
                controlAffinity: ListTileControlAffinity.leading,
                value: item["done"],
                onChanged: (val) async {
                  item["done"] = val ?? false;
                  onUpdate(List.from(items));
                  await _saveUserData(); // ✅ 체크 변경 즉시 저장
                  debugPrint("[ChecklistTab] 저장 완료: ${json.encode(items)}");
                },
                title: Text(
                  item["text"],
                  style: TextStyle(
                    color: item["done"] ? Colors.white54 : Colors.white,
                    decoration: item["done"]
                        ? TextDecoration.lineThrough
                        : TextDecoration.none,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  void _editItems(
    BuildContext context,
    String title,
    List<Map<String, dynamic>> items,
    VoidCallback onChanged,
  ) {
    final controller = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10), // ✅ 둥근 모서리
          ),
          title: Text("$title 수정", style: const TextStyle(fontSize: 18)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...items.map(
                (e) => ListTile(
                  title: Text(e["text"]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      items.remove(e);
                      onChanged();
                      Navigator.pop(context);
                      _editItems(context, title, items, onChanged);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: "새 항목 입력..."),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  items.add({"text": controller.text, "done": false});
                  onChanged();
                }
                Navigator.pop(context);
              },
              child: const Text("추가"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("닫기"),
            ),
          ],
        );
      },
    );
  }
}
