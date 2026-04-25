# Scranton DVD

A macOS screensaver. The DVD logo bounces around your screen, changing colour when it hits the edges.

## Modes

| Classic | Colorful | Monochrome |
|---|---|---|
| ![Classic mode](screenshots/scranton-dvd-classic.webp) | ![Colorful mode](screenshots/scranton-dvd-colorful.webp) | ![Monochrome mode](screenshots/scranton-dvd-monochrome.webp) |
| Coloured logo on black | Coloured logo on inverted background | White logo on black |

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

### Thumbnail not showing in the picker?

macOS Sonoma+ caches screensaver thumbnails per bundle. Reinstalling the same bundle keeps the empty cached entry. Bust the cache:

```
killall WallpaperAgent 2>/dev/null
rm -rf "$(getconf DARWIN_USER_CACHE_DIR)/com.apple.wallpaper.extension.legacy/com.apple.wallpaper.legacy.thumbnails/"*
```

Then reopen System Settings > Screen Saver.

## Uninstall

```
rm -rf ~/Library/Screen\ Savers/Scranton\ DVD.saver
```

## License

MIT
