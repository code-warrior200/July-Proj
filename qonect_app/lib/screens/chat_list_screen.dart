// ignore_for_file: use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../models/message.dart';
import 'chat_screen.dart';

class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          return StreamBuilder<List<Message>>(
            stream: chatProvider.getMessages(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              final messages = snapshot.data!;
              final chats = _getChats(messages, authProvider.user!.uid);

              return ListView.builder(
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  final chat = chats[index];
                  return ListTile(
                    title: Text(chat.senderId),
                    subtitle: Text(chat.text),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(chatId: chat.senderId),
                        ),
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  List<Message> _getChats(List<Message> messages, String uid) {
    // A simple method to filter chats based on user id.
    return messages.where((msg) => msg.senderId != uid).toList();
  }
}
