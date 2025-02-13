import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/provider/onboarding/sign_up_state_notifier.dart';
import 'package:woju/provider/textfield_focus_state_notifier.dart';

import 'package:woju/theme/widget/custom_app_bar_action_button.dart';
import 'package:woju/theme/widget/custom_country_picker_widget.dart';
import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_text_button.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUp = ref.watch(signUpStateProvider);
    final signUpNotifier = ref.read(signUpStateProvider.notifier);
    final focus = ref.watch(textfieldFocusStateProvider(4));
    final theme = Theme.of(context);
    return CustomScaffold(
      title: "onboarding.signUp.title",
      appBarActions: [
        CustomAppBarTextButton(
          text: "onboarding.signUp.signin",
          onPressed: () {
            context.go('/onboarding/signin');
          },
        ),
      ],
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: <Widget>[
            // 전화번호 입력
            CustomTextfieldContainer(
              fieldKey: 'phoneNumberForSignUp',
              margin: const EdgeInsets.only(
                top: 16,
                bottom: 8,
              ),
              prefix: CustomCountryPickerWidget(
                onChanged:
                    ref.read(signUpStateProvider.notifier).onChangedCountryCode,
                searchDecoration: InputDecoration(
                  labelText: "onboarding.signUp.searchCountry".tr(),
                ),
                builder: (country) {
                  if (country == null) {
                    return const SizedBox.shrink();
                  }
                  return SizedBox(
                    height: 48,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          country.flagUri ?? '',
                          package: 'country_code_picker',
                          width: 32,
                        ),
                        const SizedBox(width: 8),
                        CustomText(
                          country.dialCode ?? '',
                          style: (signUp.userAuthModel.authCodeSent)
                              ? theme.textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey,
                                )
                              : theme.primaryTextTheme.bodyMedium,
                          isLocalize: false,
                        ),
                        // const SizedBox(width: 16),
                      ],
                    ),
                  );
                },
                isDisabled: signUp.userAuthModel.authCompleted,
              ),
              labelText: signUp.userPhoneModel.labelTextWithParameter(
                signUp.userAuthModel.authCompleted,
              ),
              validator: signUp.userPhoneModel.validator,
              focusNode: focus[0],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                ref
                    .read(signUpStateProvider.notifier)
                    .onChangePhoneNumberField(value);
              },
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: signUp.userPhoneModel.inputFormatters,
              autofillHints: const <String>[
                AutofillHints.telephoneNumberNational,
              ],
              enabled: !signUp.userAuthModel.authCodeSent,
              textStyle: (signUp.userAuthModel.authCodeSent)
                  ? theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    )
                  : theme.primaryTextTheme.bodyMedium,
              actions: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: (signUp.userAuthModel.authCodeSent)
                      ? CustomTextButton(
                          "onboarding.signUp.changePhoneNumber",
                          onPressed: () {
                            ref
                                .read(signUpStateProvider.notifier)
                                .onClickChangePhoneNumberButton();
                          },
                          minimumSize: const Size(80, 80),
                        )
                      : CustomTextButton(
                          "onboarding.signUp.sendCode",
                          onPressed: signUpNotifier.onClickSendAuthCodeButton(),
                          minimumSize: const Size(80, 80),
                        ),
                ),
              ],
            ),

            if (!signUp.userAuthModel.authCodeSent)
              Column(
                children: [
                  // 약관 동의
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: signUp.termsAgree,
                    onChanged: signUpNotifier.onClickTermsAgreeButton,
                    enabled: !signUp.userAuthModel.authCodeSent,
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: CustomText(
                            "onboarding.signUp.termsAgreement.title",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: (signUp.userAuthModel.authCodeSent)
                                  ? Colors.grey
                                  : theme.primaryTextTheme.bodyMedium?.color,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: CustomTextButton(
                            "onboarding.signUp.termsAgreement.subtitle",
                            textStyle: theme.textTheme.labelMedium?.copyWith(
                              color: (signUp.userAuthModel.authCodeSent)
                                  ? Colors.grey
                                  : theme.primaryTextTheme.bodyMedium?.color,
                            ),
                            minimumSize: const Size(80, 48),
                            onPressed: () {
                              signUpNotifier.onClickPushPolicyPageButton(
                                  context, "terms");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  // 개인정보처리방침 동의
                  CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: signUp.privacyAgree,
                    onChanged: signUpNotifier.onClickPrivacyAgreeButton,
                    enabled: !signUp.userAuthModel.authCodeSent,
                    contentPadding: EdgeInsets.zero,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 200,
                          child: CustomText(
                            "onboarding.signUp.privacyAgreement.title",
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: (signUp.userAuthModel.authCodeSent)
                                  ? Colors.grey
                                  : theme.primaryTextTheme.bodyMedium!.color,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 100,
                          child: CustomTextButton(
                            "onboarding.signUp.privacyAgreement.subtitle",
                            textStyle: theme.textTheme.labelMedium?.copyWith(
                              color: (signUp.userAuthModel.authCodeSent)
                                  ? Colors.grey
                                  : theme.primaryTextTheme.bodyMedium!.color,
                            ),
                            minimumSize: const Size(80, 48),
                            onPressed: () {
                              signUpNotifier.onClickPushPolicyPageButton(
                                  context, "privacy");
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

            // 인증코드 요청 시 입력한 전화번호로 전송된 인증코드 입력창 표시
            if (signUp.userAuthModel.authCodeSent &&
                !signUp.userAuthModel.authCompleted)
              CustomTextfieldContainer(
                fieldKey: 'authCodeForSignUp',
                labelText: signUp.userAuthModel.labelText,
                margin: const EdgeInsets.symmetric(vertical: 16),
                actions: [
                  CustomTextButton(
                    "status.authcode.resend",
                    onPressed: signUpNotifier.onClickResendAuthCodeButton(),
                    minimumSize: const Size(80, 80),
                  ),
                  CustomTextButton(
                    (!signUp.userAuthModel.authCompleted)
                        ? "status.authcode.verify"
                        : "status.authcode.verified",
                    onPressed: signUpNotifier.onClickVerifyAuthCodeButton(),
                    minimumSize: const Size(80, 80),
                  ),
                ],
                keyboardType: TextInputType.number,
                autofillHints: const <String>[AutofillHints.oneTimeCode],
                onChanged: (value) {
                  ref
                      .read(signUpStateProvider.notifier)
                      .updateUserAuthModel(authCode: value);
                },
                inputFormatters: signUp.userAuthModel.inputFormatters,
                enabled: !signUp.userAuthModel.authCompleted,
                textStyle: (signUp.userAuthModel.authCompleted)
                    ? theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      )
                    : theme.primaryTextTheme.bodyMedium,
                focusNode: focus[1],
                validator: signUp.userAuthModel.validator,
              )
            else
              Container(),
            // 인증 완료 시 아이디 입력창 표시
            if (signUp.userAuthModel.authCompleted)
              CustomTextfieldContainer(
                fieldKey: 'userIDForSignUp',
                prefixIcon: const Icon(Icons.person),
                labelText: signUp.userIDModel.labelTextWithParameter(true),
                margin: const EdgeInsets.symmetric(vertical: 16),
                keyboardType: TextInputType.streetAddress,
                autofillHints: const <String>[AutofillHints.newUsername],
                onChanged: (value) {
                  ref.read(signUpStateProvider.notifier).updateUserID(value);
                },
                inputFormatters: signUp.userIDModel.inputFormatters,
                validator: signUp.userIDModel.validator,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                enabled: !signUp.userIDModel.isIDAvailable,
                textStyle: (signUp.userIDModel.isIDAvailable)
                    ? theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      )
                    : theme.primaryTextTheme.bodyMedium,
                focusNode: focus[2],
                actions: [
                  SizedBox(
                    width: 80,
                    child: (signUp.userIDModel.isIDAvailable)
                        ? CustomTextButton(
                            "onboarding.signUp.modifyUserID",
                            onPressed: () {
                              ref
                                  .read(signUpStateProvider.notifier)
                                  .onClickModifyIDButton();
                            },
                            minimumSize: const Size(80, 80),
                          )
                        : CustomTextButton(
                            "onboarding.signUp.userIDCheck",
                            onPressed: ref
                                .read(signUpStateProvider.notifier)
                                .checkAvailableIDButtonMethod(),
                            minimumSize: const Size(80, 80),
                          ),
                  ),
                ],
              )
            else
              Container(),

            // 아이디 입력 완료 시 비밀번호 입력창 표시
            if (signUp.userIDModel.isIDAvailable)
              CustomTextfieldContainer(
                fieldKey: 'passwordForSignUp',
                prefixIcon: const Icon(
                  CupertinoIcons.lock_fill,
                  size: 24,
                ),
                margin: const EdgeInsets.symmetric(vertical: 16),
                labelText: signUp.userPasswordModel.labelText,
                keyboardType: TextInputType.visiblePassword,
                autofillHints: const <String>[AutofillHints.newPassword],
                onChanged: ref
                    .read(signUpStateProvider.notifier)
                    .onChangePasswordField,
                inputFormatters: signUp.userPasswordModel.inputFormatters,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                focusNode: focus[3],
                validator: signUp.userPasswordModel.validator,
                obscureText: !signUp.userPasswordModel.isPasswordVisible,
                actions: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: IconButton(
                      onPressed: () {
                        ref
                            .read(signUpStateProvider.notifier)
                            .onClickChangePasswordVisibilityButton();
                      },
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        fixedSize: const Size(80, 80),
                      ),
                      icon: (signUp.userPasswordModel.isPasswordVisible)
                          ? Icon(CupertinoIcons.eye_fill,
                              size: 24,
                              semanticLabel:
                                  "accessibility.hidePasswordFieldButton".tr())
                          : Icon(CupertinoIcons.eye_slash_fill,
                              size: 24,
                              semanticLabel:
                                  "accessibility.showPasswordFieldButton".tr()),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
      floatingActionButtonCallback:
          signUpNotifier.onClickNextPageButton(context),
      floatingActionButtonText: "onboarding.signUp.next",
    );
  }
}
