{CompositeDisposable} = require 'atom'

module.exports = recallFileEncConf =
  subscriptions: null
  recallFileEncConf: {}

  handleEncRestore: () ->
    editor = atom.workspace.getActiveTextEditor()
    if editor
      uri = editor.getURI()
      if @recallFileEncConf[uri]?
        editor.setEncoding(@recallFileEncConf[uri])

  handleEncSave: () ->
    editor = atom.workspace.getActiveTextEditor()
    if editor
      uri = editor.getURI()
      @recallFileEncConf[uri]=editor.getEncoding()

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @recallFileEncConf = state.recallFileEncConfState ? {}

    @subscriptions.add atom.workspace.observeTextEditors (editor) =>
      @subscriptions.add editor.onDidSave () =>
        @handleEncSave()
      @subscriptions.add editor.onDidChangeEncoding () =>
        @handleEncSave()
      @subscriptions.add editor.onDidStopChanging () =>
        @handleEncRestore()

  deactivate: ->
    @subscriptions.dispose()

  serialize: ->
    {recallFileEncConfState: @recallFileEncConf}
