import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart ';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  void _submitForm(
    String email,
    String password,
    String username,
    bool isLogin,
    BuildContext ctx,
  ) async {
    UserCredential userCreds;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        userCreds = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      } else {
        userCreds = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCreds.user!.uid)
            .set({
          'username': username,
          'email': email,
        });
      }
    } on PlatformException catch (error) {
      var message = 'An error occured, please check your credentials';
      setState(() {
        _isLoading = false;
      });

      if (error.message != null) {
        message = error.message!;
      }

      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(ctx).colorScheme.error,
          content: Text(message),
        ),
      );
    } catch (err) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(ctx).showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(ctx).colorScheme.error,
          content: Text(err.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: AuthForm(
        submitForm: _submitForm,
        isLoading: _isLoading,
      ),
    );
  }
}
