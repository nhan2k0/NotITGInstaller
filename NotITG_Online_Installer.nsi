;include NSIS plugins
!include "MUI2.nsh"
!include "nsDialogs.nsh"
;git commit id 
!tempfile CommitIDParse
!echo "$CommitIDParse"
!system '"git" rev-parse --short HEAD > "${CommitIDParse}'
!searchparse /file "${CommitIDParse}" "" CommitID
;git date
!tempfile CommitDateParse
!echo "$CommitDateParse"
!system '"git" log -1 --date=format:"%m%d%Y" --format=%cd > "${CommitDateParse}'
!searchparse /file "${CommitDateParse}" "" CommitDate
;DEFINE GAME INFORMATION
!define PRODUCT_ID "NotITG"
!define PRODUCT_NAME "NotITG"
!define PRODUCT_VER "v4.9.1"
!define PRODUCT_DISPLAY "${PRODUCT_ID} ${PRODUCT_VER}"
;DEFINE INSTALLER INFORMATION
Name "${PRODUCT_ID} ${PRODUCT_VER}"
OutFile "output/${PRODUCT_ID}${PRODUCT_VER}_${CommitID}_${CommitDate}.exe"
BrandingText "Build ${CommitID}_${CommitDate}"
Unicode "True"
InstallDir "C:\Games\NotITG"
RequestExecutionLevel user
ShowInstDetails show

;assest define stuff
;!define WAV_FILE "fish.wav" 
!define MUI_HEADERIMAGE								
!define MUI_HEADERIMAGE_BITMAP "assets\nitg_header.bmp" 
!define WELCOME_FINISH_IMAGE "assets\wizard2.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "${WELCOME_FINISH_IMAGE}"
!define MUI_ICON "assets\nitg_install.ico"
!define NITGFileSize 577277 ;game size

;asset text stuff
!define MUI_WELCOMEPAGE_TITLE "Welcome to ${PRODUCT_ID} ${PRODUCT_VER}"	
!define MUI_WELCOMEPAGE_TEXT "This installation required internet connection to download Game Files, make sure your connection is stable$\r$\nClick 'Next' to continue$\r$\n$\r$\nThe NotITG Project is managed by TaroNuke and HeySora$\r$\n$\r$\nThis installer is not endorsed by NotITG Team"

;page stuff
!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "assets\Licenses.txt"
;Page custom TestPage ; --later
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

;language
!insertmacro MUI_LANGUAGE "English"

Section "Full Game" Game
AddSize ${NITGFileSize}
SectionIn 1 RO
SetOutPath $INSTDIR
;GetDlgItem $0 $HWNDPARENT 2
;EnableWindow $0 1
  ; Target file path
  InitPluginsDir
  StrCpy $0 "$TEMP\${PRODUCT_ID}-${PRODUCT_VER}-Quickstart.zip"

  IfFileExists "$0" existFile
  ;DetailPrint "Download Game"
  ;NScurl::http GET "https://cloud.noti.tg/QuickStart-${PRODUCT_VER}.zip" $0 /RESUME /END
  inetc::get /caption "Download Game" "https://cloud.noti.tg/QuickStart-${PRODUCT_VER}.zip" "$0"
  Pop $1
  DetailPrint "Download Game: $1"
  StrCmp $1 "OK" download_ok download_notok
  
  download_ok:
  Sleep 1000
  goto extractfile
 
  existFile:
  DetailPrint "Downloaded file existed, skipped"
  Sleep 1000
  goto extractfile
  
  extractfile:
  DetailPrint "Extract Game"
  nsisunz::UnzipToLog "$0" "$INSTDIR"
  Pop $2
  DetailPrint "Extract Game: $2"
  StrCmp $2 "success" finalize extractfail
  ;MessageBox MB_ICONINFORMATION|MB_OK "Game extract complete"
  
  goto finalize
  
  finalize:
  ;MessageBox MB_ICONINFORMATION|MB_OK "Extract file success"
  DetailPrint "Extract file success"
  Sleep 1000
  Delete "$TEMP\${PRODUCT_ID}-${PRODUCT_VER}-Quickstart.zip"
  goto finish
  ;failed
  
  download_notok:
  MessageBox MB_ICONINFORMATION|MB_OK "Setup failed to download the file."
  DetailPrint "Download Game Fail"
  Sleep 1000
  Delete "$TEMP\${PRODUCT_ID}-${PRODUCT_VER}-Quickstart.zip"
  Sleep 2000
  Abort
  
  extractfail:
  MessageBox MB_ICONINFORMATION|MB_OK "Game files extract failed"
  DetailPrint "Extract Game Fail"
  delete "$TEMP\${PRODUCT_ID}-${PRODUCT_VER}-Quickstart.zip"
  Sleep 1000
  Abort
  
  finish:
  
SectionEnd
  
Section "Game Shortcut" ShortcutGame
Sleep 500
DetailPrint "Creating Shortcut"
CreateShortCut "$DESKTOP\${PRODUCT_ID} ${PRODUCT_VER} - Folder.lnk" "$INSTDIR\"
SectionEnd

Section "Folder Shortcut" ShortcutFolder
Sleep 500
DetailPrint "Creating Folder Shortcut"
CreateShortCut "$DESKTOP\${PRODUCT_ID} ${PRODUCT_VER} - Folder.lnk" "$INSTDIR\"
SectionEnd

Section "Mirin Template v5.0.2" MirinTemplate
SetOutPath $INSTDIR

CreateDirectory "$INSTDIR\Songs\MyModchart\Mirin Template"
SetOutPath "$INSTDIR\Songs\MyModchart\Mirin Template"
File /r "assets\MirinTemplate\*"
SectionEnd

Section /o "Song Removal" SongRemove
SetOutPath $INSTDIR
RMDir /r "$INSTDIR\Songs\Mod Jam Easy Modo"
RMDir /r "$INSTDIR\Songs\Mods Boot Camp"
RMDir /r "$INSTDIR\Songs\OISRT - Day 1"
SectionEnd

;section description
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
!insertmacro MUI_DESCRIPTION_TEXT ${Game} "Setup will download the game data from NotITG website and extract it"
!insertmacro MUI_DESCRIPTION_TEXT ${SongRemove} "All the songpack will be remove to keep the game in minimal space. Unchecked this if you don't need to (Specially if you are beginner)"
!insertmacro MUI_DESCRIPTION_TEXT ${MirinTemplate} "Template use for NotITG Modfile. This will install in Song directory"
!insertmacro MUI_DESCRIPTION_TEXT ${ShortcutGame} "Creating game shortcut"
!insertmacro MUI_DESCRIPTION_TEXT ${ShortcutFolder} "Creating game folder shortcut"
!insertmacro MUI_FUNCTION_DESCRIPTION_END

Function .onInit
			;skin (uncomment this if you want to implement this)
			/*
			SetOutPath $TEMP
      File /oname=skin.skf "fish.skf"
      NSIS_SkinCrafter_Plugin::skin /NOUNLOAD $TEMP\skin.skf
      Delete $TEMP\skin.skf
			*/
			
			;splash
			InitPluginsDir
			File /oname=$PLUGINSDIR\splash.bmp "assets\nitglogo.bmp"
			advsplash::show 300 200 400 0x04025C $PLUGINSDIR\splash
			Delete "$PLUGINSDIR\splash.bmp"
			
			;music bg (uncomment this if you want to implement this)
			;ffmpeg -i input.mp3 output.wav
			/*
			File /ONAME=$PLUGINSDIR\sound.wav "${WAV_FILE}"
			StrCpy $0 "$PLUGINSDIR\sound.wav"  ; location of the wav file
			IntOp $1 "SND_ASYNC" || 1
			System::Call 'winmm::PlaySound(t r0, i 0, i 131081) b'
			*/
FunctionEnd
