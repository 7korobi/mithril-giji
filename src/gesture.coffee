class Gesture
  constructor: ({ @timeout, @on, @off, @do, @fail })->
    @timeout ?= 500
    @off ?= ->
    @on ?= ->
    @do ?= (p)-> p
    @fail ?= ->

    @action = (e)=>
      if @timer
        @fail()
      else
        @promise(e)

    @timer = null
    @off()

  cancel: ->
    clearTimeout @timer
    @timer = null
    @off()

  promise: (e)->
    @timer = true
    timer = new Promise (_, ng)=>
      @timer = setTimeout =>
        ng new Error "reset #{ @timeout }ms "
      , @timeout

    main = @do new Promise (ok)=>
      @on()
      ok e

    Promise.race [main, timer]
    .then ()=>
      clearTimeout @timer
    .catch (e)=>
      @fail()
    .then ()=>
      @timer = null
      @off()


  tap: (o)->
    o.onclick = @action
    o.onmouseup = @action
    o.ontouchend = @action
    o

win = module.exports
win.gesture = Gesture
