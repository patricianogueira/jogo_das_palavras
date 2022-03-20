import 'package:flutter/material.dart';
import 'package:jogo_das_palavras/quantas_palavras/list_of_word.dart';

class WordsGamesApp extends StatelessWidget {
  const WordsGamesApp({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WordsGameScreen(),
    );
  }
}

class WordsGameScreen extends StatefulWidget {
  const WordsGameScreen({ Key? key }) : super(key: key);

  @override
  State<WordsGameScreen> createState() => _WordsGameScreenState();
}

class _WordsGameScreenState extends State<WordsGameScreen> {
  var gameRunning = false;
  var timerSeconds = 30;
  var countWord = 3;
  var inputWord = '';
  final wordController = TextEditingController();

  void startGame() async{
    setState(() {
      gameRunning = true;
      timerSeconds = 30;
      countWord = 3;
    });

    for(var i = timerSeconds; i >= 0; i--){
      if(countWord == 0) break;
      
      await Future.delayed(const Duration(seconds: 1));
      setState(() => timerSeconds = i);
    }

    setState(() => gameRunning = false);
  }

  void sendWord(){
    final messenger = ScaffoldMessenger.of(context);
    final word = wordController.text;
    final hasWord = wordsList.contains(word.toLowerCase());

    wordController.clear();

    if(!hasWord){
       messenger.showSnackBar(
        const SnackBar(
          content: Text('Resposta errada!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    messenger.showSnackBar(
        const SnackBar(
          content: Text('Certa resposta!'),
          duration: Duration(seconds: 1),
          backgroundColor: Colors.purple,
        ),
      );

    countWord -= 1;

    if(countWord == 0){
       showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text('Parabéns! Você acertou as três palavras.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final titleText = gameRunning ? '00:$timerSeconds' : 'Adivinhe três palavras!';

    return Scaffold(
      appBar: AppBar(
        title:  Text(titleText),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: wordController,
            ),
            const SizedBox(height: 8.0),
            ElevatedButton(
              onPressed: gameRunning ? sendWord : null, 
              child: const Text('Enviar')
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: !gameRunning ? startGame : null, 
              child: const Text('Start Game'))
          ],
        ),
      ),
    );
  }
}