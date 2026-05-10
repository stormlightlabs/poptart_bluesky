# poptart_bluesky_text

Parse Bluesky post text into handles, links, hashtags, byte indices, and
rich-text facet maps for the AT Protocol.

This package is a Poptart-compatible fork of `bluesky_text`. It keeps the
small `BlueskyText` API while using `poptart_xrpc` for handle-to-DID lookups.

## Features

- Detects mentions, links, hashtags, and markdown links.
- Tracks UTF-8 byte indices for `app.bsky.richtext.facet` records.
- Builds facet JSON for mentions, links, and tags.
- Splits long text without breaking grapheme clusters.
- Handles Unicode text, emoji, and multilingual input.

## Install

```yaml
dependencies:
  poptart_bluesky_text: ^0.1.0
```

## Usage

```dart
import 'package:poptart_bluesky_text/poptart_bluesky_text.dart';

Future<void> main() async {
  const text = BlueskyText(
    'Hello @alice.test, see https://example.com/docs and #poptart.',
  );

  final handles = text.handles;
  final links = text.links;
  final tags = text.tags;

  final facets = await Entities([...links, ...tags]).toFacets();

  assert(handles.single.value == '@alice.test');
  assert(facets.length == 2);
}
```

Mention facets resolve handles through `com.atproto.identity.resolveHandle`.
If a handle cannot be resolved, that mention facet is skipped. Link and tag
facets are built locally.

## Common Tasks

### Read Entities

```dart
const text = BlueskyText('Follow @alice.test and #poptart.');

final firstHandle = text.handles.single;
final firstTag = text.tags.single;

assert(firstHandle.type == EntityType.handle);
assert(firstTag.value == 'poptart');
```

### Build Facets

```dart
const text = BlueskyText('Read https://example.com and #atproto.');

final facets = await text.entities.toFacets();
```

### Split Long Text

```dart
final text = BlueskyText('A long post body...');

if (text.isLengthLimitExceeded) {
  final chunks = text.split();
  assert(chunks.every((chunk) => !chunk.isLengthLimitExceeded));
}
```

## Example

See `example/main.dart` for a complete example.

## Attribution

This package is derived from
[`bluesky_text`](https://github.com/myConsciousness/atproto.dart/tree/main/packages/bluesky_text)
by Shinya Kato and contributors. The source is licensed under the BSD
3-Clause License. See `LICENSE`.
