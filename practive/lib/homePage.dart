import 'package:flutter/material.dart';
import '../chartWidget.dart';

//서버
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // JSON 인코딩/디코딩에 필요

//차트
import 'package:fl_chart/fl_chart.dart';

// 메인 페이지

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int pageIndex = 0; // 0: 프로필 1: 검색 2: 관리 3: 설정

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(5, 10, 5, 0),
            width: 200,
            color: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text("강 팀",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                _buildMenuButton(Icons.person, '계정', 0),
                _buildMenuButton(Icons.search, '검색', 1),
                _buildMenuButton(Icons.computer, '현황', 2),
                _buildMenuButton(Icons.settings, '설정', 3),
              ],
            ),
          ),
          Expanded(child: _getSelectedWidget())
        ],
      ),
    );
  }

  void _onMenuButtonPressed(int index) {
    setState(() {
      pageIndex = index;
    });
  }

  Widget _buildMenuButton(IconData icon, String title, int index) {
    final bool isSelected = pageIndex == index;

    return TextButton.icon(
      iconAlignment: IconAlignment.end,
      onPressed: () => _onMenuButtonPressed(index),
      icon: Icon(icon, color: isSelected ? Colors.blue : Colors.white),
      label: Text(
        title,
        style: TextStyle(color: isSelected ? Colors.blue : Colors.white),
      ),
      style: TextButton.styleFrom(
          minimumSize: Size.fromHeight(50),
          backgroundColor: isSelected ? Colors.white : Colors.transparent),
    );
  }

  //버튼 눌러서 우측 위젯 변경
  Widget _getSelectedWidget() {
    switch (pageIndex) {
      case 0:
        return ProfilePage();
      case 1:
        return Expanded(child: SearchPage());
      case 2:
        return Expanded(child: ManagePage());
      case 3:
        return SettingPage();
      default:
        return ProfilePage();
    }
  }

  //각 위젯별 페이지

  Widget ProfilePage() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text(
          "계정 관리",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(color: Colors.white),
    );
  }

  Widget SettingPage() {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text(
          "설정",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(color: Colors.white),
    );
  }
}

class ManagePage extends StatefulWidget {
  const ManagePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ManagePageState();
}

class _ManagePageState extends State<ManagePage> {
  String searchContext = '';

  final _formKey = GlobalKey<FormState>();

  List<double> dataValue = [20, 25, 30];

  TextStyle pieChartSectionTextStyle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.white);

  late List<PieChartSectionData> pieChartData;

  @override
  void initState() {
    super.initState();
    pieChartData = [
      PieChartSectionData(
          value: dataValue[0], //값
          color: Colors.blue, //색
          radius: 100, //두께
          titleStyle: pieChartSectionTextStyle),
      PieChartSectionData(
          value: dataValue[1], //값
          color: const Color.fromARGB(255, 220, 198, 0), //색
          radius: 100, //두께
          titleStyle: pieChartSectionTextStyle),
      PieChartSectionData(
          value: dataValue[2], //값
          color: Colors.green, //색
          radius: 100, //두께
          title: "초록",
          titleStyle: pieChartSectionTextStyle)
      // 아이콘 표시
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.lightBlue,
          centerTitle: true,
          title: Text(
            "프로젝트 현황",
            style: TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
          color: Colors.white,
          padding: EdgeInsets.all(50),
          child: SingleChildScrollView(
              child: Column(
            children: [PieChartWidget(), BarChartWidget(), LineChartWidget()],
          )),
        ));
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchContext = '';
  String? password;

  final _formKey = GlobalKey<FormState>();

  String serverURL =
      "http://127.0.0.1:8000/search"; // local : http://211.243.47.122:3001/check

  Future<void> _searchPassword() async {
    final url = Uri.parse(serverURL);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': searchContext}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        password = data['password'];
      });
    } else {
      setState(() {
        password = "사용자를 찾을 수 없습니다.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.lightBlue,
        centerTitle: true,
        title: Text(
          "검색 및 조회",
          style: TextStyle(
              color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
          key: _formKey,
          child: Center(
            child: Container(
              color: Colors.white,
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    password != null ? "$password" : "조회 대상을 입력하십시오.",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: 300,
                    child: TextFormField(
                        decoration:
                            InputDecoration(border: OutlineInputBorder()),
                        textAlign: TextAlign.center,
                        onChanged: (value) => searchContext = value,
                        validator: (value) {
                          if (value == null || value.isEmpty) return;
                          searchContext = value;
                        }),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                      onPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(searchContext + "(을)를 찾아보겠습니다...")));
                        await _searchPassword();
                      },
                      child: const Text("조회"))
                ],
              ),
            ),
          )),
    );
  }
}
