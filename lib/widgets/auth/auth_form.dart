import 'dart:io';

import 'package:flutter/material.dart';

import '../picker/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    String username,
    File userImage,
    bool isLogin,
    BuildContext context,
  ) submitForm;
  final bool isLoading;
  const AuthForm({
    super.key,
    required this.submitForm,
    required this.isLoading,
  });

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _userEmail = '';
  String _userName = '';
  String _userPassword = '';
  File? _userImage;

  void _imagePickerFn(File image) {
    _userImage = image;
  }

  void _formValidation() {
    final formValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (_userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please pick an image'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }
    if (formValid) {
      _formKey.currentState!.save();
      widget.submitForm(
        _userEmail.trim(),
        _userPassword.trim(),
        _userName.trim(),
        _userImage!,
        _isLogin,
        context,
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
                  if (!_isLogin) UserImagePicker(imagePickedFn: _imagePickerFn),
                  TextFormField(
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
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
                      textCapitalization: TextCapitalization.words,
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
                  if (widget.isLoading) const CircularProgressIndicator(),
                  if (!widget.isLoading)
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: FilledButton(
                        onPressed: _formValidation,
                        child: Text(
                          _isLogin ? 'Login' : 'Signup',
                        ),
                      ),
                    ),
                  if (!widget.isLoading)
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
