import 'package:flutter/material.dart';

//서버
import 'package:http/http.dart' as http; // http
import 'dart:convert'; // JSON 인코딩/디코딩에 필요

//차트
import 'package:fl_chart/fl_chart.dart';

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
      "http://127.0.0.1:8000/check"; // local : http://211.243.47.122:3001/check

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

// --차트 위젯--

//데이터
class PieSectionData {
  double value;
  final Color color;
  final String title;
  PieSectionData(
      {required this.value, required this.color, required this.title});
}

class BarSectionData {
  final int index;
  final double value;
  final Color color;
  final String title;
  BarSectionData(
      {required this.index,
      required this.value,
      required this.color,
      required this.title});
}

//파이 차트
class PieChartWidget extends StatefulWidget {
  const PieChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => PieChartState();
}

class PieChartState extends State {
  int touchedIndex = -1;
  int selectedId = 1; // 선택된 ID (임의로 1로 설정)

  List<PieSectionData> chartData = [
    PieSectionData(value: 0, color: Colors.blue, title: "50%"),
    PieSectionData(value: 0, color: Colors.yellow, title: "30%"),
    PieSectionData(value: 0, color: Colors.green, title: "15%"),
    PieSectionData(value: 0, color: Colors.purple, title: "3%"),
    PieSectionData(value: 0, color: Colors.grey, title: "2%")
  ];

  List<double> chartDesignValue = [0, 40]; //간격, 크기
  List<double> sectionDesignValue = [];
  @override
  void initState() {
    super.initState();
    _fetchPieChartValues(selectedId);
  }

  Future<void> _fetchPieChartValues(int id) async {
    final url = Uri.parse('http://127.0.0.1:8000/search-pieData/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final values = json.decode(response.body)['values'] as List;
      setState(() {
        for (int i = 0; i < chartData.length; i++) {
          chartData[i].value = values[i].toDouble();
        }
      });
    } else {
      throw Exception('Failed to load pie chart values');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "강자 비율",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 1.3,
          child: Row(
            children: <Widget>[
              const SizedBox(
                height: 18,
              ),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                pieTouchResponse == null ||
                                pieTouchResponse.touchedSection == null) {
                              touchedIndex = -1;
                              return;
                            }
                            touchedIndex = pieTouchResponse
                                .touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      sectionsSpace: chartDesignValue[0],
                      centerSpaceRadius: chartDesignValue[1],
                      sections: showingSections(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 28,
              ),
            ],
          ),
        )
      ],
    );
  }

  //데이터 조절
  List<PieChartSectionData> showingSections() {
    return List.generate(chartData.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      return PieChartSectionData(
        color: chartData[i].color,
        value: chartData[i].value,
        title: chartData[i].title,
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: shadows,
        ),
      );
    });
  }
}

//바 차트

class BarChartWidget extends StatefulWidget {
  const BarChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => BarChartWidgetState();
}

class BarChartWidgetState extends State<BarChartWidget> {
  //데이터
  double maxValue = 100 + 20;
  List<BarSectionData> chartData = [
    BarSectionData(index: 0, value: 99, color: Colors.blue, title: "강팀"),
    BarSectionData(index: 1, value: 10, color: Colors.blue, title: "약팀"),
    BarSectionData(index: 2, value: 40, color: Colors.blue, title: "중팀"),
    BarSectionData(index: 3, value: 3, color: Colors.blue, title: "최약팀"),
    BarSectionData(index: 4, value: 60, color: Colors.blue, title: "A팀"),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Text(
            "우승 확률",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                barTouchData: barTouchData,
                titlesData: titlesData,
                borderData: borderData,
                barGroups: barGroups,
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                maxY: maxValue,
              ),
            ),
          )
        ],
      ),
    );
  }

  //제목
  Widget getTitles(double value, TitleMeta meta) {
    final style = TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;

    text = chartData[value.toInt()].title;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  //데이터
  List<BarChartGroupData> get barGroups => chartData
      .map((e) => BarChartGroupData(
            x: e.index,
            barRods: [
              BarChartRodData(
                toY: e.value,
                gradient: _barsGradient,
              )
            ],
            showingTooltipIndicators: [0],
          ))
      .toList();

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (group) => Colors.transparent,
          tooltipPadding: EdgeInsets.zero,
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getTitles,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _barsGradient => LinearGradient(
        colors: [
          Colors.blue,
          Colors.cyan,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
}

//라인 차트
class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  State<StatefulWidget> createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State {
  LineChartWidgetState({
    Color? line1Color,
    Color? line2Color,
    Color? betweenColor,
  })  : line1Color = line1Color ?? Colors.blue,
        line2Color = line2Color ?? Colors.purple,
        betweenColor = betweenColor ?? Color.fromRGBO(0, 255, 255, 0.5);

  final Color line1Color;
  final Color line2Color;
  final Color betweenColor;

  List<String> xLabel = ["1", "2", "3", "4", "5", "6", "7"];

  String yLabel = '';

  List<FlSpot> charData = [
    FlSpot(0, 4),
    FlSpot(1, 3.5),
    FlSpot(2, 4.5),
    FlSpot(3, 1),
    FlSpot(4, 10),
    FlSpot(5, 4),
    FlSpot(6, 7),
  ];

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.bold,
    );
    String text;
    text = xLabel[value.toInt()];

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(fontSize: 10);

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        '${yLabel} ${value}',
        style: style,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "우승 성공률 흐름",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        AspectRatio(
          aspectRatio: 2,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 18,
              top: 10,
              bottom: 4,
            ),
            child: LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: false),
                lineBarsData: [
                  LineChartBarData(
                    //여기서 다른 차트 데이터 추가 가능
                    spots: charData,
                    isCurved: true,
                    barWidth: 2,
                    color: line1Color,
                    dotData: const FlDotData(
                      show: false,
                    ),
                  ),
                  LineChartBarData(
                    //여기서 다른 차트 데이터 추가 가능
                    spots: charData,
                    isCurved: true,
                    barWidth: 2,
                    color: line1Color,
                    dotData: const FlDotData(
                      show: false,
                    ),
                  ),
                ],
                betweenBarsData: [
                  BetweenBarsData(
                    fromIndex: 0,
                    toIndex: 1,
                    color: betweenColor,
                  )
                ],
                minY: 0,
                borderData: FlBorderData(
                  show: false,
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      getTitlesWidget: bottomTitleWidgets,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: leftTitleWidgets,
                      interval: 1,
                      reservedSize: 36,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  checkToShowHorizontalLine: (double value) {
                    return value == 1 || value == 6 || value == 4 || value == 5;
                  },
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
