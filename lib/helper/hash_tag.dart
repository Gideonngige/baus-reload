import 'package:linkify/linkify.dart';

/// Regular expression to identify hashTags
final _hashTagRegex = RegExp(
  r'^(.*?)#([\w]+)',
  caseSensitive: false,
  dotAll: true,
);

class HashTagLinkifier extends Linkifier {
  const HashTagLinkifier();

  @override
  List<LinkifyElement> parse(
      List<LinkifyElement> elements, LinkifyOptions options) {
    final list = <LinkifyElement>[];

    for (var element in elements) {
      if (element is TextElement) {
        var match = _hashTagRegex.firstMatch(element.text);

        if (match == null) {
          list.add(element);
        } else {
          var textElement = '';
          var text = element.text.replaceFirst(match.group(0)!, '');
          while (match?.group(1)?.contains(RegExp(r'[\w]$')) == true) {
            textElement += match!.group(0)!;
            match = _hashTagRegex.firstMatch(text);
            if (match == null) {
              textElement += text;
              text = '';
            } else {
              text = text.replaceFirst(match.group(0)!, '');
            }
          }

          if (textElement.isNotEmpty || match?.group(1)?.isNotEmpty == true) {
            list.add(TextElement(textElement + (match?.group(1) ?? '')));
          }

          if (match?.group(2)?.isNotEmpty == true) {
            list.add(HashTagElement('#${match!.group(2)!}'));
          }

          if (text.isNotEmpty) {
            list.addAll(parse([TextElement(text)], options));
          }
        }
      } else {
        list.add(element);
      }
    }

    return list;
  }
}

/// Represents an element containing a hashTag
class HashTagElement extends LinkableElement {
  final String hashTag;

  HashTagElement(this.hashTag) : super(hashTag, hashTag);

  @override
  String toString() {
    return "HashTagElement: '$hashTag' ($text)";
  }

  @override
  bool operator ==(other) => equals(other);

  @override
  int get hashCode => Object.hash(text, originText, url, hashTag);

  @override
  bool equals(other) =>
      other is HashTagElement &&
      super.equals(other) &&
      other.hashTag == hashTag;
}
