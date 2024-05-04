import 'package:flutter/material.dart';
import 'package:flutter_application_1/Pages/Create_account.dart';

/* class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Function to handle the login button press
  void login(BuildContext context) async {
    // URL of the Django backend endpoint for login
    var url = 'http://your-django-backend-url/login/';

    // Send a POST request to the backend with the username and password
    var response = await http.post(Uri.parse(url), body: {
      'username': usernameController.text,
      'password': passwordController.text,
    });

    // Check the response status code
    if (response.statusCode == 200) {
      // If the response is successful, navigate to the home page
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      // If the response is not successful, show an error message
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Incorrect username or password.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
  */
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),

              //App Logo

              Image.asset(
                "assets/LearnProLogo.jpg",
                height: 200,
                width: 200,
              ),

              const SizedBox(
                height: 30,
              ),

              //Login Part

              const Center(
                child: Text(
                  "Login",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(
                height: 45,
              ),

              //E-mail

              const TextField(
                //    controller: usernameController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: "Email",
                  prefixIcon: Icon(
                    Icons.mail,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              //Password

              const TextField(
                //   controller: passwordController,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black,
                  ),
                ),
              ),

              // forgot password?

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              //Login button

              //    ElevatedButton(
              //     onPressed: () => login(context),
              // child :
              Container(
                height: 50,
                width: 400,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    "Log In",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              //  ),

              const SizedBox(height: 50),

              // or continue with

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  "Or continue with",
                  style: TextStyle(color: Colors.grey[700]),
                ),
              ),

              const SizedBox(height: 20),

              // google + facebook sign in buttons

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // google button

                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/google.png",
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          const Text("Google")
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),

                  // facebook button

                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/facebook.png",
                            height: 25,
                            width: 25,
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          const Text(
                            "Facebook",
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 50),

              // Don't have account? Create now

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have account?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreateAccount(),
                        ),
                      );
                    },
                    child: const Text(
                      "Create now",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
