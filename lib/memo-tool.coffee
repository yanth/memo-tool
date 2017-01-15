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

    dirPath = "C:\\Users\\yanth\\Dropbox\\text\\memo\\"
    filename = @createFilename()
    filePath = dirPath + filename

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

    console.log "== open file: " + filePath
    atom.open({
            pathsToOpen: filePath
            newWindow: false
            devmode: false
            safeMode: false
    })

  createFilename: ->
    console.log "== createFilename"
    date = new Date()
    filename = date.getFullYear() +
               ("0" + date.getMonth()+1).slice(-2) +
               ("0" + date.getDate()).slice(-2) +
               ".md"
    console.log filename
    filename
