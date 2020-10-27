import 'package:flutter/material.dart';
import 'package:simple_notes/bloc/authBloc.dart';
import 'package:simple_notes/pages/widgets/continueButton.dart';
import 'package:simple_notes/pages/widgets/inputField.dart';

import 'notesPage.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _bloc = AuthBloc();

  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isWrongAuth = false;
  String _wrongMessage = "";

  @override
  void initState() {
    _bloc.outputStateStream.listen((resp) {
      if (resp.isCorrect) {
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => NotesPage(user: resp.user)));
      } else {
        setState(() {
          _isWrongAuth = true;
          _wrongMessage = "Такой пользователь уже существует.";
        });
      }
    });
    super.initState();
  }

  void singUp() {
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
        .add(Request(_loginController.text, _passwordController.text, Event.registration));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(60.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sign Up",
                  maxLines: 1,
                  overflow: TextOverflow.visible,
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
                  onSubmitted: (_) => singUp(),
                ),
                SizedBox(height: 20),
                ContinueButton(
                  title: 'Продолжить',
                  onPressed: singUp,
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
