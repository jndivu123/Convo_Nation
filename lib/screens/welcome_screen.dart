import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';
import'package:animated_text_kit/animated_text_kit.dart';
import 'package:convo_nation/componenets/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  // static is a modifier and to create routes we dont have to make object of welcome screen,instead just pass it as it as
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
//if we want to add multiple animations we need to remove single from ticker provider
//   AnimationController controller=AnimationController(
//     // vsync is ticker provider
//     vsync: this,
//     duration:Duration(seconds:1),
//     // upperBound: 100.0,
//   );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   // controller = AnimationController(
      // vsync is ticker provider
    //   vsync: this,
    //   duration:Duration(seconds:1),
    //   // upperBound: 100.0,
    // );
    //controller.forward();
    //controller.addListener(() {
    //   setState((){});
    //   //print(controller.value);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    //controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  child: Image.asset('images/logo.png'),
                  height: 60.0,
                ),
                AnimatedTextKit(
                    animatedTexts:[
                      TypewriterAnimatedText(
                        'ConvoChat',
                        textStyle: const TextStyle(
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ]
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(title: 'Log in',colour: Colors.lightBlueAccent,onPressed: () {
              Navigator.pushNamed(context, LoginScreen.id);
              //Go to login screen.
            },
            ),

            RoundedButton(title: 'Register',colour: Colors.blueAccent,onPressed: () {
              Navigator.pushNamed(context, RegistrationScreen.id);
              //Go to login screen.
            },
            ),

          ],
        ),
      ),
    );
  }
}

