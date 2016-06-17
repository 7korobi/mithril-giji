
btn = (bool, o)->
  o.class ?= 'edge'
  if bool
    o.className = "btn #{o.class} active"
  else
    o.className = "btn #{o.class}"


class Gesture
  constructor: ({ @timeout, @debounce, @disable, @fail, @check, @do })->
    @debounce ?= 100
    @timeout ?= 500
    @disable ?= m.prop(false)
    @check ?= -> true
    @fail ?= ->
    @do ?= (p)-> p

    @action = (value, debug)=>
      (e)=>
        e.value = value
        switch
          when @timer
            e.message = "in progress."
            @fail e
          when not @check e
            e.message = "validate fail."
            @fail e
          else
            @promise e
        false

    @off()

  active: ->
    not @timer && @check()

  on: ->
    @disabled = true
    @disable true

  off: ->
    @timer = null
    @disable false
    @disabled = false

  cancel: ->
    clearTimeout @timer
    @timer = null
    @disable false

  promise: (e)->
    @on()
    @timer = true
    timer = new Promise (_, ng)=>
      @timer = setTimeout =>
        e.message = "reset #{ @timeout }ms "
        ng e
      , @timeout

    main = @do new Promise (ok)=>
      ok e

    Promise.race [timer, main]
    .then ()=>
      clearTimeout @timer
    .catch (e)=>
      @fail e
    .then ()=>
      setTimeout =>
        @off()
      , @debounce

  submit: (o)->
    btn ! @active(), o
    o.type = "submit"
    o

  form: (o)->
    o.oninput = @check
    o.onchange = @check
    o.onsubmit = @action()
    o

  tap: (value, o)->
    o.onclick = @action value
    o.onmouseup = @action value
    o.ontouchend = @action value
    o

  menu: (value, state, o)->
    btn value == state, o
    o.key = "menu-#{value}"
    o.onclick = @action value
    o.onmouseup = @action value
    o.ontouchend = @action value
    o

win = module.exports
win.gesture = Gesture
