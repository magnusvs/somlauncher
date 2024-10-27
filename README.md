# xLauncher

### Build notes
After adjusting the app icon dynamically (setIcon on macOS) the build might fail, beacuse of "resource fork"

* Run command below in the project folder
  ```
  find . -type f -name '*.jpeg' -exec xattr -c {} \;
  find . -type f -name '*.jpg' -exec xattr -c {} \;
  find . -type f -name '*.png' -exec xattr -c {} \;
  find . -type f -name '*.json' -exec xattr -c {} \;
  ```
* Press Cmd+Option+Shift+K in Xcode to clean the build
* Run Cmd+R to run the app again and it should work (Until setting the icon again)
