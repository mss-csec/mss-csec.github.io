#!/usr/bin/env nodejs

/**
 * Post-build processing script for assets (CSS/CoffeeScript)
 */

const fs = require('fs'),
      glob = require('globby'),
      postcss = require('postcss'),
      autoprfxr = require('autoprefixer'),
      extrStyles = require('postcss-extract-styles')({ pattern: /\$(\w+|\[[^\]]+\])/ }),
      clrFcns = require('postcss-sass-color-functions'),
      browserify = require('browserify'),
      coffee = require('coffee-script'),
      uglify = require('uglify-js'),
      isProduction = 'production' === process.argv[2];

// CSS colour variables
// Dynamically inserted for better user-facing performance
const variables = {
  theme:       [ 'light'  , 'dark'    ],

  brandColour:   '#f52f2f',
  fgPrimary:   [ '#232323', '#ededed' ],
  fgSecondary: [ '#777'   , '#888'    ],
  fgAccent:      '#fff'   ,
  bgPrimary:   [ '#fff'   , '#1a1f2a' ],
  bgSecondary: [ '#ededed', '#2c313c' ],
  bgTertiary:  [ '#f5f5f5', '#262a33' ],
  bgAccent:      '#f52f2f',

  error:         '#e70046',
  info:          '#3ac4ed',
  success:       '#1ec712',
  warning:       '#ffd30d',
}, themes = variables.theme; // alias

// Path for JS files
const jspath = '_site/assets/js';

// Files to *not* process
const blacklist = [
  'lib/pygments-manni.css',
  'lib/pygments-native.css'
];

// Process CSS by inserting variables
glob([ '_site/assets/**/*.css' ])
  .then(files => {
    for (let file of files) {
      fs.readFile(file, (err, css) => {
        if (err) throw err;
        if (~blacklist.indexOf(file.split('/').slice(-2).join('/'))) return;

        // Apply autoprefixer and extract any declarations with variables
        postcss([ autoprfxr, extrStyles ])
          .process(css)
          .then(res => {

            // Run the layout CSS through the colour functions plugin, in case
            // those are used
            postcss([ clrFcns ])
              .process(res.css)
              .then(res => {
                fs.writeFile(file, res.css, err => { if (err) throw err });
              });

            // Iterate through themes for each CSS source
            for (let i = 0, theme; i < themes.length, theme = themes[i]; i++) {
              let path = file.replace('.css', `-${theme}.css`);

              // Replace conditionals/variables
              let extracted = res.extracted.replace(/\$(\[[^\]]+\])/g, (_, rules) => {
                // Transform conditional statements into valid JSON
                rules = JSON.parse('{' + rules.slice(1,-1).replace(/=>/g, ':') + '}');

                if (rules.hasOwnProperty(theme)) {
                  return rules[theme];
                } else if (rules.hasOwnProperty('all')) {
                  // 'all' is placed as a fallback so that individual theme
                  // branches can overwrite it
                  return rules.all;
                }

                // it's an invalid value; could be shorted but I wouldn't take
                // the chance
                return 'null';
              }).replace(/\$(\w+)/g, (_, ident) => {
                // Replace variables with their values
                if (variables.hasOwnProperty(ident))
                  return Array.isArray(variables[ident]) ?
                    variables[ident][i] :
                    variables[ident];
                return _;
              });

              postcss([ clrFcns ])
                .process(extracted)
                .then(res => {
                  fs.writeFile(path, res.css, err => { if (err) throw err });
                });
            }
          });
      });
    }
  }, err => console.error('Error in processing CSS: ', err.message));

// Compile CoffeeScript, Browserify it, and minify (in prod)
glob([ '_site/assets/**/*.coffee' ])
  .then(async function(files) {
    // Compile CoffeeScript
    // We need to get the paths for the compiled files, but this promise can't
    // be resolved until all the files are compiled, hence async/await
    let filePromises = files.map(file => new Promise(resolve => {
      let newFile = file.replace('.coffee', '.js');
      fs.readFile(file, (err, js) => {
        if (err) throw err;
        if (~blacklist.indexOf(file.split('/').slice(-2).join('/')))
          return resolve(file);

        let compiled = coffee.compile(js.toString(), {
          bare: true
        });

        fs.writeFile(newFile, compiled, err => {
          if (err) throw err;
          resolve(newFile);
        });

        // Delete source CS file
        fs.unlink(file, err => { if (err) throw err });
      });
    }));

    return await Promise.all(filePromises);
  })
  .then(async function(files) {
    // Browserify only files in jspath
    let needsBundling = await glob([ `${jspath}/*.js` ]),
        browserifyOptions = {};

    if (!isProduction) browserifyOptions.debug = true;

    // same as async/await above
    let bundlePromises = needsBundling.map(file => new Promise((resolve, reject) => {
      browserify(file, browserifyOptions)
        .bundle((err, buf) => {
          if (err) reject(err);

          fs.writeFile(file, buf, err => {
            if (err) reject(err);
            resolve();
          });
        });
    }));

    await Promise.all(bundlePromises);
    return files;
  })
  .then(files => {
    // Remove extraneous files
    let acceptedFiles = [],
        rmDirs = new Set();

    for (let file of files) {
      // Anything in a subdirectory of jspath is extraneous, so we delete it
      // and then remove the subdir (1)
      if (!/_site\/assets\/js\/\w+\//.test(file)) {
        acceptedFiles.push(file);
      } else {
        fs.unlinkSync(file);
        rmDirs.add(file.match(/_site\/assets\/js\/(\w+\/)/)[1]);
      }
    }

    // (1)
    for (let dir of rmDirs) {
      fs.rmdir(`${jspath}/${dir}`, err => { if (err) throw err });
    }

    return acceptedFiles;
  })
  .then(files => {
    // Minify in production mode
    if (isProduction) {
      for (let file of files) {
        fs.readFile(file, (err, js) => {
          if (err) throw err;

          let uglified = uglify.minify(js.toString());

          if (uglified.error) { console.error(file); throw uglified.error; }
          if (uglified.warnings) console.warn(uglified.warnings);

          fs.writeFile(file, uglified.code, err => { if (err) throw err });
        });
      }
    }
  }, err => console.error('Error in processing CoffeeScript: ', err.message));

console.log('Finished post-build processing');
