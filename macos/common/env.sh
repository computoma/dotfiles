#!/usr/bin/env /bin/bash
# shellcheck disable=SC2155

export HOMEBREW_DEFAULT_FORMULAE=(
	7zip aria2 bash bash-completion@2 bat bzip2 coreutils eza fd fio fish fzf
	gettext git-delta gsed jq lf lima miniserve mise neovim pbzip2 pigz pinentry
	ripgrep shellcheck tokei tree typst xz zstd
)

export HOMEBREW_DEFAULT_CASKS=(
	alt-tab betterdisplay brave-browser bruno dbeaver-community
	font-jetbrains-mono-nerd-font fork geekbench ghostty iina mac-mouse-fix obs
	spotify transmission visual-studio-code visualdiffer zed
)

export HOMEBREW_EXTRA_CASKS_LAPTOP=(
	coconutbattery keyboardcleantool
)

export MACPORTS_DEFAULT_PORTS=(
	7zip aria2 bash bash-completion@ bat bzip2 coreutils eza fd fio fish fzf
	gettext git-delta gsed jq lf lima miniserve mise neovim pbzip2 pigz pinentry
	ripgrep shellcheck tokei tree typst xz zstd
)
