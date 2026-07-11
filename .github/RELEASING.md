# Releasing Ultimate Belts Space Age Plus

1. Update `info.json`.
2. Add the matching version at the top of `changelog.txt`.
3. Run `python scripts/build_release.py`.
4. Test the generated ZIP in Factorio 2.1 with:
   - base game;
   - Space Age;
   - optional Deadlock stacking beltbox and compact loader integration;
   - an existing save from the previous tested build when applicable.
5. Merge the reviewed release branch into `master`.

## Automated behaviour

- Pull requests validate and build a temporary workflow artifact.
- Every push to a non-`master` branch creates or replaces a branch-specific GitHub prerelease.
- A push to `master` creates the immutable stable GitHub release for the version in `info.json`.
- Stable releases are never overwritten. Increase the version before changing released contents.

## Factorio Mod Portal

The unique Mod Portal identifier is `UltimateBeltsSpaceAgePlus` and the visible title is `Ultimate Belts Space Age Plus`.

To publish automatically, add a repository secret named `FACTORIO_API_KEY` containing an API key with `ModPortal: Upload Mods` permission. Portal publication is restricted to `master`; branch prereleases can never publish to the portal.
