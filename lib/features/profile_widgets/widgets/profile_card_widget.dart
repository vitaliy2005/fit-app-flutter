import 'package:flutter/material.dart';

class ProfileCard {
  final TextEditingController controller;
  final String description;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  ProfileCard({required this.controller, required this.description, this.keyboardType, this.validator});
}

class ProfileCardWidget extends StatelessWidget {
  final List<ProfileCard> field;
  final Widget leading;

  const ProfileCardWidget({super.key, required this.leading, required this.field});

  @override
  Widget build(BuildContext context) {
    final child = Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 68,
          alignment: Alignment.center, // 🔥 центрируем вертикально
            child: leading,
          ),
        Expanded(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 12, 0, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: _buildFieldsList(),
          ),
        ),
      ),
      ],
    );

    return IntrinsicHeight(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.95),
          borderRadius: BorderRadius.circular(12),
        
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.28),
              blurRadius: 28,
              spreadRadius: -6,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  List<Widget> _buildFieldsList() {
    List<Widget> widgets = [];
    for (int i = 0; i < field.length; i++) {
      widgets.add(
        Padding(
          padding: EdgeInsets.fromLTRB(0, i != field.length ? 12 : 8, 16, i != field.length ? 8 : 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                validator: field[i].validator,
                controller: field[i].controller,
                keyboardType: field[i].keyboardType,
                decoration: const InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 10),
                  border: InputBorder.none,
                ),
              ),
              Text(
                field[i].description,
                style: TextStyle(color: Colors.grey[400], fontSize: 10),
              )
            ],
          ),
        )
      );

      if (i != field.length - 1) {
        widgets.add(Container(height: 1, color: Colors.grey.withValues(alpha: 0.15)));
      }
    }

    return widgets;
  }
}
