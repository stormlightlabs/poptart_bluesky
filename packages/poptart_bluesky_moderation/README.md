# poptart_bluesky_moderation

Evaluate Bluesky moderation decisions for Poptart lexicon models.

This package ports the high-level moderation facade from
`atproto.dart`/`bluesky` to `poptart_lex` types. It handles label preferences,
labeler preferences, muted words, hidden posts, and UI decisions for profiles,
posts, notifications, feeds, and lists.

## Features

- Evaluates `PostView`, `ProfileViewBasic`, notification, feed generator, and
  list subjects from `poptart_lex`.
- Returns `ModerationDecision` objects with `getUI(...)` helpers.
- Supports global labels, custom labels, labelers, hidden posts, and muted
  words.
- Includes helpers for labeler headers and label-definition loading with
  `PoptartClient`.
- Ships with the upstream moderation behavior test suite ported to Poptart.

## Install

```yaml
dependencies:
  poptart_bluesky_moderation: ^0.1.0
  poptart_lex: ^0.1.0
```

## Usage

```dart
import 'package:poptart_bluesky_moderation/poptart_bluesky_moderation.dart';
import 'package:poptart_lex/app/bsky/actor/defs/profile_view_basic.dart';
import 'package:poptart_lex/app/bsky/actor/defs/viewer_state.dart';
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

## Loading Labeler Definitions

`PoptartClientLabelerExtension` adds a helper for `app.bsky.labeler`
definition requests:

```dart
final labelDefinitions = await client.getLabelDefinitions(prefs);
```

Pass the same `ModerationPrefs` into `ModerationOpts` when evaluating subjects.

## Example

See `example/main.dart` for a complete example.

## Attribution

This package is derived from the moderation code in
[`atproto.dart`](https://github.com/myConsciousness/atproto.dart) by Shinya
Kato and contributors. The source is licensed under the BSD 3-Clause License.
See `LICENSE`.
