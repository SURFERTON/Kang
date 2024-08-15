import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // JSON 인코딩/디코딩에 필요

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SignInPage());
  }
}

// 로그인/가입 페이지

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String inputEmail = "";
  String inputPw = "";

  String serverURL =
      "http://211.243.47.122:3001/check"; // local : http://127.0.0.1:8000/check

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: Card(
            color: Color.fromRGBO(226, 249, 255, 1),
            elevation: 8,
            child: Container(
              padding: const EdgeInsets.all(32.0),
              constraints: const BoxConstraints(maxWidth: 350),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "강 팀",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Image.asset("Liver.png"),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        "강자들만 가입할 수 있다!",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "당신의 이메일과 비밀번호를 입력해라!",
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      validator: (value) {
                        // add email validation
                        if (value == null || value.isEmpty) {
                          return '공백은 안 된다!!';
                        }

                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(value);
                        if (!emailValid) {
                          return '형식이 맞지 않는다!!';
                        }

                        inputEmail = value;

                        return null;
                      },
                      decoration: const InputDecoration(
                        labelText: '이메일!',
                        hintText: '입력하시오!',
                        prefixIcon: Icon(Icons.email_outlined),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    _gap(),
                    TextFormField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return '공백은 안 된다!!';
                        }

                        if (value.length < 6) {
                          return '최소한 6글자 이상으로!!';
                        }

                        inputPw = value;

                        return null;
                      },
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                          labelText: '비밀번호!',
                          hintText: '입력하시오!',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: Icon(_isPasswordVisible
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          )),
                    ),
                    _gap(),
                    CheckboxListTile(
                      value: _rememberMe,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _rememberMe = value;
                        });
                      },
                      title: const Text('기억할까?'),
                      controlAffinity: ListTileControlAffinity.leading,
                      dense: true,
                      contentPadding: const EdgeInsets.all(0),
                    ),
                    _gap(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '가입하기!',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState?.validate() ?? false) {
                            final response = await http.post(
                                Uri.parse(serverURL), //서버에 요청
                                headers: <String, String>{
                                  'Content-Type':
                                      'application/json; charset=UTF-8'
                                }, //여기 변환인가?
                                body: jsonEncode(<String, String>{
                                  'email': inputEmail,
                                  'password': inputPw
                                }) //전달할 값

                                );

                            if (response.statusCode == 200) //서버 에러 확인
                            {
                              final result =
                                  jsonDecode(response.body); // response 번역

                              if (result['exists'] == true) // 있으면 페이지 이동
                              {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainPage(),
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('자네는 강팀이 될 수 없다네.')),
                                );
                              }
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('서버 오류가 발생했습니다.')),
                              );
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 16);
}

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
        return ManagePage();
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

  Widget _searchPage() {
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
      body: Container(color: Colors.white),
    );
  }

  Widget ManagePage() {
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

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchContext = '';

  final _formKey = GlobalKey<FormState>();

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
                    "조회 대상을 입력하십시오.",
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
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(searchContext + "(을)를 찾아보겠습니다...")));
                      },
                      child: const Text("조회"))
                ],
              ),
            ),
          )),
    );
  }
}
