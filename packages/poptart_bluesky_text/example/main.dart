import 'package:poptart_bluesky_text/poptart_bluesky_text.dart';

Future<void> main() async {
  const text = BlueskyText('Hello @alice.test, see https://example.com/docs and #poptart.');

  assert(text.handles.single.value == '@alice.test');
  assert(text.links.single.value == 'https://example.com/docs');
  assert(text.tags.single.value == 'poptart');

  // Handle facets call com.atproto.identity.resolveHandle. Link and tag facets
  // are produced locally.
  final linkAndTagFacets = await Entities([...text.links, ...text.tags]).toFacets();

  assert(linkAndTagFacets.length == 2);
}
