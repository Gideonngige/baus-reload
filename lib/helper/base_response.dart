import 'package:baustaka/helper/paged.dart';
import 'package:baustaka/model/app_notification.dart';
import 'package:baustaka/model/blog.dart';
import 'package:baustaka/model/blog_like.dart';
import 'package:baustaka/model/blog_like_page.dart';
import 'package:baustaka/model/blog_page.dart';
import 'package:baustaka/model/cbo.dart';
import 'package:baustaka/model/champ.dart';
import 'package:baustaka/model/chat.dart';
import 'package:baustaka/model/csr.dart';
import 'package:baustaka/model/dumping.dart';
import 'package:baustaka/model/dumping_page.dart';
import 'package:baustaka/model/error.dart';
import 'package:baustaka/model/event.dart';
import 'package:baustaka/model/event_page.dart';
import 'package:baustaka/model/issue.dart';
import 'package:baustaka/model/issue_page.dart';
import 'package:baustaka/model/message.dart';
import 'package:baustaka/model/picker.dart';
import 'package:baustaka/model/picker_page.dart';
import 'package:baustaka/model/post.dart';
import 'package:baustaka/model/post_page.dart';
import 'package:baustaka/model/price.dart';
import 'package:baustaka/model/product.dart';
import 'package:baustaka/model/product_page.dart';
import 'package:baustaka/model/promo.dart';
import 'package:baustaka/model/promo_page.dart';
import 'package:baustaka/model/reward.dart';
import 'package:baustaka/model/reward_page.dart';
import 'package:baustaka/model/rsvp.dart';
import 'package:baustaka/model/rsvp_page.dart';
import 'package:baustaka/model/station.dart';
import 'package:baustaka/model/station_page.dart';
import 'package:baustaka/model/transaction.dart';
import 'package:baustaka/model/transaction_page.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/model/user_page.dart';
import 'package:baustaka/model/waste_manager.dart';
import 'package:json_annotation/json_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable()
class BaseResponse {
  AppNotification? notification;

  Paged<AppNotification>? notificationPage;

  Message? message;

  Paged<Message>? messagePage;

  Chat? chat;

  Paged<Chat>? chatPage;

  Paged<Champ>? champPage;

  Champ? champ;

  Paged<WasteManager>? wasteManagerPage;

  WasteManager? wasteManager;

  Paged<Cbo>? cboPage;

  Cbo? cbo;

  Paged<Csr>? csrPage;

  Csr? csr;

  String? token;

  int? toggle;

  Error? error;

  User? user;

  UserPage? userPage;

  DumpingPage? dumpingPage;

  Dumping? dumping;

  Post? post;

  PostPage? postPage;

  Event? event;

  EventPage? eventPage;

  Rsvp? rsvp;

  RsvpPage? rsvpPage;

  Blog? blog;

  BlogPage? blogPage;

  BlogLike? blogLike;

  BlogLikePage? blogLikePage;

  Promo? promo;

  PromoPage? promoPage;

  Reward? reward;

  RewardPage? rewardPage;

  Issue? issue;

  IssuePage? issuePage;

  Transaction? transaction;

  TransactionPage? transactionPage;

  List<Price>? prices;

  Picker? picker;

  PickerPage? pickerPage;

  Station? station;

  StationPage? stationPage;

  Product? product;

  ProductPage? productPage;

  static BaseResponse fromJson(dynamic json) => _$BaseResponseFromJson(json);
}
