#!/usr/bin/env python3
"""Generate all launcher/app icons from a single source PNG."""

from PIL import Image
import shutil
from pathlib import Path

# ---------------------------------------------------------------------------
# CONFIG
# ---------------------------------------------------------------------------
SRC = Path("C:/Users/sbaih/.gemini/antigravity-ide/brain/1fa0ee98-746c-45b1-9f2c-d67695f02b70/media__1783185165025.png")
PROJECT = Path("C:/Users/sbaih/german_learning_app")

# ---------------------------------------------------------------------------
# IN-APP ASSETS
# ---------------------------------------------------------------------------
def copy_in_app_assets():
    print("Copying in-app assets...")
    for dest in [
        PROJECT / "assets" / "brand" / "logo.png",
        PROJECT / "assets" / "splash" / "splash_logo.png",
    ]:
        dest.parent.mkdir(parents=True, exist_ok=True)
        shutil.copy2(SRC, dest)
        print(f"  -> {dest}")

# ---------------------------------------------------------------------------
# ANDROID MIPMAP ICONS
# ---------------------------------------------------------------------------
def generate_android():
    print("Generating Android mipmap icons...")
    android_sizes = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192,
    }
    res = PROJECT / "android" / "app" / "src" / "main" / "res"
    for folder, size in android_sizes.items():
        dest_dir = res / folder
        dest_dir.mkdir(parents=True, exist_ok=True)
        for name in ["ic_launcher.png", "ic_launcher_round.png"]:
            dest = dest_dir / name
            img = Image.open(SRC).convert("RGBA")
            img.thumbnail((size, size), Image.LANCZOS)
            canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
            x_offset = (size - img.width) // 2
            y_offset = (size - img.height) // 2
            canvas.paste(img, (x_offset, y_offset), img)
            canvas.save(dest)
        print(f"  -> {folder} ({size}x{size})")

# ---------------------------------------------------------------------------
# IOS APPICON ASSETS
# ---------------------------------------------------------------------------
def generate_ios():
    print("Generating iOS AppIcon assets...")
    iconset = PROJECT / "ios" / "Runner" / "Assets.xcassets" / "AppIcon.appiconset"
    iconset.mkdir(parents=True, exist_ok=True)

    icons = [
        ("Icon-App-20x20@1x.png", 20, 1),
        ("Icon-App-20x20@2x.png", 20, 2),
        ("Icon-App-20x20@3x.png", 20, 3),
        ("Icon-App-29x29@1x.png", 29, 1),
        ("Icon-App-29x29@2x.png", 29, 2),
        ("Icon-App-29x29@3x.png", 29, 3),
        ("Icon-App-40x40@1x.png", 40, 1),
        ("Icon-App-40x40@2x.png", 40, 2),
        ("Icon-App-40x40@3x.png", 40, 3),
        ("Icon-App-60x60@2x.png", 60, 2),
        ("Icon-App-60x60@3x.png", 60, 3),
        ("Icon-App-76x76@1x.png", 76, 1),
        ("Icon-App-76x76@2x.png", 76, 2),
        ("Icon-App-83.5x83.5@2x.png", 83, 2),
        ("Icon-App-1024x1024@1x.png", 1024, 1),
    ]

    for filename, logical, scale in icons:
        size = int(logical * scale)
        dest = iconset / filename
        img = Image.open(SRC).convert("RGBA")
        img.thumbnail((size, size), Image.LANCZOS)
        canvas = Image.new("RGBA", (size, size), (0, 0, 0, 0))
        x_offset = (size - img.width) // 2
        y_offset = (size - img.height) // 2
        canvas.paste(img, (x_offset, y_offset), img)
        canvas.save(dest)
        print(f"  -> {filename} ({size}x{size})")

# ---------------------------------------------------------------------------
# MAIN
# ---------------------------------------------------------------------------
if __name__ == "__main__":
    print(f"Source: {SRC}\n")
    copy_in_app_assets()
    generate_android()
    generate_ios()
    print("\nDone!")
