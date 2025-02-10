#/bin/bash

DOTFILES=$(dirname $0 | xargs realpath)

read -p "Please input installation directory: " INSTALL_DIR

if [ ! -d ${INSTALL_DIR} ]; then
    echo "${INSTALL_DIR} is invalid"
    exit 1
fi

echo "Configuring git"
ln -si "${DOTFILES}/.gitconfig" "${INSTALL_DIR}/.gitconfig"

echo "Configuring tmux"
ln -si "${DOTFILES}/.tmux.conf" "${INSTALL_DIR}/.tmux.conf"

echo "Configuring wezterm"
ln -si "${DOTFILES}/.wezterm.lua" "${INSTALL_DIR}/.wezterm.lua"

echo "Configuring vim"
ln -si "${DOTFILES}/.vimrc" "${INSTALL_DIR}/.vimrc"
ln -si "${DOTFILES}/.vrapperrc" "${INSTALL_DIR}/.vrapperrc"
mkdir -p "${INSTALL_DIR}/.vim"
ln -si "${DOTFILES}/coc-settings" "${INSTALL_DIR}/.vim/coc-settings"

echo "Configuring bash"
cat >> "${INSTALL_DIR}/.bashrc" <<- EOF
MY_PROFILE=${DOTFILES}/.bashrc
if [ -f "\$MY_PROFILE" ]; then
    . "\$MY_PROFILE";
fi
EOF
