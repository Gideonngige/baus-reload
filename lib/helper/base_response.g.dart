// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseResponse _$BaseResponseFromJson(Map<String, dynamic> json) => BaseResponse()
  ..notification = json['notification'] == null
      ? null
      : AppNotification.fromJson(json['notification'] as Map<String, dynamic>)
  ..notificationPage = json['notificationPage'] == null
      ? null
      : Paged<AppNotification>.fromJson(
          json['notificationPage'] as Map<String, dynamic>)
  ..message = json['message'] == null
      ? null
      : Message.fromJson(json['message'] as Map<String, dynamic>)
  ..messagePage = json['messagePage'] == null
      ? null
      : Paged<Message>.fromJson(json['messagePage'] as Map<String, dynamic>)
  ..chat = json['chat'] == null
      ? null
      : Chat.fromJson(json['chat'] as Map<String, dynamic>)
  ..chatPage = json['chatPage'] == null
      ? null
      : Paged<Chat>.fromJson(json['chatPage'] as Map<String, dynamic>)
  ..champPage = json['champPage'] == null
      ? null
      : Paged<Champ>.fromJson(json['champPage'] as Map<String, dynamic>)
  ..champ = json['champ'] == null
      ? null
      : Champ.fromJson(json['champ'] as Map<String, dynamic>)
  ..wasteManagerPage = json['wasteManagerPage'] == null
      ? null
      : Paged<WasteManager>.fromJson(
          json['wasteManagerPage'] as Map<String, dynamic>)
  ..wasteManager = json['wasteManager'] == null
      ? null
      : WasteManager.fromJson(json['wasteManager'] as Map<String, dynamic>)
  ..cboPage = json['cboPage'] == null
      ? null
      : Paged<Cbo>.fromJson(json['cboPage'] as Map<String, dynamic>)
  ..cbo = json['cbo'] == null
      ? null
      : Cbo.fromJson(json['cbo'] as Map<String, dynamic>)
  ..csrPage = json['csrPage'] == null
      ? null
      : Paged<Csr>.fromJson(json['csrPage'] as Map<String, dynamic>)
  ..csr = json['csr'] == null
      ? null
      : Csr.fromJson(json['csr'] as Map<String, dynamic>)
  ..token = json['token'] as String?
  ..toggle = (json['toggle'] as num?)?.toInt()
  ..error = json['error'] == null
      ? null
      : Error.fromJson(json['error'] as Map<String, dynamic>)
  ..user = json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>)
  ..userPage = json['userPage'] == null
      ? null
      : UserPage.fromJson(json['userPage'] as Map<String, dynamic>)
  ..dumpingPage = json['dumpingPage'] == null
      ? null
      : DumpingPage.fromJson(json['dumpingPage'] as Map<String, dynamic>)
  ..dumping = json['dumping'] == null
      ? null
      : Dumping.fromJson(json['dumping'] as Map<String, dynamic>)
  ..post = json['post'] == null
      ? null
      : Post.fromJson(json['post'] as Map<String, dynamic>)
  ..postPage = json['postPage'] == null
      ? null
      : PostPage.fromJson(json['postPage'] as Map<String, dynamic>)
  ..event = json['event'] == null
      ? null
      : Event.fromJson(json['event'] as Map<String, dynamic>)
  ..eventPage = json['eventPage'] == null
      ? null
      : EventPage.fromJson(json['eventPage'] as Map<String, dynamic>)
  ..rsvp = json['rsvp'] == null
      ? null
      : Rsvp.fromJson(json['rsvp'] as Map<String, dynamic>)
  ..rsvpPage = json['rsvpPage'] == null
      ? null
      : RsvpPage.fromJson(json['rsvpPage'] as Map<String, dynamic>)
  ..blog = json['blog'] == null
      ? null
      : Blog.fromJson(json['blog'] as Map<String, dynamic>)
  ..blogPage = json['blogPage'] == null
      ? null
      : BlogPage.fromJson(json['blogPage'] as Map<String, dynamic>)
  ..blogLike = json['blogLike'] == null
      ? null
      : BlogLike.fromJson(json['blogLike'] as Map<String, dynamic>)
  ..blogLikePage = json['blogLikePage'] == null
      ? null
      : BlogLikePage.fromJson(json['blogLikePage'] as Map<String, dynamic>)
  ..promo = json['promo'] == null
      ? null
      : Promo.fromJson(json['promo'] as Map<String, dynamic>)
  ..promoPage = json['promoPage'] == null
      ? null
      : PromoPage.fromJson(json['promoPage'] as Map<String, dynamic>)
  ..reward = json['reward'] == null
      ? null
      : Reward.fromJson(json['reward'] as Map<String, dynamic>)
  ..rewardPage = json['rewardPage'] == null
      ? null
      : RewardPage.fromJson(json['rewardPage'] as Map<String, dynamic>)
  ..issue = json['issue'] == null
      ? null
      : Issue.fromJson(json['issue'] as Map<String, dynamic>)
  ..issuePage = json['issuePage'] == null
      ? null
      : IssuePage.fromJson(json['issuePage'] as Map<String, dynamic>)
  ..transaction = json['transaction'] == null
      ? null
      : Transaction.fromJson(json['transaction'] as Map<String, dynamic>)
  ..transactionPage = json['transactionPage'] == null
      ? null
      : TransactionPage.fromJson(
          json['transactionPage'] as Map<String, dynamic>)
  ..prices = (json['prices'] as List<dynamic>?)
      ?.map((e) => Price.fromJson(e as Map<String, dynamic>))
      .toList()
  ..picker = json['picker'] == null
      ? null
      : Picker.fromJson(json['picker'] as Map<String, dynamic>)
  ..pickerPage = json['pickerPage'] == null
      ? null
      : PickerPage.fromJson(json['pickerPage'] as Map<String, dynamic>)
  ..station = json['station'] == null
      ? null
      : Station.fromJson(json['station'] as Map<String, dynamic>)
  ..stationPage = json['stationPage'] == null
      ? null
      : StationPage.fromJson(json['stationPage'] as Map<String, dynamic>)
  ..product = json['product'] == null
      ? null
      : Product.fromJson(json['product'] as Map<String, dynamic>)
  ..productPage = json['productPage'] == null
      ? null
      : ProductPage.fromJson(json['productPage'] as Map<String, dynamic>);
