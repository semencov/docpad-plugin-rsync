# Simple Rsync Deployer Plugin for [DocPad](http://docpad.org)

<!-- BADGES/ -->

[![Build Status](https://img.shields.io/travis/semencov/docpad-plugin-rsync/master.svg)](http://travis-ci.org/semencov/docpad-plugin-rsync "Check this project's build status on TravisCI")
[![NPM version](https://img.shields.io/npm/v/docpad-plugin-rsync.svg)](https://npmjs.org/package/docpad-plugin-rsync "View this project on NPM")
[![NPM downloads](https://img.shields.io/npm/dm/docpad-plugin-rsync.svg)](https://npmjs.org/package/docpad-plugin-rsync "View this project on NPM")
[![Dependency Status](https://img.shields.io/david/semencov/docpad-plugin-rsync.svg)](https://david-dm.org/semencov/docpad-plugin-rsync)
[![Dev Dependency Status](https://img.shields.io/david/dev/semencov/docpad-plugin-rsync.svg)](https://david-dm.org/semencov/docpad-plugin-rsync#info=devDependencies)<br/>


<!-- /BADGES -->


Deploy to remotes via `docpad deploy-rsync` using rsync. Inspired by the [GitHub Pages Deployer Plugin for DocPad](http://docpad.org/plugin/ghpages) by [Bevry](https://bevry.me/) and [Docpad rsync Deploy Script](https://gist.github.com/Hypercubed/5804999) by [Jayson Harshbarger](http://hypercubed.com/).


## Install

```
docpad install rsync
```


## Usage


Inside your [docpad configuration file](http://docpad.org/docs/config) add this:

``` coffee
plugins:
  rsync:
    host: 'example.com'       # target host
    path: '/var/www/htdocs'   # target path
    user: 'deployer'          # target username (optional)
```

Now when you run `docpad deploy-rsync --env static`, the generated `out` directory will be pushed up to your target using rsync.

If you are using multiple environments to generate different sites in one project (like [this](https://github.com/sapegin/blog.sapegin.me)), you can specify different settings for each environment:

``` coffee
plugins:
  rsync:
    host: 'example.com'
    user: 'deployer'
    environments:
      en:
        path: '/var/www/htdocs_en'
      ru:
        path: '/var/www/htdocs_ru'
```

Also you can add `dryrun: true` in your config to test if all settings are ok.

``` coffee
plugins:
  dryrun: true
  rsync:
    host: 'example.com'
    path: '/var/www/htdocs'
```

<!-- LICENSE/ -->

## License

Unless stated otherwise all works are:

- Copyright &copy; 2015 Yuri Sementsov <hello@semencov.com> (https://github.com/semencov)

and licensed under:

- The incredibly [permissive](http://en.wikipedia.org/wiki/Permissive_free_software_licence) [MIT License](http://opensource.org/licenses/mit-license.php)

<!-- /LICENSE -->


