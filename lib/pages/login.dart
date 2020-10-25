import 'package:flutter/material.dart';
import 'package:simple_notes/bloc/authBloc.dart';
import 'package:simple_notes/pages/notesPage.dart';
import 'package:simple_notes/pages/registration.dart';
import 'package:simple_notes/pages/widgets/continueButton.dart';
import 'package:simple_notes/pages/widgets/inputField.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _bloc = AuthBloc();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isWrongAuth = false;
  String _wrongMessage = "";

  @override
  void initState() {
    _bloc.outputStateStream.listen((resp) {
      if (resp.isCorrect) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NotesPage(user: resp.user)));
      } else {
        setState(() {
          _isWrongAuth = true;
          _wrongMessage =
              "Неверный логин или пароль! Попробуйте другой или зарегистрируйтесь.";
        });
      }
    });
    super.initState();
  }

  void singIn() {
    if (_loginController.text.isEmpty) {
      setState(() {
        _isWrongAuth = true;
        _wrongMessage = "Поле Login осталось пустым!";
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _isWrongAuth = true;
        _wrongMessage = "Поле Password осталось пустым!";
      });
      return;
    }

    _bloc.inputEventSink
        .add(Request(_loginController.text.trim(), _passwordController.text.trim(), Event.login));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 15, 101, 246),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(60.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Login",
                  style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 50),
                InputField(
                  hintText: 'Login',
                  controller: _loginController,
                  onChanged: (_) => setState(() => _isWrongAuth = false),
                  obscureText: false,
                  onSubmitted: (_) {},
                ),
                SizedBox(height: 10),
                InputField(
                  hintText: 'Password',
                  controller: _passwordController,
                  onChanged: (_) => setState(() => _isWrongAuth = false),
                  obscureText: true,
                  onSubmitted: (_) => singIn(),
                ),
                FlatButton(
                  onPressed: () =>
                      Navigator.push(context, MaterialPageRoute(builder: (_) => RegistrationPage())),
                  child: Text(
                    'Нет аккаунта, зарегистрируйтесь!',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 5),
                ContinueButton(
                  title: 'Войти',
                  onPressed: singIn,
                ),
                SizedBox(height: 15),
                _isWrongAuth
                    ? Text(
                        _wrongMessage,
                        style: TextStyle(
                          fontSize: 15,
                          color: Theme.of(context).errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bloc.dispose();
    _loginController.dispose();
    _passwordController.dispose();

    super.dispose();
  }
}
