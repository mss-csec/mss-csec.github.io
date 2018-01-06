# Lato

The bundled fonts provided are of Lato, version 2.0.15.
They have been retrieved and modified in the following manner:

1. Downloaded 300, 400, 400i, and 700 weights from [brick.im](https://github.com/alfredxing/brick/tree/5bf3fb975490a90757a38bfeffc9d3a322656b9d/_fonts/lato); these were the only versions that had the desired metrics
2. Conversion using `woff2sfnt` (available as `woff-tools` on apt) to OTF
3. Conversion using [FontSquirrel's Webfont Generator](https://www.fontsquirrel.com/tools/webfont-generator) to WOFF and WOFF2 files in `dist/`, using the settings specified in `generator_config.txt`
4. Compression of the WOFF files with [`woff-compress`](https://github.com/hn/woff-compress/tree/52150b7767500b63ac000edbfd7398bf5a5b91c6)

The original source files and associated build scripts are left in the `src/` folder for posterity.

Lato was created by Łukasz Dziedzic (http://www.latofonts.com) and is released under the SIL Open Font License 1.1; see LICENSE.txt for detailed terms.
