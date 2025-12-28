import 'package:contacts_app/features/auth/bloc/auth/auth_bloc.dart';
import 'package:contacts_app/features/auth/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state is AuthAuthenticated) {
            Navigator.pushNamedAndRemoveUntil(context, '/contact', (route) => false);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ошибка: ${state.errorMessage}')),
            );
          } else if (state is AuthRegistration) {

          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              const Spacer(flex: 2),
              LoginWidget(),
              const Spacer(flex: 4),
              const GoogleOauth(),
              const Spacer(flex: 4),
            ],
          );
        },
      ),
    );
  }
}
