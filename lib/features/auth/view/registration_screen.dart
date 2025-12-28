import 'package:contacts_app/features/auth/bloc/registration/registration_bloc.dart';
import 'package:contacts_app/features/auth/widgets/widgets.dart';
import 'package:contacts_app/repositories/login/login_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration'),
      ),
      backgroundColor: Colors.white,
      body: BlocProvider(
        create: (context) => RegistrationBloc(loginRepository: GetIt.I<LoginRepository>()),
        child: BlocConsumer<RegistrationBloc, RegistrationState>(
          builder: (context, state) {
            return Column(
              children: [
                const Spacer(flex: 2),
                RegistrationWidget(),
                const Spacer(flex: 4),
                const GoogleOauth(),
                const Spacer(flex: 4),
              ],
            );
          },
          listener: (context, state) {
            if(state is RegistrationSuccess){
              Navigator.pop(context, true);
            }
          },
        ),
      ),
    );
  }
}
