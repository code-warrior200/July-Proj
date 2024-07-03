import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Message>> getMessages() {
    return _firestore
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Message(
                text: doc['text'],
                senderId: doc['senderId'],
                timestamp: doc['timestamp'].toDate(),
              ))
          .toList();
    });
  }

  Future<void> sendMessage(String text, String senderId) async {
    await _firestore.collection('messages').add({
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
