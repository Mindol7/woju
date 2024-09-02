import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:woju/provider/home/user_password_change_state_notifier.dart';
import 'package:woju/provider/textfield_focus_state_notifier.dart';

import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';

class UserPasswordChangePage extends ConsumerWidget {
  const UserPasswordChangePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final password = ref.watch(userPasswordChangeStateProvider);
    final passwordNotifier =
        ref.watch(userPasswordChangeStateProvider.notifier);
    final focus = ref.watch(textfieldFocusStateProvider(2));
    final focusNotifier = ref.watch(textfieldFocusStateProvider(2).notifier);
    return CustomScaffold(
      title: "home.userProfile.userPasswordChange.title",
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 현재 비밀번호 입력
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 32, bottom: 8, top: 32),
              child: const CustomText(
                "home.userProfile.userPasswordChange.currentPassword",
                isBold: true,
                isColorful: true,
              ),
            ),
            CustomTextfieldContainer(
              fieldKey: password.currentPasswordFieldKey,
              prefixIcon: const Icon(CupertinoIcons.lock_fill),
              labelText: password.currentPassword.labelTextWithParameter(false),
              validator: password.currentPassword.validator,
              focusNode: focus.first,
              onChanged: (value) {
                passwordNotifier.onChangeUpdatePassword(
                    password.currentPasswordFieldKey, value);
              },
              keyboardType: TextInputType.visiblePassword,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (value) {
                focusNotifier.nextFocusNode();
              },
              inputFormatters: password.currentPassword.getInputFormatter,
              obscureText: !password.currentPassword.isPasswordVisible,
              actions: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: IconButton(
                    onPressed: () =>
                        passwordNotifier.onPressedUpdateVisiblePassword(
                      password.currentPasswordFieldKey,
                    ),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(80, 80),
                    ),
                    icon: (password.currentPassword.isPasswordVisible)
                        ? const Icon(
                            CupertinoIcons.eye_fill,
                            size: 24,
                            semanticLabel:
                                "accessibility.hidePasswordFieldButton",
                          )
                        : const Icon(
                            CupertinoIcons.eye_slash_fill,
                            size: 24,
                            semanticLabel:
                                "accessibility.showPasswordFieldButton",
                          ),
                  ),
                ),
              ],
            ),

            // 새 비밀번호 입력
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 32, bottom: 8, top: 16),
              child: const CustomText(
                "home.userProfile.userPasswordChange.newPassword",
                isBold: true,
                isColorful: true,
              ),
            ),
            CustomTextfieldContainer(
              fieldKey: password.newPasswordFieldKey,
              focusNode: focus.last,
              prefixIcon: const Icon(CupertinoIcons.lock_shield_fill),
              labelText: password.newPassword.labelTextWithParameter(false),
              validator: password.newPassword.validator,
              onChanged: (value) {
                passwordNotifier.onChangeUpdatePassword(
                    password.newPasswordFieldKey, value);
              },
              keyboardType: TextInputType.visiblePassword,
              inputFormatters: password.newPassword.getInputFormatter,
              autofillHints: const [AutofillHints.password],
              textInputAction: TextInputAction.done,
              onFieldSubmitted:
                  passwordNotifier.onPressedChangePasswordAPI(context),
              obscureText: !password.newPassword.isPasswordVisible,
              actions: [
                SizedBox(
                  height: 80,
                  width: 80,
                  child: IconButton(
                    onPressed: () =>
                        passwordNotifier.onPressedUpdateVisiblePassword(
                      password.newPasswordFieldKey,
                    ),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize: const Size(80, 80),
                    ),
                    icon: (password.newPassword.isPasswordVisible)
                        ? const Icon(
                            CupertinoIcons.eye_fill,
                            size: 24,
                            semanticLabel:
                                "accessibility.hidePasswordFieldButton",
                          )
                        : const Icon(
                            CupertinoIcons.eye_slash_fill,
                            size: 24,
                            semanticLabel:
                                "accessibility.showPasswordFieldButton",
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButtonText:
          "home.userProfile.userPasswordChange.changePassword",
      floatingActionButtonCallback:
          passwordNotifier.onPressedChangePasswordAPI(context),
    );
  }
}
