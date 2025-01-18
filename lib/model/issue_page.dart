import 'package:baustaka/model/issue.dart';
import 'package:baustaka/model/page.dart';
import 'package:json_annotation/json_annotation.dart';

part 'issue_page.g.dart';

@JsonSerializable()
class IssuePage extends Page<Issue> {
  static IssuePage fromJson(dynamic json) => _$IssuePageFromJson(json);
}
