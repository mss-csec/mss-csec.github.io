#!/usr/bin/env nodejs

/**
 * Pre-build processing script for assets (SCSS/CoffeeScript)
 */

const fs = require('fs'),
      glob = require('globby'),
      postcss = require('postcss'),
      sass = require('node-sass'),
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
const jspath = 'assets/js';

// Files to *not* process
const blacklist = [
  'lib/lato/import.css',
  'lib/pygments-manni.css',
  'lib/pygments-native.css'
];

// Extract Jekyll-style headers from mixed content
const extractHeader = (content) => {
  let header = [ '---' ]

  if (content instanceof Buffer) content = content.toString();

  if (content.startsWith('---')) {
    let splitSrc = content.split('\n'),
        headerBuilder = [],
        line = 1; // offset by 1 for ending delim
    for (; line < splitSrc.length; line++) {
      if (splitSrc[line].startsWith('---')) {
        line++;
        break;
      }
      headerBuilder.push(splitSrc[line]);
    }

    header = header.concat(headerBuilder);
    content = splitSrc.slice(line).join('\n');
  }

  header.push('---');
  header.push('\n');

  return { content, header: header.join('\n') };
};

// First, copy assets dir recursively
const { execSync } = require('child_process');

if (fs.existsSync('assets')) execSync('rm -r assets');

execSync('cp -r _assets assets');

// Process SCSS by inserting variables
glob([ 'assets/**/*.scss' ])
  .then(async function(files) {
    // Compile SCSS
    // We need to get the paths for the compiled files, but this promise can't
    // be resolved until all the files are compiled, hence async/await
    const resolvePath = require('path').resolve;

    let filePromises = files.map(file => new Promise((resolve, reject) => {
      if (~blacklist.indexOf(file.split('/').slice(-2).join('/')) ||
          /_[^/]+\.scss$/.test(file))
        return resolve({ css: '', file, header: '---\n---\n\n' });

      let newFile = file.replace('.scss', '.css');
      fs.readFile(file, (err, data) => {
        if (err) reject(err);

        let { content, header } = extractHeader(data);

        sass.render({
          data: content,
          includePaths: [ resolvePath(__dirname, '../assets/css/') ],
          outputStyle: isProduction ? 'compressed' : 'expanded'
        }, (err, css) => {
          if (err) {
            console.error(err.file);
            console.error(`Line ${err.line} column ${err.column}`);
            console.error(err.message);
            reject(err.status);
          }

          // Delete source CS file
          fs.unlink(file, err => { if (err) reject(err) });

          resolve({
            css: css.css.toString(),
            file: newFile,
            header
          });
        });
      });
    }));

    return await Promise.all(filePromises);
  })
  .then(files => {
    let acceptedFiles = [];

    for (let file of files) {
      if (!/_[^\/]+\.scss$/.test(file.file)) {
        acceptedFiles.push(file);
      } else {
        fs.unlinkSync(file.file);
      }
    }

    return acceptedFiles;
  })
  .then(compiledFiles => {
    for (let { css, file, header } of compiledFiles) {
      if (~blacklist.indexOf(file.split('/').slice(-2).join('/'))) continue;

      // Apply autoprefixer and extract any declarations with variables
      postcss([ autoprfxr, extrStyles ])
        .process(css)
        .then(res => {

          // Run the layout CSS through the colour functions plugin, in case
          // those are used
          postcss([ clrFcns ])
            .process(res.css)
            .then(res => {
              fs.writeFile(file, header + res.css.trimLeft(), err => { if (err) throw err });
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
                fs.writeFile(path, header + res.css.trimLeft(), err => { if (err) throw err });
              });
          }
        });
    }
  }, err => console.error('Error in processing CSS: ', err.message));

// Compile CoffeeScript, Browserify it, and minify (in prod)
glob([ 'assets/**/*.coffee' ])
  .then(async function(files) {
    // Compile CoffeeScript
    // We need to get the paths for the compiled files, but this promise can't
    // be resolved until all the files are compiled, hence async/await
    let filePromises = files.map(file => new Promise((resolve, reject) => {
      let newFile = file.replace('.coffee', '.js');
      fs.readFile(file, (err, data) => {
        if (err) throw err;
        if (~blacklist.indexOf(file.split('/').slice(-2).join('/')))
          return resolve({ file, header: '---\n---\n\n' });

        let { content, header } = extractHeader(data);

        let compiled = coffee.compile(content, {
          bare: true
        });

        fs.writeFile(newFile, compiled, err => {
          if (err) reject(err);

          // Delete source CS file
          fs.unlink(file, err => { if (err) reject(err) });

          resolve({ file: newFile, header });
        });
      });
    }));

    return await Promise.all(filePromises);
  })
  .then(async function(files) {
    // Browserify only files in jspath
    let needsBundling = [],
        regularFiles = [],
        browserifyOptions = {};

    for (let file of files) {
      if (/assets\/js\/[^/]+\.js$/.test(file.file)) {
        needsBundling.push(file);
      } else {
        regularFiles.push(file);
      }
    }

    if (!isProduction) browserifyOptions.debug = true;

    // same as async/await above
    let bundlePromises = needsBundling.map(({ file, header }) => new Promise((resolve, reject) => {
      browserify(file, browserifyOptions)
        .bundle((err, buf) => {
          if (err) reject(err);

          if (isProduction) {
            let uglified = uglify.minify(buf.toString());

            if (uglified.error) { console.error(file); reject(uglified.error); }
            if (uglified.warnings) console.warn(uglified.warnings);

            buf = uglified.code;
          }

          fs.writeFile(file, header + buf.toString(), err => {
            if (err) reject(err);
            resolve();
          });
        });
    }));

    await Promise.all(bundlePromises);
    return regularFiles;
  })
  .then(files => {
    // Remove extraneous files
    let acceptedFiles = [],
        rmDirs = new Set();

    for (let file of files) {
      // Anything in a subdirectory of jspath is extraneous, so we delete it
      // and then remove the subdir (1)
      if (!/assets\/js\/\w+\//.test(file.file)) {
        acceptedFiles.push(file);
      } else {
        fs.unlinkSync(file.file);
        rmDirs.add(file.file.match(/assets\/js\/(\w+\/)/)[1]);
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
    for (let { file, header } of files) {
      fs.readFile(file, (err, js) => {
        if (isProduction) {
          if (err) throw err;

          let uglified = uglify.minify(js.toString());

          if (uglified.error) { console.error(file); throw uglified.error; }
          if (uglified.warnings) console.warn(uglified.warnings);

          js = uglified.code;
        }

        fs.writeFile(file, header + js.toString(), err => { if (err) throw err });
      });
    }
  }, err => console.error('Error in processing CoffeeScript: ', err.message));
