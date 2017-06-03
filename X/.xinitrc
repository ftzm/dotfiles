# Enable for Japanese support
#export GTK_IM_MODULE=fcitx
#export QT_IM_MODULE=fcitx
#export XMODIFIERS="@im=fcitx"
#fcitx

# General Environmental Setup
xset +fp /usr/share/fonts/local
xset fp rehash
xset +fp ~/.fonts
xset fp rehash
xrdb -merge .Xresources
hsetroot -solid "#282828"
xsetroot -cursor_name left_ptr
setxkbmap -option caps:swapescape
exec xmonad
