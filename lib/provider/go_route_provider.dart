import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:woju/model/app_state_model.dart';
import 'package:woju/model/item/item_model.dart';
import 'package:woju/model/onboarding/sign_in_model.dart';

import 'package:woju/page/error/router_error_page.dart';
import 'package:woju/page/error/server_error_page.dart';
import 'package:woju/page/home/main/addItem/add_item_page.dart';
import 'package:woju/page/home/main/addItem/barter_place_select_page.dart';
import 'package:woju/page/home/main/addItem/category_select_page.dart';
import 'package:woju/page/home/main/addItem/feeling_of_use_guide_page.dart';
import 'package:woju/page/home/main/main_page.dart';
import 'package:woju/page/home/shared/item_detail_page.dart';
import 'package:woju/page/home/setting/setting_page.dart';
import 'package:woju/page/home/shared/user_favorite_category_page.dart';
import 'package:woju/page/home/userProfile/user_id_change_page.dart';
import 'package:woju/page/home/userProfile/user_phone_number_change_page.dart';
import 'package:woju/page/home/userProfile/user_profile_page.dart';
import 'package:woju/page/home/userProfile/user_withdrawal_page.dart';
import 'package:woju/page/onboarding/onboarding_page.dart';
import 'package:woju/page/onboarding/signin/password_reset_page.dart';
import 'package:woju/page/onboarding/signin/signin_page.dart';
import 'package:woju/page/onboarding/signup/signup_page.dart';
import 'package:woju/page/onboarding/signup/signup_policy_page.dart';
import 'package:woju/page/onboarding/signup/signup_userinfo_page.dart';
import 'package:woju/page/home/userProfile/user_password_change_page.dart';

import 'package:woju/provider/app_state_notifier.dart';

import 'package:woju/service/debug_service.dart';
import 'package:woju/theme/widget/custom_scaffold.dart';

/// ### RouterObserver
///
/// - [NavigatorObserver] 라우터 관찰자
///
/// #### Fields
///
/// - [Provider]<[GoRouter]> goRouterProvider: GoRouter 프로바이더, 경로 관리 객체
///
/// #### Methods
///
/// - [void] [didPush] ([Route]<[dynamic]> route, [Route]<[dynamic]>? previousRoute): 라우트 푸시 메서드
/// - [void] [didPop] ([Route]<[dynamic]> route, [Route]<[dynamic]>? previousRoute): 라우트 팝 메서드
/// - [void] [didRemove] ([Route]<[dynamic]> route, [Route]<[dynamic]>? previousRoute): 라우트 제거 메서드
/// - [void] [didReplace] ([Route]<[dynamic]> newRoute, [Route]<[dynamic]>? oldRoute): 라우트 교체 메서드
///
/// - [GoRoute] : [_buildNoTransitionRoute] ({required [String] path, required [Widget] Function([BuildContext], [GoRouterState]) builder, required [String] text}): 라우트 생성 메서드
/// - [GoRoute] : [_buildNestedRoute] ({required [String] path, required [Widget] Function([BuildContext], [GoRouterState]) builder, required [String] text, required [List]<[GoRoute]> routes}): 라우트 생성 메서드
/// - [GoRoute] : [_buildCustomTransitionRoute] ({required [String] path, required [Widget] Function([BuildContext], [GoRouterState]) builder, required [String] text}): 라우트 생성 메서드
///
class RouterObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidPush: $previousRoute -> $route");
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidPop: $route -> $previousRoute");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    printd("DidRemove: $route -> $previousRoute");
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    printd("DidReplace: $oldRoute -> $newRoute");
  }
}

final goRouterProvider = Provider<GoRouter>((ref) {
  final signInStatus =
      ref.watch(appStateProvider.select((state) => state.signInStatus));
  final errorState =
      ref.watch(appStateProvider.select((state) => state.appError));
  return GoRouter(
    initialLocation: '/onboarding',
    observers: [RouterObserver()],
    errorPageBuilder: (context, state) {
      return const NoTransitionPage(child: RouterErrorPage());
    },
    redirect: (context, state) {
      // 현재 경로가 null이라면 null 반환
      if (state.fullPath == null || state.fullPath == '') {
        return null;
      }

      // null이 아니라면 상태를 확인하여 리다이렉트
      final nowPath = state.fullPath as String;
      // 현재 경로
      printd("Current Path: $nowPath");

      if (errorState == AppError.serverError) {
        return '/error/server';
      } else if (errorState == AppError.autoSignInError) {
        return '/onboarding/signin';
      }

      // 로그인 상태가 아닐 때
      if (signInStatus != SignInStatus.loginSuccess) {
        // 온보딩 하위 경로에 있지 않다면 온보딩으로 리다이렉트
        if (!nowPath.contains('/onboarding')) {
          return '/onboarding';
        }
      } else {
        // 온보딩 하위 경로에 있다면 홈으로 리다이렉트
        if (nowPath.contains('/onboarding')) {
          return '/';
        }
      }

      return null;
    },
    routes: [
      _buildNestedRoute(
        path: '/',
        builder: (context, state) {
          return const MainPage();
        },
        text: '홈',
        routes: [
          _buildNestedRoute(
            path: 'userProfile',
            builder: (context, state) => const UserProfilePage(),
            text: "유저 프로필",
            routes: [
              _buildNoTransitionRoute(
                path: 'userPasswordChange',
                builder: (context, state) => const UserPasswordChangePage(),
                text: "비밀번호 변경",
              ),
              _buildNoTransitionRoute(
                path: 'userPhoneNumberChange',
                builder: (context, state) => const UserPhoneNumberChangePage(),
                text: "전화번호 변경",
              ),
              _buildNoTransitionRoute(
                path: 'userIDChange',
                builder: (context, state) => const UserIdChangePage(),
                text: "아이디 변경",
              ),
              _buildNoTransitionRoute(
                path: 'userWithdrawal',
                builder: (context, state) => const UserWithdrawalPage(),
                text: "회원 탈퇴",
              ),
              _buildNoTransitionRoute(
                path: 'userFavoriteCategories',
                builder: (context, state) => const UserFavoriteCategoriesPage(),
                text: "선호 카테고리 변경",
              ),
            ],
          ),
          _buildNestedRoute(
            path: "setting",
            builder: (context, state) => const SettingPage(),
            text: "설정",
            routes: [],
          ),
          _buildCustomTransitionRoute(
            path: 'addItem',
            builder: (context, state) {
              final item = state.extra as ItemDetailModel?;
              return AddItemPage(editItemModel: item);
            },
            text: "아이템 추가",
            routes: [
              _buildNoTransitionRoute(
                path: "categorySelect",
                builder: (context, state) => const CategorySelectPage(),
                text: "카테고리 선택",
              ),
              _buildNoTransitionRoute(
                path: "feelingOfUseGuide",
                builder: (context, state) => const FeelingOfUseGuidePage(),
                text: "사용감 설명",
              ),
              _buildNoTransitionRoute(
                path: "barterPlaceSelect",
                builder: (context, state) => const BarterPlaceSelectPage(),
                text: "교환 장소 선택",
              ),
            ],
          ),
          _buildCustomTransitionRoute(
            path: 'item/:itemUUID',
            builder: (context, state) {
              final itemUUID = state.pathParameters['itemUUID'].toString();
              printd("itemUUID: $itemUUID");
              return ItemDetailPage(itemUUID: itemUUID);
            },
            text: "아이템",
            routes: null,
          ),
        ],
      ),
      _buildNestedRoute(
        path: '/onboarding',
        builder: (context, state) {
          return const OnboardingPage();
        },
        text: '온보딩',
        routes: [
          _buildNestedRoute(
            path: 'signup',
            builder: (context, state) {
              return const SignUpPage();
            },
            text: '회원가입',
            routes: [
              _buildNoTransitionRoute(
                path: "policy/:type",
                builder: (context, state) {
                  final type = state.pathParameters['type'].toString();
                  return SignupPolicyPage(type: type);
                },
                text: "이용약관",
              ),
              _buildNoTransitionRoute(
                path: 'detail',
                builder: (context, state) {
                  return const SignupUserinfoPage();
                },
                text: '회원가입 상세',
              ),
            ],
          ),
          _buildNestedRoute(
            path: 'signin',
            builder: (context, state) {
              return const SignInPage();
            },
            text: '로그인',
            routes: [
              _buildNoTransitionRoute(
                path: 'resetPassword',
                builder: (context, state) {
                  return const PasswordResetPage();
                },
                text: '비밀번호 재설정',
              ),
            ],
          ),
        ],
      ),
      _buildNestedRoute(
        path: '/error',
        builder: (context, state) {
          return const CustomScaffold(
            title: "error.title",
          );
        },
        text: '에러',
        routes: [
          _buildNoTransitionRoute(
            path: 'server',
            builder: (context, state) {
              return const ServerErrorPage();
            },
            text: '서버 에러',
          ),
        ],
      ),
    ],
  );
});

GoRoute _buildNoTransitionRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
  required String text,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      printd("Navigating to $text, fullPath: ${state.fullPath}");
      return NoTransitionPage(child: builder(context, state));
    },
  );
}

// ignore: unused_element
GoRoute _buildCustomTransitionRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
  required String text,
  List<GoRoute>? routes,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      printd("Navigating to $text, fullPath: ${state.fullPath}");
      return CustomTransitionPage(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          );
        },
        child: builder(context, state),
      );
    },
    routes: routes ?? [],
  );
}

GoRoute _buildNestedRoute({
  required String path,
  required Widget Function(BuildContext, GoRouterState) builder,
  required String text,
  required List<GoRoute> routes,
}) {
  return GoRoute(
    path: path,
    pageBuilder: (context, state) {
      printd("Navigating to $text, fullPath: ${state.fullPath}");
      return NoTransitionPage(child: builder(context, state));
    },
    routes: routes,
  );
}
