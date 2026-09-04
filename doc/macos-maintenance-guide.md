# macOS maintenance guide
This guide targets macOS Tahoe but most it, if not all, is applicable to
previous versions too.

## Preparation
- Check for updates for [MongoDB Tools](https://github.com/mongodb/mongo-tools/tags)
  and install them `etc/scripts/install-mongo-utils.sh`.
- Enable maintenance services `bash etc/macos/scripts/enable-maintenance-services.sh`
- Reboot.
- Check for updates from Apple `softwareupdate --list`
- Install updates from Apple
  - Regular install: `softwareupdate --install "<label>"`
  - Update w/ restart: `sudo softwareupdate --restart --install "<label>"`
- Reboot.
- Install App Store update.
- Open 1st party apps and make sure they're working as intended.

## Updates
- Update dotfiles `./macos/<hostname>/configure.sh`
- Update hosts `bash etc/scripts/install-hosts.sh --with-sb-hosts-variant unified`
- Update iSMC `bash etc/macos/scripts/install-ismc.sh`
- Update MongoDB Shell/Tools
  `bash etc/scripts/install-mongo-utils.sh --shell-version latest --tools-version latest`
- Update vcpkg `bash etc/scripts/install-vcpkg.sh`
- Update Homebrew's apps.
  - Quit all apps.
  - Unlock apps: `bash etc/macos/scripts/toggle-application-lock.sh`
  - Update Homebrew environment: `brew update`
  - Update formulae with special needs
    - `brew install --ignore-dependencies liblinear lua nmap`
    - `brew install --ignore-dependencies jdtls maven zls`
  - Update all outdated formulae and apps: `brew upgrade --greedy`
  - Unlink specific formulae: `brew unlink python@3.14 openssl@3`
  - Purge the cache: `brew cleanup [--dry-run]`
- Update MacPorts and its apps
  - Update MacPorts and the local ports tree: `sudo port selfupdate`
  - List outdated ports: `port outdated`
  - Update outdated ports: `sudo port upgrade outdated`
- Update other apps.
  - Update Azahar:`bash etc/macos/scripts/install-azahar.sh`
  - Update melonDS:`bash etc/macos/scripts/install-melonds.sh`
  - Update SkyEmu:`bash etc/macos/scripts/install-skyemu.sh`
- Update Mise plugins and tools
  - Update all plugins: `mise plugins upgrade`
  - Update all tools: `mise upgrade`
- Update Python packages
  - List outdated packages: `pip3 list --user --outdated`
  - Update specific package: `pip3 install --user --upgrade <package>`
- Open updated apps and make sure they're working as intended.
- Update Brave's Content Filters list.
- Update VSCode's extensions.
- Review the settings of iCloud, Login Items, Siri Suggestions, Spotlight and
  Notifications.

## Wrap up
- Lock apps: `bash etc/macos/scripts/toggle-application-lock.sh`
- Disable SIP in case it got enabled
  - `csrutil status`.
  - [Disable SIP](https://developer.apple.com/documentation/security/disabling-and-enabling-system-integrity-protection).
- Disable macOS services `bash etc/macos/scripts/disable-services.sh`
- Save any configuration changes: `./macos/<hostname>/configure-settings.sh --save`
- Open _Ghostty_ and purge all caches: `purge all` 
- Reboot.
