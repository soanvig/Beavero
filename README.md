# Beavero
[![Version v0.7.0](https://img.shields.io/badge/Version-v0.7.0-brightgreen.svg?style=flat)](https://github.com/soanvig/Beavero/releases)

Beavero is simple Ruby tasker programmed for webdevelopment.

It is based on idea, that - practically - every file in app has its unique name.
Therefore whole app can be compiled to one, flat folder.
Moreover it enforces app structure, preprocessors (for now), and file types.
So, it is: *convention over configuration* (however a lot of things [like paths], can be configured via [config file](#configuration)).

Beavero supports:
* HTML (Slim)
* CSS (SASS)
* JS (uglify)
* Images (compressing)
* Fonts (converting formats, automated generating @font-face rules)

**This is pre-release version** (more information at https://github.com/soanvig/Beavero/releases).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Preprocessors](#preprocessors)
- [Installation](#installation)
- [Usage](#usage)
- [App tree](#app-tree)
- [Modules](#modules)
  - [Static](#static)
  - [Vendor](#vendor)
  - [Sass](#sass)
  - [Uglifier](#uglifier)
  - [Images](#images)
  - [Fonts](#fonts)
  - [Slim](#slim)
- [Configuration](#configuration)
  - [Configuration table](#configuration-table)
    - [Basic](#basic)
    - [Static](#static-1)
    - [Vendor](#vendor-1)
    - [Sass](#sass-1)
    - [Uglifier](#uglifier-1)
    - [Images](#images-1)
    - [Fonts](#fonts-1)
    - [Slim](#slim-1)
- [Release plan](#release-plan)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Preprocessors
Here are listed prepocessors used by Beaver-o:
- HTML: Slim (http://slim-lang.com)
- CSS: SASS (http://sass-lang.com)
- JS: Uglifier (https://github.com/lautis/uglifier [Uglifier Ruby version])
- Images: (https://github.com/toy/image_optim)
- Fonts: [currently no processor chosen]

## Installation
Beavero is hosted by RubyGems, so just run:
`gem install beavero`
and you can start *beavering*.

## Usage
Wanna know how to use Beavero, huh?

Simply create [configuration file](#configuration), and run Ruby script: `Beavero.build`. Sorry, I couldn't make it simplier :(

Example usage of modules can be found in `tests/test_enviroment_configuration` directory, beacause this is a directory used for running tests.

## App tree
The most important part here: the app tree.
For default configuration: everything in *assets* is processed, everything in *static* is copied without touching,
and everything in *vendor* is treated as outside code, so copied without touching.

- assets
  - scss
    - _\*.scss|sass
    - \*.scss|sass
  - js
    - \*.js
  - slim
    - \*.slim
  - fonts
    - \*.woff
  - images
    - \*.jpg|png
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
By default module searches for `main_file` (see [Configuration/Sass](#sass-1) section),
and compiles this file to *one* file in output directory.
If you want to split your CSS (SASS) into number of files, you should use SASS `@import` directive.
Imported files will be included by SASS in your output CSS file.

### Uglifier
*Uglifier* module is made for minimizing JS code.
The module searches for all `.js` files in module's directory.
After collecting list of files, each of file is compressed using `uglifier` gem,
and saved in output directory with the same name but with *.min.js* suffix.

Uglifier module can be set in *combine* mode (see [Configuration/Uglifier](#uglifier-1) section), which causes all files to be minified and combined into one file.
However, you should be careful, because **file combining order is not guaranteed**. If your code depends on including order it can cause problems.

### Images
*Images* module is made for copying and compressing your graphic files.
It supports JPEG, PNG and GIF files. SVG files are supported too, however they are not compressed.

By default file compression is disabled (see [Configuration/Images](#images-1)), due to long execution time.
It is recommended to enable compression just before push to server, and have it disabled during development process.

### Fonts
*Fonts* module, for now, is made only for copying files to appropriate folder.
**In future** following features will be added:

* Converting fonts to number of formats
* Generating @font-face rules and including it in SASS

### Slim
*Slim* module is made for compiling Slim files.
The Slim itself lacks of few (important in my opinion) features:

* *layouts* - compiling content files into layout files, with layout name defined directly in content file (Jade/Pug has *extends*)
* *content_for* - in layouts mechanism `content_for` placed inside content file should enable creating blocks of parsed Slim code for layouts. I.e. it can be a title for `<title>` tag defined in layout - this way every subpage using the same layout can have different page titles!
* *include* - `include` allows to include (and eventually parse) other files. I.e. two of your content files shares the same code - it is the best practice to exclude this code to seperate file, and include the file in both content files!

*Slim* module contains every one of foregoing features.

## Configuration
Whole custom configuration is handled by one file: `beavero_config.json`, which is a JSON file.

Beavero doesn't require this file to exist - every module is prepared to work with its default configuration.
However you **must to** define modules you want to use. Otherwise no modules will be used.

Sample configuration file can look like this:
```json
{
  "modules": [
    "static",
    "vendor",
    "sass",
    "uglifier"
  ],
  "sass": {
    "style": "nested",
    "main_file": "app.scss",
    "output": "style"
  },
  "paths": {
    "sass": "./assets/style",
    "output": "./output"
  }
}
```

### Configuration table

#### Basic

Key | Values | Default | Description
--- | ------ | ------- | -----------
modules | ["static", "vendor", "sass", "uglifier"] | None | Modules which should be used by Beavero
paths/app | String | Beavero's script execution path | Beavero's working directory (system absolute path)
paths/output | String | `./public/` | Output of Beavero's building
logger/level | String | `info` | Level of Beavero logger. See [Rubydoc/Logger](https://ruby-doc.org/stdlib-2.1.0/libdoc/logger/rdoc/Logger.html) page for more information about levels

#### Static

Key | Values | Default | Description
--- | ------ | ------- | -----------
paths/static | String | `./static/` | Path of directory with static files

#### Vendor

Key | Values | Default | Description
--- | ------ | ------- | -----------
paths/vendor | String | `./vendor/` | Path of directory with vendor files

#### Sass

Key | Values | Default | Description
--- | ------ | ------- | -----------
paths/sass | String | `./assets/scss/` | Path of directory with SASS files
sass/syntax | ["scss", "sass"] | Determined by `main_file` extension | Syntax used by SASS to compile files. See [SASS Indented Synax](http://sass-lang.com/documentation/file.INDENTED_SYNTAX.html) (*sass* syntax) for more details.
sass/style | ["nested", "expanded", "compact", "compressed"] | `compressed` | SASS output style. See more on [SASS documentation](http://sass-lang.com/documentation/file.SASS_REFERENCE.html#output_style)
sass/output | String | Determined by `main_file` filename | Name of output CSS file
sass/output_ext | String | `.min.css` | Extension of output file
sass/main_file | String | `main.scss` | Name of SASS file which will be looked for in module's directory by Beavero. This is the starting point for all CSS/SASS directives

#### Uglifier

Key | Values | Default | Description
--- | ------ | ------- | -----------
paths/js | String | `./assets/js/` | Path of directory with JS files
js/combine | Boolean | `false` | Determines whether JS files should be compiled into one file or not
js/combine_name | String | `app` | If *js/combine* is set to true, then *js/combine_name* determines the name of combined file

#### Images

Key | Values | Default | Description
--- | ------ | ------- | -----------
paths/images | String | `./assets/images/` | Path of directory with images
images/compress | Boolean | `false` | Determines wheter module should compress files or not

#### Fonts

Key | Values | Default | Description
--- | ------ | ------- | -----------
paths/fonts | String | `./assets/fonts/` | Path of directory with fonts

#### Slim

Key | Values | Default | Description
--- | ------ | ------- | -----------
paths/slim | String | `./assets/slim/` | Path of directory with all slim files
paths/slim_layouts | String | `./assets/slim/layouts/` | Path of directory with layouts files
paths/slim_includes | String | `./assets/slim/partials/` | Path of directory with partials files (directory in which Slim module will search for files called by `include`)

## Release plan
https://github.com/soanvig/Beavero/releases

Release plan below is updated systematically

- [x] v0.1.0 Beavero class, Static and Vendor support
- [x] v0.2.0 Modules
- [x] v0.2.1 Configuration file
- [x] v0.2.2 Logger
- [x] v0.2.3 Logger colors, modules configuration
- [x] v0.3.0 Sass module
- [x] v0.4.0 Uglifier module
- [x] v0.4.1 Add logs to everything
- [x] v0.5.0 Images module
- [x] v0.6.0 Fonts module
- [x] v0.7.0 Slim module
- [ ] v0.7.1 Generating font face rules
- [ ] v0.7.2 Converting fonts
- [ ] v1.0.0 Beavero official release along with binary for command-line execution