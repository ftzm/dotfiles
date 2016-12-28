# General Environmental Setup
xset +fp /usr/share/fonts/local
xset fp rehash
xset +fp ~/.fonts
xset fp rehash
xrdb -merge .Xresources
hsetroot -solid "#282828"
xsetroot -cursor_name left_ptr
setxkbmap -option caps:swapescape

#xmodmap ~/.xmodmap

# I3
#~/bin/mattbar.sh &
#exec i3

#mattbar.sh &
[ -e "/tmp/xmonad_info" ] && rm "/tmp/xmonad_info"
mkfifo "/tmp/xmonad_info"
polybar example &
compton &
exec xmonad

