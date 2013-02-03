/*
 Layout using CodeMirror
 */

Element.implement({
  getInnerWidth: function() {
    return this.getSize().x -
      this.getStyle('padding-left').toInt() -
      this.getStyle('padding-right').toInt() -
      this.getStyle('border-left-width').toInt() -
      this.getStyle('border-right-width').toInt();
  },
  getInnerHeight: function() {
    return this.getSize().y -
      this.getStyle('padding-top').toInt() -
      this.getStyle('padding-bottom').toInt() -
      this.getStyle('border-top-width').toInt() -
      this.getStyle('border-bottom-width').toInt();
  }
});

var keyMods = {
  'shift': false,
  'shiftKey': false,
  'control': false,
  'ctrlKey': false
}; // these mods will be checked

var Layout = {
  editors: $H({}),
  editors_order: ['html', 'css', 'js'],
    
  reservedKeys: [ // list of [modifier,keycode,callbackname]
    ['ctrlKey', 13, 'run'], ['control', 13, 'run'],   // c+ret+run
    ['ctrlKey', 38, 'switchPrev'],                    // c+upArrow
    ['ctrlKey', 40, 'switchNext'],                     // c+dnArrow
    ['ctrlKey+shiftKey', 13, 'loadDraft'], ['control+shift', 13, 'loadDraft'],
    ['ctrlKey+shiftKey', 38, 'toggleSidebar'], ['control+shift', 38, 'toggleSidebar'],
    ['ctrlKey+shiftKey', 76, 'showShortcutDialog'], ['control+shift', 76, 'showShortcutDialog'],
    ['ctrlKey', 83, 'saveAndReload'], ['control', 83, 'saveAndReload']
    // future
    // ['ctrlKey', f, 'searchBox'], ['control', f, 'searchBox']
  ],
  isMobile: (navigator.userAgent.match(/(iPhone|iPod|iPad)/) || 
             navigator.userAgent.match(/BlackBerry/) || 
             navigator.userAgent.match(/Android/)),
  render: function () {
    // instantiate sidebar
    this.sidebar = new Sidebar({
      DOM: 'sidebar'
    });
    window.addEvents({
      'resize': this.resize.bind(this),
      'keydown': function(keyEvent) {
        if (this.isReservedKey(false, keyEvent)) {
          this.routeReservedKey(keyEvent);
        }
      }.bind(this)
    });
    this.sidebar.addEvents({
      'accordion_resized': this.resize.bind(this)
    });
    // set editor labels
    var result = document.id('result');
    $$('.window_label').setStyle('opacity', 0.8);
    if (result) {
      result.getElement('.window_label').setStyle('opacity', 0.3);
      this.result = result.getElement('iframe');
    }
    // resize
    this.resize();
    this.resize.bind(this).delay(20);
    // change behaviour for IE
    if (!Browser.Engine.trident4) {
      this.createDragInstances();
    }
    this.createErrorTooltips();
    // send an event
    this.fireEvent('ready');
  },
  
  createErrorTooltips: function(){
    var tooltip = Element('span', {
      'class': 'CodeMirror-error-tooltip'
    }).inject(document.body);
    document.id('content').addEvents({
      'mouseover:relay(span.CodeMirror-line-error)': function(){
        tooltip.set({
          html: this.get('data-title'),
          styles: {
            display: 'block'
          }
        });
        tooltip.position({
          relativeTo: this,
          edge: 'centerBottom',
          offset: {
            y: -20
          }
        })
      },
      'mouseout:relay(span.CodeMirror-line-error)': function(){
        tooltip.set({
          html: '',
          styles: {
            top: 0,
            left: 0,
            display: 'none'
          }
        });
      }
    });
  },

  routeReservedKey: function(keyEvent) {
    this.reservedKeys.each(function(keyDef){
      if (this.matchKey(keyEvent, keyDef)) {
        mooshell[keyDef.getLast()].bind(mooshell).call();
      }
    }, this);
  },
    
  matchKey: function(keyEvent, keyDef) {
    if (!keyEvent) return false;
    var key = keyEvent.keyCode || keyEvent.code;
    // check if the right key is pressed
    if (!keyDef.contains(key)) return false;
    // check for the modifications
    var pass = true;
    if (keyDef.length > 1) {
      var mods = {};
      keyDef[0].split('+').each(function(mod) {
        mods[mod] = true;
      });
      // adding other mods
      $each(keyMods, function(value, mod) {
        if (!mods[mod]) mods[mod] = false;
      });
      // check all possibilities
      $each(mods, function(required, mod) {
        if (!!keyEvent[mod] != required) pass = false;
      });
    }
    return pass;
  },

  isReservedKey: function(keyCode, keyEvent) {
    return (this.reservedKeys.some(function(keyDef) {
      return this.matchKey(keyEvent, keyDef);
    }, this));
  },

  findLayoutElements: function() {
    // look up some elements, and cache the findings
    this.content = document.id('content');
    this.columns = this.content.getChildren('.column');
    this.windows = this.content.getElements('.window');
    this.shims = this.content.getElements('.column .shim');
    this.handlers = $H({
      'vertical': this.content.getElementById('handler_vertical'),
      'left': this.columns[0].getElement('.handler_horizontal'),
      'right': this.columns[1].getElement('.handler_horizontal')
    });
  },

  registerEditor: function(editor) {
    this.editors[editor.options.name] = editor;
    this.resize();
  },

  decodeEditors: function() {
    this.editors.each(function(ed) {
      ed.b64decode();
    });
  },

  updateFromMirror: function() {
    this.editors.each(function(ed) {
      ed.updateFromMirror();
    });
  },

  cleanMirrors: function() {
    this.editors.each(function(ed) {
      ed.clean();
    });
  },

  createDragInstances: function() {
    var onDrag_horizontal = function(h) {
      var windows = h.getParent().getElements('.window');
      var top = (h.getPosition(this.content).y + h.getHeight() / 2) / this.content.getHeight() * 100;
      windows[0].setStyle('height', top + '%');
      windows[1].setStyle('height', 100 - top + '%');
      this.refreshEditors();
    }.bind(this);

    var onDrag_vertical = function(h) {
      var left = (h.getPosition(this.content).x + h.getWidth() / 2) / this.content.getWidth() * 100;
      this.columns[0].setStyle('width', left + '%');
      this.columns[1].setStyle('width', 100 - left + '%');
    }.bind(this);

    this.handlers.each(function(h) {
      var isHorizontal = h.hasClass('handler_horizontal');
      h.dragInstance = new Drag(h, {
        'modifiers': isHorizontal ? {'x': null, 'y': 'top'} : {'x': 'left', 'y': null},
        'limit': {
          'x': [100, this.content.getWidth() - 100],
          'y': [100, this.content.getHeight() - 100]
        },
        'onBeforeStart': function() { this.shims.show(); }.bind(this),
        'onDrag': isHorizontal ? onDrag_horizontal : onDrag_vertical,
        'onCancel': function() { this.shims.hide(); }.bind(this),
        'onComplete': function() { this.shims.hide(); }.bind(this)
      });
    }, this);

    // Save window sizes to cookie onUnload.
    window.addEvent('unload', function() {
      var sizes = {
        'w': [],
        'h': []
      };
      this.columns.each(function(col, i) {
        var width = col.getStyle('width');
        sizes.w[i] = width.contains('%') ? width : null;
      });
      this.windows.each(function(win, i) {
        var height = win.getStyle('height');
        sizes.h[i] = height.contains('%') ? height : null;
      });
      Cookie.write('window_sizes', JSON.encode(sizes), {'domain': location.host});
    }.bind(this));

    // Read window sizes from cookie.
    this.setWindowSizes();
  },
  
  setWindowSizes: function(sizes) {
    // sizes === undefined --> read from cookie
    // sizes == null/false --> reset sizes + delete cookie
    // sizes == true       --> use sizes
    if (typeof sizes === 'undefined') {
      sizes = Cookie.read('window_sizes');
      if (sizes) {
        sizes = JSON.decode(sizes);
      }
    }
    if (sizes) {
      if ($type(sizes.w) === 'array') {
        sizes.w.each(function(width, i) {
          this.columns[i].setStyle('width', width);
        }, this);
      }
      if ($type(sizes.h) == 'array') {
        sizes.h.each(function(height, i) {
          this.windows[i].setStyle('height', height);
        }, this);
      }
    } else {
      this.columns.setStyle('width', null);
      this.windows.setStyle('height', null);
      Cookie.dispose('window_sizes', {'domain': location.host});
    }
    this.resize();
  },
  
  resize: function(e) {
    if (!this.content) {
      this.findLayoutElements();
    }
    
    var win_size = window.getSize();
    var av_height = win_size.y -
      this.columns[0].getPosition().y +
      this.windows[0].getStyle('top').toInt() +
      this.windows[1].getStyle('bottom').toInt();
      
    this.content.setStyle('height', av_height);
    
    // set handler positions
    this.handlers.vertical.setStyle('left', this.windows[0].getCoordinates(this.content).right);
    this.handlers.left.setStyle('top', this.windows[0].getCoordinates(this.content).bottom);
    this.handlers.right.setStyle('top', this.windows[2].getCoordinates(this.content).bottom);
    
    this.fireEvent('resize');
  },
  
  refreshEditors: function(){
    Object.each(this.editors, function(editorInstance){
      editorInstance.editor.refresh();
    });
  }
};

// add events to Layout object
$extend(Layout, new Events());
