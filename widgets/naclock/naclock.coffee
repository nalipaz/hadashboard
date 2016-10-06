class Dashing.Naclock extends Dashing.Widget

  ready: ->
    if @get('bgcolor')
      $(@node).css("background-color", @get('bgcolor'))
    else
      $(@node).css("background-color", "#444")
    setInterval(@startTime, 500)

  startTime: =>
    today = new Date()

    h = today.getHours()
    m = today.getMinutes()
    m = @formatTime(m)
    @set('time', @formatHours(h) + ":" + m + " " + @formatAmPm(h))
    @set('date', today.toLocaleDateString())

  formatTime: (i) ->
    if i < 10 then "0" + i else i

  formatAmPm: (h) ->
    if h >= 12 then "PM" else "AM"

  formatHours: (h) ->
    if h > 12
      h - 12
    else if h == 0
      12
    else
      h
