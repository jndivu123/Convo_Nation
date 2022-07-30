import 'package:flutter/material.dart';
import 'package:convo_nation/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth =FirebaseAuth.instance;
  late User loggedInUser;
 late String messageText;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser()async {
    try {
      final user = await _auth.currentUser!;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    }
    catch(e)
    {
      print(e);
    }
  }

// we will get notified as soon as we get new data by using streams and snapshot
  void getMessages() async{
    FirebaseFirestore.instance.collection('messages').get().then( (QuerySnapshot querySnapshot) =>{
      querySnapshot.docs.forEach((doc){
        print(doc['sender']);
        print(doc['text']);
      }
      )
    }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
               // getMessages();
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context,snapshot)
              {
                if(!snapshot.hasData)
                  {
                     return const Center(
                       child:CircularProgressIndicator(
                         backgroundColor: Colors.lightBlueAccent,
                       ),

                     );
                  }
                List<MessageBubble> messageBubbles= [];
                    final messages =snapshot.data!.docs.reversed.forEach((doc) {
                      {
                        final messageText = doc['text'];
                        final messageSender = doc['sender'];
             final currentUSer = loggedInUser.email;
            
                        final messageBubble = MessageBubble(sender: messageSender, text: messageText,isMe: currentUSer==messageSender);
                        messageBubbles.add(messageBubble);
                      }
                    }
                    );
                    return Expanded(
                      child: ListView(
                        // for ordering of messages
                        reverse: true,
                        children: messageBubbles,
                      ),
                    );
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText=value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //send button_
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text':messageText,
                        'sender' :loggedInUser.email,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MessageBubble extends StatelessWidget {
  //const MessageBubble({Key? key}) : super(key: key);

   MessageBubble({required this. sender,required this.text,required this.isMe});

  late final String  sender;
  late final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe?CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text(sender,style: const TextStyle(
            fontSize: 12.0,
            color: Colors.black54,
          ),),
          Material(
            borderRadius: isMe?BorderRadius.only(topLeft: Radius.circular(30.0),bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0)):
            BorderRadius.only(bottomLeft: Radius.circular(30.0),bottomRight: Radius.circular(30.0),topRight: Radius.circular(30.0)),
            elevation: 5.0,
            color: isMe?Colors.lightBlueAccent:Colors.white,
            child: Padding(
              padding:  EdgeInsets.symmetric(vertical: 10.0,horizontal:20.0 ),
              child: Text(
                text ,
                style:  TextStyle(
                  color: isMe?Colors.white : Colors.black54,
                  fontSize :15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

