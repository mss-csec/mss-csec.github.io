#!/usr/bin/nodejs

const fs = require('fs'),
      glob = require('glob-fs')({ gitignore: true }),
      sass = require('node-sass'),
      postcss = require('postcss'),
      autoprfxr = require('autoprefixer'),
      extrStyles = require('postcss-extract-styles')({ pattern: /\$([a-zA-Z0-9]+|{[\s\S]+?})/g }),
      clrFcns = require('postcss-sass-color-functions'),
      uglify = require('uglify-js');

const variables = {
  theme:       [ 'light'  , 'dark'    ],

  brandColour: [ '#f52f2f', '#f52f2f' ],
  fgPrimary:   [ '#232323', '#ededed' ],
  fgSecondary: [ '#777'   , '#888'    ],
  fgAccent:    [ '#fff'   , '#fff'    ],
  bgPrimary:   [ '#fff'   , '#1a1f2a' ],
  bgSecondary: [ '#ededed', '#2c313c' ],
  bgTertiary:  [ `lighten(#ededed, 3%)`, `darken(#2c313c, 3%)` ],
  bgAccent:    [ '#f52f2f', '#f52f2f' ],
};

// alias
const themes = variables.theme;

glob.readdirStream('_site/assets/**/*.css')
  .on('data', (file) => {
    fs.readFile(file.path, (err, css) => {
      if (err) throw err;

      postcss([ autoprfxr, extrStyles ])
        .process(css)
        .then((res) => {
          fs.writeFile(file.path, res.css);

          for (let i = 0, theme; i < themes.length, theme = themes[i]; i++) {
            let path = file.path.replace('.css', `-${theme}.css`);

            let extracted = res.extracted.replace(/\$({[\s\S]+?})/g, (_, rules) => {
              rules = JSON.parse(rules);

              if (rules.hasOwnProperty(theme)) {
                return rules[theme];
              }
              return 'null';
            }).replace(/\$([a-zA-Z0-9])/, (_, ident) => variables.hasOwnProperty(ident) ? variables[ident][i] : _);

            console.log(extracted);

            postcss([ clrFcns ])
              .process(extracted)
              .then((res) => {
                fs.writeFile(path, res.css);
              });
          }

        });
    });
  })
  .on('error', console.error)
  .on('end', () => {
    console.log('');
  });


// glob.readdirStream('_site/assets/**/*.js')
//   .on('data', (file) => {
//     fs.readFile(file.path, (err, js) => {
//       if (err) throw err;

//       uglified = uglify.minify(js);

//       if (uglified.error) throw uglified.error;
//       if (uglified.warnings) console.warn(uglified.warnings);

//       fs.writeFile(file.path, uglified.code);
//     });
//   })
//   .on('error', console.error)
//   .on('end', () => {
//     console.log('');
//   });
