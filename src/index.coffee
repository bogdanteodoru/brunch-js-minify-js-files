{spawn, exec} = require 'child_process'
fs = require "fs"
path = require "path"
sysPath = require 'path'
uglify = require 'uglify-js'
exists = fs.exists or path.exists

module.exports = class minifyJsFiles
  brunchPlugin: yes
  active: yes
  appPath: '/'
  constructor: (@config) ->
    @active = @config.minifyJsFiles.active if @config.minifyJsFiles?.active
    @appPath = sysPath.join @config.paths.public, @appPath

  onCompile: (generatedFiles) ->
    return unless fs.existsSync(@appPath)
    files = @readDirSync(@imagePath)
    @optimize(files)

  optimize: (data, path, callback) ->
    options = @options

    try
      optimized = uglify.minify(data, options)
    catch err
      error = "JS minify failed on #{path}: #{err}"
    finally
      result = optimized.code
      console.log "The force is strong in this one. All files are minified."

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

    readdirSyncRecursive(baseDir).forEach((filepath) =>
      fileList.push(filepath) if !!~@js.indexOf(path.extname(filepath).toLowerCase())
    )

    return fileList