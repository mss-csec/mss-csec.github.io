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
      cssnano = require('cssnano'),
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

// Delete Jekyll-style headers from mixed content
const deleteHeader = (content) => {
  if (content instanceof Buffer) content = content.toString();

  if (content.startsWith('---')) {
    let splitSrc = content.split('\n'),
        line = 1; // offset by 1 for ending delim
    for (; line < splitSrc.length; line++) {
      if (splitSrc[line].startsWith('---')) {
        line++;
        break;
      }
    }

    content = splitSrc.slice(line).join('\n');
  }

  return content;
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
        return resolve({ css: '', file });

      let newFile = file.replace('.scss', '.css');
      fs.readFile(file, (err, data) => {
        if (err) reject(err);

        let content = deleteHeader(data);

        sass.render({
          data: content,
          includePaths: [ resolvePath(__dirname, '../assets/css/') ],
          outputStyle: 'expanded'
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
            file: newFile
          });
        });
      });
    }));

    return await Promise.all(filePromises);
  }, err => console.error('Error in compiling SCSS: ', err.message))
  .then(files => {
    let acceptedFiles = [];

    for (let file of files) {
      if (!~blacklist.indexOf(file.file.split('/').slice(-2).join('/')) &&
          !/_[^\/]+\.scss$/.test(file.file)) {
        acceptedFiles.push(file);
      } else if (/_[^\/]+\.scss$/.test(file.file)) {
        fs.unlinkSync(file.file);
      }
    }

    return acceptedFiles;
  }, err => console.error('Error in filtering CSS: ', err.message))
  .then(async function(compiledFiles) {
    // Apply autoprefixer and extract any declarations with variables
    let postCssPromises = compiledFiles.map(({ css, file }) => new Promise(resolve => {
      postcss([ autoprfxr, extrStyles ])
        .process(css)
        .then(({ css, extracted }) => { resolve({ css, extracted, file }) });
    }));

    return await Promise.all(postCssPromises);
  }, err => console.error('Error in autoprefixing/extracting CSS: ', err.message))
  .then(extractedFiles => {
    let themedFiles = [];

    for (let { extracted, file } of extractedFiles) {
      // Iterate through themes for each CSS source
      for (let i = 0, theme; i < themes.length, theme = themes[i]; i++) {

        // Replace conditionals/variables
        let css = extracted.replace(/\$(\[[^\]]+\])/g, (_, rules) => {
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

        themedFiles.push({ css, file: file.replace('.css', `-${theme}.css`) });
      }
    }

    return extractedFiles.concat(themedFiles);
  }, err => console.error('Error in theming CSS: ', err.message))
  .then(async function(compiledFiles) {
    // Run the CSSes through the colour functions plugin
    let postCssPromises = compiledFiles.map(({ css, file }) => new Promise(resolve => {
      postcss([ clrFcns ])
        .process(css)
        .then(({ css }) => { resolve({ css, file }) });
    }));

    return await Promise.all(postCssPromises);
  }, err => console.error('Error in parsing colour functions in CSS: ', err.message))
  .then(async function(compiledFiles) {
    // Minify CSS in production mode
    if (isProduction) {
      let postCssPromises = compiledFiles.map(({ css, file }) => new Promise(resolve => {
        postcss([ cssnano ])
          .process(css)
          .then(({ css }) => {
            fs.writeFile(file, css, err => { if (err) throw err });
            resolve();
          });
      }));

      await Promise.all(postCssPromises);
    }

    console.log('Finished processing SCSS');
  }, err => console.error('Error in minifying CSS: ', err.message));

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
          return resolve(file);

        let content = deleteHeader(data);

        let compiled = coffee.compile(content, {
          bare: true
        });

        fs.writeFile(newFile, compiled, err => {
          if (err) reject(err);

          // Delete source CS file
          fs.unlink(file, err => { if (err) reject(err) });

          resolve(newFile);
        });
      });
    }));

    return await Promise.all(filePromises);
  })
  .then(async function(files) {
    // Browserify only files in jspath
    let needsBundling = [],
        browserifyOptions = {};

    for (let file of files) {
      if (/assets\/js\/[^/]+\.js$/.test(file)) {
        needsBundling.push(file);
      }
    }

    if (!isProduction) browserifyOptions.debug = true;

    // same as async/await above
    let bundlePromises = needsBundling.map((file) => new Promise((resolve, reject) => {
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
      if (!/assets\/js\/\w+\//.test(file)) {
        acceptedFiles.push(file);
      } else {
        fs.unlinkSync(file);
        rmDirs.add(file.match(/assets\/js\/(\w+\/)/)[1]);
      }
    }

    // (1)
    for (let dir of rmDirs) {
      fs.rmdir(`${jspath}/${dir}`, err => { if (err) throw err });
    }

    return acceptedFiles;
  })
  .then(async function(files) {
    // Minify in production mode
    if (isProduction) {
      let filePromises = files.map(file => new Promise(resolve => {
        fs.readFile(file, (err, js) => {
          if (err) reject(err);

          let uglified = uglify.minify(js.toString());

          if (uglified.error) { console.error(file); reject(uglified.error); }
          if (uglified.warnings) console.warn(uglified.warnings);

          js = uglified.code;

          fs.writeFile(file, js, err => {
            if (err) reject(err);
            resolve();
          });
        });
      }));

      await Promise.all(filePromises);
    }

    console.log('Finished processing CoffeeScript');
  }, err => console.error('Error in processing CoffeeScript: ', err.message));
