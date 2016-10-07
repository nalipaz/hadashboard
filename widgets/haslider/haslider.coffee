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
        @set 'level', json.level

  postState: ->
    newState = @toggleState()
    $.post '/homeassistant/dimmer',
      widgetId: @get('id'),
      command: newState,
      (data) =>
        json = JSON.parse data
        if json.error != 0
          @toggleState()

  getLevel: ->
    newLevel = parseInt(@get('level'))+10
    if newLevel > 100
      newLevel = 100
    else if newLevel < 0
      newLevel = 0
    @set 'level', newLevel
    return @get('level')

  setLevel: ->
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

  onRangeChange: (event) ->
    if event.target.id == "slider-slider"
      @postState()

  onClick: (event) ->
    if event.target.id == "slider-switch"
      @postState()
