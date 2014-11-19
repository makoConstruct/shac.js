// Generated by CoffeeScript 1.8.0
(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  this.attach_autocompletion = function(input, matchset) {
    var ac;
    if (matchset.constructor === Array) {
      matchset = new this.MatchSet(matchset);
    }
    ac = new this.Autocompletion(matchset);
    ac.attach(input);
    return ac;
  };

  this.Autocompletion = (function() {
    function Autocompletion(matchset) {
      this.matchset = matchset;
      this.on_input = __bind(this.on_input, this);
      this.collapse = __bind(this.collapse, this);
      this.deploy = __bind(this.deploy, this);
      this.drop = document.createElement('div');
      this.drop.classList.add('autocompletion_drop');
      document.body.appendChild(this.drop);
      this.drop_list_container = this.drop;
    }

    Autocompletion.prototype.attach = function(new_input) {
      if (this.input) {
        this.detach();
      }
      this.input = new_input;
      this.input.addEventListener('input', this.on_input);
      this.input.addEventListener('focus', this.deploy);
      return this.input.addEventListener('blur', this.collapse);
    };

    Autocompletion.prototype.detach = function() {
      document.body.removeChild(this.drop);
      this.input.removeEventListener('input', this.on_input);
      this.input.removeEventListener('focus', this.deploy);
      this.input.removeEventListener('blur', this.collapse);
      return this.input = null;
    };

    Autocompletion.prototype.push_to_drop = function(result_list) {
      var i, new_result_el, _i, _ref;
      while (this.drop_list_container.children.length > result_list.length) {
        this.drop_list_container.removeChild(this.drop_list_container.lastChild);
      }
      while (this.drop_list_container.children.length < result_list.length) {
        new_result_el = document.createElement('div');
        new_result_el.classList.add('match');
        this.drop_list_container.appendChild(new_result_el);
      }
      for (i = _i = 0, _ref = result_list.length; 0 <= _ref ? _i < _ref : _i > _ref; i = 0 <= _ref ? ++_i : --_i) {
        this.drop_list_container.children[i].innerHTML = result_list[i].matched;
      }
      if (result_list.length > 0) {
        return this.deploy();
      } else {
        return this.collapse();
      }
    };

    Autocompletion.prototype.deploy = function() {
      var cr;
      if (this.drop_list_container.children.length > 0) {
        cr = this.input.getBoundingClientRect();
        this.drop.style.left = cr.left + 'px';
        this.drop.style.top = cr.bottom + 'px';
        return this.drop.classList.add('visible');
      }
    };

    Autocompletion.prototype.collapse = function() {
      return this.drop.classList.remove('visible');
    };

    Autocompletion.prototype.on_input = function() {
      var res;
      res = this.matchset.seek(this.input.value);
      this.push_to_drop(res);
      if (res.length > 0) {
        return this.deploy();
      }
    };

    return Autocompletion;

  })();

}).call(this);
