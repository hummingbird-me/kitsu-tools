/*
 Class: MooshellEditor
 Editor using CodeMirror
 http://codemirror.net
 */

var disallowedPlatforms = ['ios', 'android', 'ipod'];
var default_code_mirror_options = {
  gutters: ["note-gutter", "CodeMirror-linenumbers"],
  tabSize: 4,
  indentUnit: 4,
  lineNumbers: true,
  lineWrapping: true,
  tabMode: 'spaces' // or 'shift'
};

var MooShellEditor = new Class({
  Implements: [Options, Events],

  parameter: 'Editor',

  options: {
    useCodeMirror: true,
    codeMirrorOptions: default_code_mirror_options,
    syntaxHighlighting: []
  },

  window_names: {
    'javascript': 'JavaScript',
    'html': 'HTML',
    'css': 'CSS',
    'scss': 'SCSS',
    'coffeescript': 'CoffeeScript',
    'javascript 1.7': 'JavaScript 1.7'
  },

  initialize: function(el, options) {
    // switch off CodeMirror for IE
    //if (Browser.Engine.trident) options.useCodeMirror = false;
    this.element = $(el);
    if (!this.options.syntaxHighlighting.contains(options.language)) {
      this.forceDefaultCodeMirrorOptions();
    } 
    this.setOptions(options);
    
    var is_disallowed = (disallowedPlatforms.contains(Browser.Platform.name));
    if (this.options.useCodeMirror && !is_disallowed) {
      // hide textarea
      this.element.hide();
      // prepare settings
      if (!this.options.codeMirrorOptions.stylesheet && this.options.stylesheet) {
        this.options.codeMirrorOptions.stylesheet = this.options.stylesheet.map(function(path) {
          return mediapath + path;
        });
      }
      if (!this.options.codeMirrorOptions.path) {
        this.options.codeMirrorOptions.path = codemirrorpath + 'js/';
      }
      if (!this.options.codeMirrorOptions.content) {
        this.options.codeMirrorOptions.content = this.element.get('value');
      }
      
      // fromTextArea is forbidden
      // this.editor = CodeMirror.fromTextArea(this.element, this.options.codeMirrorOptions);
      var parentNode = this.element.getParent();
      var options = { value: this.element.value };
      options = Object.append(options, this.options.codeMirrorOptions);
      this.editor = CodeMirror(parentNode, options);
      
      // run this after initialization
      if (!this.options.codeMirrorOptions.initCallback){
        
        // @todo: no idea what the below should do
        // grab some keys
        // this.editor.grabKeys(
        //   Layout.routeReservedKey.bind(Layout),
        //   Layout.isReservedKey.bind(Layout)
        // );
        if (this.options.codeMirrorOptions.autofocus) {
          // set current editor
          Layout.current_editor = this.options.name;
        }
        
        // @todo: really buggy when using the defineInitHook
        //CodeMirror.defineInitHook(function(){
        //}.bind(this));
      }
      
      // set editor options that can only be set once the editor is initialized
      var cur = this.editor.getLineHandle(this.editor.getCursor().line);
      this.setEditorEvents({
        focus: function(){
          Layout.current_editor = this.options.name;
          this.editor.removeLineClass(cur, 'background', 'activeline');
          this.editor.hlLine = this.editor.addLineClass(0, "background", "activeline");
        },
        cursorActivity: function(){
          var cur = this.editor.getLineHandle(this.editor.getCursor().line);
          if (cur != this.editor.hlLine) {
            this.editor.removeLineClass(this.editor.hlLine, 'background', 'activeline');
            this.editor.hlLine = this.editor.addLineClass(cur, 'background', 'activeline');
          }
        },
        blur: function(){
          this.editor.removeLineClass(this.editor.hlLine, 'background', 'activeline');
        }
      });

      this.editor.on("cursorActivity", function() {
        this.editor.matchHighlight("CodeMirror-matchhighlight");
      }.bind(this));
    }
    
    this.editorLabelFX = new Fx.Tween(this.getLabel(), {
      property: 'opacity',
      link: 'cancel'
    });
    
    this.getWindow().addEvents({
      mouseenter: function() {
        this.editorLabelFX.start(0);
        //this.fullscreen.retrieve('fx').start(0.3);
      }.bind(this),
      mouseleave: function() {
        this.editorLabelFX.start(0.8);
        //this.fullscreen.retrieve('fx').start(0);
      }.bind(this)
    });
    
    mooshell.addEvents({
      'run': this.b64decode.bind(this)
    });
    
    Layout.registerEditor(this);
    this.setLabelName(this.options.language || this.options.name);
  },
  
  getEditor: function() {
    return this.editor || this.element;
  },

  getWindow: function() {
    if (!this.window) {
      this.window = this.element.getParent('.window');
    }
    return this.window;
  },

  getLabel: function() {
    return this.getWindow().getElement('.window_label');
  },

  b64decode: function() {
    this.element.set('value', this.before_decode);
  },

  getCode: function() {
    return (this.editor) ? this.editor.getValue() : this.element.get('value');
  },

  updateFromMirror: function() {
    this.before_decode = this.getCode();
    this.element.set('value', Base64.encode(this.before_decode));
  },

  updateCode: function() {
    this.element.set('value', this.getCode());
  },

  clean: function() {
    this.element.set('value', '');
    this.cleanEditor();
  },

  cleanEditor: function() {
    if (this.editor) this.editor.setCode('');
  },

  hide: function() {
    this.getWindow().hide();
  },

  show: function() {
    this.getWindow().show();
  },
  
  setEditorOptions: function(options){
    Object.each(options, function(fn, key){
      this.editor.setOption(key, fn.bind(this));
    }, this);
  },
  
  setEditorEvents: function(e){
    Object.each(e, function(fn, key){
      this.editor.on(key, fn.bind(this));
    }, this);
  },

  setLanguage: function(language) {
    // Todo: This is hacky
    this.setLabelName(language);
  },

  setLabelName: function(language) {
    this.getLabel().set('text', this.window_names[language] || language);
  },

  setStyle: function(key, value) {
    if (this.editor) return $(this.editor.frame).setStyle(key, value);
    return this.element.setStyle(key, value);
  },

  setStyles: function(options) {
    if (this.editor) return $(this.editor.frame).setStyles(options);
    return this.element.setStyles(options);
  },

  setWidth: function(width) {
    this.getWindow().setStyle('width', width);
  },

  setHeight: function(height) {
    this.getWindow().setStyle('height', height);
  },

  getPosition: function() {
    if (this.editor) return $(this.editor.frame).getPosition();
    return this.element.getPosition();
  },

  forceDefaultCodeMirrorOptions: function() {
    this.options.codeMirrorOptions = default_code_mirror_options;
  }
});


/*
 * JS specific settings
 */
MooShellEditor.JS = new Class({
  Extends: MooShellEditor,

  options: {
    name: 'js',
    language: 'javascript',
    useCodeMirror: true,
    codeMirrorOptions: {
      autofocus: true,
      mode: 'javascript'
    },
    syntaxHighlighting: ['javascript', 'javascript 1.7']
  },

  initialize: function(el, options) {
    this.setOptions(options);
    this.parent(el, this.options);
  }
});

/*
 * CSS specific settings
 */
MooShellEditor.CSS = new Class({
  Extends: MooShellEditor,

  options: {
    name: 'css',
    language: 'css',
    useCodeMirror: true,
    codeMirrorOptions: {
      mode: 'css'
    },
    syntaxHighlighting: ['css', 'scss']
  },

  initialize: function(el, options) {
    this.setOptions(options);
    this.parent(el, this.options);
  }
});

/*
 * HTML specific settings
 */
MooShellEditor.HTML = new Class({
  Extends: MooShellEditor,

  options: {
    name: 'html',
    language: 'html',
    useCodeMirror: true,
    codeMirrorOptions: {
      mode: 'xml'
    },
    syntaxHighlighting: ['html']
  },

  initialize: function(el, options) {
    this.setOptions(options);
    this.parent(el, this.options);
  }
});
