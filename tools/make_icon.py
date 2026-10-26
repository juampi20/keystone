"""Generates the Keystone tray icons: an arch whose top stone (the keystone) is gold.

Run: python tools/make_icon.py
Writes assets/keystone.ico, assets/keystone-paused.ico and assets/keystone-preview.png.
Standard library only.
"""
import math
import struct
import zlib
from pathlib import Path

SIZES = [16, 20, 24, 32, 48, 64, 256]
SUPERSAMPLE = 4

# Arch geometry in a 0..1 square.
CX, CY = 0.5, 0.70
R_IN, R_OUT, R_KEY = 0.20, 0.40, 0.46  # the keystone protrudes past the ring
GAP_DEG = 4
KEY_FROM, KEY_TO = 72, 108  # keystone spans the top 36 degrees
SEGMENTS = [(0, 36), (36, KEY_FROM), (KEY_FROM, KEY_TO), (KEY_TO, 144), (144, 180)]
PILLARS = [(0.10, 0.30), (0.70, 0.90)]  # x ranges under each side of the ring
PILLAR_BOTTOM = 0.88
BG_INSET, BG_RADIUS = 0.04, 0.20

THEMES = {
    "keystone": {"bg": (0x1E, 0x29, 0x33), "stone": (0xA9, 0xB8, 0xC4), "key": (0xF2, 0xB1, 0x34)},
    "keystone-paused": {"bg": (0x3A, 0x3F, 0x44), "stone": (0x7D, 0x86, 0x8E), "key": (0x9A, 0xA2, 0xA9)},
}


def in_rounded_rect(x, y):
    lo, hi, r = BG_INSET, 1 - BG_INSET, BG_RADIUS
    if not (lo <= x <= hi and lo <= y <= hi):
        return False
    nx = min(max(x, lo + r), hi - r)
    ny = min(max(y, lo + r), hi - r)
    return (x - nx) ** 2 + (y - ny) ** 2 <= r * r


def stone_at(x, y):
    """Returns 'key', 'stone' or None for a point."""
    for left, right in PILLARS:
        if left <= x <= right and CY <= y <= PILLAR_BOTTOM:
            return "stone"
    if y > CY:
        return None
    d = math.hypot(x - CX, y - CY)
    angle = math.degrees(math.atan2(CY - y, x - CX))
    for start, end in SEGMENTS:
        if start + GAP_DEG / 2 <= angle <= end - GAP_DEG / 2:
            is_key = start == KEY_FROM
            if R_IN <= d <= (R_KEY if is_key else R_OUT):
                return "key" if is_key else "stone"
    return None


def render(size, theme):
    """Returns RGBA rows (top-down) with supersampled antialiasing."""
    rows = []
    n = SUPERSAMPLE
    for py in range(size):
        row = bytearray()
        for px in range(size):
            r = g = b = a = 0
            for sy in range(n):
                for sx in range(n):
                    x = (px + (sx + 0.5) / n) / size
                    y = (py + (sy + 0.5) / n) / size
                    if not in_rounded_rect(x, y):
                        continue
                    color = theme[stone_at(x, y) or "bg"]
                    r, g, b, a = r + color[0], g + color[1], b + color[2], a + 1
            if a:
                row += bytes((r // a, g // a, b // a, a * 255 // (n * n)))
            else:
                row += bytes(4)
        rows.append(bytes(row))
    return rows


def png(size, rows):
    def chunk(kind, data):
        return struct.pack(">I", len(data)) + kind + data + struct.pack(">I", zlib.crc32(kind + data))

    raw = b"".join(b"\x00" + row for row in rows)
    return (
        b"\x89PNG\r\n\x1a\n"
        + chunk(b"IHDR", struct.pack(">IIBBBBB", size, size, 8, 6, 0, 0, 0))
        + chunk(b"IDAT", zlib.compress(raw, 9))
        + chunk(b"IEND", b"")
    )


def dib(size, rows):
    header = struct.pack("<IiiHHIIiiII", 40, size, size * 2, 1, 32, 0, 0, 0, 0, 0, 0)
    pixels = b"".join(
        bytes(px for i in range(0, len(row), 4) for px in (row[i + 2], row[i + 1], row[i], row[i + 3]))
        for row in reversed(rows)
    )
    mask = bytes(((size + 31) // 32) * 4 * size)  # alpha channel carries transparency
    return header + pixels + mask


def ico(images):
    header = struct.pack("<HHH", 0, 1, len(images))
    offset = len(header) + 16 * len(images)
    entries, blobs = b"", b""
    for size, data in images:
        dim = 0 if size == 256 else size
        entries += struct.pack("<BBBBHHII", dim, dim, 0, 0, 1, 32, len(data), offset)
        blobs += data
        offset += len(data)
    return header + entries + blobs


def main():
    assets = Path(__file__).resolve().parent.parent / "assets"
    assets.mkdir(exist_ok=True)
    for name, theme in THEMES.items():
        images = []
        for size in SIZES:
            rows = render(size, theme)
            images.append((size, png(size, rows) if size == 256 else dib(size, rows)))
            if name == "keystone" and size == 256:
                (assets / "keystone-preview.png").write_bytes(png(size, rows))
        (assets / f"{name}.ico").write_bytes(ico(images))
        print(f"wrote assets/{name}.ico")


if __name__ == "__main__":
    main()
