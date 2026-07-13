# Ultimate Belts Space Age Plus

A community-maintained continuation of **Ultimate Belts** for Factorio 2.1.

The mod adds five transport-belt tiers beyond express belts, including matching underground belts and splitters. The fastest tier runs at six times express-belt speed.

## Compatibility

- Factorio 2.1
- Space Age is supported but optional
- Deadlock's Stacking Beltboxes and Compact Loaders integration is retained when its API is available

## Belt tiers

1. Ultra Fast — 2× express speed
2. Extreme Fast — 3× express speed
3. Ultra Express — 4× express speed
4. Extreme Express — 5× express speed
5. Ultimate — 6× express speed

## Modern Factorio 2.1 graphics

Version 0.0.6 rebuilds the five custom transport belts, underground belts and splitters from Factorio 2.1's current express-tier prototype layouts. Modern belt animations, underground directional and side-loading structures, splitter animations, patches and remnants are recoloured for each custom tier while the established gameplay values remain unchanged.

Version 0.0.7 also replaces the legacy 32-pixel item icons with modern 64-pixel Factorio-style icon sheets and embedded mip levels for all five tiers.

## Localisation

Version 0.0.8 adds English, German, French, Spanish, Brazilian Portuguese, Russian, Polish, Japanese, Korean, Simplified Chinese, Ukrainian and Dutch locale files. These cover the belt tiers, underground belts, splitters, technologies, mod description and the optional Deadlock beltboxes and loaders.

## Building a release

```bash
python scripts/build_release.py
```

This validates `info.json`, the changelog, required files and root Lua module references. It then creates a deterministic Factorio-ready ZIP and SHA-256 checksum in `dist/`.

## Automated releases

- Pull requests validate the mod and upload a temporary workflow artifact.
- Pushes to non-`master` branches create or replace a GitHub prerelease for that branch.
- Pushes to `master` create an immutable stable GitHub release for the version in `info.json`.
- Factorio Mod Portal publishing is restricted to `master` and requires the `FACTORIO_API_KEY` repository secret.

The unique Mod Portal identifier is `UltimateBeltsSpaceAgePlus`; the visible mod title is **Ultimate Belts Space Age Plus**.

The earlier internal identifier `UltimateBeltsSpaceAge` was used only during repository release preparation and was not intended as the public Mod Portal identity. Factorio treats different internal names as different mods, so test builds using the earlier identifier should be removed before installing the public build.

## Maintenance status

This fork updates and maintains the original mod for newer Factorio releases. Gameplay, names, graphics, recipes and progression are kept as close to the existing release as practical.

## Credits

Originally based on Tyarns' UltimateBelts mod. Previous maintenance by Jabor047 and contributors.

## License

MIT License. See [LICENSE](LICENSE).
