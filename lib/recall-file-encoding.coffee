{CompositeDisposable} = require 'atom'

module.exports = OrbitalConf =
  subscriptions: null
  orbitalConf: {}

  handleEncRestore: () ->
    editor = atom.workspace.getActiveTextEditor()
    if editor
      uri = editor.getURI()
      if @orbitalConf[uri]?
        editor.setEncoding(@orbitalConf[uri])

  handleEncSave: () ->
    editor = atom.workspace.getActiveTextEditor()
    uri = editor.getURI()
    @orbitalConf[uri]=editor.getEncoding()

  activate: (state) ->
    @subscriptions = new CompositeDisposable
    @orbitalConf = state.orbitalConfState ? {}

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
    {orbitalConfState: @orbitalConf}
