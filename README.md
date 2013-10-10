brunch-js-minify-js-files
=========================

Minify all JavaScript files after brunch compile has been done. Build to help minify files that brunch doesn't minify them or are not in the regular JavaScript folders (For example: files that are in the assets folder that you don't concatenate).

Just add the folowing into your config.coffee file

```coffeescript
minifyJsFiles:
  active: true #if false it doesn't do anything ;)
```
