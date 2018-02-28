require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"TextField":[function(require,module,exports){
var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

exports.TextField = (function(superClass) {
  extend(TextField, superClass);

  function TextField(options) {
    var ref, ref1, ref2, ref3, ref4, ref5, ref6, ref7;
    if (options == null) {
      options = {};
    }
    this.showFocused = bind(this.showFocused, this);
    this.focus = bind(this.focus, this);
    this.setValue = bind(this.setValue, this);
    this._color = (ref = options.color) != null ? ref : 'rgba(0,0,0,.87)';
    this._inputType = (ref1 = options.inputType) != null ? ref1 : 'text';
    this._inputMode = (ref2 = options.inputMode) != null ? ref2 : 'latin';
    this._maxLength = options.maxLength;
    this._placeholder = (ref3 = options.placeholder) != null ? ref3 : '';
    this._readOnly = options.readOnly;
    this._value = '';
    this.tint = (ref4 = options.tint) != null ? ref4 : 'blue';
    this.selectionColor = (ref5 = options.selectionColor) != null ? ref5 : new Color(this.tint).desaturate(-20).alpha(.5);
    this._warn = false;
    this._warnText = (ref6 = options.warnText) != null ? ref6 : 'Warning description.';
    this.pattern = (ref7 = options.pattern) != null ? ref7 : function(value) {
      return null;
    };
    this.matches = false;
    this._warn;
    this._disabled;
    this._focused;
    this._color;
    this._helperText;
    this._helperTextColor;
    this._labelText;
    this._labelTextColor;
    TextField.__super__.constructor.call(this, _.defaults(options, {
      text: '',
      fontSize: 14,
      height: 48,
      width: 256,
      borderWidth: 1,
      borderRadius: 4,
      padding: {
        top: 4,
        right: 12,
        bottom: 4,
        left: 12
      },
      animationOptions: {
        time: .15
      }
    }));
    this._input = document.createElement('input');
    this._element.appendChild(this._input);
    this._input.spellcheck = false;
    this._input.autocapitalize = false;
    this._input.autocomplete = false;
    this._input.tabindex = "-1";
    this._input.placeholder = this._placeholder;
    Utils.insertCSS("*:focus { outline: 0; }\ntextarea { resize: none; } \n::selection { background: " + this.selectionColor + "; } \n}");
    this.setStyle();
    this._input.onfocus = (function(_this) {
      return function() {
        return _this.focused = true;
      };
    })(this);
    this._input.onblur = (function(_this) {
      return function() {
        return _this.focused = false;
      };
    })(this);
    this._input.oninput = this.setValue;
    this.warnText = new TextLayer({
      parent: this,
      y: this.height + 8,
      fontSize: 10,
      fontFamily: this.fontFamily,
      color: '#FF3333',
      text: '{warnText}',
      visible: this._warn
    });
    this.warnText.template = this._warnText;
    this.states = {
      disabled: {
        borderColor: '#AAA',
        color: '#CCC'
      },
      focus_hasText: {
        borderColor: '#000',
        color: '#333'
      },
      focus_noText: {
        borderColor: '#000',
        color: '#AAA'
      },
      unfocus_hasText: {
        borderColor: '#AAA',
        color: '#000'
      },
      unfocus_noText: {
        borderColor: '#AAA',
        color: '#AAA'
      },
      warn_noText: {
        borderColor: '#FF3333',
        color: '#FF7777'
      },
      warn_hasText: {
        borderColor: '#FF3333',
        color: '#FF3333'
      }
    };
    this.on("change:color", (function(_this) {
      return function() {
        return _this._input.style['-webkit-text-fill-color'] = _this.color;
      };
    })(this));
    this.showFocused();
  }

  TextField.prototype.setStyle = function() {
    return this._input.style.cssText = "z-index:5;\nzoom: " + this.context.scale + ";\nfont-size: " + this.fontSize + "px;\nfont-weight: " + this.fontWeight + ";\nfont-family: " + this.fontFamily + ";\ncolor: " + this.tint + ";\n-webkit-text-fill-color: " + this._color + ";\nbackground-color: transparent;\nposition: absolute;\ntop: 0px;\nleft: 0px;\nresize: none;\nwidth: " + this.width + "px;\nheight: 100%;\npadding: " + this.padding.top + "px " + this.padding.right + "px " + this.padding.bottom + "px " + this.padding.left + "px;\noutline: 0px none transparent !important;\nline-height: " + this.lineHeight + ";\n-webkit-box-sizing: border-box; /* Safari/Chrome, other WebKit */\n-moz-box-sizing: border-box;    /* Firefox, other Gecko */\nbox-sizing: border-box; ";
  };

  TextField.prototype.setValue = function() {
    return this.value = this._input.value;
  };

  TextField.prototype.setInputAttribute = function(attribute, value) {
    return this._input.setAttribute(attribute, value);
  };

  TextField.prototype.focus = function() {
    return this._input.focus();
  };

  TextField.prototype.showFocused = function() {
    if (this.disabled) {
      this.animateStop();
      this.animate('disabled');
      return;
    }
    if (this.warn) {
      this.animateStop();
      if (this.hasTextContent()) {
        this.animate('warn_hasText');
      } else {
        this.animate('warn_noText');
      }
      return;
    }
    if (this.focused) {
      this.animateStop();
      if (this.hasTextContent()) {
        return this.animate('focus_hasText');
      } else {
        return this.animate('focus_noText');
      }
    } else {
      this.animateStop();
      if (this.hasTextContent()) {
        return this.animate('unfocus_hasText');
      } else {
        return this.animate('unfocus_noText');
      }
    }
  };

  TextField.prototype.hasTextContent = function() {
    return this.value.length > 0;
  };

  TextField.prototype.hasHelperText = function() {
    var ref;
    return ((ref = this.helperText) != null ? ref.length : void 0) > 0;
  };

  TextField.prototype.hasLabelText = function() {
    var ref;
    return ((ref = this.labelText) != null ? ref.length : void 0) > 0;
  };

  TextField.prototype.hasPlaceholder = function() {
    var ref;
    return ((ref = this._placeholder) != null ? ref.length : void 0) > 0;
  };

  TextField.define("value", {
    get: function() {
      return this._value;
    },
    set: function(value) {
      if (this._value === value) {
        return;
      }
      this._value = value;
      this.matches = this.pattern(value);
      this.emit("change:value", this.value, this.matches, this);
      return this.showFocused();
    }
  });

  TextField.define("disabled", {
    get: function() {
      return this._disabled;
    },
    set: function(value) {
      if (this._disabled === value) {
        return;
      }
      if (typeof value !== 'boolean') {
        throw 'Disabled must be either true or false.';
      }
      this._disabled = value;
      this.emit("change:disabled", value, this);
      return this.showFocused();
    }
  });

  TextField.define("warn", {
    get: function() {
      return this._warn;
    },
    set: function(value) {
      if (this._warn === value) {
        return;
      }
      if (typeof value !== 'boolean') {
        throw 'Warn must be either true or false.';
      }
      this._warn = value;
      this.emit("change:warn", value, this);
      this.warnText.visible = this._warn;
      return this.showFocused();
    }
  });

  TextField.define("warning", {
    get: function() {
      return this._warnText;
    },
    set: function(value) {
      if (this._warnText === value) {
        return;
      }
      this._warnText = value;
      return this.warnText.template = this._warnText;
    }
  });

  TextField.define("focused", {
    get: function() {
      return this._focused;
    },
    set: function(value) {
      if (this._focused === value) {
        return;
      }
      if (typeof value !== 'boolean') {
        throw 'Focused must be either true or false.';
      }
      this._focused = value;
      if (value === true && document.activeElement !== this._input) {
        this._input.focus();
      } else if (value === false && document.activeElement === this._input) {
        this._input.blur();
      }
      this.emit("change:focused", value, this);
      return this.showFocused();
    }
  });

  return TextField;

})(TextLayer);


},{}],"myModule":[function(require,module,exports){
exports.myVar = "myVariable";

exports.myFunction = function() {
  return print("myFunction is running");
};

exports.myArray = [1, 2, 3];


},{}]},{},[])
//# sourceMappingURL=data:application/json;charset=utf-8;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZnJhbWVyLm1vZHVsZXMuanMiLCJzb3VyY2VzIjpbIi4uLy4uLy4uLy4uLy4uL1VzZXJzL3N0ZXBoZW5ydWl6L0RvY3VtZW50cy9GcmFtZXIvbG9naW4uZnJhbWVyL21vZHVsZXMvbXlNb2R1bGUuY29mZmVlIiwiLi4vLi4vLi4vLi4vLi4vVXNlcnMvc3RlcGhlbnJ1aXovRG9jdW1lbnRzL0ZyYW1lci9sb2dpbi5mcmFtZXIvbW9kdWxlcy9UZXh0RmllbGQuY29mZmVlIiwibm9kZV9tb2R1bGVzL2Jyb3dzZXItcGFjay9fcHJlbHVkZS5qcyJdLCJzb3VyY2VzQ29udGVudCI6WyIjIEFkZCB0aGUgZm9sbG93aW5nIGxpbmUgdG8geW91ciBwcm9qZWN0IGluIEZyYW1lciBTdHVkaW8uIFxuIyBteU1vZHVsZSA9IHJlcXVpcmUgXCJteU1vZHVsZVwiXG4jIFJlZmVyZW5jZSB0aGUgY29udGVudHMgYnkgbmFtZSwgbGlrZSBteU1vZHVsZS5teUZ1bmN0aW9uKCkgb3IgbXlNb2R1bGUubXlWYXJcblxuZXhwb3J0cy5teVZhciA9IFwibXlWYXJpYWJsZVwiXG5cbmV4cG9ydHMubXlGdW5jdGlvbiA9IC0+XG5cdHByaW50IFwibXlGdW5jdGlvbiBpcyBydW5uaW5nXCJcblxuZXhwb3J0cy5teUFycmF5ID0gWzEsIDIsIDNdIiwiIyBUZXh0RmllbGRcblxuY2xhc3MgZXhwb3J0cy5UZXh0RmllbGQgZXh0ZW5kcyBUZXh0TGF5ZXJcblx0Y29uc3RydWN0b3I6IChvcHRpb25zID0ge30pIC0+XG5cblx0XHRAX2NvbG9yID0gb3B0aW9ucy5jb2xvciA/ICdyZ2JhKDAsMCwwLC44NyknXG5cdFx0QF9pbnB1dFR5cGUgPSBvcHRpb25zLmlucHV0VHlwZSA/ICd0ZXh0J1xuXHRcdEBfaW5wdXRNb2RlID0gb3B0aW9ucy5pbnB1dE1vZGUgPyAnbGF0aW4nXG5cdFx0QF9tYXhMZW5ndGggPSBvcHRpb25zLm1heExlbmd0aFxuXHRcdEBfcGxhY2Vob2xkZXIgPSBvcHRpb25zLnBsYWNlaG9sZGVyID8gJydcblx0XHRAX3JlYWRPbmx5ID0gb3B0aW9ucy5yZWFkT25seVxuXHRcdEBfdmFsdWUgPSAnJ1xuXHRcdFxuXHRcdEB0aW50ID0gb3B0aW9ucy50aW50ID8gJ2JsdWUnXG5cdFx0QHNlbGVjdGlvbkNvbG9yID0gb3B0aW9ucy5zZWxlY3Rpb25Db2xvciA/IG5ldyBDb2xvcihAdGludCkuZGVzYXR1cmF0ZSgtMjApLmFscGhhKC41KVxuXG5cdFx0QF93YXJuID0gZmFsc2Vcblx0XHRAX3dhcm5UZXh0ID0gb3B0aW9ucy53YXJuVGV4dCA/ICdXYXJuaW5nIGRlc2NyaXB0aW9uLidcblxuXHRcdEBwYXR0ZXJuID0gb3B0aW9ucy5wYXR0ZXJuID8gKHZhbHVlKSAtPiBudWxsXG5cdFx0QG1hdGNoZXMgPSBmYWxzZVxuXG5cdFx0QF93YXJuXG5cdFx0QF9kaXNhYmxlZFxuXHRcdEBfZm9jdXNlZFxuXHRcdEBfY29sb3Jcblx0XHRAX2hlbHBlclRleHRcblx0XHRAX2hlbHBlclRleHRDb2xvclxuXHRcdEBfbGFiZWxUZXh0XG5cdFx0QF9sYWJlbFRleHRDb2xvclxuXG5cdFx0c3VwZXIgXy5kZWZhdWx0cyBvcHRpb25zLFxuXHRcdFx0dGV4dDogJydcblx0XHRcdGZvbnRTaXplOiAxNFxuXHRcdFx0aGVpZ2h0OiA0OFxuXHRcdFx0d2lkdGg6IDI1NlxuXHRcdFx0Ym9yZGVyV2lkdGg6IDFcblx0XHRcdGJvcmRlclJhZGl1czogNFxuXHRcdFx0cGFkZGluZzoge3RvcDogNCwgcmlnaHQ6IDEyLCBib3R0b206IDQsIGxlZnQ6IDEyfVxuXHRcdFx0YW5pbWF0aW9uT3B0aW9uczogeyB0aW1lOiAuMTUgfVxuXG5cdFx0QF9pbnB1dCA9IGRvY3VtZW50LmNyZWF0ZUVsZW1lbnQoJ2lucHV0Jylcblx0XHRAX2VsZW1lbnQuYXBwZW5kQ2hpbGQoQF9pbnB1dClcblx0XHRcblx0XHRAX2lucHV0LnNwZWxsY2hlY2sgXHRcdD0gZmFsc2Vcblx0XHRAX2lucHV0LmF1dG9jYXBpdGFsaXplICA9IGZhbHNlXG5cdFx0QF9pbnB1dC5hdXRvY29tcGxldGUgXHQ9IGZhbHNlXG5cdFx0QF9pbnB1dC50YWJpbmRleCBcdFx0PSBcIi0xXCJcblx0XHRAX2lucHV0LnBsYWNlaG9sZGVyIFx0PSBAX3BsYWNlaG9sZGVyXG5cdFx0XG5cdFx0VXRpbHMuaW5zZXJ0Q1NTKCBcIlwiXCJcblx0XHRcdCo6Zm9jdXMgeyBvdXRsaW5lOiAwOyB9XG5cdFx0XHR0ZXh0YXJlYSB7IHJlc2l6ZTogbm9uZTsgfSBcblx0XHRcdDo6c2VsZWN0aW9uIHsgYmFja2dyb3VuZDogI3tAc2VsZWN0aW9uQ29sb3J9OyB9IFxuXHRcdFx0fVwiXCJcIiApXG5cdFx0XHRcblx0XHRAc2V0U3R5bGUoKVxuXHRcdFxuXHRcdEBfaW5wdXQub25mb2N1cyA9ID0+IEBmb2N1c2VkID0gdHJ1ZTsjIEBzZXRTY3JvbGwoZmFsc2UpXG5cdFx0QF9pbnB1dC5vbmJsdXIgPSA9PiBAZm9jdXNlZCA9IGZhbHNlOyAjQHNldFNjcm9sbCh0cnVlKVxuXHRcdEBfaW5wdXQub25pbnB1dCA9IEBzZXRWYWx1ZVxuXG5cdFx0QHdhcm5UZXh0ID0gbmV3IFRleHRMYXllclxuXHRcdFx0cGFyZW50OiBAXG5cdFx0XHR5OiBAaGVpZ2h0ICsgOFxuXHRcdFx0Zm9udFNpemU6IDEwXG5cdFx0XHRmb250RmFtaWx5OiBAZm9udEZhbWlseVxuXHRcdFx0Y29sb3I6ICcjRkYzMzMzJ1xuXHRcdFx0dGV4dDogJ3t3YXJuVGV4dH0nXG5cdFx0XHR2aXNpYmxlOiBAX3dhcm5cblxuXHRcdEB3YXJuVGV4dC50ZW1wbGF0ZSA9IEBfd2FyblRleHRcblxuXHRcdEBzdGF0ZXMgPVxuXHRcdFx0ZGlzYWJsZWQ6XG5cdFx0XHRcdGJvcmRlckNvbG9yOiAnI0FBQSdcblx0XHRcdFx0Y29sb3I6ICcjQ0NDJ1xuXG5cdFx0XHRmb2N1c19oYXNUZXh0OlxuXHRcdFx0XHRib3JkZXJDb2xvcjogJyMwMDAnXG5cdFx0XHRcdGNvbG9yOiAnIzMzMydcblxuXHRcdFx0Zm9jdXNfbm9UZXh0OlxuXHRcdFx0XHRib3JkZXJDb2xvcjogJyMwMDAnXG5cdFx0XHRcdGNvbG9yOiAnI0FBQSdcblxuXHRcdFx0dW5mb2N1c19oYXNUZXh0OlxuXHRcdFx0XHRib3JkZXJDb2xvcjogJyNBQUEnXG5cdFx0XHRcdGNvbG9yOiAnIzAwMCdcblxuXHRcdFx0dW5mb2N1c19ub1RleHQ6XG5cdFx0XHRcdGJvcmRlckNvbG9yOiAnI0FBQSdcblx0XHRcdFx0Y29sb3I6ICcjQUFBJ1xuXG5cdFx0XHR3YXJuX25vVGV4dDpcblx0XHRcdFx0Ym9yZGVyQ29sb3I6ICcjRkYzMzMzJ1xuXHRcdFx0XHRjb2xvcjogJyNGRjc3NzcnXG5cblx0XHRcdHdhcm5faGFzVGV4dDpcblx0XHRcdFx0Ym9yZGVyQ29sb3I6ICcjRkYzMzMzJ1xuXHRcdFx0XHRjb2xvcjogJyNGRjMzMzMnXG5cblxuXHRcdEBvbiBcImNoYW5nZTpjb2xvclwiLCA9PiBAX2lucHV0LnN0eWxlWyctd2Via2l0LXRleHQtZmlsbC1jb2xvciddID0gQGNvbG9yXG5cdFx0QHNob3dGb2N1c2VkKClcblxuXHQjIHNldFBsYWNlaG9sZGVyOiA9PiBcblx0IyBcdGlmIEBoYXNUZXh0Q29udGVudCgpIG9yIG5vdCBAZm9jdXNlZFxuXHQjIFx0XHRAY29sb3IgPSBudWxsIFxuXHQjIFx0ZWxzZSBpZiBAZm9jdXNlZFxuXHQjIFx0XHRAY29sb3IgPSAncmdiYSgwLDAsMCwuNDIpJ1xuXHRcblx0c2V0U3R5bGU6IC0+XG5cdFx0QF9pbnB1dC5zdHlsZS5jc3NUZXh0ID0gXCJcIlwiXG5cdFx0XHR6LWluZGV4OjU7XG5cdFx0XHR6b29tOiAje0Bjb250ZXh0LnNjYWxlfTtcblx0XHRcdGZvbnQtc2l6ZTogI3tAZm9udFNpemV9cHg7XG5cdFx0XHRmb250LXdlaWdodDogI3tAZm9udFdlaWdodH07XG5cdFx0XHRmb250LWZhbWlseTogI3tAZm9udEZhbWlseX07XG5cdFx0XHRjb2xvcjogI3tAdGludH07XG5cdFx0XHQtd2Via2l0LXRleHQtZmlsbC1jb2xvcjogI3tAX2NvbG9yfTtcblx0XHRcdGJhY2tncm91bmQtY29sb3I6IHRyYW5zcGFyZW50O1xuXHRcdFx0cG9zaXRpb246IGFic29sdXRlO1xuXHRcdFx0dG9wOiAwcHg7XG5cdFx0XHRsZWZ0OiAwcHg7XG5cdFx0XHRyZXNpemU6IG5vbmU7XG5cdFx0XHR3aWR0aDogI3tAd2lkdGh9cHg7XG5cdFx0XHRoZWlnaHQ6IDEwMCU7XG5cdFx0XHRwYWRkaW5nOiAje0BwYWRkaW5nLnRvcH1weCAje0BwYWRkaW5nLnJpZ2h0fXB4ICN7QHBhZGRpbmcuYm90dG9tfXB4ICN7QHBhZGRpbmcubGVmdH1weDtcblx0XHRcdG91dGxpbmU6IDBweCBub25lIHRyYW5zcGFyZW50ICFpbXBvcnRhbnQ7XG5cdFx0XHRsaW5lLWhlaWdodDogI3tAbGluZUhlaWdodH07XG5cdFx0XHQtd2Via2l0LWJveC1zaXppbmc6IGJvcmRlci1ib3g7IC8qIFNhZmFyaS9DaHJvbWUsIG90aGVyIFdlYktpdCAqL1xuXHRcdFx0LW1vei1ib3gtc2l6aW5nOiBib3JkZXItYm94OyAgICAvKiBGaXJlZm94LCBvdGhlciBHZWNrbyAqL1xuXHRcdFx0Ym94LXNpemluZzogYm9yZGVyLWJveDsgXG5cdFx0XCJcIlwiXG5cblx0IyBzZXQgdmFsdWUgb2YgdGV4dGxheWVyIHVzaW5nIHRleHRhcmVhIHZhbHVlXG5cdHNldFZhbHVlOiA9PiBAdmFsdWUgPSBAX2lucHV0LnZhbHVlXG5cdFxuXHQjIHNldCBpbmRpdmlkdWFsIGF0dHJpYnV0ZSBvZiB0ZXh0YXJlYVxuXHRzZXRJbnB1dEF0dHJpYnV0ZTogKGF0dHJpYnV0ZSwgdmFsdWUpIC0+XG5cdFx0QF9pbnB1dC5zZXRBdHRyaWJ1dGUoYXR0cmlidXRlLCB2YWx1ZSlcblx0XG5cdGZvY3VzOiA9PiBAX2lucHV0LmZvY3VzKClcblxuXHRzaG93Rm9jdXNlZDogPT5cblx0XHRpZiBAZGlzYWJsZWQgXG5cdFx0XHRAYW5pbWF0ZVN0b3AoKVxuXHRcdFx0QGFuaW1hdGUgJ2Rpc2FibGVkJ1xuXHRcdFx0cmV0dXJuXG5cblx0XHRpZiBAd2FybiBcblx0XHRcdEBhbmltYXRlU3RvcCgpXG5cdFx0XHRpZiBAaGFzVGV4dENvbnRlbnQoKSB0aGVuIEBhbmltYXRlICd3YXJuX2hhc1RleHQnXG5cdFx0XHRlbHNlIEBhbmltYXRlICd3YXJuX25vVGV4dCdcblx0XHRcdHJldHVyblxuXG5cdFx0aWYgQGZvY3VzZWRcblx0XHRcdEBhbmltYXRlU3RvcCgpXG5cblx0XHRcdGlmIEBoYXNUZXh0Q29udGVudCgpIHRoZW4gQGFuaW1hdGUgJ2ZvY3VzX2hhc1RleHQnXG5cdFx0XHRlbHNlIEBhbmltYXRlICdmb2N1c19ub1RleHQnXG5cblx0XHRlbHNlXG5cdFx0XHRAYW5pbWF0ZVN0b3AoKVxuXG5cdFx0XHRpZiBAaGFzVGV4dENvbnRlbnQoKSB0aGVuIEBhbmltYXRlICd1bmZvY3VzX2hhc1RleHQnXG5cdFx0XHRlbHNlIEBhbmltYXRlICd1bmZvY3VzX25vVGV4dCdcdFx0XHRcblx0XHRcblx0aGFzVGV4dENvbnRlbnQgOiAtPiBAdmFsdWUubGVuZ3RoICBcdFx0PiAwXG5cdGhhc0hlbHBlclRleHQgIDogLT4gQGhlbHBlclRleHQ/Lmxlbmd0aCAgPiAwXG5cdGhhc0xhYmVsVGV4dCAgIDogLT4gQGxhYmVsVGV4dD8ubGVuZ3RoICAgPiAwXG5cdGhhc1BsYWNlaG9sZGVyIDogLT4gQF9wbGFjZWhvbGRlcj8ubGVuZ3RoID4gMFx0XG5cdFx0XG5cdCMgdmFsdWVcblx0QGRlZmluZSBcInZhbHVlXCIsXG5cdFx0Z2V0OiAtPiByZXR1cm4gQF92YWx1ZVxuXHRcdHNldDogKHZhbHVlKSAtPlxuXHRcdFx0cmV0dXJuIGlmIEBfdmFsdWUgaXMgdmFsdWVcblx0XHRcdFxuXHRcdFx0QF92YWx1ZSA9IHZhbHVlXG5cblx0XHRcdEBtYXRjaGVzID0gQHBhdHRlcm4odmFsdWUpXG5cdFx0XHRAZW1pdChcImNoYW5nZTp2YWx1ZVwiLCBAdmFsdWUsIEBtYXRjaGVzLCBAKVxuXG5cdFx0XHRAc2hvd0ZvY3VzZWQoKVxuXG5cdCMgZGlzYWJsZWRcblx0QGRlZmluZSBcImRpc2FibGVkXCIsXG5cdFx0Z2V0OiAtPiByZXR1cm4gQF9kaXNhYmxlZFxuXHRcdHNldDogKHZhbHVlKSAtPlxuXHRcdFx0cmV0dXJuIGlmIEBfZGlzYWJsZWQgaXMgdmFsdWVcblx0XHRcdGlmIHR5cGVvZiB2YWx1ZSBpc250ICdib29sZWFuJyB0aGVuIHRocm93ICdEaXNhYmxlZCBtdXN0IGJlIGVpdGhlciB0cnVlIG9yIGZhbHNlLidcblx0XHRcdFxuXHRcdFx0QF9kaXNhYmxlZCA9IHZhbHVlXG5cblx0XHRcdEBlbWl0KFwiY2hhbmdlOmRpc2FibGVkXCIsIHZhbHVlLCBAKVxuXHRcdFx0QHNob3dGb2N1c2VkKClcblxuXHQjIHdhcm5cblx0QGRlZmluZSBcIndhcm5cIixcblx0XHRnZXQ6IC0+IHJldHVybiBAX3dhcm5cblx0XHRzZXQ6ICh2YWx1ZSkgLT5cblx0XHRcdHJldHVybiBpZiBAX3dhcm4gaXMgdmFsdWVcblx0XHRcdGlmIHR5cGVvZiB2YWx1ZSBpc250ICdib29sZWFuJyB0aGVuIHRocm93ICdXYXJuIG11c3QgYmUgZWl0aGVyIHRydWUgb3IgZmFsc2UuJ1xuXHRcdFx0XG5cdFx0XHRAX3dhcm4gPSB2YWx1ZVxuXG5cdFx0XHRAZW1pdChcImNoYW5nZTp3YXJuXCIsIHZhbHVlLCBAKVxuXHRcdFx0XG5cdFx0XHRAd2FyblRleHQudmlzaWJsZSA9IEBfd2FyblxuXHRcdFx0QHNob3dGb2N1c2VkKClcblxuXHQjIHdhcm5cblx0QGRlZmluZSBcIndhcm5pbmdcIixcblx0XHRnZXQ6IC0+IHJldHVybiBAX3dhcm5UZXh0XG5cdFx0c2V0OiAodmFsdWUpIC0+XG5cdFx0XHRyZXR1cm4gaWYgQF93YXJuVGV4dCBpcyB2YWx1ZVxuXHRcdFx0QF93YXJuVGV4dCA9IHZhbHVlXG5cdFx0XHRAd2FyblRleHQudGVtcGxhdGUgPSBAX3dhcm5UZXh0XG5cblx0IyBmb2N1c2VkXG5cdEBkZWZpbmUgXCJmb2N1c2VkXCIsXG5cdFx0Z2V0OiAtPiByZXR1cm4gQF9mb2N1c2VkXG5cdFx0c2V0OiAodmFsdWUpIC0+XG5cdFx0XHRyZXR1cm4gaWYgQF9mb2N1c2VkIGlzIHZhbHVlXG5cdFx0XHRpZiB0eXBlb2YgdmFsdWUgaXNudCAnYm9vbGVhbicgdGhlbiB0aHJvdyAnRm9jdXNlZCBtdXN0IGJlIGVpdGhlciB0cnVlIG9yIGZhbHNlLidcblx0XHRcdFxuXHRcdFx0QF9mb2N1c2VkID0gdmFsdWVcblxuXHRcdFx0IyBibHVyIG9yIGZvY3VzIHRleHQgYXJlYSBpZiBzZXQgcHJvZ3JhbW1haWNhbGx5XG5cdFx0XHRpZiB2YWx1ZSBpcyB0cnVlIGFuZCBkb2N1bWVudC5hY3RpdmVFbGVtZW50IGlzbnQgQF9pbnB1dCBcblx0XHRcdFx0QF9pbnB1dC5mb2N1cygpXG5cdFx0XHRlbHNlIGlmIHZhbHVlIGlzIGZhbHNlIGFuZCBkb2N1bWVudC5hY3RpdmVFbGVtZW50IGlzIEBfaW5wdXRcblx0XHRcdFx0QF9pbnB1dC5ibHVyKClcblxuXHRcdFx0QGVtaXQoXCJjaGFuZ2U6Zm9jdXNlZFwiLCB2YWx1ZSwgQClcblx0XHRcdEBzaG93Rm9jdXNlZCgpXG4iLCIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3ZhciBmPW5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIik7dGhyb3cgZi5jb2RlPVwiTU9EVUxFX05PVF9GT1VORFwiLGZ9dmFyIGw9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGwuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sbCxsLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2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
