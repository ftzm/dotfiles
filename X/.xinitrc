# General Environmental Setup
xset +fp /usr/share/fonts/local
xset fp rehash
xset +fp ~/.fonts
xset fp rehash
xrdb -merge .Xresources
hsetroot -solid "#002730"
xsetroot -cursor_name left_ptr
setxkbmap -option caps:swapescape

# I3
#~/bin/mattbar.sh &
#exec i3

# XMonad
exec xmonad
