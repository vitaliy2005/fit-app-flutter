import 'package:contacts_app/core/utils/validators.dart';
import 'package:contacts_app/features/health_widgets/widgets/widgets.dart';
import 'package:contacts_app/features/profile_widgets/profile_widgets_bloc/bloc/profile_widgets_bloc.dart';
import 'package:contacts_app/features/profile_widgets/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatefulWidget {

  const ProfileScreen({super.key,});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController emailController;
  late TextEditingController numberController;
  late TextEditingController userIdController;
  late TextEditingController _oldPasswordController;

  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    surnameController = TextEditingController();
    emailController = TextEditingController();
    numberController = TextEditingController();
    userIdController = TextEditingController();
    _oldPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    emailController.dispose();
    numberController.dispose();
    userIdController.dispose();
    _oldPasswordController.dispose();

    super.dispose();
  }

  String get initials {
    final n = nameController.text.trim();
    final s = surnameController.text.trim();
    String a = n.isNotEmpty ? n[0].toUpperCase() : '';
    String b = s.isNotEmpty ? s[0].toUpperCase() : '';
    return (a + b).isNotEmpty ? (a + b) : '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF8F0), Color.fromARGB(255, 198, 233, 231)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              final avatarSize = (width * 0.28).clamp(100.0, 140.0);
              final avatarTopOffset = 18.0;
              final contentTopPadding = avatarTopOffset + avatarSize + 22;

              return BlocConsumer<ProfileWidgetsBloc, ProfileWidgetsState>(
                listener: (context, state) {
                  if (state is ProfileWidgetsLoaded && !_initialized) {
                    surnameController.text = state.surname;
                    nameController.text = state.name;
                    emailController.text = state.email;
                    userIdController.text = state.userId;
                    numberController.text = state.number;
                  }
                },
                builder: (context, state) {
                  if(state is ProfileWidgetsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  // if (state is ProfileWidgetsError) {
                  //   return ErrorView(
                  //     message: state.message,
                  //     onRetry: () {
                  //       context.read<ProfileWidgetsBloc>().add(ProfileWidgetsReadEvent());
                  //     },
                  //   );
                  // }
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: SingleChildScrollView(
                          padding: EdgeInsets.fromLTRB(
                              20, contentTopPadding / 2, 20, 36),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: avatarSize,
                                height: avatarSize,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withValues(alpha: 0.95),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.28),
                                      blurRadius: 28,
                                      spreadRadius: -6,
                                      offset: const Offset(0, 14),
                                    ),
                                  ],
                                ),
                                child: Center(
                                        child: Text(
                                          initials,
                                          style: TextStyle(
                                            fontSize: avatarSize * 0.35,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black
                                                .withValues(alpha: 0.7),
                                          ),
                                        ),
                                      )
                              ),
                              const SizedBox(height: 16),
                              ProfileCardWidget(
                                leading: const Icon(Icons.person,
                                    size: 28, color: Color(0xFF597A99)),
                                field: [
                                  ProfileCard(
                                      controller: nameController,
                                      description:
                                          'Нажмите чтобы изменить имя'),
                                  ProfileCard(
                                    controller: surnameController,
                                    description:
                                        'Нажмите чтобы изменить фамилию',
                                  ),
                                  ProfileCard(
                                    controller: userIdController,
                                    description:
                                        'Нажмите чтобы изменить идентификатор пользователя',
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              ProfileCardWidget(
                                leading: Icon(Icons.mail_outline,
                                    size: 26, color: const Color(0xFF597A99)),
                                field: [
                                  ProfileCard(
                                    validator: validateEmail,
                                    controller: emailController,
                                    description: 'Нажмите чтобы поменять email',
                                  )
                                ],
                              ),
                              const SizedBox(height: 16),
                              ProfileCardWidget(
                                leading: Icon(Icons.phone,
                                    size: 26, color: const Color(0xFF597A99)),
                                field: [
                                  ProfileCard(
                                      controller: numberController,
                                      description:
                                          'Нажмите чтобы изменить номер телефона')
                                ],
                              ),
                              const SizedBox(height: 16),
                              ProfileCardWidget(
                                leading: Icon(Icons.key,
                                    size: 26, color: const Color(0xFF597A99)),
                                field: [
                                  ProfileCard(
                                      controller: _oldPasswordController,
                                      description:
                                          'Нажмите чтобы изменить пароль')
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        left: 8,
                        child: BackButtonCustom(returnIndex: null),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
