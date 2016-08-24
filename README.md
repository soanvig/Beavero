# Beavero
Beavero is simple Ruby tasker programmed for webdevelopment.

It is based on idea, that - practically - every file in app has its unique name.
Therefore whole app can be compiled to one, flat folder.
Moreover it enforces app structure, preprocessors (for now), and file types.
So, it is: *convention over configuration* (however a lot of things [like paths], can be configured via config file).

**This is pre-release version** (more information at https://github.com/soanvig/Beavero/releases).

## Preprocessors
Here are listed prepocessors used by Beaver-o:
- HTML: Slim (http://slim-lang.com)
- CSS: SASS (http://sass-lang.com)
- JS: Uglifier (https://github.com/lautis/uglifier [Uglifier Ruby version])
- Images: [currently no processor chosen - propably TinyJPG/TinyPNG]

## App tree
The most important part here: the app tree.
For default configuration: everything in *assets* is processed, everything in *static* is copied without touching,
and everything in *vendor* is treated as outside code, so copied without touching.

- assets
  - scss
    - _\*.scss
    - \*.scss
  - js
    - \*.js
  - slim
    - \*.slim
  - fonts
    - \*.woff
  - images
    - \*.jpg
    - \*.png
- vendor
  - plugin Name
    - \*.js
    - \*.css
- static
- public

## Modules

### Static
*Static* module is made for files, which should not be touched by Beavero,
therefore they are just copied to output directory.

### Vendor
*Vendor* module is made for plugins which you want to have in your application.
Everything in module's directory is just copied to output directory
(because third-party tools should not be touched).

### Sass
*Sass*  module is made for preprocessing CSS code.
Visit [SASS webpage](http://sass-lang.com/) for syntax details.
By default module search for `main_file` (see [Configuration](#configuration) section),
and compiles this file to *one* file in output directory.
If you want to split your CSS into number of files, you should use `@import` directive.
Imported files will be included by SASS in your output CSS file.

### Uglifier
*Uglifier* module is made for minimizing JS code.
The module search for all **.js** files in module's directory.
After collecting list of files, each of file is compressed using `uglifier` gem,
and saved in output directory with the same name but with *.min.js* suffix.

Uglifier module can be set in *combine* mode, which causes all files to be minified and combined into one file.
However, you should be careful, because **file combining order is not guranteed**. If your code depends on including order it can cause problems.

## TODO
- Slim module
- README "advices" section
