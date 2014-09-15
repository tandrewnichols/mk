EventEmitter = require('events').EventEmitter
chalk = require 'chalk'

describe 'mk cli', ->
  Given -> @utils = spyObj 'spawn', 'exit', 'writeBlock', 'resolveTemplate', 'writeConfig'
  Given -> @cp = spyObj 'spawn'
  Given -> @subject = sandbox '../lib/mk/cli',
    '../utils': @utils
    child_process: @cp

  describe 'register', ->
    Given -> @opts =
      root: '/foo/bar'
      config: {}
    Given -> @utils.resolveTemplate.withArgs('template').returns 'git@github.com:some/template.git'

    context 'with no name', ->
      Given -> @spawn = new EventEmitter()
      Given -> @cp.spawn.withArgs('git', ['clone', 'git@github.com:some/template.git'],
        stdio: 'inherit'
        cwd: '/foo/bar'
      ).returns @spawn
      When -> @subject.register 'template', undefined, @opts
      And -> @spawn.emit 'close', 0
      Then -> expect(@utils.writeBlock).to.have.been.calledWith chalk.green('Registered template.')
      And -> expect(@utils.writeConfig).to.have.been.calledWith
        root: '/foo/bar'
        config:
          templates: [
            key: 'template'
            value:
              path: '/foo/bar/template'
          ]
      , @utils.exit

    context 'with a name', ->
      Given -> @spawn = new EventEmitter()
      Given -> @cp.spawn.withArgs('git', ['clone', 'git@github.com:some/template.git', 'name'],
        stdio: 'inherit'
        cwd: '/foo/bar'
      ).returns @spawn
      When -> @subject.register 'template', 'name', @opts
      And -> @spawn.emit 'close', 0
      Then -> expect(@utils.writeBlock).to.have.been.calledWith chalk.green('Registered template as name.')
      And -> expect(@utils.writeConfig).to.have.been.calledWith
        root: '/foo/bar'
        config:
          templates: [
            key: 'name'
            value:
              path: '/foo/bar/name'
          ]
      , @utils.exit

  describe 'config', ->
    context 'with set or get', ->
      Given -> @spawn = new EventEmitter
      Given -> @utils.spawn.withArgs('config', 'baz').returns @spawn
      When -> @subject.config 'foo', 'bar', 'baz'
      And -> @spawn.emit 'close'
      Then -> expect(@utils.exit).to.have.been.called

    context 'with no parameters', ->
      Given -> @opts = {}
      When -> @subject.config @opts
      Then -> expect(@utils.writeBlock.getCall(0).args).to.deep.equal [
        'The following config values can be set:',
        ['   ', chalk.magenta('username') + ': ', 'Your github username.', chalk.cyan('<String>')],
        ['   ', chalk.magenta('pattern') + ':  ', 'Interpolation style or regex pattern.', chalk.cyan('<String|RegExp>')],
        ['   ', chalk.magenta('private') + ':  ', 'New repos should marked private.', chalk.cyan('<Boolean>')],
        ['   ', chalk.magenta('wiki') + ':     ', 'New repos should include a wiki.', chalk.cyan('<Boolean>')],
        ['   ', chalk.magenta('issues') + ':   ', 'New repos should include an issues page.', chalk.cyan('<Boolean>')]
      ]
      And -> expect(@utils.writeBlock.getCall(1).args).to.deep.equal [
        'Additionally, any option besides username can be specified on a registered template with dot notation (e.g. "templateName.wiki")'
      ]
