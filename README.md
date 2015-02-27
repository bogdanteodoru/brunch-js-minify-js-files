brunch-js-minify-js-files
=========================

Minify all JavaScript files after brunch compile has been done. Build to help minify files that brunch doesn't minify them or are not in the regular JavaScript folders (For example: files that are in the assets folder that you don't concatenate).

**Install**
Add the plugin to `package.json`:
```javascript
dependencies": {
  ...
  "brunch-js-minify-js-files": "git://github.com/bogdanteodoru/brunch-js-minify-js-files.git"
}
```

**Config**
Just add the folowing into your `config.coffee`/`brunch-config.coffee` file:

```coffeescript
minifyJsFiles:
  active: true # if false it doesn't do anything ;)
  fileExtensions: [".js", ".json"] # optional: when not specified, ".js" is used.
  options: {} # optional: when not specified {mangle:false, compress:true} is used.
```

**Preserving comments**
Use minifyJsFiles.options.output.comments to control how comments are minified. You can pass one of the following values:
- "all" to keep all comments
- a valid JS regexp to keep only comments that match.
Note that currently not *all* comments can be kept when compression is on, because of dead code removal or cascading statements into sequences.

```coffeescript
minifyJsFiles:
  options:
    output:
      comments: /@license|@preserve|^!/
```