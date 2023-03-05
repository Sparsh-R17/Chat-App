import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    bool isLogin,
  ) submitForm;
  const AuthForm({super.key, required this.submitForm});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';

  void _formValidation() {
    final formValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (formValid) {
      _formKey.currentState!.save();
      widget.submitForm(
        _userEmail,
        _userPassword,
        _userName,
        _isLogin,
      );
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        // color: Theme.of(context).colorScheme.primaryContainer,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      label: Text('Email Address'),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Email Cannot be Empty';
                      }
                      if (!value.contains('@')) {
                        return 'Invalid Email';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userEmail = newValue!;
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Username Cannot be Empty';
                        }
                        if (value.length < 5) {
                          return 'Enter atleast 5 character';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _userName = newValue!;
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password Cannot be Empty';
                      }
                      if (value.length < 8) {
                        return 'Password is too short';
                      }
                      return null;
                    },
                    onSaved: (newValue) {
                      _userPassword = newValue!;
                    },
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: FilledButton(
                      onPressed: _formValidation,
                      child: Text(
                        _isLogin ? 'Login' : 'Signup',
                      ),
                    ),
                  ),
                  TextButton(
                    style: const ButtonStyle(
                      splashFactory: NoSplash.splashFactory,
                      overlayColor: MaterialStatePropertyAll(
                        Colors.transparent,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(
                      _isLogin
                          ? 'Create new Account'
                          : 'Already have an account',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
