#!/usr/bin/env python3
"""
Generate app icon for Crystal Pop Journey
Creates a 1024x1024 icon with gradient background and crystal design
"""

from PIL import Image, ImageDraw, ImageFont
import math

def create_gradient_background(size):
    """Create a radial gradient background"""
    img = Image.new('RGB', (size, size))
    draw = ImageDraw.Draw(img)

    # Purple to blue gradient
    for y in range(size):
        for x in range(size):
            # Calculate distance from center
            dx = x - size/2
            dy = y - size/2
            distance = math.sqrt(dx*dx + dy*dy)
            max_distance = size * 0.7

            # Gradient from purple to dark blue
            ratio = min(distance / max_distance, 1.0)
            r = int(128 - ratio * 78)  # 128 to 50
            g = int(0 + ratio * 0)      # 0 to 0
            b = int(200 - ratio * 80)   # 200 to 120

            img.putpixel((x, y), (r, g, b))

    return img

def draw_crystal(draw, cx, cy, size, color, rotation=0):
    """Draw a diamond/crystal shape"""
    half = size / 2

    # Crystal points (diamond shape)
    points = [
        (cx, cy - half),      # top
        (cx + half, cy),      # right
        (cx, cy + half),      # bottom
        (cx - half, cy),      # left
    ]

    # Rotate if needed
    if rotation != 0:
        rotated = []
        for px, py in points:
            # Rotate around center
            dx = px - cx
            dy = py - cy
            rad = math.radians(rotation)
            new_x = cx + dx * math.cos(rad) - dy * math.sin(rad)
            new_y = cy + dx * math.sin(rad) + dy * math.cos(rad)
            rotated.append((new_x, new_y))
        points = rotated

    # Draw crystal
    draw.polygon(points, fill=color, outline=(255, 255, 255, 200))

    # Add highlight
    highlight_points = [
        (cx - half/3, cy - half/3),
        (cx, cy - half/2),
        (cx + half/4, cy)
    ]
    draw.polygon(highlight_points, fill=(255, 255, 255, 100))

def create_app_icon(size=1024):
    """Create the main app icon"""
    # Create gradient background
    img = create_gradient_background(size)
    draw = ImageDraw.Draw(img, 'RGBA')

    center = size / 2

    # Draw multiple crystals in a circular pattern
    crystal_size = size * 0.18

    # Crystal colors (vibrant gem colors)
    colors = [
        (255, 50, 50),    # Red
        (255, 200, 50),   # Yellow
        (50, 255, 50),    # Green
        (50, 200, 255),   # Cyan
        (150, 50, 255),   # Purple
    ]

    # Draw crystals in a circular arrangement
    num_crystals = 5
    radius = size * 0.28

    for i in range(num_crystals):
        angle = (i * 360 / num_crystals) - 90
        rad = math.radians(angle)
        x = center + radius * math.cos(rad)
        y = center + radius * math.sin(rad)

        color = colors[i % len(colors)]
        draw_crystal(draw, x, y, crystal_size, color, rotation=angle)

    # Draw center crystal (larger)
    draw_crystal(draw, center, center, crystal_size * 1.3, (255, 255, 255), rotation=45)

    # Add sparkle effects
    for _ in range(30):
        import random
        sx = random.randint(int(size * 0.1), int(size * 0.9))
        sy = random.randint(int(size * 0.1), int(size * 0.9))
        sparkle_size = random.randint(2, 6)

        # Draw cross-shaped sparkle
        draw.line([(sx - sparkle_size, sy), (sx + sparkle_size, sy)],
                  fill=(255, 255, 255, 200), width=2)
        draw.line([(sx, sy - sparkle_size), (sx, sy + sparkle_size)],
                  fill=(255, 255, 255, 200), width=2)

    return img

def generate_all_sizes():
    """Generate all required iOS icon sizes"""
    sizes = [
        1024,  # App Store
        180,   # iPhone 60x3
        167,   # iPad Pro
        152,   # iPad 76x2
        120,   # iPhone 40x3
        87,    # iPhone 29x3
        80,    # iPhone 40x2
        76,    # iPad
        58,    # iPhone 29x2
        40,    # iPhone 20x2
        29,    # iPhone Settings
        20,    # iPhone Notification
    ]

    print("Generating app icons...")

    # Create the main 1024x1024 icon
    main_icon = create_app_icon(1024)
    main_icon.save('/Users/monah/Desktop/AppIcon-1024.png')
    print("✅ Created AppIcon-1024.png")

    # Generate all other sizes
    for size in sizes:
        if size == 1024:
            continue

        resized = main_icon.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(f'/Users/monah/Desktop/AppIcon-{size}.png')
        print(f"✅ Created AppIcon-{size}.png")

    print("\n🎉 All icons generated successfully!")
    print("Icons saved to Desktop")

if __name__ == '__main__':
    generate_all_sizes()
