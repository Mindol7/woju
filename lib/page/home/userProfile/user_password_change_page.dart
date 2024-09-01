import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:woju/theme/widget/custom_text.dart';

class UserPasswordChangePage extends ConsumerWidget {
  const UserPasswordChangePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const CustomText(
          '비밀번호 변경',
          isTitle: true,
        ),
      ),
    );
  }
}
