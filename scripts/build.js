#!/usr/bin/nodejs

const fs = require('fs'),
      glob = require('glob-fs'),
      sass = require('node-sass'),
      postcss = require('postcss'),
      autoprfxr = require('autoprefixer'),
      extrStyles = require('postcss-extract-styles')({ pattern: /\$(\w+|\[[^\]]+\])/ }),
      clrFcns = require('postcss-sass-color-functions'),
      uglify = require('uglify-js'),
      isProduction = 'production' === process.argv[2];

const variables = {
  theme:       [ 'light'  , 'dark'    ],

  brandColour: [ '#f52f2f', '#f52f2f' ],
  fgPrimary:   [ '#232323', '#ededed' ],
  fgSecondary: [ '#777'   , '#888'    ],
  fgAccent:    [ '#fff'   , '#fff'    ],
  bgPrimary:   [ '#fff'   , '#1a1f2a' ],
  bgSecondary: [ '#ededed', '#2c313c' ],
  bgTertiary:  [ '#f5f5f5', '#262a33' ],
  bgAccent:    [ '#f52f2f', '#f52f2f' ],
}, themes = variables.theme; // alias

const blacklist = [
  'lib/pygments-manni.css',
  'lib/pygments-native.css',
  'lib/lunr.min.js'
];

glob().readdir('_site/assets/**/*.css', (err, files) => {
  if (err) throw err;

  files.forEach((file) => {
    file = '../' + file;

    fs.readFile(file, (err, css) => {
      if (err) throw err;
      if (~blacklist.indexOf(file.split('/').slice(-2).join('/'))) return;

      postcss([ autoprfxr, extrStyles ])
        .process(css)
        .then((res) => {
          fs.writeFile(file, res.css);

          for (let i = 0, theme; i < themes.length, theme = themes[i]; i++) {
            let path = file.replace('.css', `-${theme}.css`);

            let extracted = res.extracted.replace(/\$(\[[^\]]+\])/g, (_, rules) => {
              rules = JSON.parse('{' + rules.slice(1,-1).replace(/=>/g, ':') + '}');

              if (rules.hasOwnProperty(theme)) {
                return rules[theme];
              }
              return 'null';
            }).replace(/\$(\w+)/g, (_, ident) => variables.hasOwnProperty(ident) ? variables[ident][i] : _);

            postcss([ clrFcns ])
              .process(extracted)
              .then((res) => {
                fs.writeFile(path, res.css);
              });
          }

        });
    });
  });
});

if (isProduction) {
  glob().readdir('_site/assets/**/*.js', (err, files) => {
    if (err) throw err;

    files.forEach((file) => {
      file = '../' + file;

      fs.readFile(file, (err, js) => {
        if (err) throw err;
        if (~blacklist.indexOf(file.split('/').slice(-2).join('/'))) return;

        let uglified = uglify.minify(js.toString());

        if (uglified.error) { console.error(file); throw uglified.error; }
        if (uglified.warnings) console.warn(uglified.warnings);

        fs.writeFile(file, uglified.code);
      });
    });
  });
}
