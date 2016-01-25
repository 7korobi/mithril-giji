global.window =
  innerHeight: 100
  innerWidth: 100
  scrollX: 10
  scrollY: 20
  requestAnimationFrame: (cb)->
    cb()

global.document =
  documentElement:
    clientHeight: 110
    clientWidth:   90
  querySelector: (query)->
    style: {}
    parentElement: {}
  createElement: (o)-> console.log o

global.m =
  mount: (dom, vdom)->
    {}
