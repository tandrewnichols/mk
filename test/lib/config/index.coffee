describe 'mk-config', ->
  Given -> @config = spyObj 'set', 'get'
  Given -> @subject = sandbox '../lib/config',
    './cli': @config

  describe 'name', ->
    Then -> expect(@subject.name).to.equal 'mk-config'

  describe 'version', ->
    Then -> expect(@subject.version()).to.equal require('../../../package').version

  describe 'set', ->
    context 'correct settings', ->
      Given -> @cmd = _.findWhere @subject.commands, { _name: 'set' }
      And -> expect(@cmd._description).to.equal 'Set a config value'
      And -> expect(@cmd._args).to.deep.equal [
        required: true
        name: 'key'
      ,
        required: true
        name: 'value'
      ]
    
    context 'set calls config.set', ->
      When -> @subject.parse ['node', 'mk-config', 'set', 'foo', 'bar']
      Then -> expect(@config.set).to.have.been.called

  describe 'get', ->
    context 'correct settings', ->
      Given -> @cmd = _.findWhere @subject.commands, { _name: 'get' }
      And -> expect(@cmd._description).to.equal 'Get a config value'
      And -> expect(@cmd._args).to.deep.equal [
        required: true
        name: 'key'
      ]

    context 'get calls config.get', ->
      When -> @subject.parse ['node', 'mk-config', 'get', 'foo', 'bar']
      Then -> expect(@config.get).to.have.been.called
