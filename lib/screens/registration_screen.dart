import 'package:flutter/material.dart';
import 'package:convo_nation/componenets/rounded_button.dart';
import 'package:convo_nation/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
 final _auth = FirebaseAuth.instance;
 // spinner is to show loading while registering
 bool showSpinner = false;
  late String email;
late String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      //modal progress is for spinner
      body: ModalProgressHUD(
        inAsyncCall:showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password=value;
                  //Do something with the user input.
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(title:'Register' ,
                colour:Colors.blueAccent,
                onPressed: ()async{

                setState(() {
                  showSpinner =true;
                });
                  // print(email);
                  // print(password);
                  // we are using await to make sure new user is valid before moving to next step
                  try {
                    final newUser = await _auth.createUserWithEmailAndPassword(
                        email: email, password: password);
                    if(newUser!=null)
                      Navigator.pushNamed(context, ChatScreen.id);
                    // to end spinner
                  setState(() {
                    showSpinner=false;
                  });
                  }

                  catch(e){
                    print(e);
                  }
                 },
              )
            ],
          ),
        ),
      ),
    );
  }
}
