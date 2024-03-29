;--------------------------------
; NSIS Script
; Author  - Ramesh Prasad
; Email   - rp181135198@gmail.com
; Github  - https://github.com/rp181135198
; Youtube - https://www.youtube.com/c/codewar
;--------------------------------

;--------------------------------
;Including Header Files

  !include "MUI2.nsh"
  !include "LogicLib.nsh"
  
;--------------------------------
;Settings

  !define APPNAME "Test Appplication"
  !define APP_NAME_IN_INSTALLED_DIR "app"
  !define COMPANYNAME "CodeWar"
  !define DESCRIPTION "This is a test."
  !define DEVELOPER "Ramesh Prasad" #License Holder
  # Files Directory
  !define FILE_DIR "D:\NSIS-Script" #Replace with the full path of install folder
  !define LOGO_ICON_FILE "${FILE_DIR}\logo.ico"
  !define LICENSE_TEXT_FILE "${FILE_DIR}\LICENSE.txt"
  !define SPLASH_IMG_FILE "${FILE_DIR}\splash.bmp"
  !define HEADER_IMG_FILE "${FILE_DIR}\header.bmp"
  # These three must be integers
  !define VERSIONMAJOR 1	#Major release Number
  !define VERSIONMINOR 1	#Minor release Number
  !define VERSIONBUILD 1	#Maintenance release Number (bugfixes only)
  !define BUILDNUMBER 1		#Source control revision number
  # These will be displayed by the "Click here for support information" link in "Add/Remove Programs"
  # It is possible to use "mailto:" links in here to open email client
  !define HELPURL "https://codewarindia.business.site"
  !define UPDATEURL "https://"
  !define ABOUTURL "https://www.youtube.com/c/codewar"
  # This is the size (in kB) of all the files copied into "Program Files"
  !define INSTALLSIZE 1118721

;--------------------------------
;General

  ;Name and file
  Name "${APPNAME}"
  Icon "logo.ico"
  OutFile "${APPNAME} Setup.exe"

  ;Default installation folder
  InstallDir "$PROGRAMFILES\${APPNAME}"

  ;Get installation folder from registry if available
  InstallDirRegKey HKCU "Software\${APPNAME}" ""

  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin ;Require admin rights on NT6+ (When UAC is turned on)
  
;--------------------------------
;Splash Screen
  
  XPStyle on

  Function .onInit
	# the plugins dir is automatically deleted when the installer exits
	InitPluginsDir
	File /oname=$PLUGINSDIR\splash.bmp "${SPLASH_IMG_FILE}"
	#optional
	#File /oname=$PLUGINSDIR\splash.wav "C:\myprog\sound.wav"

	splash::show 3000 $PLUGINSDIR\splash

	Pop $0 ; $0 has '1' if the user closed the splash screen early,
		; '0' if everything closed normally, and '-1' if some error occurred.
  FunctionEnd

;--------------------------------
;Variables

  Var StartMenuFolder
  
;--------------------------------
;Interface Settings

  !define MUI_HEADERIMAGE
  !define MUI_HEADERIMAGE_BITMAP "${HEADER_IMG_FILE}" ; optional
  
  !define MUI_ABORTWARNING

;--------------------------------
;Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "${LICENSE_TEXT_FILE}"
  !insertmacro MUI_PAGE_DIRECTORY
  
  ;Start Menu Folder Page Configuration
  !define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
  !define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\${APPNAME}" 
  !define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
  
  !insertmacro MUI_PAGE_STARTMENU Application $StartMenuFolder
  
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  !insertmacro MUI_UNPAGE_FINISH

;--------------------------------
;Languages

  !insertmacro MUI_LANGUAGE "English"

;--------------------------------
;Verify User is Admin or not

  !macro VerifyUserIsAdmin
  UserInfo::GetAccountType
  pop $0
  ${If} $0 != "admin" ;Require admin rights on NT4+
	messageBox mb_iconstop "Administrator rights required!"
	setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
	quit
  ${EndIf}
  !macroend

;--------------------------------
;Installer section

Section "install"
  # Files for install directory - to build the installer, these should be in the same directory as the install script (this file)
  SetOutPath $INSTDIR

  ################################################################################################################
  #Create required Directories in Install Location
  CreateDirectory "$INSTDIR\sample folder"
  
  #Add your Files Here
  # Files add here should be removed by the uninstaller (see section "uninstall")
  file "${APP_NAME_IN_INSTALLED_DIR}.exe"
  file "logo.ico"
  
  ;File in sample folder
  SetOutPath "$INSTDIR\sample folder"
  file "sample folder\sample file.txt"
  
  ################################################################################################################

  # Uninstaller - see function un.onInit and section "uninstall" for configuration
  writeUninstaller "$INSTDIR\uninstall.exe"

  SetOutPath $INSTDIR
  # Start Menu
  CreateDirectory "$SMPROGRAMS\${APPNAME}"
  CreateShortCut "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk" "$INSTDIR\${APP_NAME_IN_INSTALLED_DIR}.exe" "" "$INSTDIR\logo.ico"
  CreateShortCut "$SMPROGRAMS\${APPNAME}\uninstall.lnk" "$INSTDIR\uninstall.exe" "" ""
  
  # Desktop Shortcut
  CreateShortCut "$DESKTOP\${APPNAME}.lnk" "$INSTDIR\${APP_NAME_IN_INSTALLED_DIR}.exe" "" "$INSTDIR\logo.ico"

  # Registry information for add/remove programs
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME} - ${DESCRIPTION}"
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "QuitUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayIcon" "$\"$INSTDIR\logo.ico$\""
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "Publisher" "$\"${COMPANYNAME}$\""
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "HelpLink" "$\"${HELPURL}$\""
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLUpdateInfo" "$\"${UPDATEURL}$\""
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "URLInfoAbout" "$\"${ABOUTURL}$\""
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayVersion" "$\"${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}.${BUILDNUMBER}$\""
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMajor" ${VERSIONMAJOR}
  WriteRegStr HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "VersionMinor" ${VERSIONMINOR}
  # There is no option for modifying or reparing the install
  WriteRegDWORD HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoModify" 1
  WriteRegDWORD HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "NoRepair" 1
  # Set the INSTALLSIZE constant (!define at the top of this script) so Add/Remove Program can accurately report the size
  WriteRegDWORD HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}" "EstimatedSize" ${INSTALLSIZE}
SectionEnd

;--------------------------------
;Version Information

  VIProductVersion "${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}.${BUILDNUMBER}"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "${APPNAME}"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "${DESCRIPTION}"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "${COMPANYNAME}"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "${APPNAME} is a trademark of ${COMPANYNAME}"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "${DEVELOPER} | ${COMPANYNAME}"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "${APPNAME}"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}"
  VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductVersion" "${VERSIONMAJOR}.${VERSIONMINOR}.${VERSIONBUILD}.${BUILDNUMBER}"

;--------------------------------
;Verify Unintall

  function un.onInit		
	# Verify the uninstaller - last chance to back out
	MessageBox MB_OKCANCEL "Permanantly remove ${APPNAME}?" IDOK next
		Abort
	next:
	!insertmacro VerifyUserIsAdmin
  functionEnd
  
;--------------------------------
;Uninstaller Section

Section "uninstall"
  #Remove Start Menu Launcher
  delete "$SMPROGRAMS\${APPNAME}\${APPNAME}.lnk"
  delete "$SMPROGRAMS\${APPNAME}\uninstall.lnk"
  #Remove Desktop Shortcut
  delete "$DESKTOP\${APPNAME}.lnk"
  #Try to remove the Start Menu folder - this will only happen if it is empty
  rmDir "$SMPROGRAMS\${APPNAME}"

  ################################################################################################################
  #Remove files
  delete $INSTDIR\${APP_NAME_IN_INSTALLED_DIR}.exe
  delete $INSTDIR\logo.ico
  
  #removeing files from sample folder
  delete "$INSTDIR\sample folder\sample file.txt"
  
  #Remove Directories created in Install Location
  rmDir "$INSTDIR\sample folder"
  
  ################################################################################################################
	
  # ALways delete uninstaller as the last section
  delete $INSTDIR\uninstall.exe

  # Try to remove the install directory - this will only happen if it is empty
  rmDir $INSTDIR

  #Delete installation folder from registry if available - this will only happen if it is empty
  DeleteRegKey /ifempty HKCU "Software\${APPNAME}"

  # Remove uninstaller information from the registry
  DeleteRegKey HKLM "Software\Microstft\Windows\CurrentVersion\Uninstall\${APPNAME}"
SectionEnd

;--------------------------------
