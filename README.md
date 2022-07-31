# 1开发相关说明

## 1.1 添加图标

在[`iconfont`](https://www.iconfont.cn),选择好图标后，以`unicode`方式下载，并解压，并把其中的 `iconfont.css` 和 `iconfont.ttf`
置于`assets/fonts/`目录下。 

最后在项目目录下执行`flutter pub run iconfont_css_to_class:main`, 则图标的数据将生成在`lib/common/`目录下。 使用里面的数据
就可以使用对应的图标了。 
