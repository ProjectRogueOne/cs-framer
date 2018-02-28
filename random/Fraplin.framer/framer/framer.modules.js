require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"fraplin":[function(require,module,exports){
var Fraplin, Label, SVGContext, SVGShape, ctx, svgContext,
  bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

Framer.Extras.Hints.disable();

svgContext = void 0;

SVGContext = (function() {
  function SVGContext(options) {
    var context, sFrame, setAttributes, svgNS;
    if (options == null) {
      options = {};
    }
    this.removeAll = bind(this.removeAll, this);
    this.__constructor = true;
    this.shapes = [];
    svgContext = this;
    svgNS = "http://www.w3.org/2000/svg";
    setAttributes = function(element, attributes) {
      var key, results, value;
      if (attributes == null) {
        attributes = {};
      }
      results = [];
      for (key in attributes) {
        value = attributes[key];
        results.push(element.setAttribute(key, value));
      }
      return results;
    };
    this.frameLayer = new Layer({
      size: Screen.size,
      name: '.',
      visible: false
    });
    this.frameElement = this.frameLayer._element;
    this.lFrame = this.frameElement.getBoundingClientRect();
    _.assign(this, {
      width: this.lFrame.width.toFixed(),
      height: this.lFrame.height.toFixed(),
      x: this.lFrame.left.toFixed(),
      y: this.lFrame.top.toFixed()
    });
    this.svg = document.createElementNS(svgNS, 'svg');
    context = document.getElementById('FramerContextRoot-TouchEmulator');
    context.appendChild(this.svg);
    this.screenElement = document.getElementsByClassName('framerContext')[0];
    sFrame = this.screenElement.getBoundingClientRect();
    setAttributes(this.svg, {
      x: 0,
      y: 0,
      width: sFrame.width,
      height: sFrame.height,
      viewBox: "0 0 " + sFrame.width + " " + sFrame.height
    });
    _.assign(this.svg.style, {
      position: "absolute",
      left: 0,
      top: 0,
      width: '100%',
      height: '100%',
      'pointer-events': 'none'
    });
    this.svgDefs = document.createElementNS(svgNS, 'defs');
    this.svg.appendChild(this.svgDefs);
    delete this.__constructor;
  }

  SVGContext.prototype.addShape = function(shape) {
    this.shapes.push(shape);
    return this.showShape(shape);
  };

  SVGContext.prototype.removeShape = function(shape) {
    this.hideShape(shape);
    return _.pull(this.shapes, shape);
  };

  SVGContext.prototype.hideShape = function(shape) {
    return this.svg.removeChild(shape.element);
  };

  SVGContext.prototype.showShape = function(shape) {
    return this.svg.appendChild(shape.element);
  };

  SVGContext.prototype.addDef = function(def) {
    return this.svgDefs.appendChild(def);
  };

  SVGContext.prototype.removeAll = function() {
    var i, len, ref, shape;
    ref = this.shapes;
    for (i = 0, len = ref.length; i < len; i++) {
      shape = ref[i];
      this.svg.removeChild(shape.element);
    }
    return this.shapes = [];
  };

  return SVGContext;

})();

SVGShape = (function() {
  function SVGShape(options) {
    var key, value;
    if (options == null) {
      options = {
        type: 'circle'
      };
    }
    this.setAttribute = bind(this.setAttribute, this);
    this.__constructor = true;
    this.parent = svgContext;
    this.element = document.createElementNS("http://www.w3.org/2000/svg", options.type);
    this.setCustomProperty('text', 'textContent', 'textContent', options.text);
    for (key in options) {
      value = options[key];
      this.setAttribute(key, value);
    }
    this.parent.addShape(this);
    this.show();
  }

  SVGShape.prototype.setAttribute = function(key, value) {
    if (key === 'text') {
      return;
    }
    if (this[key] == null) {
      Object.defineProperty(this, key, {
        get: (function(_this) {
          return function() {
            return _this.element.getAttribute(key);
          };
        })(this),
        set: (function(_this) {
          return function(value) {
            return _this.element.setAttribute(key, value);
          };
        })(this)
      });
    }
    return this[key] = value;
  };

  SVGShape.prototype.setCustomProperty = function(variableName, returnValue, setValue, startValue) {
    Object.defineProperty(this, variableName, {
      get: function() {
        return returnValue;
      },
      set: function(value) {
        return this.element[setValue] = value;
      }
    });
    return this[variableName] = startValue;
  };

  SVGShape.prototype.hide = function() {
    return this.parent.hideShape(this);
  };

  SVGShape.prototype.show = function() {
    return this.parent.showShape(this);
  };

  SVGShape.prototype.remove = function() {
    return this.parent.removeShape(this);
  };

  return SVGShape;

})();

Label = (function(superClass) {
  extend(Label, superClass);

  function Label(options) {
    var w;
    if (options == null) {
      options = {};
    }
    this.__constructor = true;
    _.assign(options, {
      name: '.',
      fontSize: 12,
      fontWeight: 500,
      color: '#777',
      fontFamily: 'Menlo'
    });
    _.defaults(options, {
      text: 'x',
      value: 0
    });
    w = options.width;
    delete options.width;
    Label.__super__.constructor.call(this, options);
    this.valueLayer = new TextLayer({
      parent: this.parent,
      name: '.',
      fontSize: this.fontSize,
      fontWeight: 500,
      color: '#333',
      fontFamily: this.fontFamily,
      x: this.x + w,
      y: this.y,
      text: '{value}'
    });
    delete this.__constructor;
    this.value = options.value;
  }

  Label.define("value", {
    get: function() {
      return this._value;
    },
    set: function(value) {
      if (this.__constructor) {
        return;
      }
      this._value = value;
      return this.valueLayer.template = value;
    }
  });

  return Label;

})(TextLayer);

ctx = new SVGContext({
  size: Screen.size,
  backgroundColor: null
});


/*
	 88888888b                            dP oo
	 88                                   88
	a88aaaa    88d888b. .d8888b. 88d888b. 88 dP 88d888b.
	 88        88'  `88 88'  `88 88'  `88 88 88 88'  `88
	 88        88       88.  .88 88.  .88 88 88 88    88
	 dP        dP       `88888P8 88Y888P' dP dP dP    dP
	                             88
	                             dP
 */

Fraplin = (function() {
  function Fraplin(options) {
    var i, layer, len, ref;
    if (options == null) {
      options = {};
    }
    this.unfocus = bind(this.unfocus, this);
    this.focus = bind(this.focus, this);
    this.setWindowLabels = bind(this.setWindowLabels, this);
    this.setWindowLabel = bind(this.setWindowLabel, this);
    this.makeBoundingRects = bind(this.makeBoundingRects, this);
    this.showDistances = bind(this.showDistances, this);
    this.makeLabel = bind(this.makeLabel, this);
    this.makeLine = bind(this.makeLine, this);
    this.getDimensions = bind(this.getDimensions, this);
    this.deselect = bind(this.deselect, this);
    this.select = bind(this.select, this);
    this.getLayerFromElement = bind(this.getLayerFromElement, this);
    this.disable = bind(this.disable, this);
    this.enable = bind(this.enable, this);
    this.resetLayers = bind(this.resetLayers, this);
    this.toggle = bind(this.toggle, this);
    _.defaults(options, {
      color: 'red',
      secondaryColor: 'white',
      fontFamily: 'Arial',
      fontSize: '10',
      fontWeight: '600',
      borderRadius: 4,
      padding: {
        top: 2,
        bottom: 2,
        left: 4,
        right: 4
      }
    });
    _.assign(this, {
      color: options.color,
      secondaryColor: options.secondaryColor,
      fontFamily: options.fontFamily,
      fontSize: options.fontSize,
      fontWeight: options.fontWeight,
      shapes: [],
      borderRadius: options.borderRadius,
      padding: options.padding,
      focusedElement: void 0,
      enabled: false,
      screenElement: document.getElementsByClassName('DeviceComponentPort')[0],
      viewport: document.getElementsByClassName('DeviceComponentPort')[0],
      layers: []
    });
    document.addEventListener('keyup', this.toggle);
    this.context = document.getElementsByClassName('framerLayer DeviceScreen')[0];
    this.context.classList.add('hoverContext');
    this.context.childNodes[2].classList.add('IgnorePointerEvents');
    this.context.addEventListener("mouseover", this.focus);
    this.context.addEventListener("mouseout", this.unfocus);
    Utils.insertCSS(".framerLayer { \n	pointer-events: all !important; \n	} \n\n.DeviceContent {\n	pointer-events: none !important; \n	}\n\n.DeviceBackground {\n	pointer-events: none !important; \n	}\n\n.DeviceHands {\n	pointer-events: none !important; \n	}\n\n.DeviceComponentPort {\n	pointer-events: none !important; \n}\n\n.IgnorePointerEvents {\n	pointer-events: none !important; \n}");
    this.window = new Layer({
      parent: null,
      name: 'Details',
      y: Align.bottom(-16),
      x: 32,
      height: 156,
      width: Screen.width - 64,
      backgroundColor: '#f5f5f5',
      borderRadius: 4,
      shadowX: 1,
      shadowY: 3,
      shadowBlur: 6,
      shadowColor: 'rgba(0,0,0,.30)',
      visible: false
    });
    this.window.draggable.enabled = true;
    this.window.draggable.constraints = {
      width: Screen.width,
      height: Screen.height
    };
    this.window.onDoubleClick(function() {
      return this.visible = false;
    });
    _.bind(function() {
      this.xLabel = new Label({
        parent: this,
        x: 8,
        y: 8,
        width: 24,
        text: 'x:'
      });
      this.yLabel = new Label({
        parent: this,
        x: 8,
        y: 28,
        width: 24,
        text: 'y:'
      });
      this.widthLabel = new Label({
        parent: this,
        x: 96,
        y: 8,
        width: 60,
        text: 'width:'
      });
      this.heightLabel = new Label({
        parent: this,
        x: 96,
        y: 28,
        width: 60,
        text: 'height:'
      });
      this.radiusLabel = new Label({
        parent: this,
        x: 8,
        y: 48,
        width: 60,
        text: 'radius:'
      });
      this.borderLabel = new Label({
        parent: this,
        x: 8,
        y: 72,
        width: 60,
        text: 'border:'
      });
      this.shadowLabel = new Label({
        parent: this,
        x: 8,
        y: 96,
        width: 60,
        text: 'shadow:'
      });
      this.componentLabel = new Label({
        parent: this,
        x: 8,
        y: 120,
        width: 80,
        text: 'Component:'
      });
      this.close = new TextLayer({
        parent: this,
        y: 0,
        x: Align.right(),
        text: 'x',
        fontFamily: 'Menlo',
        color: '#333',
        fontSize: 14,
        fontWeight: 600,
        padding: 8
      });
      this.close.onTap((function(_this) {
        return function() {
          return _this.visible = false;
        };
      })(this));
      return this.style['pointer-events'] = 'none';
    }, this.window)();
    ref = this.window.descendants;
    for (i = 0, len = ref.length; i < len; i++) {
      layer = ref[i];
      layer.classList.add('IgnorePointerEvents');
    }
  }

  Fraplin.prototype.toggle = function(event) {
    if (event.key === "`") {
      if (this.enabled) {
        this.disable();
      } else {
        this.enable();
      }
      return;
    }
    if (event.key === "/") {
      if (!this.enabled) {
        return;
      }
      if (this.hoveredElement === this.selectedElement) {
        this.deselect();
      } else {
        this.select();
      }
    }
  };

  Fraplin.prototype.resetLayers = function() {
    var i, layer, len, ref, results;
    this.layers = [];
    ref = Framer.CurrentContext._layers;
    results = [];
    for (i = 0, len = ref.length; i < len; i++) {
      layer = ref[i];
      results.push(this.layers.push(layer));
    }
    return results;
  };

  Fraplin.prototype.enable = function() {
    this.resetLayers();
    this.enabled = true;
    this.window.visible = true;
    this.window.bringToFront();
    return this.focus();
  };

  Fraplin.prototype.disable = function() {
    this.enabled = false;
    this.window.visible = false;
    this.window.sendToBack();
    return this.unfocus();
  };

  Fraplin.prototype.getLayerFromElement = function(element) {
    var layer, ref, ref1;
    if (element.classList.contains('framerLayer')) {
      layer = _.find(this.layers, ['_element', element]);
    } else {
      element = (ref = element.parentNode) != null ? (ref1 = ref.parentNode) != null ? ref1.parentNode : void 0 : void 0;
      layer = _.find(this.layers, ['_element', element]);
    }
    return layer;
  };

  Fraplin.prototype.select = function(event) {
    if (!this.hoveredElement) {
      return;
    }
    this.selectedElement = this.hoveredElement;
    this.selectedElement.addEventListener('click', this.deselect);
    return this.focus();
  };

  Fraplin.prototype.deselect = function(event) {
    this.selectedElement.removeEventListener('click', this.deselect);
    this.selectedElement = void 0;
    return this.focus();
  };

  Fraplin.prototype.getDimensions = function(element) {
    var d, dimensions;
    d = element.getBoundingClientRect();
    dimensions = {
      x: d.left,
      y: d.top,
      width: d.width,
      height: d.height,
      midX: d.left + (d.width / 2),
      midY: d.top + (d.height / 2),
      maxX: d.left + d.width,
      maxY: d.top + d.height,
      frame: d
    };
    return dimensions;
  };

  Fraplin.prototype.makeLine = function(pointA, pointB, label) {
    var capA, capB, line;
    if (label == null) {
      label = true;
    }
    line = new SVGShape({
      type: 'path',
      d: "M " + pointA[0] + " " + pointA[1] + " L " + pointB[0] + " " + pointB[1],
      stroke: this.color,
      'stroke-width': '1px'
    });
    if (pointA[0] === pointB[0]) {
      capA = new SVGShape({
        type: 'path',
        d: "M " + (pointA[0] - 4) + " " + pointA[1] + " L " + (pointA[0] + 5) + " " + pointA[1],
        stroke: this.color,
        'stroke-width': '1px'
      });
      return capB = new SVGShape({
        type: 'path',
        d: "M " + (pointB[0] - 4) + " " + pointB[1] + " L " + (pointB[0] + 5) + " " + pointB[1],
        stroke: this.color,
        'stroke-width': '1px'
      });
    } else if (pointA[1] === pointB[1]) {
      capA = new SVGShape({
        type: 'path',
        d: "M " + pointA[0] + " " + (pointA[1] - 4) + " L " + pointA[0] + " " + (pointA[1] + 5),
        stroke: this.color,
        'stroke-width': '1px'
      });
      return capB = new SVGShape({
        type: 'path',
        d: "M " + pointB[0] + " " + (pointB[1] - 4) + " L " + pointB[0] + " " + (pointB[1] + 5),
        stroke: this.color,
        'stroke-width': '1px'
      });
    }
  };

  Fraplin.prototype.makeLabel = function(x, y, text) {
    var box, l, label;
    label = new SVGShape({
      type: 'text',
      parent: ctx,
      x: x,
      y: y,
      'font-family': this.fontFamily,
      'font-size': this.fontSize,
      'font-weight': this.fontWeight,
      fill: this.secondaryColor,
      text: (text / this.ratio).toFixed()
    });
    l = this.getDimensions(label.element);
    label.x = x - l.width / 2;
    label.y = y + l.height / 4;
    box = new SVGShape({
      type: 'rect',
      parent: ctx,
      x: label.x - this.padding.left,
      y: label.y - l.height,
      width: l.width + this.padding.left + this.padding.right,
      height: l.height + this.padding.top + this.padding.bottom,
      rx: this.borderRadius,
      ry: this.borderRadius,
      fill: this.color
    });
    return label.show();
  };

  Fraplin.prototype.showDistances = function(selected, hovered) {
    var d, h, m, s;
    s = this.getDimensions(this.selectedElement);
    h = this.getDimensions(this.hoveredElement);
    this.ratio = this.screenElement.getBoundingClientRect().width / Screen.width;
    this.setWindowLabels(s);
    if (this.selectedElement === this.hoveredElement) {
      h = this.getDimensions(this.screenElement);
    }
    if (s.x < h.x && s.maxX > h.maxX && s.y < h.y && s.maxY > h.maxY) {
      d = Math.abs(s.y - h.y).toFixed();
      m = s.y + d / 2;
      this.makeLine([h.midX, s.y + 5], [h.midX, h.y - 4]);
      this.makeLabel(h.midX, m, d);
      d = Math.abs(s.maxX - h.maxX).toFixed();
      m = h.maxX + (d / 2);
      this.makeLine([h.maxX + 5, h.midY], [s.maxX - 4, h.midY]);
      this.makeLabel(m, h.midY, d);
      d = Math.abs(s.maxY - h.maxY).toFixed();
      m = h.maxY + (d / 2);
      this.makeLine([h.midX, h.maxY + 5], [h.midX, s.maxY - 4]);
      this.makeLabel(h.midX, m, d);
      d = Math.abs(s.x - h.x).toFixed();
      m = s.x + d / 2;
      this.makeLine([s.x + 5, h.midY], [h.x - 4, h.midY]);
      this.makeLabel(m, h.midY, d);
      this.makeBoundingRects(s, h);
      return;
    }
    if (s.x > h.x && s.maxX < h.maxX && s.y > h.y && s.maxY < h.maxY) {
      d = Math.abs(h.y - s.y).toFixed();
      m = h.y + d / 2;
      this.makeLine([s.midX, h.y + 5], [s.midX, s.y - 4]);
      this.makeLabel(s.midX, m, d);
      this.setWindowLabel('yLabel', d);
      d = Math.abs(h.maxX - s.maxX).toFixed();
      m = s.maxX + (d / 2);
      this.makeLine([s.maxX + 5, s.midY], [h.maxX - 4, s.midY]);
      this.makeLabel(m, s.midY, d);
      d = Math.abs(h.maxY - s.maxY).toFixed();
      m = s.maxY + (d / 2);
      this.makeLine([s.midX, s.maxY + 5], [s.midX, h.maxY - 4]);
      this.makeLabel(s.midX, m, d);
      d = Math.abs(h.x - s.x).toFixed();
      m = h.x + d / 2;
      this.makeLine([h.x + 5, s.midY], [s.x - 4, s.midY]);
      this.makeLabel(m, s.midY, d);
      this.setWindowLabel('xLabel', d);
      this.makeBoundingRects(s, h);
      return;
    }
    if (s.y > h.maxY) {
      d = Math.abs(s.y - h.maxY).toFixed();
      m = s.y - (d / 2);
      this.makeLine([s.midX, h.maxY + 5], [s.midX, s.y - 4]);
      this.makeLabel(s.midX, m, d);
    } else if (s.y > h.y) {
      d = Math.abs(s.y - h.y).toFixed();
      m = s.y - (d / 2);
      if (h.x < s.x) {
        this.makeLine([s.midX, h.y + 5], [s.midX, s.y - 4]);
        this.makeLabel(s.midX, m, d);
      } else {
        this.makeLine([s.midX, h.y + 5], [s.midX, s.y - 4]);
        this.makeLabel(s.midX, m, d);
      }
    }
    if (s.x > h.maxX) {
      d = Math.abs(s.x - h.maxX).toFixed();
      m = s.x - (d / 2);
      this.makeLine([h.maxX + 5, s.midY], [s.x - 4, s.midY]);
      this.makeLabel(m, h.midY, d);
    } else if (s.x > h.x) {
      d = Math.abs(s.x - h.x).toFixed();
      m = s.x - (d / 2);
      if (s.y > h.maxY) {
        this.makeLine([h.x + 5, s.midY], [s.x - 4, s.midY]);
        this.makeLabel(m, s.midY, d);
      } else {
        this.makeLine([h.x + 5, s.midY], [s.x - 4, s.midY]);
        this.makeLabel(m, s.midY, d);
      }
    }
    if (s.maxX < h.x) {
      d = Math.abs(h.x - s.maxX).toFixed();
      m = s.maxX + (d / 2);
      this.makeLine([s.maxX + 5, s.midY], [h.x - 4, s.midY]);
      this.makeLabel(m, s.midY, d);
    } else if (s.x < h.x) {
      d = Math.abs(h.x - s.x).toFixed();
      m = s.x + (d / 2);
      if (s.y > h.maxY) {
        this.makeLine([s.x + 5, h.midY], [h.x - 4, h.midY]);
        this.makeLabel(m, h.midY, d);
      } else {
        this.makeLine([s.x + 5, s.midY], [h.x - 4, s.midY]);
        this.makeLabel(m, s.midY, d);
      }
    }
    if (s.maxY < h.y) {
      d = Math.abs(h.y - s.maxY).toFixed();
      m = s.maxY + (d / 2);
      this.makeLine([s.midX, s.maxY + 5], [s.midX, h.y - 4]);
      this.makeLabel(s.midX, m, d);
    } else if (s.y < h.y) {
      d = Math.abs(h.y - s.y).toFixed();
      m = s.y + (d / 2);
      if (h.x < s.x) {
        this.makeLine([h.midX, s.y + 5], [h.midX, h.y - 4]);
        this.makeLabel(h.midX, m, d);
      } else {
        this.makeLine([h.midX, s.y + 5], [h.midX, h.y - 4]);
        this.makeLabel(h.midX, m, d);
      }
    }
    return this.makeBoundingRects(s, h);
  };

  Fraplin.prototype.makeBoundingRects = function(s, h) {
    var hoveredRect, selectedRect;
    hoveredRect = new SVGShape({
      type: 'rect',
      parent: ctx,
      x: h.x + 1,
      y: h.y + 1,
      width: h.width - 2,
      height: h.height - 2,
      stroke: 'blue',
      fill: 'none',
      'stroke-width': '1px'
    });
    return selectedRect = new SVGShape({
      type: 'rect',
      parent: ctx,
      x: s.x + 1,
      y: s.y + 1,
      width: s.width - 2,
      height: s.height - 2,
      stroke: 'red',
      fill: 'none',
      'stroke-width': '1px'
    });
  };

  Fraplin.prototype.setWindowLabel = function(layerName, value) {
    return this.window[layerName].value = value != null ? value : '';
  };

  Fraplin.prototype.setWindowLabels = function() {
    var h, he, s, se;
    h = this.hoveredLayer;
    he = this.hoveredElement;
    s = this.selectedLayer;
    se = this.selectedElement;
    if ((s == null) && (h == null)) {
      this.setWindowLabel('componentLabel', '');
      this.setWindowLabel('xLabel', '');
      this.setWindowLabel('yLabel', '');
      this.setWindowLabel('widthLabel', '');
      this.setWindowLabel('heightLabel', '');
      this.setWindowLabel('radiusLabel', '');
      this.setWindowLabel('borderLabel', '');
      return;
    }
    if ((h != null) && (s == null)) {
      this.setWindowLabel('componentLabel', h.constructor.name);
      this.setWindowLabel('xLabel', h.x);
      this.setWindowLabel('yLabel', h.y);
      this.setWindowLabel('widthLabel', h.screenFrame.width);
      this.setWindowLabel('heightLabel', h.screenFrame.height);
      this.setWindowLabel('radiusLabel', h.borderRadius);
      if (h.borderWidth > 0) {
        this.setWindowLabel('borderLabel', h.borderWidth + ' ' + h.borderColor);
      } else {
        this.setWindowLabel('borderLabel', 'none');
      }
      if (h.shadowX > 0 || h.shadowY > 0 || h.shadowSpread > 0) {
        this.setWindowLabel('shadowLabel', h.shadowX + ' ' + h.shadowY + ' ' + h.shadowSpread + ' ' + h.shadowColor);
      } else {
        this.setWindowLabel('shadowLabel', 'none');
      }
    }
  };

  Fraplin.prototype.focus = function(event) {
    var ref;
    if (this.enabled === false) {
      return;
    }
    this.unfocus();
    if (this.selectedElement == null) {
      this.selectedElement = this.screenElement;
    }
    this.hoveredElement = (ref = event != null ? event.target : void 0) != null ? ref : this.hoveredElement;
    if (!this.hoveredElement) {
      return;
    }
    if (this.hoveredElement === this.window._element) {
      this.hoveredElement = this.screenElement;
    }
    this.selectedLayer = this.getLayerFromElement(this.selectedElement);
    this.hoveredLayer = this.getLayerFromElement(this.hoveredElement);
    this.setWindowLabels();
    this.showDistances(this.selectedElement, this.hoveredElement);
    if (this.screenElement === this.hoveredElement) {
      return;
    }
    return this.hoveredElement.addEventListener('click', this.select);
  };

  Fraplin.prototype.unfocus = function(event) {
    return ctx.removeAll();
  };

  return Fraplin;

})();

exports.fraplin = new Fraplin;


},{}]},{},[])
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZnJhbWVyLm1vZHVsZXMuanMiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uL1VzZXJzL3N0ZXBoZW5ydWl6L0RvY3VtZW50cy9GcmFtZXIvRnJhcGxpbi5mcmFtZXIvbW9kdWxlcy9mcmFwbGluLmNvZmZlZSIsIm5vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiXSwic291cmNlc0NvbnRlbnQiOlsiIyBTVkdDb250ZXh0XG5cbkZyYW1lci5FeHRyYXMuSGludHMuZGlzYWJsZSgpXG5cbnN2Z0NvbnRleHQgPSB1bmRlZmluZWRcblxuY2xhc3MgU1ZHQ29udGV4dFxuXHRjb25zdHJ1Y3RvcjogKG9wdGlvbnMgPSB7fSkgLT5cblx0XHRAX19jb25zdHJ1Y3RvciA9IHRydWVcblx0XHRcblx0XHRAc2hhcGVzID0gW11cblxuXHRcdHN2Z0NvbnRleHQgPSBAXG5cblx0XHQjIG5hbWVzcGFjZVxuXHRcdHN2Z05TID0gXCJodHRwOi8vd3d3LnczLm9yZy8yMDAwL3N2Z1wiXG5cdFx0XG5cdFx0IyBzZXQgYXR0cmlidXRlcyBcblx0XHRzZXRBdHRyaWJ1dGVzID0gKGVsZW1lbnQsIGF0dHJpYnV0ZXMgPSB7fSkgLT5cblx0XHRcdGZvciBrZXksIHZhbHVlIG9mIGF0dHJpYnV0ZXNcblx0XHRcdFx0ZWxlbWVudC5zZXRBdHRyaWJ1dGUoa2V5LCB2YWx1ZSlcblxuXHRcdEBmcmFtZUxheWVyID0gbmV3IExheWVyXG5cdFx0XHRzaXplOiBTY3JlZW4uc2l6ZVxuXHRcdFx0bmFtZTogJy4nXG5cdFx0XHR2aXNpYmxlOiBmYWxzZVxuXG5cdFx0QGZyYW1lRWxlbWVudCA9IEBmcmFtZUxheWVyLl9lbGVtZW50XG5cblx0XHRAbEZyYW1lID0gQGZyYW1lRWxlbWVudC5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKVxuXG5cblx0XHRfLmFzc2lnbiBALFxuXHRcdFx0d2lkdGg6IEBsRnJhbWUud2lkdGgudG9GaXhlZCgpXG5cdFx0XHRoZWlnaHQ6IEBsRnJhbWUuaGVpZ2h0LnRvRml4ZWQoKVxuXHRcdFx0eDogQGxGcmFtZS5sZWZ0LnRvRml4ZWQoKVxuXHRcdFx0eTogQGxGcmFtZS50b3AudG9GaXhlZCgpXG5cblx0XHQjIENyZWF0ZSBTVkcgZWxlbWVudFxuXG5cdFx0QHN2ZyA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnROUyhzdmdOUywgJ3N2ZycpXG5cdFxuXHRcdGNvbnRleHQgPSBkb2N1bWVudC5nZXRFbGVtZW50QnlJZCgnRnJhbWVyQ29udGV4dFJvb3QtVG91Y2hFbXVsYXRvcicpXG5cdFx0Y29udGV4dC5hcHBlbmRDaGlsZChAc3ZnKVxuXG5cdFx0QHNjcmVlbkVsZW1lbnQgPSBkb2N1bWVudC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lKCdmcmFtZXJDb250ZXh0JylbMF1cblx0XHRzRnJhbWUgPSBAc2NyZWVuRWxlbWVudC5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKVxuXG5cdFx0c2V0QXR0cmlidXRlcyBAc3ZnLFxuXHRcdFx0eDogMFxuXHRcdFx0eTogMFxuXHRcdFx0d2lkdGg6IHNGcmFtZS53aWR0aFxuXHRcdFx0aGVpZ2h0OiBzRnJhbWUuaGVpZ2h0XG5cdFx0XHR2aWV3Qm94OiBcIjAgMCAje3NGcmFtZS53aWR0aH0gI3tzRnJhbWUuaGVpZ2h0fVwiXG5cblx0XHRfLmFzc2lnbiBAc3ZnLnN0eWxlLFxuXHRcdFx0cG9zaXRpb246IFwiYWJzb2x1dGVcIlxuXHRcdFx0bGVmdDogMFxuXHRcdFx0dG9wOiAwXG5cdFx0XHR3aWR0aDogJzEwMCUnXG5cdFx0XHRoZWlnaHQ6ICcxMDAlJ1xuXHRcdFx0J3BvaW50ZXItZXZlbnRzJzogJ25vbmUnXG5cblx0XHQjIGRlZnNcblx0XHRcblx0XHRAc3ZnRGVmcyA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnROUyhzdmdOUywgJ2RlZnMnKVxuXHRcdEBzdmcuYXBwZW5kQ2hpbGQgQHN2Z0RlZnNcblx0XHRcblx0XHRkZWxldGUgQF9fY29uc3RydWN0b3JcblxuXHRhZGRTaGFwZTogKHNoYXBlKSAtPlxuXHRcdEBzaGFwZXMucHVzaChzaGFwZSlcblx0XHRAc2hvd1NoYXBlKHNoYXBlKVxuXHRcdFxuXHRyZW1vdmVTaGFwZTogKHNoYXBlKSAtPlxuXHRcdEBoaWRlU2hhcGUoc2hhcGUpXG5cdFx0Xy5wdWxsKEBzaGFwZXMsIHNoYXBlKVxuXHRcdFxuXHRoaWRlU2hhcGU6IChzaGFwZSkgLT5cblx0XHRAc3ZnLnJlbW92ZUNoaWxkKHNoYXBlLmVsZW1lbnQpXG5cdFxuXHRzaG93U2hhcGU6IChzaGFwZSkgLT5cblx0XHRAc3ZnLmFwcGVuZENoaWxkKHNoYXBlLmVsZW1lbnQpXG5cdFx0XG5cdGFkZERlZjogKGRlZikgLT5cblx0XHRAc3ZnRGVmcy5hcHBlbmRDaGlsZChkZWYpXG5cblx0cmVtb3ZlQWxsOiA9PlxuXHRcdGZvciBzaGFwZSBpbiBAc2hhcGVzXG5cdFx0XHRAc3ZnLnJlbW92ZUNoaWxkKHNoYXBlLmVsZW1lbnQpXG5cdFx0QHNoYXBlcyA9IFtdXG5cbiMgU1ZHU2hhcGVcbmNsYXNzIFNWR1NoYXBlXG5cdGNvbnN0cnVjdG9yOiAob3B0aW9ucyA9IHt0eXBlOiAnY2lyY2xlJ30pIC0+XG5cdFx0QF9fY29uc3RydWN0b3IgPSB0cnVlXG5cdFx0XG5cdFx0QHBhcmVudCA9IHN2Z0NvbnRleHRcblx0XHRcblx0XHRAZWxlbWVudCA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnROUyhcblx0XHRcdFwiaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmdcIiwgXG5cdFx0XHRvcHRpb25zLnR5cGVcblx0XHRcdClcblxuXHRcdEBzZXRDdXN0b21Qcm9wZXJ0eSgndGV4dCcsICd0ZXh0Q29udGVudCcsICd0ZXh0Q29udGVudCcsIG9wdGlvbnMudGV4dClcblx0XHRcdFx0XG5cdFx0IyBhc3NpZ24gYXR0cmlidXRlcyBzZXQgYnkgb3B0aW9uc1xuXHRcdGZvciBrZXksIHZhbHVlIG9mIG9wdGlvbnNcblx0XHRcdEBzZXRBdHRyaWJ1dGUoa2V5LCB2YWx1ZSlcblxuXHRcdEBwYXJlbnQuYWRkU2hhcGUoQClcblx0XHRcblx0XHRAc2hvdygpXG5cdFx0XHRcblx0c2V0QXR0cmlidXRlOiAoa2V5LCB2YWx1ZSkgPT5cblx0XHRyZXR1cm4gaWYga2V5IGlzICd0ZXh0J1xuXHRcdGlmIG5vdCBAW2tleV0/XG5cdFx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkgQCxcblx0XHRcdFx0a2V5LFxuXHRcdFx0XHRnZXQ6ID0+XG5cdFx0XHRcdFx0cmV0dXJuIEBlbGVtZW50LmdldEF0dHJpYnV0ZShrZXkpXG5cdFx0XHRcdHNldDogKHZhbHVlKSA9PiBcblx0XHRcdFx0XHRAZWxlbWVudC5zZXRBdHRyaWJ1dGUoa2V5LCB2YWx1ZSlcblx0XHRcblx0XHRAW2tleV0gPSB2YWx1ZVxuXHRcblx0c2V0Q3VzdG9tUHJvcGVydHk6ICh2YXJpYWJsZU5hbWUsIHJldHVyblZhbHVlLCBzZXRWYWx1ZSwgc3RhcnRWYWx1ZSkgLT5cblx0XHRPYmplY3QuZGVmaW5lUHJvcGVydHkgQCxcblx0XHRcdHZhcmlhYmxlTmFtZSxcblx0XHRcdGdldDogLT5cblx0XHRcdFx0cmV0dXJuIHJldHVyblZhbHVlXG5cdFx0XHRzZXQ6ICh2YWx1ZSkgLT5cblx0XHRcdFx0QGVsZW1lbnRbc2V0VmFsdWVdID0gdmFsdWVcblxuXHRcdEBbdmFyaWFibGVOYW1lXSA9IHN0YXJ0VmFsdWVcblxuXHRoaWRlOiAtPiBcblx0XHRAcGFyZW50LmhpZGVTaGFwZShAKVxuXHRcblx0c2hvdzogLT4gXG5cdFx0QHBhcmVudC5zaG93U2hhcGUoQClcblx0XHRcblx0cmVtb3ZlOiAtPlxuXHRcdEBwYXJlbnQucmVtb3ZlU2hhcGUoQClcblxuY2xhc3MgTGFiZWwgZXh0ZW5kcyBUZXh0TGF5ZXJcblx0Y29uc3RydWN0b3I6IChvcHRpb25zID0ge30pIC0+XG5cdFx0QF9fY29uc3RydWN0b3IgPSB0cnVlXG5cblx0XHRfLmFzc2lnbiBvcHRpb25zLFxuXHRcdFx0bmFtZTogJy4nXG5cdFx0XHRmb250U2l6ZTogMTJcblx0XHRcdGZvbnRXZWlnaHQ6IDUwMFxuXHRcdFx0Y29sb3I6ICcjNzc3J1xuXHRcdFx0Zm9udEZhbWlseTogJ01lbmxvJ1xuXG5cdFx0Xy5kZWZhdWx0cyBvcHRpb25zLFxuXHRcdFx0dGV4dDogJ3gnXG5cdFx0XHR2YWx1ZTogMFxuXG5cdFx0dyA9IG9wdGlvbnMud2lkdGhcblx0XHRkZWxldGUgb3B0aW9ucy53aWR0aFxuXG5cdFx0c3VwZXIgb3B0aW9uc1xuXG5cdFx0QHZhbHVlTGF5ZXIgPSBuZXcgVGV4dExheWVyXG5cdFx0XHRwYXJlbnQ6IEBwYXJlbnRcblx0XHRcdG5hbWU6ICcuJ1xuXHRcdFx0Zm9udFNpemU6IEBmb250U2l6ZVxuXHRcdFx0Zm9udFdlaWdodDogNTAwXG5cdFx0XHRjb2xvcjogJyMzMzMnXG5cdFx0XHRmb250RmFtaWx5OiBAZm9udEZhbWlseVxuXHRcdFx0eDogQHggKyB3XG5cdFx0XHR5OiBAeVxuXHRcdFx0dGV4dDogJ3t2YWx1ZX0nXG5cblx0XHRkZWxldGUgQF9fY29uc3RydWN0b3JcblxuXHRcdEB2YWx1ZSA9IG9wdGlvbnMudmFsdWVcblx0XHRcblxuXHRAZGVmaW5lIFwidmFsdWVcIixcblx0XHRnZXQ6IC0+IHJldHVybiBAX3ZhbHVlXG5cdFx0c2V0OiAodmFsdWUpIC0+XG5cdFx0XHRyZXR1cm4gaWYgQF9fY29uc3RydWN0b3Jcblx0XHRcdEBfdmFsdWUgPSB2YWx1ZVxuXHRcdFx0QHZhbHVlTGF5ZXIudGVtcGxhdGUgPSB2YWx1ZVxuXG5jdHggPSBuZXcgU1ZHQ29udGV4dFxuXHRzaXplOiBTY3JlZW4uc2l6ZVxuXHRiYWNrZ3JvdW5kQ29sb3I6IG51bGxcblxuXG5cblxuXG4jIyNcblx0IDg4ODg4ODg4YiAgICAgICAgICAgICAgICAgICAgICAgICAgICBkUCBvb1xuXHQgODggICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDg4XG5cdGE4OGFhYWEgICAgODhkODg4Yi4gLmQ4ODg4Yi4gODhkODg4Yi4gODggZFAgODhkODg4Yi5cblx0IDg4ICAgICAgICA4OCcgIGA4OCA4OCcgIGA4OCA4OCcgIGA4OCA4OCA4OCA4OCcgIGA4OFxuXHQgODggICAgICAgIDg4ICAgICAgIDg4LiAgLjg4IDg4LiAgLjg4IDg4IDg4IDg4ICAgIDg4XG5cdCBkUCAgICAgICAgZFAgICAgICAgYDg4ODg4UDggODhZODg4UCcgZFAgZFAgZFAgICAgZFBcblx0ICAgICAgICAgICAgICAgICAgICAgICAgICAgICA4OFxuXHQgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGRQXG4jIyNcblxuXG5jbGFzcyBGcmFwbGluXG5cdGNvbnN0cnVjdG9yOiAob3B0aW9ucyA9IHt9KSAtPlxuXG5cdFx0Xy5kZWZhdWx0cyBvcHRpb25zLFxuXHRcdFx0Y29sb3I6ICdyZWQnXG5cdFx0XHRzZWNvbmRhcnlDb2xvcjogJ3doaXRlJ1xuXHRcdFx0Zm9udEZhbWlseTogJ0FyaWFsJ1xuXHRcdFx0Zm9udFNpemU6ICcxMCdcblx0XHRcdGZvbnRXZWlnaHQ6ICc2MDAnXG5cdFx0XHRib3JkZXJSYWRpdXM6IDRcblx0XHRcdHBhZGRpbmc6IHt0b3A6IDIsIGJvdHRvbTogMiwgbGVmdDogNCwgcmlnaHQ6IDR9XG5cblx0XHRfLmFzc2lnbiBALFxuXHRcdFx0Y29sb3I6IG9wdGlvbnMuY29sb3Jcblx0XHRcdHNlY29uZGFyeUNvbG9yOiBvcHRpb25zLnNlY29uZGFyeUNvbG9yXG5cdFx0XHRmb250RmFtaWx5OiBvcHRpb25zLmZvbnRGYW1pbHlcblx0XHRcdGZvbnRTaXplOiBvcHRpb25zLmZvbnRTaXplXG5cdFx0XHRmb250V2VpZ2h0OiBvcHRpb25zLmZvbnRXZWlnaHRcblx0XHRcdHNoYXBlczogW11cblx0XHRcdGJvcmRlclJhZGl1czogb3B0aW9ucy5ib3JkZXJSYWRpdXNcblx0XHRcdHBhZGRpbmc6IG9wdGlvbnMucGFkZGluZ1xuXHRcdFx0Zm9jdXNlZEVsZW1lbnQ6IHVuZGVmaW5lZFxuXHRcdFx0ZW5hYmxlZDogZmFsc2Vcblx0XHRcdHNjcmVlbkVsZW1lbnQ6IGRvY3VtZW50LmdldEVsZW1lbnRzQnlDbGFzc05hbWUoJ0RldmljZUNvbXBvbmVudFBvcnQnKVswXVxuXHRcdFx0dmlld3BvcnQ6IGRvY3VtZW50LmdldEVsZW1lbnRzQnlDbGFzc05hbWUoJ0RldmljZUNvbXBvbmVudFBvcnQnKVswXVxuXHRcdFx0bGF5ZXJzOiBbXVxuXG5cdFx0ZG9jdW1lbnQuYWRkRXZlbnRMaXN0ZW5lcigna2V5dXAnLCBAdG9nZ2xlKVxuXG5cdFx0QGNvbnRleHQgPSBkb2N1bWVudC5nZXRFbGVtZW50c0J5Q2xhc3NOYW1lKCdmcmFtZXJMYXllciBEZXZpY2VTY3JlZW4nKVswXVxuXHRcdEBjb250ZXh0LmNsYXNzTGlzdC5hZGQoJ2hvdmVyQ29udGV4dCcpXG5cblx0XHRAY29udGV4dC5jaGlsZE5vZGVzWzJdLmNsYXNzTGlzdC5hZGQoJ0lnbm9yZVBvaW50ZXJFdmVudHMnKVxuXG5cdFx0QGNvbnRleHQuYWRkRXZlbnRMaXN0ZW5lcihcIm1vdXNlb3ZlclwiLCBAZm9jdXMpXG5cdFx0QGNvbnRleHQuYWRkRXZlbnRMaXN0ZW5lcihcIm1vdXNlb3V0XCIsIEB1bmZvY3VzKVxuXG5cdFx0VXRpbHMuaW5zZXJ0Q1NTIFwiXCJcIiBcblx0XHRcdC5mcmFtZXJMYXllciB7IFxuXHRcdFx0XHRwb2ludGVyLWV2ZW50czogYWxsICFpbXBvcnRhbnQ7IFxuXHRcdFx0XHR9IFxuXG5cdFx0XHQuRGV2aWNlQ29udGVudCB7XG5cdFx0XHRcdHBvaW50ZXItZXZlbnRzOiBub25lICFpbXBvcnRhbnQ7IFxuXHRcdFx0XHR9XG5cblx0XHRcdC5EZXZpY2VCYWNrZ3JvdW5kIHtcblx0XHRcdFx0cG9pbnRlci1ldmVudHM6IG5vbmUgIWltcG9ydGFudDsgXG5cdFx0XHRcdH1cblxuXHRcdFx0LkRldmljZUhhbmRzIHtcblx0XHRcdFx0cG9pbnRlci1ldmVudHM6IG5vbmUgIWltcG9ydGFudDsgXG5cdFx0XHRcdH1cblxuXHRcdFx0LkRldmljZUNvbXBvbmVudFBvcnQge1xuXHRcdFx0XHRwb2ludGVyLWV2ZW50czogbm9uZSAhaW1wb3J0YW50OyBcblx0XHRcdH1cblxuXHRcdFx0Lklnbm9yZVBvaW50ZXJFdmVudHMge1xuXHRcdFx0XHRwb2ludGVyLWV2ZW50czogbm9uZSAhaW1wb3J0YW50OyBcblx0XHRcdH1cblx0XHRcdFwiXCJcIlxuXG5cdFx0QHdpbmRvdyA9IG5ldyBMYXllclxuXHRcdFx0cGFyZW50OiBudWxsXG5cdFx0XHRuYW1lOiAnRGV0YWlscydcblx0XHRcdHk6IEFsaWduLmJvdHRvbSgtMTYpXG5cdFx0XHR4OiAzMlxuXHRcdFx0aGVpZ2h0OiAxNTZcblx0XHRcdHdpZHRoOiBTY3JlZW4ud2lkdGggLSA2NFxuXHRcdFx0YmFja2dyb3VuZENvbG9yOiAnI2Y1ZjVmNSdcblx0XHRcdGJvcmRlclJhZGl1czogNFxuXHRcdFx0c2hhZG93WDogMVxuXHRcdFx0c2hhZG93WTogM1xuXHRcdFx0c2hhZG93Qmx1cjogNlxuXHRcdFx0c2hhZG93Q29sb3I6ICdyZ2JhKDAsMCwwLC4zMCknXG5cdFx0XHR2aXNpYmxlOiBmYWxzZVxuXG5cdFx0QHdpbmRvdy5kcmFnZ2FibGUuZW5hYmxlZCA9IHRydWVcblx0XHRAd2luZG93LmRyYWdnYWJsZS5jb25zdHJhaW50cyA9IFxuXHRcdFx0d2lkdGg6IFNjcmVlbi53aWR0aFxuXHRcdFx0aGVpZ2h0OiBTY3JlZW4uaGVpZ2h0XG5cblx0XHRAd2luZG93Lm9uRG91YmxlQ2xpY2sgLT4gQHZpc2libGUgPSBmYWxzZVxuXG5cdFx0ZG8gXy5iaW5kKCAtPlxuXG5cdFx0XHRAeExhYmVsID0gbmV3IExhYmVsXG5cdFx0XHRcdHBhcmVudDogQFxuXHRcdFx0XHR4OiA4LCB5OiA4XG5cdFx0XHRcdHdpZHRoOiAyNFxuXHRcdFx0XHR0ZXh0OiAneDonXG5cblx0XHRcdEB5TGFiZWwgPSBuZXcgTGFiZWxcblx0XHRcdFx0cGFyZW50OiBAXG5cdFx0XHRcdHg6IDgsIHk6IDI4XG5cdFx0XHRcdHdpZHRoOiAyNFxuXHRcdFx0XHR0ZXh0OiAneTonXG5cblx0XHRcdEB3aWR0aExhYmVsID0gbmV3IExhYmVsXG5cdFx0XHRcdHBhcmVudDogQFxuXHRcdFx0XHR4OiA5NiwgeTogOFxuXHRcdFx0XHR3aWR0aDogNjBcblx0XHRcdFx0dGV4dDogJ3dpZHRoOidcblxuXHRcdFx0QGhlaWdodExhYmVsID0gbmV3IExhYmVsXG5cdFx0XHRcdHBhcmVudDogQFxuXHRcdFx0XHR4OiA5NiwgeTogMjhcblx0XHRcdFx0d2lkdGg6IDYwXG5cdFx0XHRcdHRleHQ6ICdoZWlnaHQ6J1xuXG5cdFx0XHRAcmFkaXVzTGFiZWwgPSBuZXcgTGFiZWxcblx0XHRcdFx0cGFyZW50OiBAXG5cdFx0XHRcdHg6IDgsIHk6IDQ4XG5cdFx0XHRcdHdpZHRoOiA2MFxuXHRcdFx0XHR0ZXh0OiAncmFkaXVzOidcblxuXHRcdFx0QGJvcmRlckxhYmVsID0gbmV3IExhYmVsXG5cdFx0XHRcdHBhcmVudDogQFxuXHRcdFx0XHR4OiA4LCB5OiA3MlxuXHRcdFx0XHR3aWR0aDogNjBcblx0XHRcdFx0dGV4dDogJ2JvcmRlcjonXG5cblx0XHRcdEBzaGFkb3dMYWJlbCA9IG5ldyBMYWJlbFxuXHRcdFx0XHRwYXJlbnQ6IEBcblx0XHRcdFx0eDogOCwgeTogOTZcblx0XHRcdFx0d2lkdGg6IDYwXG5cdFx0XHRcdHRleHQ6ICdzaGFkb3c6J1xuXG5cdFx0XHRAY29tcG9uZW50TGFiZWwgPSBuZXcgTGFiZWxcblx0XHRcdFx0cGFyZW50OiBAXG5cdFx0XHRcdHg6IDgsIHk6IDEyMFxuXHRcdFx0XHR3aWR0aDogODBcblx0XHRcdFx0dGV4dDogJ0NvbXBvbmVudDonXG5cblx0XHRcdEBjbG9zZSA9IG5ldyBUZXh0TGF5ZXJcblx0XHRcdFx0cGFyZW50OiBAXG5cdFx0XHRcdHk6IDBcblx0XHRcdFx0eDogQWxpZ24ucmlnaHQoKVxuXHRcdFx0XHR0ZXh0OiAneCdcblx0XHRcdFx0Zm9udEZhbWlseTogJ01lbmxvJ1xuXHRcdFx0XHRjb2xvcjogJyMzMzMnXG5cdFx0XHRcdGZvbnRTaXplOiAxNFxuXHRcdFx0XHRmb250V2VpZ2h0OiA2MDBcblx0XHRcdFx0cGFkZGluZzogOFxuXG5cdFx0XHRAY2xvc2Uub25UYXAgPT4gQHZpc2libGUgPSBmYWxzZVxuXG5cdFx0XHRAc3R5bGVbJ3BvaW50ZXItZXZlbnRzJ10gPSAnbm9uZSdcblxuXHRcdCwgQHdpbmRvdylcblxuXHRcdGZvciBsYXllciBpbiBAd2luZG93LmRlc2NlbmRhbnRzXG5cdFx0XHRsYXllci5jbGFzc0xpc3QuYWRkKCdJZ25vcmVQb2ludGVyRXZlbnRzJylcblxuXHR0b2dnbGU6IChldmVudCkgPT5cblx0XHRpZiBldmVudC5rZXkgaXMgXCJgXCJcblx0XHRcdGlmIEBlbmFibGVkIHRoZW4gQGRpc2FibGUoKSBlbHNlIEBlbmFibGUoKVxuXG5cdFx0XHRyZXR1cm5cblxuXHRcdGlmIGV2ZW50LmtleSBpcyBcIi9cIlxuXHRcdFx0cmV0dXJuIGlmIG5vdCBAZW5hYmxlZFxuXG5cdFx0XHRpZiBAaG92ZXJlZEVsZW1lbnQgaXMgQHNlbGVjdGVkRWxlbWVudFxuXHRcdFx0XHRAZGVzZWxlY3QoKVxuXHRcdFx0ZWxzZVxuXHRcdFx0XHRAc2VsZWN0KClcblxuXHRcdFx0cmV0dXJuXG5cblxuXHRyZXNldExheWVyczogPT5cblx0XHRAbGF5ZXJzID0gW11cblxuXHRcdGZvciBsYXllciBpbiBGcmFtZXIuQ3VycmVudENvbnRleHQuX2xheWVyc1xuXHRcdFx0QGxheWVycy5wdXNoIGxheWVyXG5cblx0ZW5hYmxlOiA9PlxuXG5cdFx0QHJlc2V0TGF5ZXJzKClcblxuXHRcdEBlbmFibGVkID0gdHJ1ZVxuXHRcdEB3aW5kb3cudmlzaWJsZSA9IHRydWVcblx0XHRAd2luZG93LmJyaW5nVG9Gcm9udCgpXG5cdFx0QGZvY3VzKClcblxuXHRkaXNhYmxlOiA9PlxuXG5cdFx0QGVuYWJsZWQgPSBmYWxzZVxuXHRcdEB3aW5kb3cudmlzaWJsZSA9IGZhbHNlXG5cdFx0QHdpbmRvdy5zZW5kVG9CYWNrKClcblx0XHRAdW5mb2N1cygpXG5cblxuXHRnZXRMYXllckZyb21FbGVtZW50OiAoZWxlbWVudCkgPT5cblx0XHRpZiBlbGVtZW50LmNsYXNzTGlzdC5jb250YWlucygnZnJhbWVyTGF5ZXInKVxuXHRcdFx0bGF5ZXIgPSBfLmZpbmQoQGxheWVycywgWydfZWxlbWVudCcsIGVsZW1lbnRdKVxuXHRcdGVsc2Vcblx0XHRcdGVsZW1lbnQgPSBlbGVtZW50LnBhcmVudE5vZGU/LnBhcmVudE5vZGU/LnBhcmVudE5vZGVcblx0XHRcdGxheWVyID0gXy5maW5kKEBsYXllcnMsIFsnX2VsZW1lbnQnLCBlbGVtZW50XSlcblxuXHRcdHJldHVybiBsYXllciBcblxuXHRzZWxlY3Q6IChldmVudCkgPT5cblx0XHRyZXR1cm4gaWYgbm90IEBob3ZlcmVkRWxlbWVudFxuXG5cdFx0QHNlbGVjdGVkRWxlbWVudCA9IEBob3ZlcmVkRWxlbWVudFxuXHRcdEBzZWxlY3RlZEVsZW1lbnQuYWRkRXZlbnRMaXN0ZW5lcignY2xpY2snLCBAZGVzZWxlY3QpXG5cdFx0QGZvY3VzKClcblxuXHRkZXNlbGVjdDogKGV2ZW50KSA9PlxuXHRcdEBzZWxlY3RlZEVsZW1lbnQucmVtb3ZlRXZlbnRMaXN0ZW5lcignY2xpY2snLCBAZGVzZWxlY3QpXG5cdFx0QHNlbGVjdGVkRWxlbWVudCA9IHVuZGVmaW5lZFxuXHRcdEBmb2N1cygpXG5cblxuXHRnZXREaW1lbnNpb25zOiAoZWxlbWVudCkgPT5cblx0XHRkID0gZWxlbWVudC5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKVxuXG5cdFx0ZGltZW5zaW9ucyA9IHtcblx0XHRcdHg6IGQubGVmdFxuXHRcdFx0eTogZC50b3Bcblx0XHRcdHdpZHRoOiBkLndpZHRoXG5cdFx0XHRoZWlnaHQ6IGQuaGVpZ2h0XG5cdFx0XHRtaWRYOiBkLmxlZnQgKyAoZC53aWR0aCAvIDIpXG5cdFx0XHRtaWRZOiBkLnRvcCArIChkLmhlaWdodCAvIDIpXG5cdFx0XHRtYXhYOiBkLmxlZnQgKyBkLndpZHRoXG5cdFx0XHRtYXhZOiBkLnRvcCArIGQuaGVpZ2h0XG5cdFx0XHRmcmFtZTogZFxuXHRcdH1cblxuXHRcdHJldHVybiBkaW1lbnNpb25zXG5cblx0bWFrZUxpbmU6IChwb2ludEEsIHBvaW50QiwgbGFiZWwgPSB0cnVlKSA9PlxuXHRcdGxpbmUgPSBuZXcgU1ZHU2hhcGVcblx0XHRcdHR5cGU6ICdwYXRoJ1xuXHRcdFx0ZDogXCJNICN7cG9pbnRBWzBdfSAje3BvaW50QVsxXX0gTCAje3BvaW50QlswXX0gI3twb2ludEJbMV19XCJcblx0XHRcdHN0cm9rZTogQGNvbG9yXG5cdFx0XHQnc3Ryb2tlLXdpZHRoJzogJzFweCdcblxuXHRcdGlmIHBvaW50QVswXSBpcyBwb2ludEJbMF1cblxuXHRcdFx0Y2FwQSA9IG5ldyBTVkdTaGFwZVxuXHRcdFx0XHR0eXBlOiAncGF0aCdcblx0XHRcdFx0ZDogXCJNICN7cG9pbnRBWzBdIC0gNH0gI3twb2ludEFbMV19IEwgI3twb2ludEFbMF0gKyA1fSAje3BvaW50QVsxXX1cIlxuXHRcdFx0XHRzdHJva2U6IEBjb2xvclxuXHRcdFx0XHQnc3Ryb2tlLXdpZHRoJzogJzFweCdcblxuXHRcdFx0Y2FwQiA9IG5ldyBTVkdTaGFwZVxuXHRcdFx0XHR0eXBlOiAncGF0aCdcblx0XHRcdFx0ZDogXCJNICN7cG9pbnRCWzBdIC0gNH0gI3twb2ludEJbMV19IEwgI3twb2ludEJbMF0gKyA1fSAje3BvaW50QlsxXX1cIlxuXHRcdFx0XHRzdHJva2U6IEBjb2xvclxuXHRcdFx0XHQnc3Ryb2tlLXdpZHRoJzogJzFweCdcblxuXHRcdGVsc2UgaWYgcG9pbnRBWzFdIGlzIHBvaW50QlsxXVxuXG5cdFx0XHRjYXBBID0gbmV3IFNWR1NoYXBlXG5cdFx0XHRcdHR5cGU6ICdwYXRoJ1xuXHRcdFx0XHRkOiBcIk0gI3twb2ludEFbMF19ICN7cG9pbnRBWzFdIC0gNH0gTCAje3BvaW50QVswXX0gI3twb2ludEFbMV0gKyA1fVwiXG5cdFx0XHRcdHN0cm9rZTogQGNvbG9yXG5cdFx0XHRcdCdzdHJva2Utd2lkdGgnOiAnMXB4J1xuXG5cdFx0XHRjYXBCID0gbmV3IFNWR1NoYXBlXG5cdFx0XHRcdHR5cGU6ICdwYXRoJ1xuXHRcdFx0XHRkOiBcIk0gI3twb2ludEJbMF19ICN7cG9pbnRCWzFdIC0gNH0gTCAje3BvaW50QlswXX0gI3twb2ludEJbMV0gKyA1fVwiXG5cdFx0XHRcdHN0cm9rZTogQGNvbG9yXG5cdFx0XHRcdCdzdHJva2Utd2lkdGgnOiAnMXB4J1xuXG5cdG1ha2VMYWJlbDogKHgsIHksIHRleHQpID0+XG5cdFx0bGFiZWwgPSBuZXcgU1ZHU2hhcGVcblx0XHRcdHR5cGU6ICd0ZXh0J1xuXHRcdFx0cGFyZW50OiBjdHhcblx0XHRcdHg6IHhcblx0XHRcdHk6IHlcblx0XHRcdCdmb250LWZhbWlseSc6IEBmb250RmFtaWx5XG5cdFx0XHQnZm9udC1zaXplJzogQGZvbnRTaXplXG5cdFx0XHQnZm9udC13ZWlnaHQnOiBAZm9udFdlaWdodFxuXHRcdFx0ZmlsbDogQHNlY29uZGFyeUNvbG9yXG5cdFx0XHR0ZXh0OiAodGV4dCAvIEByYXRpbykudG9GaXhlZCgpXG5cblx0XHRsID0gQGdldERpbWVuc2lvbnMobGFiZWwuZWxlbWVudClcblxuXHRcdGxhYmVsLnggPSB4IC0gbC53aWR0aCAvIDJcblx0XHRsYWJlbC55ID0geSArIGwuaGVpZ2h0IC8gNFxuXG5cdFx0Ym94ID0gbmV3IFNWR1NoYXBlXG5cdFx0XHR0eXBlOiAncmVjdCdcblx0XHRcdHBhcmVudDogY3R4XG5cdFx0XHR4OiBsYWJlbC54IC0gQHBhZGRpbmcubGVmdFxuXHRcdFx0eTogbGFiZWwueSAtIGwuaGVpZ2h0XG5cdFx0XHR3aWR0aDogbC53aWR0aCArIEBwYWRkaW5nLmxlZnQgKyBAcGFkZGluZy5yaWdodFxuXHRcdFx0aGVpZ2h0OiBsLmhlaWdodCArIEBwYWRkaW5nLnRvcCArIEBwYWRkaW5nLmJvdHRvbVxuXHRcdFx0cng6IEBib3JkZXJSYWRpdXNcblx0XHRcdHJ5OiBAYm9yZGVyUmFkaXVzXG5cdFx0XHRmaWxsOiBAY29sb3JcblxuXHRcdGxhYmVsLnNob3coKVxuXG5cdHNob3dEaXN0YW5jZXM6IChzZWxlY3RlZCwgaG92ZXJlZCkgPT5cblxuXHRcdHMgPSBAZ2V0RGltZW5zaW9ucyhAc2VsZWN0ZWRFbGVtZW50KVxuXHRcdGggPSBAZ2V0RGltZW5zaW9ucyhAaG92ZXJlZEVsZW1lbnQpXG5cblx0XHRAcmF0aW8gPSBAc2NyZWVuRWxlbWVudC5nZXRCb3VuZGluZ0NsaWVudFJlY3QoKS53aWR0aCAvIFNjcmVlbi53aWR0aFxuXG5cdFx0QHNldFdpbmRvd0xhYmVscyhzKVxuXG5cdFx0aWYgQHNlbGVjdGVkRWxlbWVudCBpcyBAaG92ZXJlZEVsZW1lbnRcblx0XHRcdGggPSBAZ2V0RGltZW5zaW9ucyhAc2NyZWVuRWxlbWVudClcblxuXHRcdCMgV2hlbiBzZWxlY3RlZCBlbGVtZW50IGNvbnRhaW5zIGhvdmVyZWQgZWxlbWVudFxuXG5cdFx0aWYgcy54IDwgaC54IGFuZCBzLm1heFggPiBoLm1heFggYW5kIHMueSA8IGgueSBhbmQgcy5tYXhZID4gaC5tYXhZXG5cdFx0XHRcblx0XHRcdCMgdG9wXG5cblx0XHRcdGQgPSBNYXRoLmFicyhzLnkgLSBoLnkpLnRvRml4ZWQoKVxuXHRcdFx0bSA9IHMueSArIGQgLyAyXG5cblx0XHRcdEBtYWtlTGluZShbaC5taWRYLCBzLnkgKyA1XSwgW2gubWlkWCwgaC55IC0gNF0pXG5cdFx0XHRAbWFrZUxhYmVsKGgubWlkWCwgbSwgZClcblxuXHRcdFx0IyByaWdodFxuXG5cdFx0XHRkID0gTWF0aC5hYnMocy5tYXhYIC0gaC5tYXhYKS50b0ZpeGVkKClcblx0XHRcdG0gPSBoLm1heFggKyAoZCAvIDIpXG5cblx0XHRcdEBtYWtlTGluZShbaC5tYXhYICsgNSwgaC5taWRZXSwgW3MubWF4WCAtIDQsIGgubWlkWV0pXG5cdFx0XHRAbWFrZUxhYmVsKG0sIGgubWlkWSwgZClcblxuXHRcdFx0IyBib3R0b21cblxuXHRcdFx0ZCA9IE1hdGguYWJzKHMubWF4WSAtIGgubWF4WSkudG9GaXhlZCgpXG5cdFx0XHRtID0gaC5tYXhZICsgKGQgLyAyKVxuXG5cdFx0XHRAbWFrZUxpbmUoW2gubWlkWCwgaC5tYXhZICsgNV0sIFtoLm1pZFgsIHMubWF4WSAtIDRdKVxuXHRcdFx0QG1ha2VMYWJlbChoLm1pZFgsIG0sIGQpXG5cblx0XHRcdCMgbGVmdFxuXG5cdFx0XHRkID0gTWF0aC5hYnMocy54IC0gaC54KS50b0ZpeGVkKClcblx0XHRcdG0gPSBzLnggKyBkIC8gMlxuXG5cdFx0XHRAbWFrZUxpbmUoW3MueCArIDUsIGgubWlkWV0sIFtoLnggLSA0LCBoLm1pZFldKVxuXHRcdFx0QG1ha2VMYWJlbChtLCBoLm1pZFksIGQpXG5cblx0XHRcdEBtYWtlQm91bmRpbmdSZWN0cyhzLCBoKVxuXG5cdFx0XHRyZXR1cm5cblxuXHRcdCMgV2hlbiBob3ZlcmVkIGVsZW1lbnQgY29udGFpbnMgc2VsZWN0ZWQgZWxlbWVudFxuXG5cdFx0aWYgcy54ID4gaC54IGFuZCBzLm1heFggPCBoLm1heFggYW5kIHMueSA+IGgueSBhbmQgcy5tYXhZIDwgaC5tYXhZXG5cdFx0XHRcblx0XHRcdCMgdG9wXG5cblx0XHRcdGQgPSBNYXRoLmFicyhoLnkgLSBzLnkpLnRvRml4ZWQoKVxuXHRcdFx0bSA9IGgueSArIGQgLyAyXG5cblx0XHRcdEBtYWtlTGluZShbcy5taWRYLCBoLnkgKyA1XSwgW3MubWlkWCwgcy55IC0gNF0pXG5cdFx0XHRAbWFrZUxhYmVsKHMubWlkWCwgbSwgZClcblx0XHRcdEBzZXRXaW5kb3dMYWJlbCgneUxhYmVsJywgZClcblxuXHRcdFx0IyByaWdodFxuXG5cdFx0XHRkID0gTWF0aC5hYnMoaC5tYXhYIC0gcy5tYXhYKS50b0ZpeGVkKClcblx0XHRcdG0gPSBzLm1heFggKyAoZCAvIDIpXG5cblx0XHRcdEBtYWtlTGluZShbcy5tYXhYICsgNSwgcy5taWRZXSwgW2gubWF4WCAtIDQsIHMubWlkWV0pXG5cdFx0XHRAbWFrZUxhYmVsKG0sIHMubWlkWSwgZClcblxuXHRcdFx0IyBib3R0b21cblxuXHRcdFx0ZCA9IE1hdGguYWJzKGgubWF4WSAtIHMubWF4WSkudG9GaXhlZCgpXG5cdFx0XHRtID0gcy5tYXhZICsgKGQgLyAyKVxuXG5cdFx0XHRAbWFrZUxpbmUoW3MubWlkWCwgcy5tYXhZICsgNV0sIFtzLm1pZFgsIGgubWF4WSAtIDRdKVxuXHRcdFx0QG1ha2VMYWJlbChzLm1pZFgsIG0sIGQpXG5cblx0XHRcdCMgbGVmdFxuXG5cdFx0XHRkID0gTWF0aC5hYnMoaC54IC0gcy54KS50b0ZpeGVkKClcblx0XHRcdG0gPSBoLnggKyBkIC8gMlxuXG5cdFx0XHRAbWFrZUxpbmUoW2gueCArIDUsIHMubWlkWV0sIFtzLnggLSA0LCBzLm1pZFldKVxuXHRcdFx0QG1ha2VMYWJlbChtLCBzLm1pZFksIGQpXG5cdFx0XHRAc2V0V2luZG93TGFiZWwoJ3hMYWJlbCcsIGQpXG5cblx0XHRcdEBtYWtlQm91bmRpbmdSZWN0cyhzLCBoKVxuXG5cdFx0XHRyZXR1cm5cblxuXHRcdCMgV2hlbiBzZWxlY3RlZCBlbGVtZW50IGRvZXNuJ3QgY29udGFpbiBob3ZlcmVkIGVsZW1lbnRcblx0XHRcblx0XHQjIHRvcFxuXG5cdFx0aWYgcy55ID4gaC5tYXhZXG5cblx0XHRcdGQgPSBNYXRoLmFicyhzLnkgLSBoLm1heFkpLnRvRml4ZWQoKVxuXHRcdFx0bSA9IHMueSAtIChkIC8gMilcblxuXHRcdFx0QG1ha2VMaW5lKFtzLm1pZFgsIGgubWF4WSArIDVdLCBbcy5taWRYLCBzLnkgLSA0XSlcblx0XHRcdEBtYWtlTGFiZWwocy5taWRYLCBtLCBkKVxuXG5cdFx0ZWxzZSBpZiBzLnkgPiBoLnlcblxuXHRcdFx0ZCA9IE1hdGguYWJzKHMueSAtIGgueSkudG9GaXhlZCgpXG5cdFx0XHRtID0gcy55IC0gKGQgLyAyKVxuXG5cdFx0XHRpZiBoLnggPCBzLnhcblx0XHRcdFx0QG1ha2VMaW5lKFtzLm1pZFgsIGgueSArIDVdLCBbcy5taWRYLCBzLnkgLSA0XSlcblx0XHRcdFx0QG1ha2VMYWJlbChzLm1pZFgsIG0sIGQpXG5cdFx0XHRlbHNlXG5cdFx0XHRcdEBtYWtlTGluZShbcy5taWRYLCBoLnkgKyA1XSwgW3MubWlkWCwgcy55IC0gNF0pXG5cdFx0XHRcdEBtYWtlTGFiZWwocy5taWRYLCBtLCBkKVxuXG5cdFx0IyBsZWZ0XG5cblx0XHRpZiBzLnggPiBoLm1heFhcblxuXHRcdFx0ZCA9IE1hdGguYWJzKHMueCAtIGgubWF4WCkudG9GaXhlZCgpXG5cdFx0XHRtID0gcy54IC0gKGQgLyAyKVxuXG5cdFx0XHRAbWFrZUxpbmUoW2gubWF4WCArIDUsIHMubWlkWV0sIFtzLnggLSA0LCBzLm1pZFldKVxuXHRcdFx0QG1ha2VMYWJlbChtLCBoLm1pZFksIGQpXG5cblx0XHRlbHNlIGlmIHMueCA+IGgueFxuXG5cdFx0XHRkID0gTWF0aC5hYnMocy54IC0gaC54KS50b0ZpeGVkKClcblx0XHRcdG0gPSBzLnggLSAoZCAvIDIpXG5cblx0XHRcdGlmIHMueSA+IGgubWF4WVxuXHRcdFx0XHRAbWFrZUxpbmUoW2gueCArIDUsIHMubWlkWV0sIFtzLnggLSA0LCBzLm1pZFldKVxuXHRcdFx0XHRAbWFrZUxhYmVsKG0sIHMubWlkWSwgZClcblx0XHRcdGVsc2Vcblx0XHRcdFx0QG1ha2VMaW5lKFtoLnggKyA1LCBzLm1pZFldLCBbcy54IC0gNCwgcy5taWRZXSlcblx0XHRcdFx0QG1ha2VMYWJlbChtLCBzLm1pZFksIGQpXG5cblx0XHQjIHJpZ2h0XG5cblx0XHRpZiBzLm1heFggPCBoLnhcblxuXHRcdFx0ZCA9IE1hdGguYWJzKGgueCAtIHMubWF4WCkudG9GaXhlZCgpXG5cdFx0XHRtID0gcy5tYXhYICsgKGQgLyAyKVxuXG5cdFx0XHRAbWFrZUxpbmUoW3MubWF4WCArIDUsIHMubWlkWV0sIFtoLnggLSA0LCBzLm1pZFldKVxuXHRcdFx0QG1ha2VMYWJlbChtLCBzLm1pZFksIGQpXG5cblx0XHRlbHNlIGlmIHMueCA8IGgueFxuXG5cdFx0XHRkID0gTWF0aC5hYnMoaC54IC0gcy54KS50b0ZpeGVkKClcblx0XHRcdG0gPSBzLnggKyAoZCAvIDIpXG5cblx0XHRcdGlmIHMueSA+IGgubWF4WVxuXHRcdFx0XHRAbWFrZUxpbmUoW3MueCArIDUsIGgubWlkWV0sIFtoLnggLSA0LCBoLm1pZFldKVxuXHRcdFx0XHRAbWFrZUxhYmVsKG0sIGgubWlkWSwgZClcblx0XHRcdGVsc2Vcblx0XHRcdFx0QG1ha2VMaW5lKFtzLnggKyA1LCBzLm1pZFldLCBbaC54IC0gNCwgcy5taWRZXSlcblx0XHRcdFx0QG1ha2VMYWJlbChtLCBzLm1pZFksIGQpXG5cblx0XHQjIGJvdHRvbVxuXG5cdFx0aWYgcy5tYXhZIDwgaC55XG5cblx0XHRcdGQgPSBNYXRoLmFicyhoLnkgLSBzLm1heFkpLnRvRml4ZWQoKVxuXHRcdFx0bSA9IHMubWF4WSArIChkIC8gMilcblxuXHRcdFx0QG1ha2VMaW5lKFtzLm1pZFgsIHMubWF4WSArIDVdLCBbcy5taWRYLCBoLnkgLSA0XSlcblx0XHRcdEBtYWtlTGFiZWwocy5taWRYLCBtLCBkKVxuXG5cdFx0ZWxzZSBpZiBzLnkgPCBoLnlcblxuXHRcdFx0ZCA9IE1hdGguYWJzKGgueSAtIHMueSkudG9GaXhlZCgpXG5cdFx0XHRtID0gcy55ICsgKGQgLyAyKVxuXG5cdFx0XHRpZiBoLnggPCBzLnhcblx0XHRcdFx0QG1ha2VMaW5lKFtoLm1pZFgsIHMueSArIDVdLCBbaC5taWRYLCBoLnkgLSA0XSlcblx0XHRcdFx0QG1ha2VMYWJlbChoLm1pZFgsIG0sIGQpXG5cdFx0XHRlbHNlXG5cdFx0XHRcdEBtYWtlTGluZShbaC5taWRYLCBzLnkgKyA1XSwgW2gubWlkWCwgaC55IC0gNF0pXG5cdFx0XHRcdEBtYWtlTGFiZWwoaC5taWRYLCBtLCBkKVxuXG5cdFx0QG1ha2VCb3VuZGluZ1JlY3RzKHMsIGgpXG5cblx0bWFrZUJvdW5kaW5nUmVjdHM6IChzLCBoKSA9PlxuXG5cdFx0aG92ZXJlZFJlY3QgPSBuZXcgU1ZHU2hhcGVcblx0XHRcdHR5cGU6ICdyZWN0J1xuXHRcdFx0cGFyZW50OiBjdHhcblx0XHRcdHg6IGgueCArIDFcblx0XHRcdHk6IGgueSArIDFcblx0XHRcdHdpZHRoOiBoLndpZHRoIC0gMlxuXHRcdFx0aGVpZ2h0OiBoLmhlaWdodCAtIDJcblx0XHRcdHN0cm9rZTogJ2JsdWUnXG5cdFx0XHRmaWxsOiAnbm9uZSdcblx0XHRcdCdzdHJva2Utd2lkdGgnOiAnMXB4J1xuXG5cdFx0c2VsZWN0ZWRSZWN0ID0gbmV3IFNWR1NoYXBlXG5cdFx0XHR0eXBlOiAncmVjdCdcblx0XHRcdHBhcmVudDogY3R4XG5cdFx0XHR4OiBzLnggKyAxXG5cdFx0XHR5OiBzLnkgKyAxXG5cdFx0XHR3aWR0aDogcy53aWR0aCAtIDJcblx0XHRcdGhlaWdodDogcy5oZWlnaHQgLSAyXG5cdFx0XHRzdHJva2U6ICdyZWQnXG5cdFx0XHRmaWxsOiAnbm9uZSdcblx0XHRcdCdzdHJva2Utd2lkdGgnOiAnMXB4J1xuXG5cdHNldFdpbmRvd0xhYmVsOiAobGF5ZXJOYW1lLCB2YWx1ZSkgPT5cblx0XHRAd2luZG93W2xheWVyTmFtZV0udmFsdWUgPSB2YWx1ZSA/ICcnXG5cblx0c2V0V2luZG93TGFiZWxzOiAoKSA9PlxuXHRcdGggPSBAaG92ZXJlZExheWVyXG5cdFx0aGUgPSBAaG92ZXJlZEVsZW1lbnRcblx0XHRzID0gQHNlbGVjdGVkTGF5ZXJcblx0XHRzZSA9IEBzZWxlY3RlZEVsZW1lbnRcblxuXHRcdGlmIG5vdCBzPyBhbmQgbm90IGg/XG5cdFx0XHRAc2V0V2luZG93TGFiZWwgJ2NvbXBvbmVudExhYmVsJywgJydcblx0XHRcdEBzZXRXaW5kb3dMYWJlbCAneExhYmVsJywgJydcblx0XHRcdEBzZXRXaW5kb3dMYWJlbCAneUxhYmVsJywgJydcblx0XHRcdEBzZXRXaW5kb3dMYWJlbCAnd2lkdGhMYWJlbCcsICcnXG5cdFx0XHRAc2V0V2luZG93TGFiZWwgJ2hlaWdodExhYmVsJywgJydcblx0XHRcdEBzZXRXaW5kb3dMYWJlbCAncmFkaXVzTGFiZWwnLCAnJ1xuXHRcdFx0QHNldFdpbmRvd0xhYmVsICdib3JkZXJMYWJlbCcsICcnXG5cdFx0XHRcblx0XHRcdHJldHVyblxuXG5cdFx0aWYgaD8gYW5kIG5vdCBzP1xuXHRcdFx0QHNldFdpbmRvd0xhYmVsICdjb21wb25lbnRMYWJlbCcsIGguY29uc3RydWN0b3IubmFtZVxuXHRcdFx0QHNldFdpbmRvd0xhYmVsICd4TGFiZWwnLCBoLnhcblx0XHRcdEBzZXRXaW5kb3dMYWJlbCAneUxhYmVsJywgaC55XG5cdFx0XHRAc2V0V2luZG93TGFiZWwgJ3dpZHRoTGFiZWwnLCBoLnNjcmVlbkZyYW1lLndpZHRoXG5cdFx0XHRAc2V0V2luZG93TGFiZWwgJ2hlaWdodExhYmVsJywgaC5zY3JlZW5GcmFtZS5oZWlnaHRcblx0XHRcdEBzZXRXaW5kb3dMYWJlbCAncmFkaXVzTGFiZWwnLCBoLmJvcmRlclJhZGl1c1xuXG5cdFx0XHRpZiBoLmJvcmRlcldpZHRoID4gMFxuXHRcdFx0XHRAc2V0V2luZG93TGFiZWwgJ2JvcmRlckxhYmVsJywgaC5ib3JkZXJXaWR0aCArICcgJyArIGguYm9yZGVyQ29sb3Jcblx0XHRcdGVsc2Vcblx0XHRcdFx0QHNldFdpbmRvd0xhYmVsICdib3JkZXJMYWJlbCcsICdub25lJ1xuXG5cdFx0XHRpZiBoLnNoYWRvd1ggPiAwIG9yIGguc2hhZG93WSA+IDAgb3IgaC5zaGFkb3dTcHJlYWQgPiAwXG5cdFx0XHRcdEBzZXRXaW5kb3dMYWJlbCAnc2hhZG93TGFiZWwnLCBoLnNoYWRvd1ggKyAnICcgKyBoLnNoYWRvd1kgKyAnICcgKyBoLnNoYWRvd1NwcmVhZCArICcgJyArIGguc2hhZG93Q29sb3Jcblx0XHRcdGVsc2Vcblx0XHRcdFx0QHNldFdpbmRvd0xhYmVsICdzaGFkb3dMYWJlbCcsICdub25lJ1xuXG5cdFx0XHRyZXR1cm5cblxuXG5cdGZvY3VzOiAoZXZlbnQpID0+XG5cdFx0aWYgQGVuYWJsZWQgaXMgZmFsc2Vcblx0XHRcdHJldHVybiBcblxuXHRcdEB1bmZvY3VzKClcblxuXHRcdEBzZWxlY3RlZEVsZW1lbnQgPz0gQHNjcmVlbkVsZW1lbnRcblx0XHRAaG92ZXJlZEVsZW1lbnQgPSAoZXZlbnQ/LnRhcmdldCA/IEBob3ZlcmVkRWxlbWVudClcblx0XHRcblx0XHRpZiBub3QgQGhvdmVyZWRFbGVtZW50XG5cdFx0XHRyZXR1cm5cblxuXHRcdGlmIEBob3ZlcmVkRWxlbWVudCBpcyBAd2luZG93Ll9lbGVtZW50XG5cdFx0XHRAaG92ZXJlZEVsZW1lbnQgPSBAc2NyZWVuRWxlbWVudFxuXG5cdFx0QHNlbGVjdGVkTGF5ZXIgPSBAZ2V0TGF5ZXJGcm9tRWxlbWVudChAc2VsZWN0ZWRFbGVtZW50KVxuXHRcdEBob3ZlcmVkTGF5ZXIgPSBAZ2V0TGF5ZXJGcm9tRWxlbWVudChAaG92ZXJlZEVsZW1lbnQpXG5cdFx0QHNldFdpbmRvd0xhYmVscygpXG5cblx0XHRAc2hvd0Rpc3RhbmNlcyhAc2VsZWN0ZWRFbGVtZW50LCBAaG92ZXJlZEVsZW1lbnQpXG5cblx0XHRpZiBAc2NyZWVuRWxlbWVudCBpcyBAaG92ZXJlZEVsZW1lbnRcblx0XHRcdHJldHVyblxuXHRcdFxuXHRcdEBob3ZlcmVkRWxlbWVudC5hZGRFdmVudExpc3RlbmVyKCdjbGljaycsIEBzZWxlY3QpXG5cblx0dW5mb2N1czogKGV2ZW50KSA9PlxuXHRcdGN0eC5yZW1vdmVBbGwoKVxuXG5cbmV4cG9ydHMuZnJhcGxpbiA9IG5ldyBGcmFwbGluXG4iLCIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3ZhciBmPW5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIik7dGhyb3cgZi5jb2RlPVwiTU9EVUxFX05PVF9GT1VORFwiLGZ9dmFyIGw9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGwuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sbCxsLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUNBQTtBREVBLElBQUEscURBQUE7RUFBQTs7OztBQUFBLE1BQU0sQ0FBQyxNQUFNLENBQUMsS0FBSyxDQUFDLE9BQXBCLENBQUE7O0FBRUEsVUFBQSxHQUFhOztBQUVQO0VBQ1Esb0JBQUMsT0FBRDtBQUNaLFFBQUE7O01BRGEsVUFBVTs7O0lBQ3ZCLElBQUMsQ0FBQSxhQUFELEdBQWlCO0lBRWpCLElBQUMsQ0FBQSxNQUFELEdBQVU7SUFFVixVQUFBLEdBQWE7SUFHYixLQUFBLEdBQVE7SUFHUixhQUFBLEdBQWdCLFNBQUMsT0FBRCxFQUFVLFVBQVY7QUFDZixVQUFBOztRQUR5QixhQUFhOztBQUN0QztXQUFBLGlCQUFBOztxQkFDQyxPQUFPLENBQUMsWUFBUixDQUFxQixHQUFyQixFQUEwQixLQUExQjtBQUREOztJQURlO0lBSWhCLElBQUMsQ0FBQSxVQUFELEdBQWtCLElBQUEsS0FBQSxDQUNqQjtNQUFBLElBQUEsRUFBTSxNQUFNLENBQUMsSUFBYjtNQUNBLElBQUEsRUFBTSxHQUROO01BRUEsT0FBQSxFQUFTLEtBRlQ7S0FEaUI7SUFLbEIsSUFBQyxDQUFBLFlBQUQsR0FBZ0IsSUFBQyxDQUFBLFVBQVUsQ0FBQztJQUU1QixJQUFDLENBQUEsTUFBRCxHQUFVLElBQUMsQ0FBQSxZQUFZLENBQUMscUJBQWQsQ0FBQTtJQUdWLENBQUMsQ0FBQyxNQUFGLENBQVMsSUFBVCxFQUNDO01BQUEsS0FBQSxFQUFPLElBQUMsQ0FBQSxNQUFNLENBQUMsS0FBSyxDQUFDLE9BQWQsQ0FBQSxDQUFQO01BQ0EsTUFBQSxFQUFRLElBQUMsQ0FBQSxNQUFNLENBQUMsTUFBTSxDQUFDLE9BQWYsQ0FBQSxDQURSO01BRUEsQ0FBQSxFQUFHLElBQUMsQ0FBQSxNQUFNLENBQUMsSUFBSSxDQUFDLE9BQWIsQ0FBQSxDQUZIO01BR0EsQ0FBQSxFQUFHLElBQUMsQ0FBQSxNQUFNLENBQUMsR0FBRyxDQUFDLE9BQVosQ0FBQSxDQUhIO0tBREQ7SUFRQSxJQUFDLENBQUEsR0FBRCxHQUFPLFFBQVEsQ0FBQyxlQUFULENBQXlCLEtBQXpCLEVBQWdDLEtBQWhDO0lBRVAsT0FBQSxHQUFVLFFBQVEsQ0FBQyxjQUFULENBQXdCLGlDQUF4QjtJQUNWLE9BQU8sQ0FBQyxXQUFSLENBQW9CLElBQUMsQ0FBQSxHQUFyQjtJQUVBLElBQUMsQ0FBQSxhQUFELEdBQWlCLFFBQVEsQ0FBQyxzQkFBVCxDQUFnQyxlQUFoQyxDQUFpRCxDQUFBLENBQUE7SUFDbEUsTUFBQSxHQUFTLElBQUMsQ0FBQSxhQUFhLENBQUMscUJBQWYsQ0FBQTtJQUVULGFBQUEsQ0FBYyxJQUFDLENBQUEsR0FBZixFQUNDO01BQUEsQ0FBQSxFQUFHLENBQUg7TUFDQSxDQUFBLEVBQUcsQ0FESDtNQUVBLEtBQUEsRUFBTyxNQUFNLENBQUMsS0FGZDtNQUdBLE1BQUEsRUFBUSxNQUFNLENBQUMsTUFIZjtNQUlBLE9BQUEsRUFBUyxNQUFBLEdBQU8sTUFBTSxDQUFDLEtBQWQsR0FBb0IsR0FBcEIsR0FBdUIsTUFBTSxDQUFDLE1BSnZDO0tBREQ7SUFPQSxDQUFDLENBQUMsTUFBRixDQUFTLElBQUMsQ0FBQSxHQUFHLENBQUMsS0FBZCxFQUNDO01BQUEsUUFBQSxFQUFVLFVBQVY7TUFDQSxJQUFBLEVBQU0sQ0FETjtNQUVBLEdBQUEsRUFBSyxDQUZMO01BR0EsS0FBQSxFQUFPLE1BSFA7TUFJQSxNQUFBLEVBQVEsTUFKUjtNQUtBLGdCQUFBLEVBQWtCLE1BTGxCO0tBREQ7SUFVQSxJQUFDLENBQUEsT0FBRCxHQUFXLFFBQVEsQ0FBQyxlQUFULENBQXlCLEtBQXpCLEVBQWdDLE1BQWhDO0lBQ1gsSUFBQyxDQUFBLEdBQUcsQ0FBQyxXQUFMLENBQWlCLElBQUMsQ0FBQSxPQUFsQjtJQUVBLE9BQU8sSUFBQyxDQUFBO0VBN0RJOzt1QkErRGIsUUFBQSxHQUFVLFNBQUMsS0FBRDtJQUNULElBQUMsQ0FBQSxNQUFNLENBQUMsSUFBUixDQUFhLEtBQWI7V0FDQSxJQUFDLENBQUEsU0FBRCxDQUFXLEtBQVg7RUFGUzs7dUJBSVYsV0FBQSxHQUFhLFNBQUMsS0FBRDtJQUNaLElBQUMsQ0FBQSxTQUFELENBQVcsS0FBWDtXQUNBLENBQUMsQ0FBQyxJQUFGLENBQU8sSUFBQyxDQUFBLE1BQVIsRUFBZ0IsS0FBaEI7RUFGWTs7dUJBSWIsU0FBQSxHQUFXLFNBQUMsS0FBRDtXQUNWLElBQUMsQ0FBQSxHQUFHLENBQUMsV0FBTCxDQUFpQixLQUFLLENBQUMsT0FBdkI7RUFEVTs7dUJBR1gsU0FBQSxHQUFXLFNBQUMsS0FBRDtXQUNWLElBQUMsQ0FBQSxHQUFHLENBQUMsV0FBTCxDQUFpQixLQUFLLENBQUMsT0FBdkI7RUFEVTs7dUJBR1gsTUFBQSxHQUFRLFNBQUMsR0FBRDtXQUNQLElBQUMsQ0FBQSxPQUFPLENBQUMsV0FBVCxDQUFxQixHQUFyQjtFQURPOzt1QkFHUixTQUFBLEdBQVcsU0FBQTtBQUNWLFFBQUE7QUFBQTtBQUFBLFNBQUEscUNBQUE7O01BQ0MsSUFBQyxDQUFBLEdBQUcsQ0FBQyxXQUFMLENBQWlCLEtBQUssQ0FBQyxPQUF2QjtBQUREO1dBRUEsSUFBQyxDQUFBLE1BQUQsR0FBVTtFQUhBOzs7Ozs7QUFNTjtFQUNRLGtCQUFDLE9BQUQ7QUFDWixRQUFBOztNQURhLFVBQVU7UUFBQyxJQUFBLEVBQU0sUUFBUDs7OztJQUN2QixJQUFDLENBQUEsYUFBRCxHQUFpQjtJQUVqQixJQUFDLENBQUEsTUFBRCxHQUFVO0lBRVYsSUFBQyxDQUFBLE9BQUQsR0FBVyxRQUFRLENBQUMsZUFBVCxDQUNWLDRCQURVLEVBRVYsT0FBTyxDQUFDLElBRkU7SUFLWCxJQUFDLENBQUEsaUJBQUQsQ0FBbUIsTUFBbkIsRUFBMkIsYUFBM0IsRUFBMEMsYUFBMUMsRUFBeUQsT0FBTyxDQUFDLElBQWpFO0FBR0EsU0FBQSxjQUFBOztNQUNDLElBQUMsQ0FBQSxZQUFELENBQWMsR0FBZCxFQUFtQixLQUFuQjtBQUREO0lBR0EsSUFBQyxDQUFBLE1BQU0sQ0FBQyxRQUFSLENBQWlCLElBQWpCO0lBRUEsSUFBQyxDQUFBLElBQUQsQ0FBQTtFQWxCWTs7cUJBb0JiLFlBQUEsR0FBYyxTQUFDLEdBQUQsRUFBTSxLQUFOO0lBQ2IsSUFBVSxHQUFBLEtBQU8sTUFBakI7QUFBQSxhQUFBOztJQUNBLElBQU8saUJBQVA7TUFDQyxNQUFNLENBQUMsY0FBUCxDQUFzQixJQUF0QixFQUNDLEdBREQsRUFFQztRQUFBLEdBQUEsRUFBSyxDQUFBLFNBQUEsS0FBQTtpQkFBQSxTQUFBO0FBQ0osbUJBQU8sS0FBQyxDQUFBLE9BQU8sQ0FBQyxZQUFULENBQXNCLEdBQXRCO1VBREg7UUFBQSxDQUFBLENBQUEsQ0FBQSxJQUFBLENBQUw7UUFFQSxHQUFBLEVBQUssQ0FBQSxTQUFBLEtBQUE7aUJBQUEsU0FBQyxLQUFEO21CQUNKLEtBQUMsQ0FBQSxPQUFPLENBQUMsWUFBVCxDQUFzQixHQUF0QixFQUEyQixLQUEzQjtVQURJO1FBQUEsQ0FBQSxDQUFBLENBQUEsSUFBQSxDQUZMO09BRkQsRUFERDs7V0FRQSxJQUFFLENBQUEsR0FBQSxDQUFGLEdBQVM7RUFWSTs7cUJBWWQsaUJBQUEsR0FBbUIsU0FBQyxZQUFELEVBQWUsV0FBZixFQUE0QixRQUE1QixFQUFzQyxVQUF0QztJQUNsQixNQUFNLENBQUMsY0FBUCxDQUFzQixJQUF0QixFQUNDLFlBREQsRUFFQztNQUFBLEdBQUEsRUFBSyxTQUFBO0FBQ0osZUFBTztNQURILENBQUw7TUFFQSxHQUFBLEVBQUssU0FBQyxLQUFEO2VBQ0osSUFBQyxDQUFBLE9BQVEsQ0FBQSxRQUFBLENBQVQsR0FBcUI7TUFEakIsQ0FGTDtLQUZEO1dBT0EsSUFBRSxDQUFBLFlBQUEsQ0FBRixHQUFrQjtFQVJBOztxQkFVbkIsSUFBQSxHQUFNLFNBQUE7V0FDTCxJQUFDLENBQUEsTUFBTSxDQUFDLFNBQVIsQ0FBa0IsSUFBbEI7RUFESzs7cUJBR04sSUFBQSxHQUFNLFNBQUE7V0FDTCxJQUFDLENBQUEsTUFBTSxDQUFDLFNBQVIsQ0FBa0IsSUFBbEI7RUFESzs7cUJBR04sTUFBQSxHQUFRLFNBQUE7V0FDUCxJQUFDLENBQUEsTUFBTSxDQUFDLFdBQVIsQ0FBb0IsSUFBcEI7RUFETzs7Ozs7O0FBR0g7OztFQUNRLGVBQUMsT0FBRDtBQUNaLFFBQUE7O01BRGEsVUFBVTs7SUFDdkIsSUFBQyxDQUFBLGFBQUQsR0FBaUI7SUFFakIsQ0FBQyxDQUFDLE1BQUYsQ0FBUyxPQUFULEVBQ0M7TUFBQSxJQUFBLEVBQU0sR0FBTjtNQUNBLFFBQUEsRUFBVSxFQURWO01BRUEsVUFBQSxFQUFZLEdBRlo7TUFHQSxLQUFBLEVBQU8sTUFIUDtNQUlBLFVBQUEsRUFBWSxPQUpaO0tBREQ7SUFPQSxDQUFDLENBQUMsUUFBRixDQUFXLE9BQVgsRUFDQztNQUFBLElBQUEsRUFBTSxHQUFOO01BQ0EsS0FBQSxFQUFPLENBRFA7S0FERDtJQUlBLENBQUEsR0FBSSxPQUFPLENBQUM7SUFDWixPQUFPLE9BQU8sQ0FBQztJQUVmLHVDQUFNLE9BQU47SUFFQSxJQUFDLENBQUEsVUFBRCxHQUFrQixJQUFBLFNBQUEsQ0FDakI7TUFBQSxNQUFBLEVBQVEsSUFBQyxDQUFBLE1BQVQ7TUFDQSxJQUFBLEVBQU0sR0FETjtNQUVBLFFBQUEsRUFBVSxJQUFDLENBQUEsUUFGWDtNQUdBLFVBQUEsRUFBWSxHQUhaO01BSUEsS0FBQSxFQUFPLE1BSlA7TUFLQSxVQUFBLEVBQVksSUFBQyxDQUFBLFVBTGI7TUFNQSxDQUFBLEVBQUcsSUFBQyxDQUFBLENBQUQsR0FBSyxDQU5SO01BT0EsQ0FBQSxFQUFHLElBQUMsQ0FBQSxDQVBKO01BUUEsSUFBQSxFQUFNLFNBUk47S0FEaUI7SUFXbEIsT0FBTyxJQUFDLENBQUE7SUFFUixJQUFDLENBQUEsS0FBRCxHQUFTLE9BQU8sQ0FBQztFQWhDTDs7RUFtQ2IsS0FBQyxDQUFBLE1BQUQsQ0FBUSxPQUFSLEVBQ0M7SUFBQSxHQUFBLEVBQUssU0FBQTtBQUFHLGFBQU8sSUFBQyxDQUFBO0lBQVgsQ0FBTDtJQUNBLEdBQUEsRUFBSyxTQUFDLEtBQUQ7TUFDSixJQUFVLElBQUMsQ0FBQSxhQUFYO0FBQUEsZUFBQTs7TUFDQSxJQUFDLENBQUEsTUFBRCxHQUFVO2FBQ1YsSUFBQyxDQUFBLFVBQVUsQ0FBQyxRQUFaLEdBQXVCO0lBSG5CLENBREw7R0FERDs7OztHQXBDbUI7O0FBMkNwQixHQUFBLEdBQVUsSUFBQSxVQUFBLENBQ1Q7RUFBQSxJQUFBLEVBQU0sTUFBTSxDQUFDLElBQWI7RUFDQSxlQUFBLEVBQWlCLElBRGpCO0NBRFM7OztBQVFWOzs7Ozs7Ozs7OztBQVlNO0VBQ1EsaUJBQUMsT0FBRDtBQUVaLFFBQUE7O01BRmEsVUFBVTs7Ozs7Ozs7Ozs7Ozs7Ozs7O0lBRXZCLENBQUMsQ0FBQyxRQUFGLENBQVcsT0FBWCxFQUNDO01BQUEsS0FBQSxFQUFPLEtBQVA7TUFDQSxjQUFBLEVBQWdCLE9BRGhCO01BRUEsVUFBQSxFQUFZLE9BRlo7TUFHQSxRQUFBLEVBQVUsSUFIVjtNQUlBLFVBQUEsRUFBWSxLQUpaO01BS0EsWUFBQSxFQUFjLENBTGQ7TUFNQSxPQUFBLEVBQVM7UUFBQyxHQUFBLEVBQUssQ0FBTjtRQUFTLE1BQUEsRUFBUSxDQUFqQjtRQUFvQixJQUFBLEVBQU0sQ0FBMUI7UUFBNkIsS0FBQSxFQUFPLENBQXBDO09BTlQ7S0FERDtJQVNBLENBQUMsQ0FBQyxNQUFGLENBQVMsSUFBVCxFQUNDO01BQUEsS0FBQSxFQUFPLE9BQU8sQ0FBQyxLQUFmO01BQ0EsY0FBQSxFQUFnQixPQUFPLENBQUMsY0FEeEI7TUFFQSxVQUFBLEVBQVksT0FBTyxDQUFDLFVBRnBCO01BR0EsUUFBQSxFQUFVLE9BQU8sQ0FBQyxRQUhsQjtNQUlBLFVBQUEsRUFBWSxPQUFPLENBQUMsVUFKcEI7TUFLQSxNQUFBLEVBQVEsRUFMUjtNQU1BLFlBQUEsRUFBYyxPQUFPLENBQUMsWUFOdEI7TUFPQSxPQUFBLEVBQVMsT0FBTyxDQUFDLE9BUGpCO01BUUEsY0FBQSxFQUFnQixNQVJoQjtNQVNBLE9BQUEsRUFBUyxLQVRUO01BVUEsYUFBQSxFQUFlLFFBQVEsQ0FBQyxzQkFBVCxDQUFnQyxxQkFBaEMsQ0FBdUQsQ0FBQSxDQUFBLENBVnRFO01BV0EsUUFBQSxFQUFVLFFBQVEsQ0FBQyxzQkFBVCxDQUFnQyxxQkFBaEMsQ0FBdUQsQ0FBQSxDQUFBLENBWGpFO01BWUEsTUFBQSxFQUFRLEVBWlI7S0FERDtJQWVBLFFBQVEsQ0FBQyxnQkFBVCxDQUEwQixPQUExQixFQUFtQyxJQUFDLENBQUEsTUFBcEM7SUFFQSxJQUFDLENBQUEsT0FBRCxHQUFXLFFBQVEsQ0FBQyxzQkFBVCxDQUFnQywwQkFBaEMsQ0FBNEQsQ0FBQSxDQUFBO0lBQ3ZFLElBQUMsQ0FBQSxPQUFPLENBQUMsU0FBUyxDQUFDLEdBQW5CLENBQXVCLGNBQXZCO0lBRUEsSUFBQyxDQUFBLE9BQU8sQ0FBQyxVQUFXLENBQUEsQ0FBQSxDQUFFLENBQUMsU0FBUyxDQUFDLEdBQWpDLENBQXFDLHFCQUFyQztJQUVBLElBQUMsQ0FBQSxPQUFPLENBQUMsZ0JBQVQsQ0FBMEIsV0FBMUIsRUFBdUMsSUFBQyxDQUFBLEtBQXhDO0lBQ0EsSUFBQyxDQUFBLE9BQU8sQ0FBQyxnQkFBVCxDQUEwQixVQUExQixFQUFzQyxJQUFDLENBQUEsT0FBdkM7SUFFQSxLQUFLLENBQUMsU0FBTixDQUFnQixnWEFBaEI7SUEwQkEsSUFBQyxDQUFBLE1BQUQsR0FBYyxJQUFBLEtBQUEsQ0FDYjtNQUFBLE1BQUEsRUFBUSxJQUFSO01BQ0EsSUFBQSxFQUFNLFNBRE47TUFFQSxDQUFBLEVBQUcsS0FBSyxDQUFDLE1BQU4sQ0FBYSxDQUFDLEVBQWQsQ0FGSDtNQUdBLENBQUEsRUFBRyxFQUhIO01BSUEsTUFBQSxFQUFRLEdBSlI7TUFLQSxLQUFBLEVBQU8sTUFBTSxDQUFDLEtBQVAsR0FBZSxFQUx0QjtNQU1BLGVBQUEsRUFBaUIsU0FOakI7TUFPQSxZQUFBLEVBQWMsQ0FQZDtNQVFBLE9BQUEsRUFBUyxDQVJUO01BU0EsT0FBQSxFQUFTLENBVFQ7TUFVQSxVQUFBLEVBQVksQ0FWWjtNQVdBLFdBQUEsRUFBYSxpQkFYYjtNQVlBLE9BQUEsRUFBUyxLQVpUO0tBRGE7SUFlZCxJQUFDLENBQUEsTUFBTSxDQUFDLFNBQVMsQ0FBQyxPQUFsQixHQUE0QjtJQUM1QixJQUFDLENBQUEsTUFBTSxDQUFDLFNBQVMsQ0FBQyxXQUFsQixHQUNDO01BQUEsS0FBQSxFQUFPLE1BQU0sQ0FBQyxLQUFkO01BQ0EsTUFBQSxFQUFRLE1BQU0sQ0FBQyxNQURmOztJQUdELElBQUMsQ0FBQSxNQUFNLENBQUMsYUFBUixDQUFzQixTQUFBO2FBQUcsSUFBQyxDQUFBLE9BQUQsR0FBVztJQUFkLENBQXRCO0lBRUcsQ0FBQyxDQUFDLElBQUYsQ0FBUSxTQUFBO01BRVYsSUFBQyxDQUFBLE1BQUQsR0FBYyxJQUFBLEtBQUEsQ0FDYjtRQUFBLE1BQUEsRUFBUSxJQUFSO1FBQ0EsQ0FBQSxFQUFHLENBREg7UUFDTSxDQUFBLEVBQUcsQ0FEVDtRQUVBLEtBQUEsRUFBTyxFQUZQO1FBR0EsSUFBQSxFQUFNLElBSE47T0FEYTtNQU1kLElBQUMsQ0FBQSxNQUFELEdBQWMsSUFBQSxLQUFBLENBQ2I7UUFBQSxNQUFBLEVBQVEsSUFBUjtRQUNBLENBQUEsRUFBRyxDQURIO1FBQ00sQ0FBQSxFQUFHLEVBRFQ7UUFFQSxLQUFBLEVBQU8sRUFGUDtRQUdBLElBQUEsRUFBTSxJQUhOO09BRGE7TUFNZCxJQUFDLENBQUEsVUFBRCxHQUFrQixJQUFBLEtBQUEsQ0FDakI7UUFBQSxNQUFBLEVBQVEsSUFBUjtRQUNBLENBQUEsRUFBRyxFQURIO1FBQ08sQ0FBQSxFQUFHLENBRFY7UUFFQSxLQUFBLEVBQU8sRUFGUDtRQUdBLElBQUEsRUFBTSxRQUhOO09BRGlCO01BTWxCLElBQUMsQ0FBQSxXQUFELEdBQW1CLElBQUEsS0FBQSxDQUNsQjtRQUFBLE1BQUEsRUFBUSxJQUFSO1FBQ0EsQ0FBQSxFQUFHLEVBREg7UUFDTyxDQUFBLEVBQUcsRUFEVjtRQUVBLEtBQUEsRUFBTyxFQUZQO1FBR0EsSUFBQSxFQUFNLFNBSE47T0FEa0I7TUFNbkIsSUFBQyxDQUFBLFdBQUQsR0FBbUIsSUFBQSxLQUFBLENBQ2xCO1FBQUEsTUFBQSxFQUFRLElBQVI7UUFDQSxDQUFBLEVBQUcsQ0FESDtRQUNNLENBQUEsRUFBRyxFQURUO1FBRUEsS0FBQSxFQUFPLEVBRlA7UUFHQSxJQUFBLEVBQU0sU0FITjtPQURrQjtNQU1uQixJQUFDLENBQUEsV0FBRCxHQUFtQixJQUFBLEtBQUEsQ0FDbEI7UUFBQSxNQUFBLEVBQVEsSUFBUjtRQUNBLENBQUEsRUFBRyxDQURIO1FBQ00sQ0FBQSxFQUFHLEVBRFQ7UUFFQSxLQUFBLEVBQU8sRUFGUDtRQUdBLElBQUEsRUFBTSxTQUhOO09BRGtCO01BTW5CLElBQUMsQ0FBQSxXQUFELEdBQW1CLElBQUEsS0FBQSxDQUNsQjtRQUFBLE1BQUEsRUFBUSxJQUFSO1FBQ0EsQ0FBQSxFQUFHLENBREg7UUFDTSxDQUFBLEVBQUcsRUFEVDtRQUVBLEtBQUEsRUFBTyxFQUZQO1FBR0EsSUFBQSxFQUFNLFNBSE47T0FEa0I7TUFNbkIsSUFBQyxDQUFBLGNBQUQsR0FBc0IsSUFBQSxLQUFBLENBQ3JCO1FBQUEsTUFBQSxFQUFRLElBQVI7UUFDQSxDQUFBLEVBQUcsQ0FESDtRQUNNLENBQUEsRUFBRyxHQURUO1FBRUEsS0FBQSxFQUFPLEVBRlA7UUFHQSxJQUFBLEVBQU0sWUFITjtPQURxQjtNQU10QixJQUFDLENBQUEsS0FBRCxHQUFhLElBQUEsU0FBQSxDQUNaO1FBQUEsTUFBQSxFQUFRLElBQVI7UUFDQSxDQUFBLEVBQUcsQ0FESDtRQUVBLENBQUEsRUFBRyxLQUFLLENBQUMsS0FBTixDQUFBLENBRkg7UUFHQSxJQUFBLEVBQU0sR0FITjtRQUlBLFVBQUEsRUFBWSxPQUpaO1FBS0EsS0FBQSxFQUFPLE1BTFA7UUFNQSxRQUFBLEVBQVUsRUFOVjtRQU9BLFVBQUEsRUFBWSxHQVBaO1FBUUEsT0FBQSxFQUFTLENBUlQ7T0FEWTtNQVdiLElBQUMsQ0FBQSxLQUFLLENBQUMsS0FBUCxDQUFhLENBQUEsU0FBQSxLQUFBO2VBQUEsU0FBQTtpQkFBRyxLQUFDLENBQUEsT0FBRCxHQUFXO1FBQWQ7TUFBQSxDQUFBLENBQUEsQ0FBQSxJQUFBLENBQWI7YUFFQSxJQUFDLENBQUEsS0FBTSxDQUFBLGdCQUFBLENBQVAsR0FBMkI7SUEvRGpCLENBQVIsRUFpRUQsSUFBQyxDQUFBLE1BakVBLENBQUgsQ0FBQTtBQW1FQTtBQUFBLFNBQUEscUNBQUE7O01BQ0MsS0FBSyxDQUFDLFNBQVMsQ0FBQyxHQUFoQixDQUFvQixxQkFBcEI7QUFERDtFQXZKWTs7b0JBMEpiLE1BQUEsR0FBUSxTQUFDLEtBQUQ7SUFDUCxJQUFHLEtBQUssQ0FBQyxHQUFOLEtBQWEsR0FBaEI7TUFDQyxJQUFHLElBQUMsQ0FBQSxPQUFKO1FBQWlCLElBQUMsQ0FBQSxPQUFELENBQUEsRUFBakI7T0FBQSxNQUFBO1FBQWlDLElBQUMsQ0FBQSxNQUFELENBQUEsRUFBakM7O0FBRUEsYUFIRDs7SUFLQSxJQUFHLEtBQUssQ0FBQyxHQUFOLEtBQWEsR0FBaEI7TUFDQyxJQUFVLENBQUksSUFBQyxDQUFBLE9BQWY7QUFBQSxlQUFBOztNQUVBLElBQUcsSUFBQyxDQUFBLGNBQUQsS0FBbUIsSUFBQyxDQUFBLGVBQXZCO1FBQ0MsSUFBQyxDQUFBLFFBQUQsQ0FBQSxFQUREO09BQUEsTUFBQTtRQUdDLElBQUMsQ0FBQSxNQUFELENBQUEsRUFIRDtPQUhEOztFQU5POztvQkFpQlIsV0FBQSxHQUFhLFNBQUE7QUFDWixRQUFBO0lBQUEsSUFBQyxDQUFBLE1BQUQsR0FBVTtBQUVWO0FBQUE7U0FBQSxxQ0FBQTs7bUJBQ0MsSUFBQyxDQUFBLE1BQU0sQ0FBQyxJQUFSLENBQWEsS0FBYjtBQUREOztFQUhZOztvQkFNYixNQUFBLEdBQVEsU0FBQTtJQUVQLElBQUMsQ0FBQSxXQUFELENBQUE7SUFFQSxJQUFDLENBQUEsT0FBRCxHQUFXO0lBQ1gsSUFBQyxDQUFBLE1BQU0sQ0FBQyxPQUFSLEdBQWtCO0lBQ2xCLElBQUMsQ0FBQSxNQUFNLENBQUMsWUFBUixDQUFBO1dBQ0EsSUFBQyxDQUFBLEtBQUQsQ0FBQTtFQVBPOztvQkFTUixPQUFBLEdBQVMsU0FBQTtJQUVSLElBQUMsQ0FBQSxPQUFELEdBQVc7SUFDWCxJQUFDLENBQUEsTUFBTSxDQUFDLE9BQVIsR0FBa0I7SUFDbEIsSUFBQyxDQUFBLE1BQU0sQ0FBQyxVQUFSLENBQUE7V0FDQSxJQUFDLENBQUEsT0FBRCxDQUFBO0VBTFE7O29CQVFULG1CQUFBLEdBQXFCLFNBQUMsT0FBRDtBQUNwQixRQUFBO0lBQUEsSUFBRyxPQUFPLENBQUMsU0FBUyxDQUFDLFFBQWxCLENBQTJCLGFBQTNCLENBQUg7TUFDQyxLQUFBLEdBQVEsQ0FBQyxDQUFDLElBQUYsQ0FBTyxJQUFDLENBQUEsTUFBUixFQUFnQixDQUFDLFVBQUQsRUFBYSxPQUFiLENBQWhCLEVBRFQ7S0FBQSxNQUFBO01BR0MsT0FBQSw4RUFBd0MsQ0FBRTtNQUMxQyxLQUFBLEdBQVEsQ0FBQyxDQUFDLElBQUYsQ0FBTyxJQUFDLENBQUEsTUFBUixFQUFnQixDQUFDLFVBQUQsRUFBYSxPQUFiLENBQWhCLEVBSlQ7O0FBTUEsV0FBTztFQVBhOztvQkFTckIsTUFBQSxHQUFRLFNBQUMsS0FBRDtJQUNQLElBQVUsQ0FBSSxJQUFDLENBQUEsY0FBZjtBQUFBLGFBQUE7O0lBRUEsSUFBQyxDQUFBLGVBQUQsR0FBbUIsSUFBQyxDQUFBO0lBQ3BCLElBQUMsQ0FBQSxlQUFlLENBQUMsZ0JBQWpCLENBQWtDLE9BQWxDLEVBQTJDLElBQUMsQ0FBQSxRQUE1QztXQUNBLElBQUMsQ0FBQSxLQUFELENBQUE7RUFMTzs7b0JBT1IsUUFBQSxHQUFVLFNBQUMsS0FBRDtJQUNULElBQUMsQ0FBQSxlQUFlLENBQUMsbUJBQWpCLENBQXFDLE9BQXJDLEVBQThDLElBQUMsQ0FBQSxRQUEvQztJQUNBLElBQUMsQ0FBQSxlQUFELEdBQW1CO1dBQ25CLElBQUMsQ0FBQSxLQUFELENBQUE7RUFIUzs7b0JBTVYsYUFBQSxHQUFlLFNBQUMsT0FBRDtBQUNkLFFBQUE7SUFBQSxDQUFBLEdBQUksT0FBTyxDQUFDLHFCQUFSLENBQUE7SUFFSixVQUFBLEdBQWE7TUFDWixDQUFBLEVBQUcsQ0FBQyxDQUFDLElBRE87TUFFWixDQUFBLEVBQUcsQ0FBQyxDQUFDLEdBRk87TUFHWixLQUFBLEVBQU8sQ0FBQyxDQUFDLEtBSEc7TUFJWixNQUFBLEVBQVEsQ0FBQyxDQUFDLE1BSkU7TUFLWixJQUFBLEVBQU0sQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFDLENBQUMsQ0FBQyxLQUFGLEdBQVUsQ0FBWCxDQUxIO01BTVosSUFBQSxFQUFNLENBQUMsQ0FBQyxHQUFGLEdBQVEsQ0FBQyxDQUFDLENBQUMsTUFBRixHQUFXLENBQVosQ0FORjtNQU9aLElBQUEsRUFBTSxDQUFDLENBQUMsSUFBRixHQUFTLENBQUMsQ0FBQyxLQVBMO01BUVosSUFBQSxFQUFNLENBQUMsQ0FBQyxHQUFGLEdBQVEsQ0FBQyxDQUFDLE1BUko7TUFTWixLQUFBLEVBQU8sQ0FUSzs7QUFZYixXQUFPO0VBZk87O29CQWlCZixRQUFBLEdBQVUsU0FBQyxNQUFELEVBQVMsTUFBVCxFQUFpQixLQUFqQjtBQUNULFFBQUE7O01BRDBCLFFBQVE7O0lBQ2xDLElBQUEsR0FBVyxJQUFBLFFBQUEsQ0FDVjtNQUFBLElBQUEsRUFBTSxNQUFOO01BQ0EsQ0FBQSxFQUFHLElBQUEsR0FBSyxNQUFPLENBQUEsQ0FBQSxDQUFaLEdBQWUsR0FBZixHQUFrQixNQUFPLENBQUEsQ0FBQSxDQUF6QixHQUE0QixLQUE1QixHQUFpQyxNQUFPLENBQUEsQ0FBQSxDQUF4QyxHQUEyQyxHQUEzQyxHQUE4QyxNQUFPLENBQUEsQ0FBQSxDQUR4RDtNQUVBLE1BQUEsRUFBUSxJQUFDLENBQUEsS0FGVDtNQUdBLGNBQUEsRUFBZ0IsS0FIaEI7S0FEVTtJQU1YLElBQUcsTUFBTyxDQUFBLENBQUEsQ0FBUCxLQUFhLE1BQU8sQ0FBQSxDQUFBLENBQXZCO01BRUMsSUFBQSxHQUFXLElBQUEsUUFBQSxDQUNWO1FBQUEsSUFBQSxFQUFNLE1BQU47UUFDQSxDQUFBLEVBQUcsSUFBQSxHQUFJLENBQUMsTUFBTyxDQUFBLENBQUEsQ0FBUCxHQUFZLENBQWIsQ0FBSixHQUFtQixHQUFuQixHQUFzQixNQUFPLENBQUEsQ0FBQSxDQUE3QixHQUFnQyxLQUFoQyxHQUFvQyxDQUFDLE1BQU8sQ0FBQSxDQUFBLENBQVAsR0FBWSxDQUFiLENBQXBDLEdBQW1ELEdBQW5ELEdBQXNELE1BQU8sQ0FBQSxDQUFBLENBRGhFO1FBRUEsTUFBQSxFQUFRLElBQUMsQ0FBQSxLQUZUO1FBR0EsY0FBQSxFQUFnQixLQUhoQjtPQURVO2FBTVgsSUFBQSxHQUFXLElBQUEsUUFBQSxDQUNWO1FBQUEsSUFBQSxFQUFNLE1BQU47UUFDQSxDQUFBLEVBQUcsSUFBQSxHQUFJLENBQUMsTUFBTyxDQUFBLENBQUEsQ0FBUCxHQUFZLENBQWIsQ0FBSixHQUFtQixHQUFuQixHQUFzQixNQUFPLENBQUEsQ0FBQSxDQUE3QixHQUFnQyxLQUFoQyxHQUFvQyxDQUFDLE1BQU8sQ0FBQSxDQUFBLENBQVAsR0FBWSxDQUFiLENBQXBDLEdBQW1ELEdBQW5ELEdBQXNELE1BQU8sQ0FBQSxDQUFBLENBRGhFO1FBRUEsTUFBQSxFQUFRLElBQUMsQ0FBQSxLQUZUO1FBR0EsY0FBQSxFQUFnQixLQUhoQjtPQURVLEVBUlo7S0FBQSxNQWNLLElBQUcsTUFBTyxDQUFBLENBQUEsQ0FBUCxLQUFhLE1BQU8sQ0FBQSxDQUFBLENBQXZCO01BRUosSUFBQSxHQUFXLElBQUEsUUFBQSxDQUNWO1FBQUEsSUFBQSxFQUFNLE1BQU47UUFDQSxDQUFBLEVBQUcsSUFBQSxHQUFLLE1BQU8sQ0FBQSxDQUFBLENBQVosR0FBZSxHQUFmLEdBQWlCLENBQUMsTUFBTyxDQUFBLENBQUEsQ0FBUCxHQUFZLENBQWIsQ0FBakIsR0FBZ0MsS0FBaEMsR0FBcUMsTUFBTyxDQUFBLENBQUEsQ0FBNUMsR0FBK0MsR0FBL0MsR0FBaUQsQ0FBQyxNQUFPLENBQUEsQ0FBQSxDQUFQLEdBQVksQ0FBYixDQURwRDtRQUVBLE1BQUEsRUFBUSxJQUFDLENBQUEsS0FGVDtRQUdBLGNBQUEsRUFBZ0IsS0FIaEI7T0FEVTthQU1YLElBQUEsR0FBVyxJQUFBLFFBQUEsQ0FDVjtRQUFBLElBQUEsRUFBTSxNQUFOO1FBQ0EsQ0FBQSxFQUFHLElBQUEsR0FBSyxNQUFPLENBQUEsQ0FBQSxDQUFaLEdBQWUsR0FBZixHQUFpQixDQUFDLE1BQU8sQ0FBQSxDQUFBLENBQVAsR0FBWSxDQUFiLENBQWpCLEdBQWdDLEtBQWhDLEdBQXFDLE1BQU8sQ0FBQSxDQUFBLENBQTVDLEdBQStDLEdBQS9DLEdBQWlELENBQUMsTUFBTyxDQUFBLENBQUEsQ0FBUCxHQUFZLENBQWIsQ0FEcEQ7UUFFQSxNQUFBLEVBQVEsSUFBQyxDQUFBLEtBRlQ7UUFHQSxjQUFBLEVBQWdCLEtBSGhCO09BRFUsRUFSUDs7RUFyQkk7O29CQW1DVixTQUFBLEdBQVcsU0FBQyxDQUFELEVBQUksQ0FBSixFQUFPLElBQVA7QUFDVixRQUFBO0lBQUEsS0FBQSxHQUFZLElBQUEsUUFBQSxDQUNYO01BQUEsSUFBQSxFQUFNLE1BQU47TUFDQSxNQUFBLEVBQVEsR0FEUjtNQUVBLENBQUEsRUFBRyxDQUZIO01BR0EsQ0FBQSxFQUFHLENBSEg7TUFJQSxhQUFBLEVBQWUsSUFBQyxDQUFBLFVBSmhCO01BS0EsV0FBQSxFQUFhLElBQUMsQ0FBQSxRQUxkO01BTUEsYUFBQSxFQUFlLElBQUMsQ0FBQSxVQU5oQjtNQU9BLElBQUEsRUFBTSxJQUFDLENBQUEsY0FQUDtNQVFBLElBQUEsRUFBTSxDQUFDLElBQUEsR0FBTyxJQUFDLENBQUEsS0FBVCxDQUFlLENBQUMsT0FBaEIsQ0FBQSxDQVJOO0tBRFc7SUFXWixDQUFBLEdBQUksSUFBQyxDQUFBLGFBQUQsQ0FBZSxLQUFLLENBQUMsT0FBckI7SUFFSixLQUFLLENBQUMsQ0FBTixHQUFVLENBQUEsR0FBSSxDQUFDLENBQUMsS0FBRixHQUFVO0lBQ3hCLEtBQUssQ0FBQyxDQUFOLEdBQVUsQ0FBQSxHQUFJLENBQUMsQ0FBQyxNQUFGLEdBQVc7SUFFekIsR0FBQSxHQUFVLElBQUEsUUFBQSxDQUNUO01BQUEsSUFBQSxFQUFNLE1BQU47TUFDQSxNQUFBLEVBQVEsR0FEUjtNQUVBLENBQUEsRUFBRyxLQUFLLENBQUMsQ0FBTixHQUFVLElBQUMsQ0FBQSxPQUFPLENBQUMsSUFGdEI7TUFHQSxDQUFBLEVBQUcsS0FBSyxDQUFDLENBQU4sR0FBVSxDQUFDLENBQUMsTUFIZjtNQUlBLEtBQUEsRUFBTyxDQUFDLENBQUMsS0FBRixHQUFVLElBQUMsQ0FBQSxPQUFPLENBQUMsSUFBbkIsR0FBMEIsSUFBQyxDQUFBLE9BQU8sQ0FBQyxLQUoxQztNQUtBLE1BQUEsRUFBUSxDQUFDLENBQUMsTUFBRixHQUFXLElBQUMsQ0FBQSxPQUFPLENBQUMsR0FBcEIsR0FBMEIsSUFBQyxDQUFBLE9BQU8sQ0FBQyxNQUwzQztNQU1BLEVBQUEsRUFBSSxJQUFDLENBQUEsWUFOTDtNQU9BLEVBQUEsRUFBSSxJQUFDLENBQUEsWUFQTDtNQVFBLElBQUEsRUFBTSxJQUFDLENBQUEsS0FSUDtLQURTO1dBV1YsS0FBSyxDQUFDLElBQU4sQ0FBQTtFQTVCVTs7b0JBOEJYLGFBQUEsR0FBZSxTQUFDLFFBQUQsRUFBVyxPQUFYO0FBRWQsUUFBQTtJQUFBLENBQUEsR0FBSSxJQUFDLENBQUEsYUFBRCxDQUFlLElBQUMsQ0FBQSxlQUFoQjtJQUNKLENBQUEsR0FBSSxJQUFDLENBQUEsYUFBRCxDQUFlLElBQUMsQ0FBQSxjQUFoQjtJQUVKLElBQUMsQ0FBQSxLQUFELEdBQVMsSUFBQyxDQUFBLGFBQWEsQ0FBQyxxQkFBZixDQUFBLENBQXNDLENBQUMsS0FBdkMsR0FBK0MsTUFBTSxDQUFDO0lBRS9ELElBQUMsQ0FBQSxlQUFELENBQWlCLENBQWpCO0lBRUEsSUFBRyxJQUFDLENBQUEsZUFBRCxLQUFvQixJQUFDLENBQUEsY0FBeEI7TUFDQyxDQUFBLEdBQUksSUFBQyxDQUFBLGFBQUQsQ0FBZSxJQUFDLENBQUEsYUFBaEIsRUFETDs7SUFLQSxJQUFHLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLENBQVIsSUFBYyxDQUFDLENBQUMsSUFBRixHQUFTLENBQUMsQ0FBQyxJQUF6QixJQUFrQyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQyxDQUExQyxJQUFnRCxDQUFDLENBQUMsSUFBRixHQUFTLENBQUMsQ0FBQyxJQUE5RDtNQUlDLENBQUEsR0FBSSxJQUFJLENBQUMsR0FBTCxDQUFTLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLENBQWpCLENBQW1CLENBQUMsT0FBcEIsQ0FBQTtNQUNKLENBQUEsR0FBSSxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUEsR0FBSTtNQUVkLElBQUMsQ0FBQSxRQUFELENBQVUsQ0FBQyxDQUFDLENBQUMsSUFBSCxFQUFTLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBZixDQUFWLEVBQTZCLENBQUMsQ0FBQyxDQUFDLElBQUgsRUFBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQWYsQ0FBN0I7TUFDQSxJQUFDLENBQUEsU0FBRCxDQUFXLENBQUMsQ0FBQyxJQUFiLEVBQW1CLENBQW5CLEVBQXNCLENBQXRCO01BSUEsQ0FBQSxHQUFJLElBQUksQ0FBQyxHQUFMLENBQVMsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFDLENBQUMsSUFBcEIsQ0FBeUIsQ0FBQyxPQUExQixDQUFBO01BQ0osQ0FBQSxHQUFJLENBQUMsQ0FBQyxJQUFGLEdBQVMsQ0FBQyxDQUFBLEdBQUksQ0FBTDtNQUViLElBQUMsQ0FBQSxRQUFELENBQVUsQ0FBQyxDQUFDLENBQUMsSUFBRixHQUFTLENBQVYsRUFBYSxDQUFDLENBQUMsSUFBZixDQUFWLEVBQWdDLENBQUMsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFWLEVBQWEsQ0FBQyxDQUFDLElBQWYsQ0FBaEM7TUFDQSxJQUFDLENBQUEsU0FBRCxDQUFXLENBQVgsRUFBYyxDQUFDLENBQUMsSUFBaEIsRUFBc0IsQ0FBdEI7TUFJQSxDQUFBLEdBQUksSUFBSSxDQUFDLEdBQUwsQ0FBUyxDQUFDLENBQUMsSUFBRixHQUFTLENBQUMsQ0FBQyxJQUFwQixDQUF5QixDQUFDLE9BQTFCLENBQUE7TUFDSixDQUFBLEdBQUksQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFDLENBQUEsR0FBSSxDQUFMO01BRWIsSUFBQyxDQUFBLFFBQUQsQ0FBVSxDQUFDLENBQUMsQ0FBQyxJQUFILEVBQVMsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFsQixDQUFWLEVBQWdDLENBQUMsQ0FBQyxDQUFDLElBQUgsRUFBUyxDQUFDLENBQUMsSUFBRixHQUFTLENBQWxCLENBQWhDO01BQ0EsSUFBQyxDQUFBLFNBQUQsQ0FBVyxDQUFDLENBQUMsSUFBYixFQUFtQixDQUFuQixFQUFzQixDQUF0QjtNQUlBLENBQUEsR0FBSSxJQUFJLENBQUMsR0FBTCxDQUFTLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLENBQWpCLENBQW1CLENBQUMsT0FBcEIsQ0FBQTtNQUNKLENBQUEsR0FBSSxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUEsR0FBSTtNQUVkLElBQUMsQ0FBQSxRQUFELENBQVUsQ0FBQyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQVAsRUFBVSxDQUFDLENBQUMsSUFBWixDQUFWLEVBQTZCLENBQUMsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFQLEVBQVUsQ0FBQyxDQUFDLElBQVosQ0FBN0I7TUFDQSxJQUFDLENBQUEsU0FBRCxDQUFXLENBQVgsRUFBYyxDQUFDLENBQUMsSUFBaEIsRUFBc0IsQ0FBdEI7TUFFQSxJQUFDLENBQUEsaUJBQUQsQ0FBbUIsQ0FBbkIsRUFBc0IsQ0FBdEI7QUFFQSxhQXBDRDs7SUF3Q0EsSUFBRyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQyxDQUFSLElBQWMsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFDLENBQUMsSUFBekIsSUFBa0MsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFDLENBQUMsQ0FBMUMsSUFBZ0QsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFDLENBQUMsSUFBOUQ7TUFJQyxDQUFBLEdBQUksSUFBSSxDQUFDLEdBQUwsQ0FBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQyxDQUFqQixDQUFtQixDQUFDLE9BQXBCLENBQUE7TUFDSixDQUFBLEdBQUksQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFBLEdBQUk7TUFFZCxJQUFDLENBQUEsUUFBRCxDQUFVLENBQUMsQ0FBQyxDQUFDLElBQUgsRUFBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQWYsQ0FBVixFQUE2QixDQUFDLENBQUMsQ0FBQyxJQUFILEVBQVMsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFmLENBQTdCO01BQ0EsSUFBQyxDQUFBLFNBQUQsQ0FBVyxDQUFDLENBQUMsSUFBYixFQUFtQixDQUFuQixFQUFzQixDQUF0QjtNQUNBLElBQUMsQ0FBQSxjQUFELENBQWdCLFFBQWhCLEVBQTBCLENBQTFCO01BSUEsQ0FBQSxHQUFJLElBQUksQ0FBQyxHQUFMLENBQVMsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFDLENBQUMsSUFBcEIsQ0FBeUIsQ0FBQyxPQUExQixDQUFBO01BQ0osQ0FBQSxHQUFJLENBQUMsQ0FBQyxJQUFGLEdBQVMsQ0FBQyxDQUFBLEdBQUksQ0FBTDtNQUViLElBQUMsQ0FBQSxRQUFELENBQVUsQ0FBQyxDQUFDLENBQUMsSUFBRixHQUFTLENBQVYsRUFBYSxDQUFDLENBQUMsSUFBZixDQUFWLEVBQWdDLENBQUMsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFWLEVBQWEsQ0FBQyxDQUFDLElBQWYsQ0FBaEM7TUFDQSxJQUFDLENBQUEsU0FBRCxDQUFXLENBQVgsRUFBYyxDQUFDLENBQUMsSUFBaEIsRUFBc0IsQ0FBdEI7TUFJQSxDQUFBLEdBQUksSUFBSSxDQUFDLEdBQUwsQ0FBUyxDQUFDLENBQUMsSUFBRixHQUFTLENBQUMsQ0FBQyxJQUFwQixDQUF5QixDQUFDLE9BQTFCLENBQUE7TUFDSixDQUFBLEdBQUksQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFDLENBQUEsR0FBSSxDQUFMO01BRWIsSUFBQyxDQUFBLFFBQUQsQ0FBVSxDQUFDLENBQUMsQ0FBQyxJQUFILEVBQVMsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFsQixDQUFWLEVBQWdDLENBQUMsQ0FBQyxDQUFDLElBQUgsRUFBUyxDQUFDLENBQUMsSUFBRixHQUFTLENBQWxCLENBQWhDO01BQ0EsSUFBQyxDQUFBLFNBQUQsQ0FBVyxDQUFDLENBQUMsSUFBYixFQUFtQixDQUFuQixFQUFzQixDQUF0QjtNQUlBLENBQUEsR0FBSSxJQUFJLENBQUMsR0FBTCxDQUFTLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLENBQWpCLENBQW1CLENBQUMsT0FBcEIsQ0FBQTtNQUNKLENBQUEsR0FBSSxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUEsR0FBSTtNQUVkLElBQUMsQ0FBQSxRQUFELENBQVUsQ0FBQyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQVAsRUFBVSxDQUFDLENBQUMsSUFBWixDQUFWLEVBQTZCLENBQUMsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFQLEVBQVUsQ0FBQyxDQUFDLElBQVosQ0FBN0I7TUFDQSxJQUFDLENBQUEsU0FBRCxDQUFXLENBQVgsRUFBYyxDQUFDLENBQUMsSUFBaEIsRUFBc0IsQ0FBdEI7TUFDQSxJQUFDLENBQUEsY0FBRCxDQUFnQixRQUFoQixFQUEwQixDQUExQjtNQUVBLElBQUMsQ0FBQSxpQkFBRCxDQUFtQixDQUFuQixFQUFzQixDQUF0QjtBQUVBLGFBdENEOztJQTRDQSxJQUFHLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLElBQVg7TUFFQyxDQUFBLEdBQUksSUFBSSxDQUFDLEdBQUwsQ0FBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQyxJQUFqQixDQUFzQixDQUFDLE9BQXZCLENBQUE7TUFDSixDQUFBLEdBQUksQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFDLENBQUEsR0FBSSxDQUFMO01BRVYsSUFBQyxDQUFBLFFBQUQsQ0FBVSxDQUFDLENBQUMsQ0FBQyxJQUFILEVBQVMsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFsQixDQUFWLEVBQWdDLENBQUMsQ0FBQyxDQUFDLElBQUgsRUFBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQWYsQ0FBaEM7TUFDQSxJQUFDLENBQUEsU0FBRCxDQUFXLENBQUMsQ0FBQyxJQUFiLEVBQW1CLENBQW5CLEVBQXNCLENBQXRCLEVBTkQ7S0FBQSxNQVFLLElBQUcsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFDLENBQUMsQ0FBWDtNQUVKLENBQUEsR0FBSSxJQUFJLENBQUMsR0FBTCxDQUFTLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLENBQWpCLENBQW1CLENBQUMsT0FBcEIsQ0FBQTtNQUNKLENBQUEsR0FBSSxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQSxHQUFJLENBQUw7TUFFVixJQUFHLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLENBQVg7UUFDQyxJQUFDLENBQUEsUUFBRCxDQUFVLENBQUMsQ0FBQyxDQUFDLElBQUgsRUFBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQWYsQ0FBVixFQUE2QixDQUFDLENBQUMsQ0FBQyxJQUFILEVBQVMsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFmLENBQTdCO1FBQ0EsSUFBQyxDQUFBLFNBQUQsQ0FBVyxDQUFDLENBQUMsSUFBYixFQUFtQixDQUFuQixFQUFzQixDQUF0QixFQUZEO09BQUEsTUFBQTtRQUlDLElBQUMsQ0FBQSxRQUFELENBQVUsQ0FBQyxDQUFDLENBQUMsSUFBSCxFQUFTLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBZixDQUFWLEVBQTZCLENBQUMsQ0FBQyxDQUFDLElBQUgsRUFBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQWYsQ0FBN0I7UUFDQSxJQUFDLENBQUEsU0FBRCxDQUFXLENBQUMsQ0FBQyxJQUFiLEVBQW1CLENBQW5CLEVBQXNCLENBQXRCLEVBTEQ7T0FMSTs7SUFjTCxJQUFHLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLElBQVg7TUFFQyxDQUFBLEdBQUksSUFBSSxDQUFDLEdBQUwsQ0FBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQyxJQUFqQixDQUFzQixDQUFDLE9BQXZCLENBQUE7TUFDSixDQUFBLEdBQUksQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFDLENBQUEsR0FBSSxDQUFMO01BRVYsSUFBQyxDQUFBLFFBQUQsQ0FBVSxDQUFDLENBQUMsQ0FBQyxJQUFGLEdBQVMsQ0FBVixFQUFhLENBQUMsQ0FBQyxJQUFmLENBQVYsRUFBZ0MsQ0FBQyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQVAsRUFBVSxDQUFDLENBQUMsSUFBWixDQUFoQztNQUNBLElBQUMsQ0FBQSxTQUFELENBQVcsQ0FBWCxFQUFjLENBQUMsQ0FBQyxJQUFoQixFQUFzQixDQUF0QixFQU5EO0tBQUEsTUFRSyxJQUFHLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLENBQVg7TUFFSixDQUFBLEdBQUksSUFBSSxDQUFDLEdBQUwsQ0FBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQyxDQUFqQixDQUFtQixDQUFDLE9BQXBCLENBQUE7TUFDSixDQUFBLEdBQUksQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFDLENBQUEsR0FBSSxDQUFMO01BRVYsSUFBRyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQyxJQUFYO1FBQ0MsSUFBQyxDQUFBLFFBQUQsQ0FBVSxDQUFDLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBUCxFQUFVLENBQUMsQ0FBQyxJQUFaLENBQVYsRUFBNkIsQ0FBQyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQVAsRUFBVSxDQUFDLENBQUMsSUFBWixDQUE3QjtRQUNBLElBQUMsQ0FBQSxTQUFELENBQVcsQ0FBWCxFQUFjLENBQUMsQ0FBQyxJQUFoQixFQUFzQixDQUF0QixFQUZEO09BQUEsTUFBQTtRQUlDLElBQUMsQ0FBQSxRQUFELENBQVUsQ0FBQyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQVAsRUFBVSxDQUFDLENBQUMsSUFBWixDQUFWLEVBQTZCLENBQUMsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFQLEVBQVUsQ0FBQyxDQUFDLElBQVosQ0FBN0I7UUFDQSxJQUFDLENBQUEsU0FBRCxDQUFXLENBQVgsRUFBYyxDQUFDLENBQUMsSUFBaEIsRUFBc0IsQ0FBdEIsRUFMRDtPQUxJOztJQWNMLElBQUcsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFDLENBQUMsQ0FBZDtNQUVDLENBQUEsR0FBSSxJQUFJLENBQUMsR0FBTCxDQUFTLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLElBQWpCLENBQXNCLENBQUMsT0FBdkIsQ0FBQTtNQUNKLENBQUEsR0FBSSxDQUFDLENBQUMsSUFBRixHQUFTLENBQUMsQ0FBQSxHQUFJLENBQUw7TUFFYixJQUFDLENBQUEsUUFBRCxDQUFVLENBQUMsQ0FBQyxDQUFDLElBQUYsR0FBUyxDQUFWLEVBQWEsQ0FBQyxDQUFDLElBQWYsQ0FBVixFQUFnQyxDQUFDLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBUCxFQUFVLENBQUMsQ0FBQyxJQUFaLENBQWhDO01BQ0EsSUFBQyxDQUFBLFNBQUQsQ0FBVyxDQUFYLEVBQWMsQ0FBQyxDQUFDLElBQWhCLEVBQXNCLENBQXRCLEVBTkQ7S0FBQSxNQVFLLElBQUcsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFDLENBQUMsQ0FBWDtNQUVKLENBQUEsR0FBSSxJQUFJLENBQUMsR0FBTCxDQUFTLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLENBQWpCLENBQW1CLENBQUMsT0FBcEIsQ0FBQTtNQUNKLENBQUEsR0FBSSxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQSxHQUFJLENBQUw7TUFFVixJQUFHLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLElBQVg7UUFDQyxJQUFDLENBQUEsUUFBRCxDQUFVLENBQUMsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFQLEVBQVUsQ0FBQyxDQUFDLElBQVosQ0FBVixFQUE2QixDQUFDLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBUCxFQUFVLENBQUMsQ0FBQyxJQUFaLENBQTdCO1FBQ0EsSUFBQyxDQUFBLFNBQUQsQ0FBVyxDQUFYLEVBQWMsQ0FBQyxDQUFDLElBQWhCLEVBQXNCLENBQXRCLEVBRkQ7T0FBQSxNQUFBO1FBSUMsSUFBQyxDQUFBLFFBQUQsQ0FBVSxDQUFDLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBUCxFQUFVLENBQUMsQ0FBQyxJQUFaLENBQVYsRUFBNkIsQ0FBQyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQVAsRUFBVSxDQUFDLENBQUMsSUFBWixDQUE3QjtRQUNBLElBQUMsQ0FBQSxTQUFELENBQVcsQ0FBWCxFQUFjLENBQUMsQ0FBQyxJQUFoQixFQUFzQixDQUF0QixFQUxEO09BTEk7O0lBY0wsSUFBRyxDQUFDLENBQUMsSUFBRixHQUFTLENBQUMsQ0FBQyxDQUFkO01BRUMsQ0FBQSxHQUFJLElBQUksQ0FBQyxHQUFMLENBQVMsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFDLENBQUMsSUFBakIsQ0FBc0IsQ0FBQyxPQUF2QixDQUFBO01BQ0osQ0FBQSxHQUFJLENBQUMsQ0FBQyxJQUFGLEdBQVMsQ0FBQyxDQUFBLEdBQUksQ0FBTDtNQUViLElBQUMsQ0FBQSxRQUFELENBQVUsQ0FBQyxDQUFDLENBQUMsSUFBSCxFQUFTLENBQUMsQ0FBQyxJQUFGLEdBQVMsQ0FBbEIsQ0FBVixFQUFnQyxDQUFDLENBQUMsQ0FBQyxJQUFILEVBQVMsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFmLENBQWhDO01BQ0EsSUFBQyxDQUFBLFNBQUQsQ0FBVyxDQUFDLENBQUMsSUFBYixFQUFtQixDQUFuQixFQUFzQixDQUF0QixFQU5EO0tBQUEsTUFRSyxJQUFHLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBQyxDQUFDLENBQVg7TUFFSixDQUFBLEdBQUksSUFBSSxDQUFDLEdBQUwsQ0FBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQyxDQUFqQixDQUFtQixDQUFDLE9BQXBCLENBQUE7TUFDSixDQUFBLEdBQUksQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFDLENBQUEsR0FBSSxDQUFMO01BRVYsSUFBRyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQUMsQ0FBQyxDQUFYO1FBQ0MsSUFBQyxDQUFBLFFBQUQsQ0FBVSxDQUFDLENBQUMsQ0FBQyxJQUFILEVBQVMsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFmLENBQVYsRUFBNkIsQ0FBQyxDQUFDLENBQUMsSUFBSCxFQUFTLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FBZixDQUE3QjtRQUNBLElBQUMsQ0FBQSxTQUFELENBQVcsQ0FBQyxDQUFDLElBQWIsRUFBbUIsQ0FBbkIsRUFBc0IsQ0FBdEIsRUFGRDtPQUFBLE1BQUE7UUFJQyxJQUFDLENBQUEsUUFBRCxDQUFVLENBQUMsQ0FBQyxDQUFDLElBQUgsRUFBUyxDQUFDLENBQUMsQ0FBRixHQUFNLENBQWYsQ0FBVixFQUE2QixDQUFDLENBQUMsQ0FBQyxJQUFILEVBQVMsQ0FBQyxDQUFDLENBQUYsR0FBTSxDQUFmLENBQTdCO1FBQ0EsSUFBQyxDQUFBLFNBQUQsQ0FBVyxDQUFDLENBQUMsSUFBYixFQUFtQixDQUFuQixFQUFzQixDQUF0QixFQUxEO09BTEk7O1dBWUwsSUFBQyxDQUFBLGlCQUFELENBQW1CLENBQW5CLEVBQXNCLENBQXRCO0VBeExjOztvQkEwTGYsaUJBQUEsR0FBbUIsU0FBQyxDQUFELEVBQUksQ0FBSjtBQUVsQixRQUFBO0lBQUEsV0FBQSxHQUFrQixJQUFBLFFBQUEsQ0FDakI7TUFBQSxJQUFBLEVBQU0sTUFBTjtNQUNBLE1BQUEsRUFBUSxHQURSO01BRUEsQ0FBQSxFQUFHLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FGVDtNQUdBLENBQUEsRUFBRyxDQUFDLENBQUMsQ0FBRixHQUFNLENBSFQ7TUFJQSxLQUFBLEVBQU8sQ0FBQyxDQUFDLEtBQUYsR0FBVSxDQUpqQjtNQUtBLE1BQUEsRUFBUSxDQUFDLENBQUMsTUFBRixHQUFXLENBTG5CO01BTUEsTUFBQSxFQUFRLE1BTlI7TUFPQSxJQUFBLEVBQU0sTUFQTjtNQVFBLGNBQUEsRUFBZ0IsS0FSaEI7S0FEaUI7V0FXbEIsWUFBQSxHQUFtQixJQUFBLFFBQUEsQ0FDbEI7TUFBQSxJQUFBLEVBQU0sTUFBTjtNQUNBLE1BQUEsRUFBUSxHQURSO01BRUEsQ0FBQSxFQUFHLENBQUMsQ0FBQyxDQUFGLEdBQU0sQ0FGVDtNQUdBLENBQUEsRUFBRyxDQUFDLENBQUMsQ0FBRixHQUFNLENBSFQ7TUFJQSxLQUFBLEVBQU8sQ0FBQyxDQUFDLEtBQUYsR0FBVSxDQUpqQjtNQUtBLE1BQUEsRUFBUSxDQUFDLENBQUMsTUFBRixHQUFXLENBTG5CO01BTUEsTUFBQSxFQUFRLEtBTlI7TUFPQSxJQUFBLEVBQU0sTUFQTjtNQVFBLGNBQUEsRUFBZ0IsS0FSaEI7S0FEa0I7RUFiRDs7b0JBd0JuQixjQUFBLEdBQWdCLFNBQUMsU0FBRCxFQUFZLEtBQVo7V0FDZixJQUFDLENBQUEsTUFBTyxDQUFBLFNBQUEsQ0FBVSxDQUFDLEtBQW5CLG1CQUEyQixRQUFRO0VBRHBCOztvQkFHaEIsZUFBQSxHQUFpQixTQUFBO0FBQ2hCLFFBQUE7SUFBQSxDQUFBLEdBQUksSUFBQyxDQUFBO0lBQ0wsRUFBQSxHQUFLLElBQUMsQ0FBQTtJQUNOLENBQUEsR0FBSSxJQUFDLENBQUE7SUFDTCxFQUFBLEdBQUssSUFBQyxDQUFBO0lBRU4sSUFBTyxXQUFKLElBQWUsV0FBbEI7TUFDQyxJQUFDLENBQUEsY0FBRCxDQUFnQixnQkFBaEIsRUFBa0MsRUFBbEM7TUFDQSxJQUFDLENBQUEsY0FBRCxDQUFnQixRQUFoQixFQUEwQixFQUExQjtNQUNBLElBQUMsQ0FBQSxjQUFELENBQWdCLFFBQWhCLEVBQTBCLEVBQTFCO01BQ0EsSUFBQyxDQUFBLGNBQUQsQ0FBZ0IsWUFBaEIsRUFBOEIsRUFBOUI7TUFDQSxJQUFDLENBQUEsY0FBRCxDQUFnQixhQUFoQixFQUErQixFQUEvQjtNQUNBLElBQUMsQ0FBQSxjQUFELENBQWdCLGFBQWhCLEVBQStCLEVBQS9CO01BQ0EsSUFBQyxDQUFBLGNBQUQsQ0FBZ0IsYUFBaEIsRUFBK0IsRUFBL0I7QUFFQSxhQVREOztJQVdBLElBQUcsV0FBQSxJQUFXLFdBQWQ7TUFDQyxJQUFDLENBQUEsY0FBRCxDQUFnQixnQkFBaEIsRUFBa0MsQ0FBQyxDQUFDLFdBQVcsQ0FBQyxJQUFoRDtNQUNBLElBQUMsQ0FBQSxjQUFELENBQWdCLFFBQWhCLEVBQTBCLENBQUMsQ0FBQyxDQUE1QjtNQUNBLElBQUMsQ0FBQSxjQUFELENBQWdCLFFBQWhCLEVBQTBCLENBQUMsQ0FBQyxDQUE1QjtNQUNBLElBQUMsQ0FBQSxjQUFELENBQWdCLFlBQWhCLEVBQThCLENBQUMsQ0FBQyxXQUFXLENBQUMsS0FBNUM7TUFDQSxJQUFDLENBQUEsY0FBRCxDQUFnQixhQUFoQixFQUErQixDQUFDLENBQUMsV0FBVyxDQUFDLE1BQTdDO01BQ0EsSUFBQyxDQUFBLGNBQUQsQ0FBZ0IsYUFBaEIsRUFBK0IsQ0FBQyxDQUFDLFlBQWpDO01BRUEsSUFBRyxDQUFDLENBQUMsV0FBRixHQUFnQixDQUFuQjtRQUNDLElBQUMsQ0FBQSxjQUFELENBQWdCLGFBQWhCLEVBQStCLENBQUMsQ0FBQyxXQUFGLEdBQWdCLEdBQWhCLEdBQXNCLENBQUMsQ0FBQyxXQUF2RCxFQUREO09BQUEsTUFBQTtRQUdDLElBQUMsQ0FBQSxjQUFELENBQWdCLGFBQWhCLEVBQStCLE1BQS9CLEVBSEQ7O01BS0EsSUFBRyxDQUFDLENBQUMsT0FBRixHQUFZLENBQVosSUFBaUIsQ0FBQyxDQUFDLE9BQUYsR0FBWSxDQUE3QixJQUFrQyxDQUFDLENBQUMsWUFBRixHQUFpQixDQUF0RDtRQUNDLElBQUMsQ0FBQSxjQUFELENBQWdCLGFBQWhCLEVBQStCLENBQUMsQ0FBQyxPQUFGLEdBQVksR0FBWixHQUFrQixDQUFDLENBQUMsT0FBcEIsR0FBOEIsR0FBOUIsR0FBb0MsQ0FBQyxDQUFDLFlBQXRDLEdBQXFELEdBQXJELEdBQTJELENBQUMsQ0FBQyxXQUE1RixFQUREO09BQUEsTUFBQTtRQUdDLElBQUMsQ0FBQSxjQUFELENBQWdCLGFBQWhCLEVBQStCLE1BQS9CLEVBSEQ7T0FiRDs7RUFqQmdCOztvQkFzQ2pCLEtBQUEsR0FBTyxTQUFDLEtBQUQ7QUFDTixRQUFBO0lBQUEsSUFBRyxJQUFDLENBQUEsT0FBRCxLQUFZLEtBQWY7QUFDQyxhQUREOztJQUdBLElBQUMsQ0FBQSxPQUFELENBQUE7O01BRUEsSUFBQyxDQUFBLGtCQUFtQixJQUFDLENBQUE7O0lBQ3JCLElBQUMsQ0FBQSxjQUFELGlFQUFtQyxJQUFDLENBQUE7SUFFcEMsSUFBRyxDQUFJLElBQUMsQ0FBQSxjQUFSO0FBQ0MsYUFERDs7SUFHQSxJQUFHLElBQUMsQ0FBQSxjQUFELEtBQW1CLElBQUMsQ0FBQSxNQUFNLENBQUMsUUFBOUI7TUFDQyxJQUFDLENBQUEsY0FBRCxHQUFrQixJQUFDLENBQUEsY0FEcEI7O0lBR0EsSUFBQyxDQUFBLGFBQUQsR0FBaUIsSUFBQyxDQUFBLG1CQUFELENBQXFCLElBQUMsQ0FBQSxlQUF0QjtJQUNqQixJQUFDLENBQUEsWUFBRCxHQUFnQixJQUFDLENBQUEsbUJBQUQsQ0FBcUIsSUFBQyxDQUFBLGNBQXRCO0lBQ2hCLElBQUMsQ0FBQSxlQUFELENBQUE7SUFFQSxJQUFDLENBQUEsYUFBRCxDQUFlLElBQUMsQ0FBQSxlQUFoQixFQUFpQyxJQUFDLENBQUEsY0FBbEM7SUFFQSxJQUFHLElBQUMsQ0FBQSxhQUFELEtBQWtCLElBQUMsQ0FBQSxjQUF0QjtBQUNDLGFBREQ7O1dBR0EsSUFBQyxDQUFBLGNBQWMsQ0FBQyxnQkFBaEIsQ0FBaUMsT0FBakMsRUFBMEMsSUFBQyxDQUFBLE1BQTNDO0VBeEJNOztvQkEwQlAsT0FBQSxHQUFTLFNBQUMsS0FBRDtXQUNSLEdBQUcsQ0FBQyxTQUFKLENBQUE7RUFEUTs7Ozs7O0FBSVYsT0FBTyxDQUFDLE9BQVIsR0FBa0IsSUFBSSJ9
