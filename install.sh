BASE_REPO_LINK="https://github.com/xenia-canary/xenia-canary-releases"
BUG_REPORT_LINK="https://github.com/Static-Codes/Xenia-Linux-Installer/issues"
RELEASE_ARCHIVE_NAME="xenia_canary_linux.tar.xz"
BINARY_NAME="xenia_canary"
BINARY_INSTALL_DIR="$HOME/xenia"
BINARY_INSTALL_PATH="$BINARY_INSTALL_DIR/$BINARY_NAME"
ARCHIVE_DOWNLOAD_PATH="$BINARY_INSTALL_DIR/$RELEASE_ARCHIVE_NAME"
EXTRACTED_BINARY_PATH="$BINARY_INSTALL_DIR/build/bin/Linux/Release/xenia_canary"
BUILD_DIRECTORY="$BINARY_INSTALL_DIR/build"

# Credits to Lukechilds (https://gist.github.com/lukechilds/a83e1d7127b78fef38c2914c4ececc3c)
get_latest_release() {
  curl -s "https://api.github.com/repos/xenia-canary/xenia-canary-releases/releases/latest" |
    grep '"tag_name":' |
    sed -E 's/.*"([^"]+)".*/\1/'
}

download_release() {
    if [ -n "$1" ] || [ -n "$2" ]; then
        curl -sL $1 -o $2 || show_error_and_exit "Unable to download the latest release of Xenia Canary, please make a bug report at $BUG_REPORT_LINK"
    fi
}

show_error() {
    echo -e "[ERROR]: $1\n"
    exit
}

show_error_and_exit() {
    echo -e "[ERROR]: $1\n"
    exit
}

show_warning() {
    echo -e "[WARNING]: $1\n"
}

show_info() {
    echo -e "[INFO]: $1\n"
}

show_command() {
    echo -e "[COMMAND]: $1\n"
}

show_success() {
    echo -e "[SUCCESS]: $1\n"
}




show_info "Determining latest release of Xenia Canary."
sleep 2

VERSION_TAG=$(get_latest_release) || "Not Found" # Example: v1.0.0A5

if [ -z $VERSION_TAG ] || [ $VERSION_TAG == "Not Found" ]; then
    show_error "Unable to determine the latest version of xenia canary, please try again."
fi

DOWNLOAD_URL="$BASE_REPO_LINK/releases/download/$VERSION_TAG/$RELEASE_ARCHIVE_NAME"

show_success "Determined latest release of Xenia Canary is $VERSION_TAG"
sleep 2

show_info "Creating installation directory at '$BINARY_INSTALL_DIR'"
sleep 2

mkdir -p "$BINARY_INSTALL_DIR" || show_error_and_exit "Unable to create installation directory"

cd "$BINARY_INSTALL_DIR" || show_error_and_exit "Unable to navigate to installation directory"

show_success "Created and navigated to installation directory at '$BINARY_INSTALL_DIR'"
sleep 2

show_info "Downloading latest release of Xenia Canary at: $DOWNLOAD_URL"
sleep 2

download_release $DOWNLOAD_URL $ARCHIVE_DOWNLOAD_PATH
sleep 2

if [ ! -f $ARCHIVE_DOWNLOAD_PATH ]; then
    show_error_and_exit "Unable to download the latest release of Xenia Canary"
else
    show_info "Downloaded latest release of Xenia Canary."
fi

show_info "Extracting latest release archive."
sleep 2

tar -xf $ARCHIVE_DOWNLOAD_PATH || show_error_and_exit "Unable to unzip the downloaded archive at: '$ARCHIVE_DOWNLOAD_PATH'"
show_success "Extracted latest release archive."
sleep 2

show_info "Copying release binary from $EXTRACTED_BINARY_PATH"
cp "$EXTRACTED_BINARY_PATH" "$BINARY_INSTALL_PATH" || show_error_and_exit "Unable to copy the downloaded binary at: '$BINARY_INSTALL_PATH'"
show_success "Copying release binary to: '$BINARY_INSTALL_PATH'"
sleep 2

show_info "Cleaning up left over files."
sleep 2

if [ -d "$BUILD_DIRECTORY" ]; then
    rm -rf "$BUILD_DIRECTORY"
fi

if [ -f "$ARCHIVE_DOWNLOAD_PATH" ]; then
    rm "$ARCHIVE_DOWNLOAD_PATH"
fi

show_success "Cleaned up left over files."

show_info "The Xenia Canary installation is almost finished."

show_info "To complete the installation, please use the following commands:"

show_command "chmod +x $BINARY_INSTALL_PATH # Makes the Xenia Canary binary an executable"
show_command "xed ~/.bash_aliases # Opens your system's bash alias file."

show_info "Insert the following line:"
show_info "alias xenia=\"$BINARY_INSTALL_PATH\" # Creates the alias to run Xenia easier."

show_command ". ~/.bash_aliases # Refreshes the aliases"
