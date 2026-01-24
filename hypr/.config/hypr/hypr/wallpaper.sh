#WALLPAPER="$HOME/Pictures/Wallpapers/igor-saikin-E840iJGN8_k-unsplash.jpg"
#WALLPAPER="$HOME/Pictures/Wallpapers/Crimson Static Macbook Glass Gradient Wallpaper.png"
WALLPAPER=$1

hyprpaper &
disown

hyprctl hyprpaper preload "$WALLPAPER"
hyprctl hyprpaper wallpaper ",$WALLPAPER"

wallust run "$WALLPAPER"
