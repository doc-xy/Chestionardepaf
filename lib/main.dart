import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chestionar Stare Afectivă și Activitate Fizică',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const SurveyPage(),
    );
  }
}

class SurveyPage extends StatefulWidget {
  const SurveyPage({super.key});

  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  String? _gender;
  String? _educationLevel;
  int _currentQuestionIndex = -1;
  int _score = 0;
  bool isSurveyCompleted = false;
  bool consentGiven = false;
  String? errorMessage;

  final List<String> questions = [
    '1. Simți că lipsa energiei te împiedică să faci activități fizice?',
    '2. Îți pierzi interesul față de exerciții fizice sau activități pe care le găseai plăcute din cauza stării de spirit?',
    '3. Când te simți trist/ă sau descurajat/ă, ți-e greu să începi sau să menții o activitate fizică?',
    '4. Observi că ai mai puțină motivație de a face exerciții fizice atunci când te simți obosit/ă mental?',
    '5. Când te simți neliniștit/ă sau stresat/ă, găsești că îți este greu să faci mișcare?',
    '6. Simți că activitatea fizică te obosește mai mult decât înainte, chiar și fără a depune efort intens?',
    '7. Ai tendința de a evita activitatea fizică atunci când te simți fără speranță sau descurajat/ă?',
    '8. Crezi că dispoziția ta scăzută te face să fii mai sedentar/ă decât ai dori?',
    '9. Observi că nu te poți bucura de activitățile fizice din cauza grijilor sau a autocriticii?',
    '10. Te simți demotivat/ă să faci mișcare atunci când te simți lipsit/ă de încredere în tine?',
    '11. Simți că te confrunți cu dificultăți de concentrare în timpul exercițiilor fizice din cauza gândurilor negative?',
    '12. Când te simți anxios/anxioasă, îți este greu să te relaxezi în timpul activităților fizice?',
    '13. Te simți vinovat/ă pentru că nu reușești să menții o rutină de exerciții fizice?',
    '14. Participi mai rar la activități fizice în grup din cauza stării tale emoționale?',
    '15. După activitatea fizică, starea de bine dispare repede și revii la starea negativă?',
  ];

  final List<int> answers = List.filled(15, -1);

  void nextQuestion() {
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      calculateScore();
    }
  }

  void calculateScore() {
    setState(() {
      _score = answers.fold(0, (sum, item) => sum + (item >= 0 ? item : 0));
      isSurveyCompleted = true;
    });
  }

  String getDepressionLevel(int score) {
    if (score >= 0 && score <= 15) {
      return '''
Felicitări! Ai un nivel scăzut de simptome depresive și, cel mai probabil, îți menții o stare emoțională bună, iar activitatea fizică face parte din rutina ta. Continuă să îți îngrijești sănătatea prin exerciții fizice regulate și să îți menții echilibrul emoțional. Activitatea fizică este un aliat puternic pentru menținerea unei stări de bine.
''';
    } else if (score >= 16 && score <= 30) {
      return '''
Se pare că resimți unele simptome ușoare de depresie, care pot influența și nivelul de energie pentru activități fizice. Este recomandat să continui să practici exerciții fizice moderate pentru a-ți îmbunătăți dispoziția și nivelul de energie. Nu uita să acorzi atenție și sănătății tale mentale prin activități relaxante sau suport psihologic dacă simți că ai nevoie de ajutor.
''';
    } else if (score >= 31 && score <= 45) {
      return '''
Scorul tău sugerează simptome moderate de depresie, ceea ce înseamnă că ai putea întâmpina dificultăți în menținerea unei activități fizice constante. Este important să începi cu exerciții blânde și să ceri sprijin pentru starea ta emoțională. Activitatea fizică ușoară, precum mersul pe jos sau înotul, poate contribui semnificativ la îmbunătățirea stării tale mentale și la reducerea oboselii. 
''';
    } else {
      return '''
Scorul tău indică simptome severe de depresie. Este esențial să cauți sprijin profesionist pentru a face față acestei stări. Activitatea fizică poate părea o provocare, dar este important să îți începi recuperarea cu ajutorul unui specialist. Exercițiile de intensitate scăzută, împreună cu un plan terapeutic, pot ajuta la îmbunătățirea stării tale emoționale și fizice.
''';
    }
  }

  bool validateDemographicData() {
    // Verificăm dacă toate câmpurile sunt completate
    if (_ageController.text.isEmpty || _heightController.text.isEmpty ||
        _weightController.text.isEmpty || _gender == null || _educationLevel == null) {
      setState(() {
        errorMessage = "Te rugăm să completezi toate câmpurile pentru datele demografice.";
      });
      return false;
    }
    setState(() {
      errorMessage = null; // Ștergem mesajul de eroare, dacă este completat corect
    });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chestionar Stare Afectivă și Activitate Fizică'),
      ),
      body: SingleChildScrollView(  // Împachetăm conținutul într-un SingleChildScrollView
        padding: const EdgeInsets.all(16.0),
        child: isSurveyCompleted
            ? ResultPage(score: _score, interpretation: getDepressionLevel(_score))
            : _currentQuestionIndex == -1
                ? buildConsentForm()
                : buildQuestion(),
      ),
    );
  }

  Widget buildConsentForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Vă rugăm să citiți cu atenție următoarele:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          '- Am citit toate informațiile.\n'
          '- Înțeleg că toate datele mele vor fi stocate în mod anonim.\n'
          '- Înțeleg că datele mele vor fi stocate și analizate pentru o cercetare științifică.\n'
          '- Înțeleg că datele pot fi utilizate pentru publicarea unei cercetări.\n'
          '- Înțeleg că mă pot retrage din cercetare în orice moment, fără a prezenta un motiv.',
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Checkbox(
              value: consentGiven,
              onChanged: (value) {
                setState(() {
                  consentGiven = value ?? false;
                });
              },
            ),
            const Expanded(child: Text('Sunt de acord cu condițiile menționate.')),
          ],
        ),
        const SizedBox(height: 10),
        if (errorMessage != null)
          Text(
            errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
          ),
        const SizedBox(height: 20),
        TextField(
          controller: _ageController,
          decoration: const InputDecoration(labelText: 'Vârsta'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _heightController,
          decoration: const InputDecoration(labelText: 'Înălțime (cm)'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _weightController,
          decoration: const InputDecoration(labelText: 'Greutate (kg)'),
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _gender,
          onChanged: (String? newValue) {
            setState(() {
              _gender = newValue;
            });
          },
          items: const [
            DropdownMenuItem(value: 'Masculin', child: Text('Masculin')),
            DropdownMenuItem(value: 'Feminin', child: Text('Feminin')),
            DropdownMenuItem(value: 'Altul', child: Text('Altul')),
          ],
          decoration: const InputDecoration(labelText: 'Gen'),
        ),
        const SizedBox(height: 10),
        DropdownButtonFormField<String>(
          value: _educationLevel,
          onChanged: (String? newValue) {
            setState(() {
              _educationLevel = newValue;
            });
          },
          items: const [
            DropdownMenuItem(value: 'Primar', child: Text('Primar')),
            DropdownMenuItem(value: 'Liceu', child: Text('Liceu')),
            DropdownMenuItem(value: 'Facultate', child: Text('Facultate')),
            DropdownMenuItem(value: 'Postuniversitar', child: Text('Postuniversitar')),
          ],
          decoration: const InputDecoration(labelText: 'Nivelul de educație'),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: consentGiven && validateDemographicData()
              ? () {
                  setState(() {
                    _currentQuestionIndex = 0;
                  });
                }
              : null,
          child: const Text('Începe chestionarul'),
        ),
      ],
    );
  }

  Widget buildQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          questions[_currentQuestionIndex],
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          '0 = Niciodată, 1 = Rareori, 2 = Uneori, 3 = Adeseori, 4 = Mereu',
          style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 20),
        ...[0, 1, 2, 3, 4].map((index) {
          return ElevatedButton(
            onPressed: () {
              setState(() {
                answers[_currentQuestionIndex] = index;
              });
              nextQuestion();
            },
            child: Text(index == 0
                ? 'Niciodată'
                : index == 1
                    ? 'Rareori'
                    : index == 2
                        ? 'Uneori'
                        : index == 3
                            ? 'Adeseori'
                            : 'Mereu'),
          );
        }).toList(),
      ],
    );
  }
}

class ResultPage extends StatelessWidget {
  final int score;
  final String interpretation;

  const ResultPage({
    super.key,
    required this.score,
    required this.interpretation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Scor: $score',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Text(
          interpretation,
          style: const TextStyle(fontSize: 18),
        ),
      ],
    );
  }
}
