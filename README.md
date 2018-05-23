# Appodeal GameMaker Extension Demo

# Extension integration

Please reffer to [this](https://github.com/appodeal/appodeal-gamemaker-plugin) doc.

# Running Demo

+ Android fully Configurated.
+ For iOS:
  * Download iOS SDK [here](https://www.appodeal.com/sdk)
  * Unzip SDK, zip `Appodeal.framework` into `Appodeal.framework.zip`, `Resources` into `Resources.zip`
  * Place bith zip's into [extensions/AppodealAds/](/extensions/AppodealAds/) -> make new folder `iOSSourcesFromMac`.
  * After Expotring iOS XCode project, create New Group in project tree, name it Resources, go to fw/Resources folder, select all the files there and drag'n'drop it under created Resources folder.
    * Go to the "Build Settings" of your target and modify "Other linker flags" option:
      * delete "-objC"
      * delete "-all_load" flag
      * check if "-ObjC" flag exists, add if not
    * Change deployment target to 8.1 or higher
