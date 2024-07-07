import 'package:chatapp/components/chat_bubble.dart';
import 'package:chatapp/components/my_textfield.dart';
import 'package:chatapp/services/auth/auth_service.dart';
import 'package:chatapp/services/chat/chat_service.dart';
import 'package:chatapp/themes/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const ChatPage(
      {super.key, required this.receiverEmail, required this.receiverID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  FocusNode myFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });

    Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  final ScrollController _scrollController = ScrollController();

  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.fastOutSlowIn);
  }

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);

      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        title: Text(
          widget.receiverEmail,
          style: const TextStyle(
              //color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w500),
        ),
        //iconTheme: IconThemeData(color: Theme.of(context).colorScheme.tertiary),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(child: _buildMessageList()),
          _buildUserInput(context)
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
        stream: _chatService.getMessages(widget.receiverID, senderID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          //print('Snapshot data: ${snapshot.data!.docs}');
          return ListView(
            controller: _scrollController,
            children: snapshot.data!.docs
                .map((doc) => _buildMessageListItem(doc))
                .toList(),
          );
        });
  }

  Widget _buildMessageListItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data["senderID"] == _authService.getCurrentUser()!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
        alignment: alignment,
        child:
            ChatBubble(message: data["message"], isCurrentUser: isCurrentUser));
  }

  Widget _buildUserInput(context) {
    bool isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(bottom: 25),
      child: Row(
        children: [
          Expanded(
              child: MyTextfield(
            focusNode: myFocusNode,
            controller: _messageController,
            hintText: "Type a message",
          )),
          Container(
            decoration: BoxDecoration(
                color:
                    (isDarkMode ? Colors.blue.shade700 : Colors.blue.shade500),
                shape: BoxShape.circle),
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(
                onPressed: sendMessage,
                icon: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                )),
          )
        ],
      ),
    );
  }
}
