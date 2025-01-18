import 'package:baustaka/model/app_notification.dart';
import 'package:baustaka/model/balance.dart';
import 'package:baustaka/model/blog.dart';
import 'package:baustaka/model/blog_like.dart';
import 'package:baustaka/model/cbo.dart';
import 'package:baustaka/model/champ.dart';
import 'package:baustaka/model/chat.dart';
import 'package:baustaka/model/csr.dart';
import 'package:baustaka/model/dumping.dart';
import 'package:baustaka/model/error.dart';
import 'package:baustaka/model/event.dart';
import 'package:baustaka/model/file.dart';
import 'package:baustaka/model/issue.dart';
import 'package:baustaka/model/message.dart';
import 'package:baustaka/model/partner.dart';
import 'package:baustaka/model/picker.dart';
import 'package:baustaka/model/point.dart';
import 'package:baustaka/model/post.dart';
import 'package:baustaka/model/product.dart';
import 'package:baustaka/model/promo.dart';
import 'package:baustaka/model/review.dart';
import 'package:baustaka/model/reward.dart';
import 'package:baustaka/model/rsvp.dart';
import 'package:baustaka/model/station.dart';
import 'package:baustaka/model/transaction.dart';
import 'package:baustaka/model/user.dart';
import 'package:baustaka/model/waste_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paged.g.dart';

@JsonSerializable(createToJson: false)
class Paged<T> {
  @JsonKey(fromJson: _listFromJson)
  final List<T> docs;
  final int total;
  final int page;
  final int pages;
  final int limit;
  final String sort;

  Paged(this.docs, this.total, this.page, this.pages, this.limit, this.sort);

  int get next => page + 1;

  bool get isEnd => page >= pages || docs.isEmpty;

  factory Paged.fromJson(Map<String, dynamic> json) => _$PagedFromJson(json);

  static T _listFromJson<T>(List<dynamic> jsonList) {
    if (kDebugMode) {
      print('Jsonlist $T');
    }

    if (T == typeOf<List<Message>>()) {
      return jsonList.isEmpty
          ? List<Message>.empty() as T
          : jsonList.map<Message>((json) => Message.fromJson(json)).toList()
              as T;
    }

    if (T == typeOf<List<Chat>>()) {
      return jsonList.isEmpty
          ? List<Chat>.empty() as T
          : jsonList.map<Chat>((json) => Chat.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Champ>>()) {
      return jsonList.isEmpty
          ? List<Champ>.empty() as T
          : jsonList.map<Champ>((json) => Champ.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<WasteManager>>()) {
      return jsonList.isEmpty
          ? List<WasteManager>.empty() as T
          : jsonList
              .map<WasteManager>((json) => WasteManager.fromJson(json))
              .toList() as T;
    }

    if (T == typeOf<List<Cbo>>()) {
      return jsonList.isEmpty
          ? List<Cbo>.empty() as T
          : jsonList.map<Cbo>((json) => Cbo.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Csr>>()) {
      return jsonList.isEmpty
          ? List<Csr>.empty() as T
          : jsonList.map<Csr>((json) => Csr.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Dumping>>()) {
      return jsonList.isEmpty
          ? List<Dumping>.empty() as T
          : jsonList.map<Dumping>((json) => Dumping.fromJson(json)).toList()
              as T;
    }

    if (T == typeOf<List<Partner>>()) {
      return jsonList.isEmpty
          ? List<Partner>.empty() as T
          : jsonList.map<Partner>((json) => Partner.fromJson(json)).toList()
              as T;
    }

    if (T == typeOf<List<Station>>()) {
      return jsonList.isEmpty
          ? List<Station>.empty() as T
          : jsonList.map<Station>((json) => Station.fromJson(json)).toList()
              as T;
    }

    if (T == typeOf<List<Event>>()) {
      return jsonList.isEmpty
          ? List<Event>.empty() as T
          : jsonList.map<Event>((json) => Event.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Rsvp>>()) {
      return jsonList.isEmpty
          ? List<Rsvp>.empty() as T
          : jsonList.map<Rsvp>((json) => Rsvp.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<BlogLike>>()) {
      return jsonList.isEmpty
          ? List<BlogLike>.empty() as T
          : jsonList.map<BlogLike>((json) => BlogLike.fromJson(json)).toList()
              as T;
    }

    if (T == typeOf<List<Blog>>()) {
      return jsonList.isEmpty
          ? List<Blog>.empty() as T
          : jsonList.map<Blog>((json) => Blog.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<AppNotification>>()) {
      return jsonList.isEmpty
          ? List<AppNotification>.empty() as T
          : jsonList
              .map<AppNotification>((json) => AppNotification.fromJson(json))
              .toList() as T;
    }

    if (T == typeOf<List<Balance>>()) {
      return jsonList.isEmpty
          ? List<Balance>.empty() as T
          : jsonList.map<Balance>((json) => Balance.fromJson(json)).toList()
              as T;
    }

    if (T == typeOf<List<Picker>>()) {
      return jsonList.isEmpty
          ? List<Picker>.empty() as T
          : jsonList.map<Picker>((json) => Picker.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Error>>()) {
      return jsonList.isEmpty
          ? List<Error>.empty() as T
          : jsonList.map<Error>((json) => Error.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<File>>()) {
      return jsonList.isEmpty
          ? List<File>.empty() as T
          : jsonList.map<File>((json) => File.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Issue>>()) {
      return jsonList.isEmpty
          ? List<Issue>.empty() as T
          : jsonList.map<Issue>((json) => Issue.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Point>>()) {
      return jsonList.isEmpty
          ? List<Point>.empty() as T
          : jsonList.map<Point>((json) => Point.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Post>>()) {
      return jsonList.isEmpty
          ? List<Post>.empty() as T
          : jsonList.map<Post>((json) => Post.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Product>>()) {
      return jsonList.isEmpty
          ? List<Product>.empty() as T
          : jsonList.map<Product>((json) => Product.fromJson(json)).toList()
              as T;
    }

    if (T == typeOf<List<Promo>>()) {
      return jsonList.isEmpty
          ? List<Promo>.empty() as T
          : jsonList.map<Promo>((json) => Promo.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Review>>()) {
      return jsonList.isEmpty
          ? List<Review>.empty() as T
          : jsonList.map<Review>((json) => Review.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Reward>>()) {
      return jsonList.isEmpty
          ? List<Reward>.empty() as T
          : jsonList.map<Reward>((json) => Reward.fromJson(json)).toList() as T;
    }

    if (T == typeOf<List<Transaction>>()) {
      return jsonList.isEmpty
          ? List<Transaction>.empty() as T
          : jsonList
              .map<Transaction>((json) => Transaction.fromJson(json))
              .toList() as T;
    }

    if (T == typeOf<List<User>>()) {
      return jsonList.isEmpty
          ? List<User>.empty() as T
          : jsonList.map<User>((json) => User.fromJson(json)).toList() as T;
    }

    throw ArgumentError.value(
      T,
      'type',
      'Unknown type conversion',
    );
  }
}

Type typeOf<X>() => X;
