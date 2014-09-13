EventEmitter = require('events').EventEmitter

describe 'mk cli', ->
  Given -> @utils = spyObj 'spawn', 'exit'
  Given -> @subject = sandbox '../mk/cli',
    '../lib/utils': @utils

  describe 'config', ->
    Given -> @spawn = new EventEmitter
    Given -> @utils.spawn.withArgs('config', 'baz').returns @spawn
    When -> @subject.config 'foo', 'bar', 'baz'
    And -> @spawn.emit 'close'
    Then -> expect(@utils.exit).to.have.been.called
