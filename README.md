# Scranton DVD

A macOS screensaver. The DVD logo bounces around your screen, changing colour when it hits the edges.

## Modes

- **Classic** -- Coloured logo on black
- **Colorful** -- Coloured logo on inverted background
- **Monochrome** -- White logo on black

Switch modes via the Options button in System Settings > Screen Saver.

## Build

Requires Swift (Xcode Command Line Tools).

```
./build.sh
```

Outputs `Scranton DVD.saver`, a universal binary (arm64 + x86_64) targeting macOS 13+.

## Install

Double-click `Scranton DVD.saver`, or:

```
cp -r "Scranton DVD.saver" ~/Library/Screen\ Savers/
```

macOS may prompt you to approve the unsigned screensaver in System Settings > Privacy & Security.

## Uninstall

```
rm -rf ~/Library/Screen\ Savers/Scranton\ DVD.saver
```

## License

MIT
