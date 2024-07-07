import 'package:chatapp/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;

  const ChatBubble(
      {super.key, required this.message, required this.isCurrentUser});

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isCurrentUser
            ? (isDarkMode ? Colors.blue.shade700 : Colors.blue.shade500)
            : (isDarkMode ? Colors.grey.shade900 : Colors.grey.shade500),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          //BoxShadow(
          //  color: Colors.grey.withOpacity(0.1),
          //  spreadRadius: 1,
          //  blurRadius: 5,
          //  offset: Offset(0, 1), // changes position of shadow
          //),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 0.5,
            blurRadius: 3,
            offset: const Offset(1, 1), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      margin: const EdgeInsets.symmetric(vertical: 2.5, horizontal: 25),
      child: Text(
        message,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
