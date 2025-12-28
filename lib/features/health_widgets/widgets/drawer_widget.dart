import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String name;
  final String surname;
  final String? avatarUrl;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final double width;

  const AppDrawer({
    super.key,
    required this.name,
    required this.surname,
    this.avatarUrl,
    this.onProfileTap,
    this.onSettingsTap,
    this.width = 280,
  });

  String get initials {
    final n = name.trim();
    final s = surname.trim();
    String a = n.isNotEmpty ? n[0].toUpperCase() : '';
    String b = s.isNotEmpty ? s[0].toUpperCase() : '';
    return (a + b).isNotEmpty ? (a + b) : '?';
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return SizedBox(
      width: width,
      child: Drawer(
        elevation: 0,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF8F0), Color.fromARGB(255, 198, 233, 231)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: statusBarHeight),

              // ---------- HEADER ----------
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: onProfileTap,
                  child: Row(
                    children: [
                      // Аватар
                      SizedBox(
                        width: 64,
                        height: 64,
                        child: ClipOval(
                          child: avatarUrl != null
                              ? Image.network(
                                  avatarUrl!,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: Colors.grey.shade300,
                                  child: Center(
                                    child: Text(
                                      initials,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      // Имя пользователя
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "$name $surname",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 8),

              const Divider(thickness: 0.5, color: Colors.black26),

              // ---------- MENU ----------
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Профиль'),
                onTap: onProfileTap,
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Настройки'),
                onTap: onSettingsTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------------------------
// Оставил твой кастомный виджет, но теперь он не используется,
// потому что CircleAvatar требует double, а не Widget.
// ------------------------------------------------------------

class ThirtyTwo extends StatelessWidget {
  const ThirtyTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: const _AvatarContent(),
    );
  }
}

class _AvatarContent extends StatelessWidget {
  const _AvatarContent();

  @override
  Widget build(BuildContext context) {
    return const FlutterLogo();
  }
}
