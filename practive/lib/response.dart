import 'package:flutter/material.dart';
import 'package:practive/widgets/card.dart';

class ResponsePage extends StatefulWidget {
  const ResponsePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        // Center 위젯으로 감싸줍니다.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/gin2');
              },
              label: const Text(
                '나도 요청할래요',
                selectionColor: Color.fromARGB(255, 105, 166, 228),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 30.0),
                textStyle: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 50),
            const CurrencyCard(
                name: 'TO | 강남대 이공관 310호\nFROM | 강남대 이공관 310호',
                code: '',
                amount: '오늘 13:10 까지',
                isInverted: false,
                icon: Icons.task_alt,
                off: 0),
            const CurrencyCard(
                name: 'TO | 강남대 이공관 310호\nFROM | 강남대 이공관 310호',
                code: '',
                amount: '오늘 13:10 까지',
                isInverted: false,
                icon: Icons.task_alt,
                off: 20),
          ],
        ),
      ),
    );
  }
}
