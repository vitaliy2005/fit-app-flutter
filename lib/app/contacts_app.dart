import 'package:contacts_app/features/auth/bloc/auth/auth_bloc.dart';
import 'package:contacts_app/features/health_widgets/bloc/health_widgets_bloc/health_widgets_bloc.dart';
import 'package:flutter/material.dart';
import 'package:contacts_app/router/router.dart';
import 'package:contacts_app/theme/theme.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';


class ContactApp extends StatelessWidget {
  const ContactApp({super.key});

  @override
  Widget build(BuildContext context){
    return MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>.value(value: GetIt.I<AuthBloc>()),
          BlocProvider<HealthWidgetsBloc>.value(value: GetIt.I<HealthWidgetsBloc>(),)
        ],
        child: MaterialApp(
          title: 'Contact',
          theme: darkTheme,
          routes: routes,
        ),
    );
  }
}