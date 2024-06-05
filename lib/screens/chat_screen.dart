import 'dart:async';

import 'package:flutter/material.dart';
import 'package:med_app/constants.dart';
import 'package:med_app/screens/loading_screen.dart';
import 'package:med_app/services/firestore.dart';
import 'package:med_app/services/models.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late String chatId;
  late Stream<List<MessageDoc>> chatStream = const Stream.empty();
  ChatMessageDoc? chatMessage;
  late StreamSubscription<List<MessageDoc>> chatSubscription;
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Do not access ModalRoute.of(context) here
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access ModalRoute.of(context) here
    chatId = ModalRoute.of(context)!.settings.arguments as String;
    fetchChat(); // <-- This method fetches the initial chat data
    chatStream = FireStoreService().streamChatById(
        chatId); // <-- This sets up the stream for real-time updates
    chatSubscription = chatStream.listen((_) {});
  }

  Future<void> fetchChat() async {
    final chat = await FireStoreService().getChat(chatId);
    setState(() {
      chatMessage = chat;
    });
  }

  void sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      FireStoreService().sendMessage(chatId, message);
      _messageController.clear();
    }
  }

  void editMessage(MessageDoc message) {
    // Add your logic here to edit the message
  }

  void deleteMessage(MessageDoc message) {
    // Add your logic here to delete the message
  }

  Widget buildChatMessage(MessageDoc message) {
    final isPatient = message.sender == 'patient';
    final alignment = isPatient ? Alignment.centerRight : Alignment.centerLeft;
    return GestureDetector(
      onLongPress: () {
        // Show edit and delete options when a message is long-pressed
        showOptions(message);
      },
      child: Align(
        alignment: alignment,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isPatient ? kBackgroundColor : Colors.indigoAccent.shade100,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message.senderName,
                style: kTitle2Style.copyWith(
                    color: isPatient ? Colors.black : Colors.white,
                    fontSize: 18),
              ),
              const SizedBox(height: 5),
              Text(
                message.message,
                style: kCardSubtitleStyle.copyWith(
                    color: isPatient ? Colors.grey.shade600 : Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showOptions(MessageDoc message) {
    // Show options to edit or delete the message
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                editMessage(message);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete'),
              onTap: () {
                Navigator.pop(context);
                deleteMessage(message);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    chatSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("re-render");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent.shade100,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(chatMessage?.doctorAvatar ?? ''),
            ),
            const SizedBox(width: 12),
            Text(
              chatMessage?.doctorDisplayName ?? '',
              style: kCardTitleStyle,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: StreamBuilder<List<MessageDoc>>(
                  stream: chatStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(child: Text('No Messages'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return buildChatMessage(snapshot.data![index]);
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              color: Colors.indigoAccent.shade100,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 6.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: 'Type your message...',
                              border: InputBorder.none,
                            ),
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50.0),
                        onTap: sendMessage,
                        child: Container(
                          padding: const EdgeInsets.all(12.0),
                          child: const Icon(
                            Icons.send,
                            color: Colors.indigo,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
