import 'package:flutter/material.dart';
import 'package:flutter_first_project/login_screen.dart';
import 'package:flutter_first_project/register_screen.dart';

class WelcomeScreen extends StatelessWidget { // ما تتغيرش لما نستخدمها
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //  صورة الخلفية
          Positioned.fill(
            child: Image.asset(
              'images/background.jpg',
              fit: BoxFit.cover, // الصورة تكون في كل الشاشة
            ),
          ),

          //  محتوى الشاشة
          Align(
            alignment: Alignment.bottomCenter, // حددت مكانه لوطة في الشاشة
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(40)),
              ),
              child: Column( //نرتب المحتوى من فوق للوطة
                mainAxisSize: MainAxisSize.min,
                children: [
                  //  الشعار دائرة سوداء فيها SB
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "SB",
                      style: TextStyle(color: Colors.white, fontSize: 28),
                    ),
                  ),

                  const SizedBox(height: 20),

                  //  النص
                  const Text(
                    "Develop your knowledge and read more with our app."
                    "Discover books wherever you are. Happy reading! ",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Colors.black87 , fontFamily: 'Roboto'),
                  ),

                  const SizedBox(height: 20),

                  // زر Get Started
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 45),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: const Text("Get Started",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Roboto',
                    ),
                    ),
                  ),


                  const SizedBox(height: 10),

                  //  زر Register
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black, //
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterScreen()),
                      );
                    },
                    child: const Text("Register"),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
