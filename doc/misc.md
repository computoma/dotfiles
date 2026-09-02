# Miscellaneous notes

## Homebrew

## Mise

## OBS
- macOS H.264 hardware encoder setup for streaming.
  - Common settings
    - Rate Control: CBR
    - Keyframe Interval: 2s
    - Profile: high
    - Use B-Frames: ✅
    - Spatial AQ: Automatic
  - Max birate per output resolution:
    - 2408x1506 and 2560x1440: 10000 Kbps
    - 3008x1692: 13000 Kbps
    - 3072x1920 and 3024x1964: 15000 Kbps
    - 3456x2234: 18000 Kbps

- macOS HEVC hardware encoder setup for recording:
  - Common settings
    - Rate Control: CRF
    - Quality: 60
    - Max bitrate window: 2s
    - Keyframe Interval:  5s
    - Profile: main
    - Use B-Frames: ✅
    - Spatial AQ: Automatic
  - Max birate per output resolution:
    - 2408x1506 and 2560x1440: 12000 Kbps
    - 3008x1692: 16000 Kbps
    - 3072x1920 and 3024x1964: 18000 Kbps
    - 3456x2234: 22000 Kbps

## SSH
- Generate new keys
  - RSA: `ssh-keygen -t rsa-sha2-512 -b 8192 -f id_rsa -C <hostname>`
  - ED25519: `ssh-keygen -t ed25519 -f id_ed25519 -C <hostname>`
- Set strict permissions
  - For the keys: `chmod u=r,g=,o= id_*`
  - For the folder where they're stored: `chmod u=rwx,g=,o= <folder>`
- Check the size of a RSA key: `ssh-keygen -l -f id_rsa.pub`

## Other
- Get Apple's CLI Tools version: `pkgutil --pkg-info=com.apple.pkg.CLTools_Executables`.
