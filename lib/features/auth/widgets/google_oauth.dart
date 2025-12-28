import 'dart:async';

import 'package:contacts_app/features/auth/bloc/auth/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';


class GoogleOauth extends StatefulWidget {
  const GoogleOauth({super.key});

  @override
  State<GoogleOauth> createState() => _GoogleOauthState();
}

class _GoogleOauthState extends State<GoogleOauth> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        onPressed: (){
          final completer = Completer();
          context.read<AuthBloc>().add(AuthEventOauthGoogle(completer: completer));
        },
        icon: Image.asset(
          'assets/logo/google_logo.png',
          height: 28,
        ),
        label: Text(
          'Продолжить с Google',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          elevation: 4,
          shadowColor: Colors.black.withValues(alpha: 0.35),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: const BorderSide(
              color: Color(0xFFDDDDDD),
              width: 1.5,
            ),
          ),
          alignment: Alignment.centerLeft,
        )
    );
  }
}




