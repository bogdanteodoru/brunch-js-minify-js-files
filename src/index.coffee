{spawn, exec} = require 'child_process'
fs = require "fs"
path = require "path"
sysPath = require 'path'
uglify = require 'uglify-js'
exists = fs.exists or path.exists

module.exports = class minifyJsFiles
  brunchPlugin: yes
  fileExtensions: "js"
  active: yes
  appPath: ''
  constructor: (@config) ->
    @active = @config.minifyJsFiles.active if @config.minifyJsFiles?.active
    @appPath = sysPath.join @config.paths.public, @appPath

  onCompile: (generatedFiles) ->
    return unless fs.existsSync(@appPath)
    files = @readDirSync(@appPath)
    @optimize(files)

  optimize: (data) ->
    options =
      mangle: false
      compress: true

    data.forEach (path) ->
      try
        optimized = uglify.minify(path, options)
        return console.log("Optimized file " + path)
      catch err
        error = "JS minify failed on " + path + ": " + err
        return console.log(error)

    console.log("Booze is the answer. I don't remember the question.")

  readDirSync: (baseDir) ->
    ## Mostly borrowed from npm wrench. thanks
    baseDir = baseDir.replace(/\/$/, "")
    fileList = []

    readdirSyncRecursive = (baseDir) ->
      files = []
      isDir = (fname) ->
        fs.statSync(sysPath.join(baseDir, fname)).isDirectory()
      prependBaseDir = (fname) ->
        sysPath.join baseDir, fname

      curFiles = fs.readdirSync(baseDir)
      nextDirs = curFiles.filter(isDir)
      curFiles = curFiles.map(prependBaseDir)
      files = files.concat(curFiles)
      files = files.concat(readdirSyncRecursive(sysPath.join(baseDir, nextDirs.shift())))  while nextDirs.length

      files

    filePaths = readdirSyncRecursive(baseDir)

    filePaths.forEach((filepath) =>
      fileList.push(filepath) if (!!~@fileExtensions.indexOf(path.extname(filepath).toLowerCase()) and (fs.statSync(filepath).isDirectory() is false) and (path.extname(filepath).toLowerCase() isnt ""))
    )

    return fileList