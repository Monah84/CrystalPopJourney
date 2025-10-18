#!/usr/bin/env python3
"""
Crystal Pop Journey - App Icon Generator
Creates all required iOS app icon sizes
"""

from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os

def create_crystal_icon(size):
    """Create a beautiful crystal-themed app icon"""

    # Create image with gradient background
    img = Image.new('RGB', (size, size))
    draw = ImageDraw.Draw(img)

    # Purple gradient background
    for y in range(size):
        r = int(130 + (y / size) * 40)
        g = int(69 + (y / size) * 40)
        b = int(217 - (y / size) * 40)
        draw.line([(0, y), (size, y)], fill=(r, g, b))

    # Draw crystal shape (diamond)
    center_x = size // 2
    center_y = size // 2
    crystal_size = size // 3

    # Crystal points
    top = (center_x, center_y - crystal_size)
    right = (center_x + crystal_size, center_y)
    bottom = (center_x, center_y + crystal_size)
    left = (center_x - crystal_size, center_y)

    # Draw crystal with glow
    glow_img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    glow_draw = ImageDraw.Draw(glow_img)

    # Outer glow
    for i in range(10, 0, -1):
        alpha = int(255 * (i / 10) * 0.3)
        offset = i * 2
        glow_points = [
            (top[0], top[1] - offset),
            (right[0] + offset, right[1]),
            (bottom[0], bottom[1] + offset),
            (left[0] - offset, left[1])
        ]
        glow_draw.polygon(glow_points, fill=(255, 215, 0, alpha))

    # Main crystal
    crystal_points = [top, right, bottom, left]
    glow_draw.polygon(crystal_points, fill=(255, 255, 255, 255))

    # Add facets
    glow_draw.polygon([top, (center_x, center_y), right], fill=(200, 200, 255, 200))
    glow_draw.polygon([right, (center_x, center_y), bottom], fill=(220, 220, 255, 180))
    glow_draw.polygon([bottom, (center_x, center_y), left], fill=(180, 180, 255, 200))
    glow_draw.polygon([left, (center_x, center_y), top], fill=(240, 240, 255, 180))

    # Composite
    img = Image.alpha_composite(img.convert('RGBA'), glow_img)

    # Add sparkles
    sparkle_positions = [
        (size // 4, size // 4),
        (3 * size // 4, size // 4),
        (size // 2, 3 * size // 4)
    ]

    sparkle_draw = ImageDraw.Draw(img)
    sparkle_size = max(3, size // 80)
    for x, y in sparkle_positions:
        sparkle_draw.ellipse([x - sparkle_size, y - sparkle_size,
                              x + sparkle_size, y + sparkle_size],
                             fill=(255, 255, 255, 255))

    return img.convert('RGB')

def main():
    print("🎨 Creating Crystal Pop Journey App Icons...")

    # iOS App Icon sizes
    sizes = {
        '20': [20, 40, 60],      # iPhone Notification
        '29': [29, 58, 87],      # iPhone Settings
        '40': [40, 80, 120],     # iPhone Spotlight
        '60': [120, 180],        # iPhone App
        '76': [76, 152],         # iPad App
        '83.5': [167],           # iPad Pro
        '1024': [1024]           # App Store
    }

    # Create Icons directory
    icons_dir = '/Users/monah/projects/CrystalPopJourney/AppIcons'
    os.makedirs(icons_dir, exist_ok=True)

    # Generate all sizes
    generated = []
    for base_size, pixel_sizes in sizes.items():
        for pixel_size in pixel_sizes:
            icon = create_crystal_icon(pixel_size)
            filename = f'Icon-{pixel_size}.png'
            filepath = os.path.join(icons_dir, filename)
            icon.save(filepath, 'PNG')
            generated.append(filename)
            print(f'  ✓ Created {filename}')

    print(f"\n✅ Generated {len(generated)} icon sizes!")
    print(f"📁 Location: {icons_dir}")
    print("\n📝 Next steps:")
    print("1. Open Xcode")
    print("2. Select Assets.xcassets → AppIcon")
    print("3. Drag icons from AppIcons folder to corresponding slots")
    print("\nOr run: python3 import_icons.py (coming next)")

if __name__ == '__main__':
    try:
        main()
    except ImportError:
        print("❌ PIL/Pillow not installed")
        print("📦 Install with: pip3 install Pillow")
        print("Then run this script again")
