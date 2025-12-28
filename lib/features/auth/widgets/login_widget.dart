import 'dart:async';

import 'package:contacts_app/features/auth/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:contacts_app/core/utils/validators.dart';

class LoginWidget extends StatelessWidget {
  LoginWidget({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fieldWidth = screenWidth > 400 ? 350 : screenWidth * 0.9;

    return Form(
      key: _formKey,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            SizedBox(
              width: fieldWidth,
              child: TextFormField(
                controller: _emailController,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Введите ваш email',
                  prefixIcon: const Icon(Icons.email_sharp),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
                validator: validateEmail,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: fieldWidth,
              child: TextFormField(
                obscureText: true,
                controller: _passwordController,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Введите ваш password',
                  prefixIcon: const Icon(Icons.vpn_key),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                  ),
                ),
                validator: validatePassword
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shadowColor: Colors.black.withValues(alpha: 0.35),
                    disabledIconColor: Colors.black87,
                    foregroundColor: Colors.black87,
                    minimumSize: Size(150, 48),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(
                        color: Color(0xFFDDDDDD),
                        width: 1.5,
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/registration');
                  },
                  child: Text(
                    "Зарегистрироваться",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shadowColor: Colors.black.withValues(alpha: 0.35),
                    disabledIconColor: Colors.black87,
                    foregroundColor: Colors.black87,
                    minimumSize: Size(150, 48),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                      side: const BorderSide(
                        color: Color(0xFFDDDDDD),
                        width: 1.5,
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Completer completer = Completer();
                      context.read<AuthBloc>().add(AuthEventLogin(completer: completer, email: _emailController.text, password: _passwordController.text));
                    }
                  },
                  child: Text(
                    "Войти",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}