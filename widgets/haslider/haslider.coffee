class Dashing.Haslider extends Dashing.ClickableWidget
  constructor: ->
    super
    @queryState()


  @accessor 'state',
    get: -> @_state ? '100'
    set: (key, value) -> @_state = value

  @accessor 'min',
    get: -> @_min ? '1'
    set: (key, value) -> @_min = value

  @accessor 'max',
    get: -> @_max ? '100'
    set: (key, value) -> @_max = value

  @accessor 'step',
    get: -> @_step ? '100'
    set: (key, value) -> @_step = value

  postState: ->
    path = '/homeassistant/inputslider'
    $.post path,
      widgetId: @get('id'),

  queryState: ->
    path = '/homeassistant/inputslider'
    $.get path,
      deviceId: @get('id')
      (data) =>
        json = JSON.parse data
        @set 'state', json.state
        @set 'min', json.attributes.min
        @set 'max', json.attributes.max
        @set 'step', json.attributes.step

  ready: ->

  onData: (data) ->
    @queryState()

  onClick: (node, event) ->
    @postState()
    Dashing.cycleDashboardsNow(
      boardnumber: @get('page'),
      stagger: @get('stagger'),
      fastTransition: @get('fasttransition'),
      transitiontype: @get('transitiontype'))
