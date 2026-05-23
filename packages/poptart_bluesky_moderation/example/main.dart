import 'package:poptart_bluesky_moderation/poptart_bluesky_moderation.dart';
import 'package:bluesky_poptart/app/bsky/actor/defs/profile_view_basic.dart';
import 'package:bluesky_poptart/app/bsky/actor/defs/viewer_state.dart';
import 'package:poptart_lex/com/atproto/label/defs.dart';

void main() {
  final profile = ProfileViewBasic(
    did: 'did:plc:alice',
    handle: 'alice.test',
    displayName: 'Alice',
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

  final ui = decision.getUI(ModerationBehaviorContext.avatar);
  assert(ui.blur);
  assert(ui.alert);
}
