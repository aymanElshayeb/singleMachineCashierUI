import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewMessage extends StatefulWidget {
  const NewMessage({super.key});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  TextEditingController messageController = TextEditingController();
  void _sendMessage() {
    FocusScope.of(context).unfocus();
    FirebaseFirestore.instance
        .collection('chat')
        .add({'text': _enteredMessage, 'createdAt': Timestamp.now()});
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.all(8),
      child: Row(children: [
        Expanded(
            child: TextField(
          controller: messageController,
          decoration: InputDecoration(labelText: 'Send a message...'),
          onChanged: ((value) {
            setState(() {
              _enteredMessage = value;
            });
          }),
        )),
        IconButton(
          onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          color: Theme.of(context).primaryColor,
          icon: Icon(Icons.send),
        )
      ]),
    );
  }
}
