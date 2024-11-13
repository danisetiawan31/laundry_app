import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _sendMessage() async {
    if (_messageController.text.isEmpty) return;

    User? user = _auth.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('chats').add({
        'text': _messageController.text,
        'senderId': user.uid,
        'senderName': user.displayName ?? 'User',
        'timestamp': FieldValue.serverTimestamp(),
      });
    }
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'CUSTOMER SUPPORT',
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              color: Colors
                  .white, // Tambahkan background putih pada Container utama
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .orderBy('timestamp', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // Menampilkan pesan kosong jika tidak ada data
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        "No messages yet.",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    );
                  }

                  // Menampilkan daftar pesan jika ada data
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var message = snapshot.data!.docs[index];
                      var isUserMessage =
                          message['senderId'] == _auth.currentUser?.uid;

                      return Align(
                        alignment: isUserMessage
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.7,
                          ),
                          margin: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUserMessage
                                ? Colors.blue
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: isUserMessage
                                  ? const Radius.circular(16)
                                  : Radius.zero,
                              bottomRight: isUserMessage
                                  ? Radius.zero
                                  : const Radius.circular(16),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                message['text'] ?? '',
                                style: TextStyle(
                                  color: isUserMessage
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                _formatTimestamp(message['timestamp']),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isUserMessage
                                      ? Colors.white70
                                      : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          _buildMessageInput(),
        ],
      ),
      backgroundColor: Colors.white, // Background putih untuk seluruh Scaffold
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.attach_file, color: Colors.blue),
            onPressed: _pickImage, // Fungsi untuk memilih gambar
          ),
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: "Message here...",
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.mic, color: Colors.blue),
            onPressed: _recordVoiceMessage, // Fungsi untuk merekam pesan suara
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Colors.blue),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return '';
    DateTime date = timestamp.toDate();
    return "${date.hour}:${date.minute < 10 ? '0' : ''}${date.minute} ${date.hour < 12 ? 'AM' : 'PM'}";
  }

  void _pickImage() {
    // Logika untuk memilih gambar dari galeri atau mengambil foto
    print("Function to pick image goes here.");
  }

  void _recordVoiceMessage() {
    // Logika untuk merekam pesan suara
    print("Function to record voice message goes here.");
  }
}
