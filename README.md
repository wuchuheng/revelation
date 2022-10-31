[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://badgen.net/badge/license/MIT/blue)
<a href="https://github.com/wuchuheng/revelation/actions/workflows/release.yml"><img src="https://github.com/wuchuheng/revelation/actions/workflows/release.yml/badge.svg" alt="Build Status"></a>
<a href="https://github.com/wuchuheng/revelation/actions/workflows/dev.yml"><img src="https://github.com/wuchuheng/revelation/actions/workflows/dev.yml/badge.svg" alt="Build Status"></a>
<a href="https://github.com/wuchuheng/revelation"><img src="https://badgen.net/pub/flutter-platform/xml" alt="Build Status"></a>



# 1开发相关说明

## 1.1 添加图标

在[`iconfont`](https://www.iconfont.cn),选择好图标后，以`unicode`方式下载，并解压，并把其中的 `iconfont.css` 和 `iconfont.ttf`
置于`assets/fonts/`目录下。 

最后在项目目录下执行`flutter pub run iconfont_css_to_class:main`, 则图标的数据将生成在`lib/common/`目录下。 使用里面的数据
就可以使用对应的图标了。 

## 1.2 启动图标更换
### 1.2.1 修改 `ios` `android` `windows`启动图标
更换`assets/images/1024.png`文件后， 执行`flutter pub run flutter_launcher_icons:main`


### 1.2.2 修改 `macos` 启动图标
`macos/Runner/Assets.xcassets/AppIcon.appiconset`图标在这里进行更换，
如果没有相关的格式的工具，可以借助[appicon](https://appicon.co/) 来生成相关大小格式的图片.


## 2 发布

## 3 FQA

### 3.1 Failed to load dynamic library 'sqlite3.dll': error code 126
在`windows`下， 构建时缺少`sqlite3.dll`文件，而引发的问题。下载[sqlite](https://raw.githubusercontent.com/tekartik/sqflite/master/sqflite_common_ffi/lib/src/windows/sqlite3.dll)
后，放在`build/windows/runner/Debug`和`build/windows/runner/Release`就可以了。


    