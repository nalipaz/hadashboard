class Dashing.Haslider extends Dashing.ClickableWidget
  constructor: ->
    super
    @queryState()

  @accessor 'state',
    get: -> @_state ? 'off'
    set: (key, value) -> @_state = value

  @accessor 'level',
    get: -> @_level ? '50'
    set: (key, value) -> @_level = value

  @accessor 'icon',
    get: -> if @['icon'] then @['icon'] else
      if @get('state') == 'on' then @get('iconon') else @get('iconoff')
    set: Batman.Property.defaultAccessor.set

  @accessor 'iconon',
    get: -> @['iconon'] ? 'circle'
    set: Batman.Property.defaultAccessor.set

  @accessor 'iconoff',
    get: -> @['iconoff'] ? 'circle-thin'
    set: Batman.Property.defaultAccessor.set

  @accessor 'icon-style', ->
    if @get('state') == 'on' then 'slider-icon-on' else 'slider-icon-off'

  toggleState: ->
    newState = if @get('state') == 'on' then 'off' else 'on'
    @set 'state', newState
    return newState

  queryState: ->
    $.get '/homeassistant/dimmer',
      widgetId: @get('id'),
      (data) =>
        json = JSON.parse data
        @set 'state', json.state
        if json.level then @set 'level', json.level else @set 'level', @getLevel()

  postState: ->
    newState = @toggleState()
    $.post '/homeassistant/dimmer',
      widgetId: @get('id'),
      command: newState,
      (data) =>
        json = JSON.parse data

  getLevel: ->
    newLevel = parseInt(@get('level'))
    if newLevel > 100
      newLevel = 100
    else if newLevel < 0
      newLevel = 0
    @set 'level', newLevel
    return @get('level')

  postLevel: ->
    newLevel = @getLevel()
    $.post '/homeassistant/dimmerLevel',
      widgetId: @get('id'),
      command: newLevel,
      (data) =>
        json = JSON.parse data

  ready: ->
    if @get('bgcolor')
      $(@node).css("background-color", @get('bgcolor'))
    else
      $(@node).css("background-color", "#444")
  onData: (data) ->

  onChange: (event) ->
    if event.target.id == "slider-slider"
      @postLevel()

  onClick: (event) ->
    if event.target.id == "slider-switch"
      @postState()
