{CompositeDisposable} = require 'atom'

module.exports = MemoTool =
  subscriptions: null

  activate: (state) ->
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    @subscriptions.add atom.commands.add 'atom-workspace', 'memo-tool:today': => @openToday()

  deactivate: ->
    @subscriptions.dispose()

  openToday: ->
    console.log 'file open'

    path = require 'path'
    dirPath = atom.config.get("memo-tool.path")
    filename = @createFilename()
    filePath = path.join dirPath, filename

    atom.project.addPath(dirPath) if not atom.project.contains(dirPath)
    @createNewFile(filePath)
    atom.open({
            pathsToOpen: filePath
            newWindow: false
            devmode: false
            safeMode: false
    })
    console.log "== open file: " + filePath

  createFilename: ->
    console.log "== createFilename"
    date = new Date()
    filename = date.getFullYear() +
               ("0" + (date.getMonth()+1)).slice(-2) +
               ("0" + date.getDate()).slice(-2) +
               ".md"
    console.log filename
    filename

  createNewFile: (filePath) ->
    fs = require 'fs'
    fs.access filePath,
      (err) ->
        if !err
          console.log "exists: " + filePath
          return

        console.log "create: " + filePath
        fs.open filePath, "a+",
          (err, fd) ->
            if err
              throw err
