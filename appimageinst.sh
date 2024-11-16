#!/bin/bash

# Get the base name without the .AppImage extension
getname(){
    basename "$1" .AppImage | grep -oP "^.+?((?=\.)|$)"
}

# firstly get the file type then extract its name 
getpicname(){
    basename "$1"
}

# Create a directory for the appimg file and icon and get them there
make_app_dir(){
    mkdir -p "$HOME/$(getname "$1")"
    mv "$1" "$HOME/$(getname "$1")"
    mv "$2" "$HOME/$(getname "$1")"
}

# Create a .desktop file
make_desktop(){
    APPNAME=$(getname "$1")
    ICONNAME=$(getpicname "$2")
    # make iconname with extension
    APPDIR="$HOME/$APPNAME"
    DESKTOP_FILE="/usr/share/applications/$APPNAME.desktop"

    echo "[Desktop Entry]
Name=$APPNAME
Exec=$APPDIR/$(basename "$1")
Icon=$APPDIR/$ICONNAME
Type=Application
Categories=Application;Utility;" > "$DESKTOP_FILE"

    chmod 644 "$DESKTOP_FILE"
}

# Setup the application
install(){
    chmod +x "$1" && chmod +x "$2" # making files executable b4 mowing them cause it would be to much of a hustle later
    make_app_dir "$1" "$2"
    make_desktop "$1" "$2"
}

# uninstall function

uninstall(){
	APPNAME=$(getname "$1")
	rm -fr  -i "$HOME/$APPNAME"
	rm -i "$HOME/.local/share/applications/$APPNAME.desktop"
	echo "Application $APPNAME has been succesfully uninstalled, you now can remove it's icon from the panel."
} 


while getopts "i:u:h" flag; do

    case $flag in

        h)
            echo "The AppImageInstaller is a script which helps with setting up and uninstalling .AppImage applications,"
            echo "making icons for ease of use."
            echo
            echo "Usage:"
            echo
            echo "-h                          Display help message"
            echo "-i [app/path] [icon/path]   Set up application and make .desktop launcher"
            echo "-u [appname]                Delete application’s file, icon, directory and launcher files"
        ;;

        i)
            install $2 $3
        ;;

        u)
            uninstall $2 
        ;;

        \?)
            echo "Invalid option/flag has been provided, exiting"
        ;;
    esac

done;
