#WALLPAPER="$HOME/Pictures/Wallpapers/igor-saikin-E840iJGN8_k-unsplash.jpg"
WALLPAPER="$HOME/Pictures/Wallpapers/Crimson Static Macbook Glass Gradient Wallpaper.png"
hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper ",$WALLPAPER"
hyprpaper &
disown
wallust run "$WALLPAPER"

pkill waybar && waybar &
disown
