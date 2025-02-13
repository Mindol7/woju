import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:woju/model/secure_model.dart';

import 'package:woju/provider/onboarding/auth_state_notififer.dart';
import 'package:woju/provider/onboarding/phone_number_state_notifier.dart';
import 'package:woju/provider/onboarding/user_detail_info_state_notifier.dart';
import 'package:woju/provider/textfield_focus_state_notifier.dart';

import 'package:woju/service/api/user_service.dart';
import 'package:woju/service/secure_storage_service.dart';
import 'package:woju/service/toast_message_service.dart';
import 'package:woju/theme/widget/custom_country_picker_widget.dart';

import 'package:woju/theme/widget/custom_scaffold.dart';
import 'package:woju/theme/widget/custom_text.dart';
import 'package:woju/theme/widget/custom_text_button.dart';
import 'package:woju/theme/widget/custom_textfield_container.dart';

class UserPhoneNumberChangePage extends ConsumerWidget {
  const UserPhoneNumberChangePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phoneNumber = ref.watch(phoneNumberStateProvider(true));
    final phoneNumberNotifier =
        ref.watch(phoneNumberStateProvider(true).notifier);
    final auth = ref.watch(authStateProvider);
    final authNotifier = ref.watch(authStateProvider.notifier);
    final focus = ref.watch(textfieldFocusStateProvider(2));
    final focusNotifier = ref.watch(textfieldFocusStateProvider(2).notifier);
    final theme = Theme.of(context);

    return CustomScaffold(
      title: 'home.userProfile.userPhoneNumberChange.title',
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // 전화번호 입력
            CustomTextfieldContainer(
              fieldKey: 'change_phone_number',
              headerText:
                  "home.userProfile.userPhoneNumberChange.newPhoneNumber",
              hearderTextPadding: EdgeInsets.zero,
              margin: const EdgeInsets.symmetric(vertical: 16),
              prefix: CustomCountryPickerWidget(
                onChanged: phoneNumberNotifier.updateCountryCode,
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
                          style: (auth.authCodeSent)
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
                isDisabled: auth.authCompleted,
              ),
              labelText: phoneNumber.labelTextWithParameter(
                auth.authCompleted,
              ),
              validator: phoneNumber.validator,
              focusNode: focus[0],
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: phoneNumberNotifier.updatePhoneNumber,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: phoneNumber.inputFormatters,
              autofillHints: const <String>[
                AutofillHints.telephoneNumberNational,
              ],
              enabled: !auth.authCodeSent,
              textStyle: (auth.authCodeSent)
                  ? theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    )
                  : theme.primaryTextTheme.bodyMedium,
              actions: [
                SizedBox(
                  width: 80,
                  child: (auth.authCodeSent)
                      ? CustomTextButton(
                          "onboarding.signUp.changePhoneNumber",
                          onPressed: () {
                            authNotifier.reset();
                            focusNotifier.setFocusNode(0);
                          },
                          minimumSize: const Size(80, 80),
                        )
                      : CustomTextButton(
                          "onboarding.signUp.sendCode",
                          onPressed: authNotifier.onClickAuthSendButton(
                            phoneNumber.phoneNumber ?? "",
                            phoneNumber.dialCode,
                            focusNotifier.nextFocusNodeMethod,
                          ),
                          minimumSize: const Size(80, 80),
                        ),
                ),
              ],
            ),

            // 인증코드 요청 시 입력한 전화번호로 전송된 인증코드 입력창 표시
            if (auth.authCodeSent && !auth.authCompleted)
              CustomTextfieldContainer(
                fieldKey: 'authCodeForSignUp',
                headerText: "home.userProfile.userPhoneNumberChange.authCode",
                hearderTextPadding: EdgeInsets.zero,
                margin: const EdgeInsets.symmetric(vertical: 16),
                labelText: auth.labelText,
                actions: [
                  CustomTextButton(
                    "status.authcode.resend",
                    onPressed: authNotifier.onClickAuthResendButton(
                      phoneNumber.phoneNumber ?? "",
                      phoneNumber.dialCode,
                      () {},
                    ),
                    minimumSize: const Size(80, 80),
                  ),
                  CustomTextButton(
                    (!auth.authCompleted)
                        ? "status.authcode.verify"
                        : "status.authcode.verified",
                    onPressed: authNotifier.onClickAuthConfirmButton(
                      context,
                      () {},
                    ),
                    minimumSize: const Size(80, 80),
                  ),
                ],
                keyboardType: TextInputType.number,
                autofillHints: const <String>[AutofillHints.oneTimeCode],
                onChanged: authNotifier.updateAuthCode,
                inputFormatters: auth.inputFormatters,
                enabled: !auth.authCompleted,
                textStyle: (auth.authCompleted)
                    ? theme.textTheme.bodyMedium!.copyWith(
                        color: Colors.grey,
                      )
                    : theme.primaryTextTheme.bodyMedium,
                focusNode: focus[1],
                validator: auth.validator,
              )
            else
              Container(),
          ],
        ),
      ),
      floatingActionButtonText:
          "home.userProfile.userPhoneNumberChange.changePhoneNumberButton",
      floatingActionButtonCallback: (!auth.authCompleted)
          ? null
          : () async {
              final userData = ref.watch(userDetailInfoStateProvider);
              final userPassword = await SecureStorageService.readSecureData(
                SecureModel.userPassword,
              );

              if (userData == null || userPassword == null) {
                if (context.mounted) {
                  ToastMessageService.nativeSnackbar(
                      "error.userDetail.nullInfo", context);
                }
                return;
              }

              final userUID = auth.userUid as String;
              final phoneNumberAsString = phoneNumber.phoneNumber as String;

              final result = await UserService.updateUserPhoneNumber(
                userData.userUUID,
                userUID,
                phoneNumberAsString,
                phoneNumber.dialCode,
                phoneNumber.isoCode,
                userPassword,
                ref,
              );

              if (result == null) {
                if (context.mounted) {
                  ToastMessageService.nativeSnackbar(
                      "status.UserServiceStatus.updateSuccess", context);
                  context.pop();
                  return;
                }
              } else {
                if (context.mounted) {
                  ToastMessageService.nativeSnackbar(result, context);
                  authNotifier.reset();
                  return;
                }
              }
            },
    );
  }
}
