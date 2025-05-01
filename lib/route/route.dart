import 'package:baustaka/config/routes.dart';
import 'package:baustaka/ui/add_dumping/add_dumping_widget.dart';
import 'package:baustaka/ui/add_issue/add_issue_widget.dart';
import 'package:baustaka/ui/auth/email/change_email/change_email_widget.dart';
import 'package:baustaka/ui/auth/email/change_password/change_password_widget.dart';
import 'package:baustaka/ui/auth/email/email/email_widget.dart';
import 'package:baustaka/ui/auth/email/forgot_password/forgot_password_widget.dart';
import 'package:baustaka/ui/auth/email/link_email/link_email_screen.dart';
import 'package:baustaka/ui/auth/email/register/register_widget.dart';
import 'package:baustaka/ui/auth/email/verify_email/verify_email_widget.dart';
import 'package:baustaka/ui/auth/phone/change_phone/change_phone_widget.dart';
import 'package:baustaka/ui/auth/phone/phone/phone_widget.dart';
import 'package:baustaka/ui/auth/phone/verify_phone/verify_phone_widget.dart';
import 'package:baustaka/ui/auth/profile/profile_widget.dart';
import 'package:baustaka/ui/blog/blog_widget.dart';
import 'package:baustaka/ui/blogs/blogs_widget.dart';
import 'package:baustaka/ui/booking/booking_widget.dart';
import 'package:baustaka/ui/cbos/add_cbo/add_cbo_widget.dart';
import 'package:baustaka/ui/cbos/cbo/cbo_widget.dart';
import 'package:baustaka/ui/cbos/cbos_widget.dart';
import 'package:baustaka/ui/champs/add_champ/add_champ_widget.dart';
import 'package:baustaka/ui/champs/champ/champ_widget.dart';
import 'package:baustaka/ui/champs/champs_widget.dart';
import 'package:baustaka/ui/csrs/csr/csr_widget.dart';
import 'package:baustaka/ui/csrs/csrs_widget.dart';
import 'package:baustaka/ui/dumping/dumping_widget.dart';
import 'package:baustaka/ui/dumpings/dumpings_widget.dart';
import 'package:baustaka/ui/event/event_widget.dart';
import 'package:baustaka/ui/events/events_widget.dart';
import 'package:baustaka/ui/issue/issue_widget.dart';
import 'package:baustaka/ui/issues/issues_widget.dart';
import 'package:baustaka/ui/main/account/account_widget.dart';
import 'package:baustaka/ui/main/account/settings/settings_widget.dart';
import 'package:baustaka/ui/main/home/home_widget.dart';
import 'package:baustaka/ui/main/home/messages/messages_widget.dart';
import 'package:baustaka/ui/main/home/notifications/notifications_widget.dart';
import 'package:baustaka/ui/main/main_widget.dart';
import 'package:baustaka/ui/onboarding/onboarding_widget.dart';
import 'package:baustaka/ui/post/post_widget.dart';
import 'package:baustaka/ui/posts/posts_widget.dart';
import 'package:baustaka/ui/products/products_widget.dart';
import 'package:baustaka/ui/promo/promo_widget.dart';
import 'package:baustaka/ui/promos/promos_widget.dart';
import 'package:baustaka/ui/rewards/balance_widget.dart';
import 'package:baustaka/ui/rewards/guide_widget.dart';
import 'package:baustaka/ui/rewards/redeem_widget.dart';
import 'package:baustaka/ui/rewards/redemption_widget.dart';
import 'package:baustaka/ui/rewards/rewards_widget.dart';
import 'package:baustaka/ui/splash/splash_widget.dart';
import 'package:baustaka/ui/transactions/transactions_widget.dart';
import 'package:baustaka/ui/waste_managers/waste_manager/waste_manager_widget.dart';
import 'package:baustaka/ui/waste_managers/waste_managers_widget.dart';
import 'package:baustaka/ui_picker/add_picker/add_picker_widget.dart';
import 'package:baustaka/ui_picker/home/home_widget.dart' as home_picker;
import 'package:baustaka/ui_picker/picker/picker_widget.dart';
import 'package:baustaka/ui_picker/station/station_widget.dart';
import 'package:baustaka/ui_picker/stations/stations_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final kRoutes = [
  // Notifications
  GetPage(
    name: Routes.kNotifications,
    page: () => NotificationsWidget(),
  ),

  // Chat
  GetPage(
    name: Routes.kMessages,
    page: () => MessagesWidget(
      userId: Get.parameters['userId'],
      action: Get.parameters['action'],
    ),
  ),

  // Email
  GetPage(
    name: Routes.kChangeEmail,
    page: () => ChangeEmailWidget(),
  ),
  GetPage(
    name: Routes.kChangePassword,
    page: () => ChangePasswordWidget(),
  ),
  GetPage(
    name: Routes.kForgotPassword,
    page: () => ForgotPasswordWidget(),
  ),
  GetPage(
    name: Routes.kLoginWithEmail,
    page: () => EmailWidget(),
  ),
  GetPage(
    name: Routes.kVerifyEmail,
    page: () => VerifyEmailWidget(),
  ),
  GetPage(
    name: Routes.kRegister,
    page: () => RegisterWidget(),
  ),
  GetPage(
    name: Routes.kLinkEmail,
    page: () => LinkEmailScreen(),
  ),

  // Phone
  GetPage(
    name: Routes.kLoginWithPhone,
    page: () => PhoneWidget(),
  ),
  GetPage(
    name: Routes.kChangePhoneNumber,
    page: () => ChangePhoneWidget(),
  ),
  GetPage(
    name: '${Routes.kVerifyPhoneNumber}:phoneNumber',
    page: () => VerifyPhoneWidget(
      phoneNumber: Get.parameters['phoneNumber']!,
      action: Get.parameters['action'],
    ),
  ),

  // Account
  GetPage(
    name: Routes.kAccount,
    page: () => AccountWidget(),
  ),
  GetPage(
    name: Routes.kProfile,
    page: () => ProfileWidget(
      action: Get.parameters['action'],
    ),
  ),
  GetPage(
    name: Routes.kSettings,
    page: () => SettingsWidget(),
  ),

  // Splash
  GetPage(
    name: Routes.kSplash,
    page: () => SplashWidget(),
  ),

  // Onboarding
  GetPage(
    name: Routes.kOnboarding,
    page: () => OnboardingWidget(),
  ),

  // Old
  GetPage(
    name: '${Routes.kChamp}:champId',
    page: () => ChampWidget(
      champId: Get.parameters['champId']!,
    ),
  ),
  GetPage(
    name: Routes.kChamps,
    page: () => ChampsWidget(
      withAppbar: true,
      owner: Get.parameters['owner'],
    ),
  ),
  GetPage(
    name: Routes.kAddCbo,
    page: () => AddCboWidget(),
  ),
  GetPage(
    name: '${Routes.kCsr}:csrId',
    page: () => CsrWidget(
      csrId: Get.parameters['csrId']!,
    ),
  ),
  GetPage(
    name: Routes.kCsrs,
    page: () => CsrsWidget(),
  ),
  GetPage(
    name: '${Routes.kWasteManager}:wasteManagerId',
    page: () => WasteManagerWidget(
      wasteManagerId: Get.parameters['wasteManagerId']!,
    ),
  ),
  GetPage(
    name: Routes.kWasteManagers,
    page: () => WasteManagersWidget(),
  ),
  GetPage(
    name: '${Routes.kCbo}:cboId',
    page: () => CboWidget(
      cboId: Get.parameters['cboId']!,
    ),
  ),
  GetPage(
    name: Routes.kCbos,
    page: () => CbosWidget(
      withAppbar: true,
      owner: Get.parameters['owner'],
    ),
  ),
  GetPage(
    name: '${Routes.kStation}:stationId',
    page: () => StationWidget(
      stationId: Get.parameters['stationId']!,
    ),
  ),
  GetPage(
    name: Routes.kStations,
    page: () => StationsWidget(),
  ),
  GetPage(
    name: Routes.kAddPicker,
    page: () => AddPickerWidget(),
  ),
  GetPage(
    name: '${Routes.kPicker}:pickerId',
    page: () => PickerWidget(
      pickerId: Get.parameters['pickerId']!,
    ),
  ),
  GetPage(
    name: Routes.kHomePicker,
    page: () => home_picker.HomeWidget(),
  ),
  GetPage(
    name: '${Routes.kDumping}:dumpingId',
    page: () => DumpingWidget(
      dumpingId: Get.parameters['dumpingId']!,
    ),
  ),
  GetPage(
    name: Routes.kAddDumping,
    page: () => AddDumpingWidget(),
  ),
  GetPage(
    name: Routes.kDumpings,
    page: () => DumpingsWidget(),
  ),
  GetPage(
    name: Routes.kBooking,
    page: () => BookingWidget(
      type: Get.parameters['type']!,
      withProduct: Get.parameters['withProduct']!,
    ),
  ),
  GetPage(
    name: Routes.kProducts,
    page: () => ProductsWidget(),
  ),
  GetPage(
    name: '${Routes.kBlog}:blogId',
    page: () => BlogWidget(
      blogId: Get.parameters['blogId']!,
    ),
  ),
  GetPage(
    name: Routes.kBlogs,
    page: () => BlogsWidget(),
  ),
  GetPage(
    name: '${Routes.kEvent}:eventId',
    page: () => EventWidget(
      eventId: Get.parameters['eventId']!,
    ),
  ),
  GetPage(
    name: Routes.kEvents,
    page: () => EventsWidget(
      tags: Get.parameters['tags']!,
    ),
  ),
  GetPage(
    name: '${Routes.kPost}:postId',
    page: () => PostWidget(
      postId: Get.parameters['postId']!,
    ),
  ),
  GetPage(
    name: Routes.kPosts,
    page: () => PostsWidget(
      withProduct: Get.parameters['withProduct'],
    ),
  ),
  GetPage(
    name: '${Routes.kTransaction}:transactionId',
    page: () => Scaffold(
      appBar: AppBar(
        title: const Text(Routes.kTransaction),
      ),
    ),
  ),
  GetPage(
    name: Routes.kTransactions,
    page: () => TransactionsWidget(),
  ),
  GetPage(
    name: Routes.kPromotions,
    page: () => PromosWidget(),
  ),
  GetPage(
    name: '${Routes.kPromotion}:promoId',
    page: () => PromoWidget(
      promoId: Get.parameters['promoId']!,
    ),
  ),
  GetPage(
    name: Routes.kRewards,
    page: () => RewardsWidget(),
  ),
  GetPage(
    name: '${Routes.kIssue}:issueId',
    page: () => IssueWidget(
      issueId: Get.parameters['issueId']!,
    ),
  ),
  GetPage(
    name: Routes.kAddIssue,
    page: () => AddIssueWidget(
      issueId: Get.parameters['issueId'],
    ),
  ),
  GetPage(
    name: Routes.kIssues,
    page: () => IssuesWidget(),
  ),
  GetPage(
    name: Routes.kHome,
    page: () => HomeWidget(),
  ),
  GetPage(
    name: Routes.kMain,
    page: () => MainWidget(),
  ),
  GetPage(
    name: Routes.kRedeemReward,
    page: () => RedeemWidget(),
  ),
  GetPage(
    name: Routes.kBadgeGuide,
    page: () => BadgeGuideWidget(),
  ),
  GetPage(
    name: Routes.kPointsBalance,
    page: () => PointsBalanceWidget(),
  ),
  GetPage(
    name: Routes.kRedemption,
    page: () => RedemptionWidget(),
  ),
  GetPage(
  name: Routes.kAddChamp, // = '/add-champ'
  page: () => AddChampWidget(), // or whatever your add-champ screen is
),
];
