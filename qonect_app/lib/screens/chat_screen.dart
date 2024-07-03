import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/chat_provider.dart';
import '../models/message.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;

  ChatScreen({required this.chatId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) {
      return;
    }
    Provider.of<ChatProvider>(context, listen: false)
        .sendMessage(_controller.text.trim(), widget.chatId);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.chatId}'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: Provider.of<ChatProvider>(context).getMessages(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final messages = snapshot.data!
                    .where((msg) => msg.senderId == widget.chatId)
                    .toList();

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return Align(
                      alignment: message.senderId == widget.chatId
                          ? Alignment.centerLeft
                          : Alignment.centerRight,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: message.senderId == widget.chatId
                              ? Colors.grey[300]
                              : Colors.blue,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          message.text,
                          style: TextStyle(
                              color: message.senderId == widget.chatId
                                  ? Colors.black
                                  : Colors.white),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
