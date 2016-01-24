/**
 mithril-giji - mithril library for 人狼議事
 @version v0.0.15
 @link https://github.com/7korobi/mithril-giji
 @license 
**/

(function() {
  var scroll_end, set_scroll, win;

  set_scroll = function(win) {
    win.left = window.scrollX;
    return win.top = window.scrollY;
  };

  scroll_end = function() {
    var check, chk, count, scan;
    if (win.scrolling) {
      return;
    }
    check = {};
    count = 0;
    chk = function() {
      var local;
      local = {};
      set_scroll(local);
      if (check.top === local.top && check.left === local.left) {
        return 10 < count++;
      } else {
        check = local;
        count = 0;
        return false;
      }
    };
    scan = function() {
      if (chk()) {
        win.scrolling = false;
        win.do_event_list(win.on.scroll_end);
        win["do"].resize();
      } else {
        window.requestAnimationFrame(scan);
      }
    };
    return scan();
  };

  module.exports = win = {
    do_event_list: function(list, e) {
      var cb, i, len;
      if (!(0 < list.length)) {
        return;
      }
      for (i = 0, len = list.length; i < len; i++) {
        cb = list[i];
        cb(e);
      }
    },
    "do": {
      layout: function(e) {
        return win.do_event_list(win.on.layout, e);
      },
      resize: function(e) {
        var docElem, ref, short;
        docElem = document.documentElement;
        short = Math.min(docElem.clientWidth, docElem.clientHeight);
        win.width = docElem.clientWidth;
        if (short < 380) {
          head.browser.viewport = "width=device-width, maximum-scale=2.0, minimum-scale=0.5, initial-scale=0.5";
          if ((ref = document.querySelector("meta[name=viewport]")) != null) {
            ref.content = head.browser.viewport;
          }
        }
        if (window.innerHeight > window.innerWidth) {
          win.landscape = false;
          win.portlate = true;
        } else {
          win.landscape = true;
          win.portlate = false;
        }
        return win.do_event_list(win.on.resize, e);
      },
      scroll_end: scroll_end,
      scroll: function(e) {
        set_scroll(win);
        win.height = window.innerHeight;
        win.right = win.left + window.innerWidth;
        win.bottom = win.top + win.height;
        win.horizon = win.height / 2;
        if (!win.scrolling) {
          win.do_event_list(win.on.scroll_start, e);
        }
        win["do"].scroll_end();
        win.scrolling = true;
        return win.do_event_list(win.on.scroll, e);
      },
      orientation: function(e) {
        win.orientation = e;
        win.compass = e.webkitCompassHeading;
        return win.do_event_list(win.on.orientation, e);
      },
      motion: function(e) {
        win.accel = e.acceleration;
        win.gravity = e.accelerationIncludingGravity;
        win.rotate = e.rotationRate;
        return win.do_event_list(win.on.motion, e);
      },
      load: function(e) {
        win.do_event_list(win.on.load, e);
        win["do"].resize();
        win["do"].scroll();
        return win["do"].layout();
      }
    },
    on: {
      layout: [],
      resize: [],
      scroll: [],
      scroll_start: [],
      scroll_end: [],
      orientation: [],
      motion: [],
      load: []
    },
    scroll: null,
    layout: null,
    mount: function(query, cb) {
      if (cb) {
        return win.on.load.push(function() {
          var dom;
          dom = document.querySelector(query);
          if (!!dom && cb) {
            return m.mount(dom, cb(dom, layout));
          }
        });
      }
    },
    top: 0,
    horizon: 0,
    bottom: 0,
    left: 0,
    right: 0,
    height: 0,
    width: 0,
    accel: {},
    rotate: {},
    gravity: {},
    orientation: {},
    compass: 0,
    is_tap: false,
    deploy: function() {
      if ("onorientationchange" in window) {
        window.addEventListener('orientationchange', win["do"].scroll);
      } else {
        window.addEventListener('resize', win["do"].scroll);
      }
      window.addEventListener('scroll', win["do"].scroll);
      if ("ondeviceorientation" in window) {
        window.addEventListener('deviceorientation', win["do"].orientation);
      }
      if ("ondevicemotion" in window) {
        window.addEventListener('devicemotion', win["do"].motion);
      }
      if ("onhashchange" in window) {
        window.addEventListener("hashchange", function(event) {
          if (event.clipboardData) {
            return console.log(event);
          } else {
            return Url.popstate();
          }
        });
      }
      if ("onpopstate" in window) {
        window.addEventListener("popstate", function(event) {
          if (event.clipboardData) {
            return console.log(event);
          } else {
            return Url.popstate();
          }
        });
        if (!head.browser.safari) {
          Url.popstate();
        }
      }
      if ("onmessage" in window) {
        window.addEventListener("message", function(event) {
          return console.log("on message");
        });
      }
      if ("onoffline" in window) {
        window.addEventListener("offline", function(event) {
          return console.log("on offline  onLine:" + navigator.onLine);
        });
      }
      if ("ononline" in window) {
        window.addEventListener("online", function(event) {
          return console.log("on online  onLine:" + navigator.onLine);
        });
      }
      if ("onstorage" in window) {
        window.addEventListener("storage", function(event) {
          return console.log("on storage");
        });
      }
      if ("onload" in window) {
        return window.addEventListener("load", win["do"].load);
      }
    }
  };

}).call(this);

(function() {
  var Layout, win, z_depth;

  Layout = (function() {
    var move;

    Layout.list = {};

    Layout.move = function() {
      var key, o, ref, results;
      ref = Layout.list;
      results = [];
      for (key in ref) {
        o = ref[key];
        results.push(o.translate());
      }
      return results;
    };

    move = function(cb) {
      var h, w, x, y;
      w = this.width || this.box.offsetWidth;
      h = this.height || this.box.offsetHeight;
      if (this.dx) {
        x = this.dx;
      } else {
        this.width = this.box.parentElement.offsetWidth;
        x = this.box.parentElement.offsetLeft;
      }
      if (this.dy) {
        y = this.dy;
      }
      return cb(x, y, w, h, {
        top: win.top,
        left: win.left,
        width: win.width,
        height: win.height
      });
    };

    function Layout(box, dx1, dy1, dz, absolute1, duration1) {
      this.box = box;
      this.dx = dx1;
      this.dy = dy1;
      this.absolute = absolute1 != null ? absolute1 : false;
      this.duration = duration1 != null ? duration1 : DELAY.animato;
      if (!this.box) {
        return;
      }
      if (this.absolute) {
        this.duration /= 4;
      }
      Layout.list[this.box.id] = this;
      this.box.style.zIndex = dz;
      this.mode = "show";
      this.from = this.hide();
      this.transform(this.from);
      this.transition();
    }

    Layout.prototype.show = function() {
      return move.call(this, function(x, y, w, h, win) {
        if (x < 0) {
          x += win.width - w;
        }
        if (y < 0) {
          y += win.height - h;
        }
        return {
          x: x,
          y: y,
          w: w,
          h: h,
          win: win
        };
      });
    };

    Layout.prototype.hide = function() {
      return move.call(this, function(x, y, w, h, win) {
        x = -x + (function() {
          switch (false) {
            case !(0 < x):
              return -w;
            case !(x < 0):
              return win.width;
          }
        })();
        y = -y + (function() {
          switch (false) {
            case !(0 < y):
              return -h;
            case !(y < 0):
              return win.height;
          }
        })();
        return {
          x: x,
          y: y,
          w: w,
          h: h,
          win: win
        };
      });
    };

    Layout.prototype.transform = function(arg) {
      var transform, x, y;
      x = arg.x, y = arg.y;
      if (this.width) {
        this.box.style.width = this.width + "px";
      }
      if (this.height) {
        this.box.style.height = this.height + "px";
      }
      if (this.absolute) {
        this.box.style.position = "absolute";
        this.box.style.left = (x + win.left) + "px";
        this.box.style.top = (y + win.top) + "px";
        this.box.style.webkitTransform = "";
        this.box.style.mozTransform = "";
        this.box.style.msTransform = "";
        this.box.style.oTransform = "";
        return this.box.style.transform = "";
      } else {
        this.box.style.position = "fixed";
        this.box.style.left = 0;
        this.box.style.top = 0;
        transform = "translate(" + x + "px, " + y + "px)";
        this.box.style.webkitTransform = transform;
        if (head.browser.ff) {
          this.box.style.mozTransform = transform;
        }
        if (head.browser.ie) {
          this.box.style.msTransform = transform;
        }
        if (head.browser.opera) {
          this.box.style.oTransform = transform;
        }
        return this.box.style.transform = transform;
      }
    };

    Layout.prototype.transition = function() {
      var trans;
      trans = this.duration && !this.absolute ? "all " + this.duration + "ms ease-in-out 0" : "";
      if (head.browser.ff) {
        this.box.style.mozTransition = trans;
      }
      if (head.browser.ie) {
        this.box.style.msTransition = trans;
      }
      if (head.browser.opera) {
        this.box.style.oTransition = trans;
      }
      return this.box.style.transition = trans;
    };

    Layout.prototype.translate = function() {
      var to;
      to = this[this.mode]();
      if (_.isEqual(this.from, to)) {
        return;
      }
      this.transform(to);
      return setTimeout((function(_this) {
        return function() {
          _this.from = to;
          return _this.translate();
        };
      })(this), this.duration);
    };

    return Layout;

  })();

  z_depth = 1000;

  win = module.exports;

  win.layout = function(query, dx, dy, dz, absolute, duration, cb) {
    if (dz == null) {
      dz = ++z_depth;
    }
    if (absolute == null) {
      absolute = false;
    }
    if (duration == null) {
      duration = 200;
    }
    return win.mount(query, function(dom) {
      var layout;
      layout = new Layout(dom, dx, dy, dz, absolute, duration);
      return cb(dom, layout);
    });
  };

  win.on.layout.push(Layout.move);

  win.on.scroll_end.push(Layout.move);

  win.on.resize.push(Layout.move);

}).call(this);

(function() {
  var ScrollSpy, win;

  ScrollSpy = (function() {
    var interval;

    ScrollSpy.elems = {};

    ScrollSpy.go = function(id, offset) {
      var elem, left_by, rect, top_by;
      elem = ScrollSpy.elems[id];
      if (elem) {
        rect = elem.getBoundingClientRect();
        if (offset == null) {
          offset = Math.min(win.horizon, rect.height) * 0.5;
        }
        top_by = rect.top - win.horizon + offset;
        left_by = 0;
        if (left_by || top_by) {
          return window.scrollBy(left_by, top_by);
        }
      }
    };

    interval = 5000;

    setInterval(function() {
      var ref;
      if ((ref = win.scroll) != null ? ref.center : void 0) {
        return win.scroll.tick(win.scroll.center, interval / 1000);
      }
    }, interval);

    ScrollSpy.capture = function() {
      var full_id, id, spy;
      full_id = ScrollSpy.view();
      spy = win.scroll;
      if (spy != null) {
        if (spy.list != null) {
          id = spy.view();
          if (id !== spy.prop()) {
            return spy.prop(id);
          }
        }
      }
    };

    ScrollSpy.view = function() {
      var elem, id, key, rect, ref, ref1, result, vision;
      result = null;
      ref = ScrollSpy.elems;
      for (key in ref) {
        elem = ref[key];
        id = elem.vision.id;
        rect = elem.getBoundingClientRect();
        vision = elem.vision;
        vision.top = rect.top;
        vision.btm = rect.bottom;
        if (elem.vision.id === key && rect.height && rect.width) {
          if (!result && (vision.top < (ref1 = win.horizon) && ref1 < vision.btm)) {
            result = id;
          }
        } else {
          delete ScrollSpy.elems[key];
        }
      }
      return result;
    };

    function ScrollSpy() {
      this.show_upper = true;
      this.size = 30;
      this.head = this.tail = 0;
    }

    ScrollSpy.prototype.rescroll = function(prop) {
      this.prop = prop;
      return window.requestAnimationFrame((function(_this) {
        return function() {
          return ScrollSpy.go(_this.prop());
        };
      })(this));
    };

    ScrollSpy.prototype.tick = function(center) {
      return console.log(center);
    };

    ScrollSpy.prototype.view = function() {
      var elem, i, id, idx, len, o, pager_rect, ref, ref1, ref2, vision;
      pager_rect = this.pager_elem.getBoundingClientRect();
      this.pager_top = pager_rect.top;
      ref = this.list;
      for (idx = i = 0, len = ref.length; i < len; idx = ++i) {
        o = ref[idx];
        id = o._id;
        if (elem = ScrollSpy.elems[id]) {
          vision = elem.vision;
          if (!this.adjust && (this.pager_top < (ref1 = win.horizon) && ref1 < vision.btm)) {
            vision.offset = Math.max(1, win.horizon - vision.top);
            this.adjust = vision;
          }
        }
      }
      m.startComputation();
      window.requestAnimationFrame(function() {
        return m.endComputation();
      });
      return (ref2 = this.adjust) != null ? ref2.id : void 0;
    };

    ScrollSpy.prototype.pager = function(tag, list, cb) {
      var attr, btm, idx, key, o, pager_cb, rect, ref, show_bottom, show_under, show_upper, top, vdom, vdom_items;
      this.list = list;
      if (!((ref = this.list) != null ? ref.length : void 0)) {
        return m(tag, {
          config: (function(_this) {
            return function(pager_elem) {
              _this.pager_elem = pager_elem;
            };
          })(this)
        });
      }
      top = 0;
      btm = this.list.length - 1;
      if (this.pager_elem != null) {
        rect = this.pager_elem.getBoundingClientRect();
        show_bottom = win.height - rect.bottom;
        show_upper = 0 < rect.top;
        show_under = 0 < show_bottom;
      }
      idx = _.findIndex(this.list, {
        _id: typeof this.prop === "function" ? this.prop() : void 0
      });
      if (idx < 0) {
        idx = (function() {
          if (this.past_list === this.list) {
            switch (false) {
              case !show_upper:
                return this.head;
              case !show_under:
                return this.tail;
              default:
                return this.head;
            }
          } else {
            switch (false) {
              case !show_upper:
                return top;
              case !show_under:
                return btm;
              default:
                return top;
            }
          }
        }).call(this);
      }
      this.past_list = this.list;
      this.center = this.list[idx];
      this.tail = Math.min(btm, _.ceil(idx + this.size, -1));
      this.head = Math.max(top, idx - this.size);
      pager_cb = (function(_this) {
        return function(pager_elem, is_continue, context) {
          var avg, diff_bottom, elem_bottom, size;
          _this.pager_elem = pager_elem;
          rect = _this.pager_elem.getBoundingClientRect();
          _this.show_under = rect.bottom < win.horizon;
          _this.show_upper = win.horizon < rect.top;
          avg = rect.height / (1 + _this.tail - _this.head);
          size = 3 * win.height / avg;
          if (_this.size < size) {
            console.log("!alert! scroll spy size " + _this.size + " < " + size);
          }
          elem_bottom = rect.bottom + win.top;
          diff_bottom = elem_bottom - _this.elem_bottom;
          if (_this.show_under && diff_bottom && !_this.prop() && win.bottom < document.height) {
            window.scrollBy(0, diff_bottom);
          }
          return _this.elem_bottom = elem_bottom;
        };
      })(this);
      vdom_items = (function() {
        var i, len, ref1, ref2, results;
        ref1 = this.list.slice(this.head, +this.tail + 1 || 9e9);
        results = [];
        for (i = 0, len = ref1.length; i < len; i++) {
          o = ref1[i];
          vdom = cb(o);
          ref2 = this.mark(o._id);
          for (key in ref2) {
            attr = ref2[key];
            vdom.attrs[key] = attr;
          }
          results.push(vdom);
        }
        return results;
      }).call(this);
      return m(tag, {
        config: pager_cb
      }, vdom_items);
    };

    ScrollSpy.prototype.mark = function(id) {
      return {
        config: (function(_this) {
          return function(elem, is_continue, context) {
            var offset;
            ScrollSpy.elems[id] = elem;
            elem.vision = {
              id: id
            };
            if (_this.adjust) {
              if (id === _this.adjust.id) {
                offset = _this.adjust.offset;
                _this.adjust = null;
                return ScrollSpy.go(id, offset);
              }
            } else {
              if (!is_continue) {
                if (id === _this.prop()) {
                  return window.requestAnimationFrame(function() {
                    return ScrollSpy.go(id);
                  });
                }
              }
            }
          };
        })(this)
      };
    };

    return ScrollSpy;

  })();

  win = module.exports;

  win.scroll = new ScrollSpy;

  win.on.scroll_end.push(function() {
    return ScrollSpy.capture();
  });

}).call(this);
