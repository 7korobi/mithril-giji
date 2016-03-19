class Gesture
  constructor: ({ @timeout, @disable, @fail, @check, @do })->
    @timeout ?= 500
    @disable ?= m.prop(false)
    @fail ?= ->
    @check ?= -> true
    @do ?= (p)-> p

    @action = (e)=>
      switch
        when @timer, not @check()
          @fail()
        else
          @promise(e)
      false

    @off()

  on: ->
    @disable true

  off: ->
    @timer = null
    @disable false

  cancel: ->
    clearTimeout @timer
    @timer = null
    @disable false

  promise: (e)->
    @timer = true
    timer = new Promise (_, ng)=>
      @timer = setTimeout =>
        ng new Error "reset #{ @timeout }ms "
      , @timeout

    main = @do new Promise (ok)=>
      @on()
      ok e

    Promise.race [timer, main]
    .then ()=>
      clearTimeout @timer
    .catch (e)=>
      @fail()
    .then ()=>
      @off()

  form: (o)->
    o.oninput = @check
    o.onchange = @check
    o.onsubmit = @action
    o

  tap: (o)->
    o.onclick = @action
    o.onmouseup = @action
    o.ontouchend = @action
    o

win = module.exports
win.gesture = Gesture
