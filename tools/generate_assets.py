from __future__ import annotations

import math
import os
import wave
from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter


ROOT = Path(__file__).resolve().parents[1]
ASSET_DIR = ROOT / "assets" / "generated"
SFX_DIR = ROOT / "assets" / "sfx"


def ensure_dirs() -> None:
    ASSET_DIR.mkdir(parents=True, exist_ok=True)
    SFX_DIR.mkdir(parents=True, exist_ok=True)


def lerp(a: int, b: int, t: float) -> int:
    return int(a + (b - a) * t)


def gradient(size: tuple[int, int], top: tuple[int, int, int], bottom: tuple[int, int, int]) -> Image.Image:
    width, height = size
    img = Image.new("RGB", size)
    draw = ImageDraw.Draw(img)
    for y in range(height):
        t = y / max(1, height - 1)
        color = tuple(lerp(top[i], bottom[i], t) for i in range(3))
        draw.line([(0, y), (width, y)], fill=color)
    return img


def make_background() -> None:
    img = gradient((1600, 900), (25, 36, 67), (4, 18, 25)).convert("RGBA")
    draw = ImageDraw.Draw(img, "RGBA")

    for layer, color, y in [
        (0, (26, 65, 82, 220), 390),
        (1, (20, 49, 58, 235), 470),
        (2, (9, 34, 42, 245), 540),
    ]:
        points = [(0, y)]
        for x in range(0, 1700, 160):
            points.append((x, y - 90 - 35 * math.sin(x * 0.007 + layer)))
        points += [(1600, 900), (0, 900)]
        draw.polygon(points, fill=color)

    for x in range(60, 1540, 58):
        h = 18 + (x * 37) % 70
        base = 575 + (x * 11) % 80
        draw.rectangle((x, base - h, x + 20, base), fill=(15, 39, 47, 190))
        if x % 3 == 0:
            draw.rectangle((x + 7, base - h + 8, x + 11, base - h + 16), fill=(255, 181, 80, 200))

    road = [(0, 820), (1600, 820), (1100, 485), (500, 485)]
    draw.polygon(road, fill=(34, 42, 47, 255))
    draw.line((0, 820, 500, 485), fill=(239, 111, 83, 180), width=7)
    draw.line((1600, 820, 1100, 485), fill=(239, 111, 83, 180), width=7)

    for i in range(22):
        t = i / 21
        y = lerp(508, 804, t)
        half = lerp(65, 760, t)
        cx = 800 + 40 * math.sin(t * 5.8)
        draw.line((cx - half, y, cx + half, y), fill=(255, 255, 255, int(26 + t * 45)), width=max(1, int(2 + t * 5)))

    for x in range(120, 1550, 190):
        y = 520 + (x % 5) * 22
        draw.line((x, y, x + 70, y + 170), fill=(35, 80, 90, 220), width=5)
        draw.ellipse((x - 12, y - 14, x + 12, y + 14), fill=(255, 157, 78, 230))

    for x in range(-200, 1800, 130):
        y = 260 + (x % 4) * 34
        draw.line((x, y, x + 260, y + 20), fill=(98, 231, 255, 45), width=3)

    img = img.filter(ImageFilter.UnsharpMask(radius=1.2, percent=120))
    img.save(ASSET_DIR / "background_neon_downhill.png")


def make_rider() -> None:
    img = Image.new("RGBA", (512, 512), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img, "RGBA")

    for r, alpha in [(190, 26), (145, 36), (105, 46)]:
        draw.ellipse((256 - r, 260 - r, 256 + r, 260 + r), outline=(84, 236, 255, alpha), width=5)

    wheel_color = (235, 244, 246, 255)
    glow = (72, 221, 255, 120)
    draw.ellipse((88, 284, 208, 404), outline=glow, width=11)
    draw.ellipse((302, 284, 422, 404), outline=glow, width=11)
    draw.ellipse((96, 292, 200, 396), outline=wheel_color, width=7)
    draw.ellipse((310, 292, 414, 396), outline=wheel_color, width=7)

    frame = (246, 90, 83, 255)
    dark = (10, 18, 24, 255)
    pts = [(148, 344), (250, 338), (338, 338), (268, 278), (205, 338), (268, 278)]
    for a, b in zip(pts, pts[1:]):
        draw.line((a, b), fill=frame, width=10)
    draw.line((338, 338, 360, 302), fill=frame, width=9)
    draw.line((268, 278, 292, 244), fill=frame, width=8)
    draw.line((292, 244, 346, 242), fill=dark, width=7)

    skin = (255, 204, 165, 255)
    suit = (64, 229, 245, 255)
    accent = (255, 115, 90, 255)
    draw.line((274, 178, 298, 246), fill=suit, width=31)
    draw.line((285, 210, 352, 250), fill=suit, width=21)
    draw.line((220, 250, 148, 344), fill=skin, width=17)
    draw.line((292, 252, 338, 338), fill=skin, width=17)
    draw.line((316, 246, 364, 244), fill=skin, width=14)
    draw.line((226, 250, 268, 338), fill=accent, width=12)
    draw.ellipse((246, 124, 318, 190), fill=skin)
    draw.pieslice((238, 116, 324, 184), 185, 360, fill=(20, 27, 33, 255))
    draw.arc((238, 116, 324, 184), 185, 360, fill=(110, 238, 255, 255), width=6)

    for i in range(14):
        y = 135 + i * 18
        draw.line((60 - i * 8, y, 188 - i * 4, y + 18), fill=(255, 255, 255, 42), width=5)

    img.save(ASSET_DIR / "rider_sprinter.png")


def icon_cone(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int]) -> None:
    x0, y0, x1, y1 = box
    cx = (x0 + x1) // 2
    draw.polygon([(cx, y0 + 28), (x0 + 26, y1 - 28), (x1 - 26, y1 - 28)], fill=(238, 88, 48, 255))
    draw.rectangle((x0 + 18, y1 - 32, x1 - 18, y1 - 18), fill=(255, 230, 140, 255))
    draw.line((cx - 26, y0 + 76, cx + 26, y0 + 76), fill=(255, 240, 180, 255), width=8)


def icon_pothole(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int]) -> None:
    x0, y0, x1, y1 = box
    draw.ellipse((x0 + 22, y0 + 46, x1 - 22, y1 - 30), fill=(8, 15, 18, 255), outline=(95, 102, 99, 255), width=7)
    draw.arc((x0 + 32, y0 + 56, x1 - 36, y1 - 48), 185, 340, fill=(146, 159, 154, 210), width=4)


def icon_rail(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int]) -> None:
    x0, y0, x1, y1 = box
    draw.line((x0 + 20, y0 + 80, x1 - 22, y0 + 48), fill=(180, 190, 196, 255), width=12)
    draw.line((x0 + 24, y0 + 100, x1 - 28, y0 + 76), fill=(180, 190, 196, 255), width=12)
    draw.line((x0 + 44, y0 + 42, x0 + 64, y1 - 22), fill=(100, 112, 118, 255), width=10)
    draw.line((x1 - 64, y0 + 36, x1 - 42, y1 - 28), fill=(100, 112, 118, 255), width=10)
    draw.line((x0 + 84, y0 + 82, x0 + 116, y0 + 54), fill=(255, 97, 82, 255), width=6)


def icon_gel(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int]) -> None:
    x0, y0, x1, y1 = box
    draw.rounded_rectangle((x0 + 36, y0 + 24, x1 - 36, y1 - 24), radius=14, fill=(76, 234, 211, 255), outline=(255, 255, 255, 230), width=5)
    draw.polygon([(x0 + 48, y0 + 44), (x1 - 46, y0 + 34), (x1 - 58, y1 - 42), (x0 + 42, y1 - 36)], fill=(255, 222, 88, 185))
    draw.ellipse((x0 + 60, y0 + 56, x0 + 92, y0 + 88), fill=(255, 97, 90, 255))


def icon_draft(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int]) -> None:
    x0, y0, x1, y1 = box
    for i, color in enumerate([(80, 232, 255, 225), (255, 226, 82, 170), (255, 107, 83, 140)]):
        inset = 18 + i * 18
        draw.arc((x0 + inset, y0 + inset, x1 - inset, y1 - inset), 205, 515, fill=color, width=9)
    draw.polygon([(x1 - 38, y0 + 48), (x1 - 20, y0 + 84), (x1 - 58, y0 + 78)], fill=(80, 232, 255, 255))


def icon_cog(draw: ImageDraw.ImageDraw, box: tuple[int, int, int, int]) -> None:
    x0, y0, x1, y1 = box
    cx = (x0 + x1) // 2
    cy = (y0 + y1) // 2
    pts = []
    for i in range(24):
        r = 55 if i % 2 == 0 else 43
        a = i * math.tau / 24
        pts.append((cx + math.cos(a) * r, cy + math.sin(a) * r))
    draw.polygon(pts, fill=(255, 198, 62, 255), outline=(255, 246, 174, 255))
    draw.ellipse((cx - 23, cy - 23, cx + 23, cy + 23), fill=(28, 35, 39, 255), outline=(255, 246, 174, 255), width=5)


def make_atlas() -> None:
    img = Image.new("RGBA", (384, 256), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img, "RGBA")
    funcs = [icon_cone, icon_pothole, icon_rail, icon_gel, icon_draft, icon_cog]
    for idx, func in enumerate(funcs):
        col = idx % 3
        row = idx // 3
        box = (col * 128 + 6, row * 128 + 6, col * 128 + 122, row * 128 + 122)
        draw.rounded_rectangle(box, radius=18, fill=(12, 20, 24, 225), outline=(56, 78, 84, 255), width=3)
        func(draw, box)
    img.save(ASSET_DIR / "object_atlas.png")


def make_card_art() -> None:
    img = gradient((512, 512), (18, 31, 43), (7, 10, 18)).convert("RGBA")
    draw = ImageDraw.Draw(img, "RGBA")
    cx, cy = 260, 265
    for i in range(30):
        a = i * math.tau / 30
        r1 = 62 + (i % 3) * 8
        r2 = 220
        color = (74, 232, 255, 45 + (i % 4) * 18) if i % 2 else (255, 99, 85, 50)
        draw.line((cx + math.cos(a) * r1, cy + math.sin(a) * r1, cx + math.cos(a) * r2, cy + math.sin(a) * r2), fill=color, width=5)
    for r, color in [(112, (255, 202, 72, 255)), (82, (75, 235, 255, 255)), (42, (255, 105, 87, 255))]:
        draw.ellipse((cx - r, cy - r, cx + r, cy + r), outline=color, width=10)
    for i in range(12):
        a = i * math.tau / 12
        draw.line((cx, cy, cx + math.cos(a) * 112, cy + math.sin(a) * 112), fill=(230, 242, 240, 190), width=5)
    draw.line((70, 360, 450, 148), fill=(235, 242, 239, 255), width=15)
    draw.line((78, 386, 458, 174), fill=(74, 235, 255, 180), width=7)
    for i in range(7):
        x = 95 + i * 48
        draw.rounded_rectangle((x, 70 + i % 2 * 12, x + 34, 118 + i % 2 * 12), radius=5, fill=(255, 255, 255, 45), outline=(255, 255, 255, 140), width=2)
    img = img.filter(ImageFilter.UnsharpMask(radius=1.1, percent=130))
    img.save(ASSET_DIR / "card_cadence.png")


def write_wav(name: str, freq: float, seconds: float, volume: float = 0.45, slide: float = 0.0, noise: bool = False) -> None:
    rate = 44100
    frames = []
    seed = 0x1234
    for n in range(int(rate * seconds)):
        t = n / rate
        env = min(1.0, t * 40) * max(0.0, 1.0 - t / seconds)
        f = freq + slide * t
        sample = math.sin(math.tau * f * t)
        if noise:
            seed = (1103515245 * seed + 12345) & 0x7FFFFFFF
            sample = sample * 0.55 + ((seed / 0x7FFFFFFF) * 2 - 1) * 0.45
        val = int(max(-1, min(1, sample * env * volume)) * 32767)
        frames.append(val.to_bytes(2, "little", signed=True))
    with wave.open(str(SFX_DIR / name), "wb") as wav:
        wav.setnchannels(1)
        wav.setsampwidth(2)
        wav.setframerate(rate)
        wav.writeframes(b"".join(frames))


def make_sfx() -> None:
    write_wav("card.wav", 660, 0.16, 0.42, slide=850)
    write_wav("near_miss.wav", 180, 0.13, 0.55, slide=360, noise=True)
    write_wav("crash.wav", 96, 0.42, 0.6, slide=-80, noise=True)
    write_wav("pickup.wav", 520, 0.22, 0.45, slide=620)
    write_wav("stage_clear.wav", 320, 0.5, 0.5, slide=720)
    write_wav("win.wav", 440, 0.9, 0.5, slide=330)


def main() -> None:
    ensure_dirs()
    make_background()
    make_rider()
    make_atlas()
    make_card_art()
    make_sfx()
    print(f"Generated assets in {ASSET_DIR} and {SFX_DIR}")


if __name__ == "__main__":
    main()

