# Beavero
Beavero is simple Ruby tasker programmed for webdevelopment.

It is based on idea, that - practically - every file in app has its unique name.
Therefore whole app can be compiled to one, flat folder.
Moreover it enforces app structure, preprocessors (for now), and file types.
So, it is: *convention over configuration*.

## Preprocessors
Here are listed prepocessors used by Beaver-o:
- HTML: Slim (http://slim-lang.com)
- CSS: SASS (http://sass-lang.com)
- JS: Uglifier (https://github.com/lautis/uglifier [Uglifier Ruby version])
- Images: [currently no processor chosen - propably TinyJPG/TinyPNG]

## App tree
The most important part here: the app tree.
Everything in *assets* is processed, everything in *static* is copied without touching,
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

## TODO
- Uglifier module
- Slim module
