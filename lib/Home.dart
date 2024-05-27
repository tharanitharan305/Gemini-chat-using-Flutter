import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Gemini gemini = Gemini.instance;
  ChatUser User = ChatUser(id: "0", firstName: "You");
  ChatUser GeminiUser = ChatUser(id: "1", firstName: "Gemini");
  List<ChatMessage> messages = [];
  String chat = "";
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ChatUser currentUser = User;
    return Scaffold(
      body: buildUi(),
    );
  }

  Widget buildUi() {
    return DashChat(currentUser: User, onSend: _onSend, messages: messages);
  }

  void _onSend(ChatMessage message) {
    setState(() {
      messages = [message, ...messages];
    });
    try {
      gemini.streamGenerateContent(message.text).listen((event) {
        final LastMessage = messages.firstOrNull;
        if (LastMessage != null || LastMessage?.user == GeminiUser) {
        } else {
          setState(() {
            String ans = event.content?.parts?.fold(
                    "", (previousValue, element) => "$previousValue$element") ??
                "";
            messages = [
              ChatMessage(
                  user: GeminiUser, createdAt: DateTime.now(), text: ans),
              ...messages
            ];
          });
        }
      });
    } catch (E) {}
  }
}
