# NotITG Installer NSIS Script

Unofficial NotITG Installer NSIS Script

In this repository, you will find the source code, assets, and along with that, the precompile binary of the installer

Structure of the installation folder based from `Quickstart-v.4.9.1.zip`

# Script Type & Progress

## Online Installer

This NSIS script compile binary in `output` folder
<br>Setup Process:

- Download game file from NotITG website using `NSCurl`
- Extract the game files using `NSISUnz`

Optional Feature:

- Shorcut game + folder
- Remove Song Pack (The purpose of this is to make the game folder in minimal space, user can also opt out this option)
- Mirin Template v.5.0.1 (bundled in this installer)

## Standalone Installer

- Unlike online installer, the game data is packed into the installer
- User can pick whenever they want to keep or not keep the Song Pack or individual Song Pack
- Standalone required you to already have zip file

# Requirement

1. NSIS 3.11 (older NSIS should be fine)
2. inetc
3. NSISUnz

# Credits / Assets

- Mirin Template (v5.0.2) by XeroOI
- Wizard Image - Altate by PlasticRainbow + mrcool909090 from Mod Jam Easy Modo
- Icon modified from OpenITG icon
- Splash Logo, Header, Licenses from NotITG

# False Positive

NSIS have common problem with false positive antivirus, please refer to [this](https://nsis.sourceforge.io/NSIS_False_Positives) for more information
<br>Because the using online feature ``NSCurl`` to download the game file from the website, Some antivirus will detect this as malcious activity
<br>The code in this repository is harmless and the gamedata taken from NotITG [website](https://noti.tg), you can review the code in case there's something wrong with the code *(Please apologize if there's something wrong with the code :( )*

# Final Note

This is the small project and will not replace the way people install NotiTG normally, and it's not endorsed by NotITG Team
