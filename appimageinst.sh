#!/bin/bash

# Default icon path (modify if necessary)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_ICON="$SCRIPT_DIR/question-mark.svg"

# Get the base name without the .AppImage extension
getname(){
    basename "$1" .AppImage | cut -d. -f1
}

getpicname(){
    basename "$1"
}

# Create a directory for the AppImage and its icon
make_app_dir(){
    local APPNAME ICONNAME
    APPNAME=$(getname "$1")
    ICONNAME=$(basename "$2")

    mkdir -p "$HOME/$APPNAME"

    mv "$1" "$HOME/$APPNAME"

    if [[ "$ICONNAME" == "default" ]]; then
        cp "$DEFAULT_ICON" "$HOME/$APPNAME/question-mark.svg"
    else
        mv "$2" "$HOME/$APPNAME"
    fi
}

# Create a .desktop file
make_desktop(){
    local APPNAME ICONNAME APPDIR DESKTOP_FILE
    APPNAME=$(getname "$1")
    ICONNAME=$(basename "$2")
    APPDIR="$HOME/$APPNAME"
    DESKTOP_FILE="$HOME/.local/share/applications/$APPNAME.desktop"

    # Ensure applications directory exists
    mkdir -p "$HOME/.local/share/applications/"

    cat > "$DESKTOP_FILE" <<EOF
[Desktop Entry]
Name=$APPNAME
Exec=$APPDIR/$(basename "$1")
Icon=$APPDIR/$ICONNAME
Type=Application
Terminal=false
Categories=Application;Utility;
EOF


    chmod 644 "$DESKTOP_FILE"
}

# Setup the application
install(){
    local APPIMAGE ICON
    APPIMAGE="$1"
    ICON="$2"

    chmod +x "$APPIMAGE" 
    make_app_dir "$APPIMAGE" "$ICON"
    make_desktop "$APPIMAGE" "$ICON"
}

# Uninstall function
uninstall(){
    local APPNAME
    APPNAME=$(getname "$1")

    rm -rf "$HOME/$APPNAME"
    rm -f "$HOME/.local/share/applications/$APPNAME.desktop"

    echo "Application $APPNAME has been successfully uninstalled. You may remove its icon from the panel."
}

# Argument parsing
while getopts "i:u:h" flag; do
    case "$flag" in
        h)
            echo "The AppImageInstaller helps with setting up and uninstalling .AppImage applications."
            echo
            echo "Usage:"
            echo "-h                          Display help message"
            echo "-i [app/path] [icon/path]   Set up application and make .desktop launcher"
            echo "-u [appname]                Delete applications file, icon, directory and launcher files"
            exit 0
        ;;

        i)
            APPNAME=$(getname "$2")

            if [ -f "$3" ]; then
                ICONNAME="$3"
            else
                echo "Icon was not provided, using default icon."
                ICONNAME="default"
            fi

            install "$2" "$ICONNAME"
        ;;

        u)
            uninstall "$2"
        ;;

        \?)
            echo "Invalid option provided. Exiting."
            exit 1
        ;;
    esac
done
