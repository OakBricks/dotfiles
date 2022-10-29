# Arc theme for Qt
Arc theme for Qt 5 and Qt 6 using QSS

## Building
You need [qtsass](https://github.com/spyder-ide/qtsass) and the Qt fusion theme applied

```sh
git clone ...
cd ./arc-qss
python3 ./build.py
```
There should be two files named `dark.css` and `light.css`, these are Qt-compliant stylesheets that can be applied either per-application or system-wide using something like `qt5ct`