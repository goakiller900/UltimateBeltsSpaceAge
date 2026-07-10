# Ultimate Belts Space Age

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

## Known issue / help wanted

The custom underground-belt entrance and exit graphics use legacy artwork and are visibly misaligned in Factorio 2.1. The entities themselves still place, connect, transport items, rotate, mine, and upgrade normally.

Several Lua-only alignment and structure-layout fixes were tested without success and have been reverted. A proper fix likely requires rebuilding the underground-belt structure artwork for Factorio 2.1, including current-size directional and side-loading sprites plus front/back patches.

Contributions from someone experienced with Factorio entity graphics, GIMP/XCF source files, or underground-belt sprite layouts are welcome.

## Maintenance status

This fork updates and maintains the original mod for newer Factorio releases. Gameplay, names, graphics, recipes, and progression are kept as close to the existing release as practical.

## Credits

Originally based on Tyarns' UltimateBelts mod. Previous maintenance by Jabor047 and contributors.
