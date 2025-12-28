import 'package:contacts_app/features/profile_widgets/profile_widgets_bloc/bloc/profile_widgets_bloc.dart';
import 'package:contacts_app/features/profile_widgets/view/profile_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../features/health_widgets/view/view.dart';
import '../features/auth/view/view.dart';

final routes = {
  '/': (context) => AuthScreen(),
  '/registration': (context) => RegistrationScreen(),
  '/contact': (context) => HealthListScreen(),
  '/detail': (context) => PlantDetailPage(startIndexWidget: 0,),
  '/profile': (_) => const ProfileRoute(),
};


class ProfileRoute extends StatelessWidget {
  const ProfileRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GetIt.I<ProfileWidgetsBloc>(),
      child: const ProfileScreen(),
    );
  }
}