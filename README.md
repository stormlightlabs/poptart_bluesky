# Poptart Bluesky

Dart packages for building Bluesky clients with
[Poptart](https://pub.dev/packages/poptart).

This repository contains small companion packages that sit on top of Poptart's
AT Protocol clients and generated lexicon models. They cover app-level behavior
that is useful in Bluesky clients but does not belong in the core Poptart SDK.

## Packages

| Package                      | Pub                                                            | Description                                                                                       |
| ---------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------------------------------- |
| `poptart_bluesky_text`       | [pub.dev](https://pub.dev/packages/poptart_bluesky_text)       | Parses Bluesky post text into handles, links, tags, UTF-8 byte indices, and rich-text facet maps. |
| `poptart_bluesky_moderation` | [pub.dev](https://pub.dev/packages/poptart_bluesky_moderation) | Evaluates Bluesky moderation decisions for Poptart lexicon models.                                |

## Install

Use the packages independently or together:

```yaml
dependencies:
    poptart: ^0.1.0
    poptart_bluesky_text: ^0.1.0
    poptart_bluesky_moderation: ^0.1.0
```

`poptart_bluesky_moderation` works with Bluesky models from
`bluesky_poptart` and AT Protocol label models from `poptart_lex`. Add them
directly if your app constructs those models itself:

```yaml
dependencies:
    bluesky_poptart: ^0.1.1
    poptart_lex: ^0.1.0
```

## Text Facets

```dart
import 'package:poptart_bluesky_text/poptart_bluesky_text.dart';

Future<void> main() async {
  const text = BlueskyText(
    'Hello @alice.test, see https://example.com/docs and #poptart.',
  );

  final facets = await text.entities.toFacets();

  assert(text.handles.single.value == '@alice.test');
  assert(facets.isNotEmpty);
}
```

Mention facets resolve handles through `com.atproto.identity.resolveHandle`.
Link and tag facets are built locally.

## Moderation

```dart
import 'package:poptart_bluesky_moderation/poptart_bluesky_moderation.dart';
import 'package:bluesky_poptart/app/bsky/actor/defs/profile_view_basic.dart';
import 'package:bluesky_poptart/app/bsky/actor/defs/viewer_state.dart';
import 'package:poptart_lex/com/atproto/label/defs.dart';

void main() {
  final profile = ProfileViewBasic(
    did: 'did:plc:alice',
    handle: 'alice.test',
    viewer: const ViewerState(),
    labels: [
      Label(
        src: 'did:plc:alice',
        uri: 'at://did:plc:alice/app.bsky.actor.profile/self',
        val: 'porn',
        cts: DateTime.utc(2026),
      ),
    ],
  );

  final decision = moderateProfile(
    ModerationSubjectProfile.profileViewBasic(data: profile),
    const ModerationOpts(
      userDid: 'did:plc:bob',
      prefs: ModerationPrefs(
        adultContentEnabled: true,
        labels: {'porn': LabelPreference.hide},
        labelers: [],
        mutedWords: [],
        hiddenPosts: [],
      ),
    ),
  );

  final avatarUi = decision.getUI(ModerationBehaviorContext.avatar);
  assert(avatarUi.blur);
}
```

## Repository Layout

```text
packages/
  poptart_bluesky_text/
  poptart_bluesky_moderation/
```

Each package has its own README, example, tests, and pubspec.

## Development

Run checks from each package directory:

```sh
cd packages/poptart_bluesky_text
dart pub get
dart analyze
dart test --reporter=failures-only

cd ../poptart_bluesky_moderation
dart pub get
dart analyze
dart test --reporter=failures-only
```

Before publishing:

```sh
dart pub publish --dry-run
```

## Attribution

These packages are derived from the [`atproto.dart`](https://github.com/myConsciousness/atproto.dart)
Bluesky packages by Shinya Kato and contributors. The derived source is licensed under
the BSD 3-Clause License. See the package-level `LICENSE` files.
