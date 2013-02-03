// TODO: refactor
// TODO: This code is now legacy code, none of it will make its way into Beta

/*
 * Define actions on the run/save/clean buttons
 */
var MooShellActions = new Class({
  Implements: [Options, Events],
  options: {
    // onRun: $empty,
    // onClean: $empty,
    formId: 'show-result',
    saveAndReloadId: 'update',
    saveAsNewId: 'savenew',
    runId: 'run',
    draftId: 'm',
    jslintId: 'jslint',
    tidyId: 'tidy',
    showJsId: 'showjscode',
    shareSelector: '#share_link_dropdown, #share_embedded_dropdown, #share_result_dropdown',
    favId: 'mark_favourite',
    entriesSelector: 'textarea',
    resultLabel: 'result_label',
    resultInput: 'select_link',
    example_id: false,
    exampleURL: '',
    exampleSaveURL: '',
    loadDependenciesURL: '',
    tidy: {
      'javascript': 'js',
      'javascript 1.7': 'js',
      'html': 'html',
      'css': 'css'
    },
    jslint: {
      evil: true,
      passfail: false,
      browser: true,
      newcap: false
    },
    jslintLanguages: ['text/javascript', 'javascript', 'javascript 1.7'],
    showJSLanguages: ['text/coffeescript', 'coffeescript']
  },
  /*
   * Assign actions
   */
  initialize: function(options) {
    this.setOptions(options);
    var addBinded = function(el, callback, bind) {
      el = $(el);
      if (el){
        el.addEvent('click', callback.bind(bind));
      }
    };
    
    Layout.addEvent('ready', function() {
      addBinded(this.options.saveAndReloadId, this.saveAndReload, this);
      addBinded(this.options.saveAsNewId, this.saveAsNew, this);
      addBinded(this.options.runId, this.run, this);
      addBinded(this.options.draftId, this.run, this);
      addBinded(this.options.jslintId, this.jsLint, this);
      addBinded(this.options.showJsId, this.showJs, this);
      addBinded(this.options.tidyId, this.prepareAndLaunchTidy, this);
      addBinded(this.options.favId, this.makeFavourite, this);

      // show key shortcuts
      var keyActions = document.getElements('a.keyActions');
      keyActions.addEvents({
        click: function(event){
          this.showShortcutDialog(event);
        }.bind(this)
      });
      document.id(document.body).addEvents({
        keydown: function(event){
          if (event.shift && event.key === '/'){
            var elType = new Element(event.target);
            if (elType.get('tag') === 'body'){
              keyActions[0].fireEvent('click');
            }
          }
        }
      });

      var share = $$(this.options.shareSelector);
      if (share.length > 0) {
        share.addEvent('click', function() {
          this.select();
        });
      }

      // actions run if shell loaded
      this.form = document.id(this.options.formId);

      if (this.options.exampleURL) {
        //  this.run();
        this.displayExampleURL();
      }
      // assign change language in panel
      $$('.panel_choice').addEvent('change', this.switchLanguageAction.bind(this));
      this.showHideJsLint();
      this.showHideTidyUp();
      this.showHideShowJs();
    }.bind(this));
  },
  
  switchLanguageAction: function(e) {
    if (!e) return;
    var sel = $(e.target);
    this.switchLanguage(sel);
  },

  /*
   * Change language in panel
   */
  switchLanguage: function(sel) {
    var panel_name = sel.get('data-panel'),
        editorClass = Layout.editors[panel_name],
        // Klass = MooShellEditor[panel_name.toUpperCase()],
        language = sel.getElement('option:selected').get('text'),
        type = sel.getElement('option:selected').get('data-mime-type');
    
    editorClass.editor.setOption('mode', type);
    // editorClass.updateCode();
    
    // editor.getWindow().getElement('.CodeMirror-wrapping').destroy();
    // Layout.editors[panel_name] = editor = false;
    // new Klass($(sel.get('data-panel_id')), {
    //   language: language.toLowerCase()
    // });
    
    Layout.editors[panel_name].setLabelName(language);
    window['panel_' + panel_name] = language.toLowerCase();
    this.showHideTidyUp();
    this.showHideJsLint();
    this.showHideShowJs();
  },

  loadAsset: function(check, file, callback, scope) {
    if (!check()) {
      if (scope){
        callback = callback.bind(scope);
      }
        
      Asset.javascript(file, {
        onload: callback
      });
      return true;
    }
  },

  prepareCoffee: function(callback) {
    return this.loadAsset(function() {
      return $defined(window.CoffeeScript);
    }, '/js/coffeescript/coffeescript.js', callback, this);
  },

  showJs: function(e) {
    if (e) e.stop();
    if (this.prepareCoffee(this.showJs, this)) return;
    var html = '<div class="modalWrap modal_Coffee">' +
      '<div class="modalHeading"><h3>JavaScript Code</h3><span class="close">Close window</span></div>'+
      '<div id="" class="modalBody">',
      jscode, coffeecode;
        
    if (panel_js != 'coffeescript') return;
    coffeecode = Layout.editors.js.editor.getValue();
    try {
      jscode = CoffeeScript.compile(coffeecode); 
      html += '<pre>' + jscode + '</pre>';
    } catch(error) {
      html += '<p class="error">' + error + '</p>';
    }
    html += '</div></div>';
    new StickyWin({
      content: html,
      relativeTo: $(document.body),
      position: 'center',
      edge: 'center',
      closeClassName: 'close',
      draggable: true,
      dragHandleSelector: 'h3',
      closeOnEsc: true,
      destroyOnClose: true,
      allowMultiple: false,
      onDisplay: this.showModalFx
    }).show();
  },

  prepareTidyUp: function(callback, scope) {
    return this.loadAsset(function() {
      return $defined(window.Beautifier);
    }, '/js/beautifier.js', callback, scope);
  },

  showHideShowJs: function() {
    var hide = true,
        showjs = $(this.options.showJsId);

    if (!showjs) return;
    hide = (Layout.editors.js.editor.getOption('mode') !== 'coffeescript');
    if (hide) {
      showjs.getParent('li').hide();
    } else {
      showjs.getParent('li').show();
    }
  },

  showHideJsLint: function() {
    
    var hide = true,
        lint = $(this.options.jslintId);

    if (!lint) return;
    Layout.editors.each(function(w){
      if (this.options.jslintLanguages.contains(w.editor.getOption('mode'))) {
        hide = false;
      }
    }, this);
    if (hide) {
      lint.getParent('li').hide();
    } else {
      lint.getParent('li').show();
    }
  },

  showHideTidyUp: function() {
    if (this.prepareTidyUp(this.showHideTidyUp, this)) return;
    var hide = true,
        tidy = $(this.options.tidyId);

    if (!tidy) return;
    Layout.editors.each(function(w){
      language = this.options.tidy[w.options.language];
      if (language && Beautifier[language]) {
        hide = false;
      }
    }, this);
    if (hide) {
      tidy.getParent('li').hide();
    } else {
      tidy.getParent('li').show();
    }
  },
  
  prepareAndLaunchTidy: function(e) {
    e.stop();
    if (this.prepareTidyUp(this.makeTidy.bind(this))) return;
    this.makeTidy();
  },
  
  makeTidy: function(){
    Layout.editors.each(function(editorInstance){
      var code = editorInstance.editor.getValue(), language;
      if (code) {
        language = this.options.tidy[editorInstance.options.language];
        if (language && Beautifier[language]) {
          var fixed = Beautifier[language](code);
          if (fixed) editorInstance.editor.setValue(fixed);
          else editorInstance.editor.reindent();
        }
      }
    }, this);
  },
  
  jsLint: function(e) {
    e.stop();
    if (JSHINT){
      return this.JSLintValidate();
    }
    // if (!window.JSLINT) {
    //   // never happens as apparently JSLINT needs to be loaded before MooTools
    //   Asset.javascript('/js/jslint.min.js', {
    //     onload: this.JSLintValidate.bind(this)
    //   });
    // } else {
    //   return this.JSLintValidate();
    // }
  },
  
  JSLintValidate: function() {
    var editor = Layout.editors.js.editor;
    var html = '<div class="modalWrap modal_jslint">' +
      '<div class="modalHeading"><h3>JSLint {title}</h3><span class="close">Close window</span></div>'+
      '<div class="modalBody">{content}</div></div>';
    var sticky = function(subs){
      return new StickyWin({
        content: html.substitute(subs),
        relativeTo: $(document.body),
        position: 'center',
        edge: 'center',
        closeClassName: 'close',
        draggable: true,
        dragHandleSelector: 'h3',
        closeOnEsc: true,
        destroyOnClose: true,
        allowMultiple: false,
        onDisplay: this.showModalFx
      }).show();
    };
    
    if (this.options.jslintLanguages.contains(panel_js)){
      var editorValue = editor.getValue();
      
      // clear all markers from the gutter, we'll highlight errors again in the next step
      for (var line = 0; editor.lineCount() >= line; line++){
        editor.setGutterMarker(line, 'note-gutter', null);
      }
      
      if (editorValue.trim() === ''){
        sticky.call(this, {
          title: 'Valid!',
          content: '<p>Good work! Your JavaScript code is perfectly valid.</p>'
        });
      } else {
        if (JSHINT(editorValue)){
          sticky.call(this, {
            title: 'Valid!',
            content: '<p>Good work! Your JavaScript code is perfectly valid.</p>'
          });
        } else {
          Array.each(JSHINT.errors, function(error, index){
            errorEl = Element('span', {
              'class': 'CodeMirror-line-error',
              'data-title': error.reason,
              'text': '●'
            });
            editor.setGutterMarker(error.line - 1, 'note-gutter', errorEl);
          }, this);
        }
      }
    } else {
      sticky.call(this, {
        title: 'Sorry No JavaScript!',
        content: '<p>You\'re using ' + panel_js + '</p>'
      });
    }
  },
  
  // mark shell as favourite
  makeFavourite: function(e) {
    e.stop();
    new Request.JSON({
      'url': makefavouritepath,
      'data': {shell_id: this.options.example_id},
      'onSuccess': function(response) {
        
        // #TODO: reload page after successful save
        window.location.href = response.url;
        //$('mark_favourite').addClass('isFavourite').getElements('span')[0].set('text', 'Base');
      }
    }).send();
  },
  
  // save and create new pastie
  saveAsNew: function(e) {
    e.stop(); 
    Layout.updateFromMirror();
    $('id_slug').value='';
    $('id_version').value='0';
    new Request.JSON({
      'url': this.options.exampleSaveUrl,
      'onSuccess': function(json) {
        Layout.decodeEditors();
        if (!json.error) {
          
          // reload page after successful save
          window.location = json.pastie_url_relative;
        } else {
          alert('ERROR: ' + json.error);
        }
      }
    }).send(this.form);
  },
  
  // update existing (create shell with new version)
  saveAndReload: function(e) {
    if (e) e.stop(); 
    Layout.updateFromMirror();
    new Request.JSON({
      'url': this.options.exampleSaveUrl,
      'onSuccess': function(json) {
        
        // reload page after successful save
        Layout.decodeEditors();
        window.location = json.pastie_url_relative;
      }
    }).send(this.form);
  },
  
  // run - submit the form (targets to the iframe)
  run: function(e) {
    var draftonly = false;
    if (e) e.stop(); 
    if (e && $(e.target).getParent().get('id') == 'm') {
      draftonly = new Element('input', {
        'hidden': true,
        'name': 'draftonly',
        'id': 'draftonly',
        'value': true
      });
      draftonly.inject(this.form);
    }
    Layout.updateFromMirror();
    this.form.submit();
    if (draftonly) {
      draftonly.destroy();
    }
    this.fireEvent('run');
  },
  loadDraft: function(e) {
    if (e) e.stop();
    if (username) {
      window.open('/draft/', 'jsfiddle_draft');
    } else {
      window.location = '/user/login/';
    }
  },
  // This is a method to be called by keyboard shortcut
  toggleSidebar: function(e) {
     if (e) e.stop();
     Layout.sidebar.toggle();
  },
  showShortcutDialog: function(e) {
    if (e) e.stop();
    var html = '<div class="modalWrap modal_kbd">' +
                '<div class="modalHeading"><h3>Keyboard shortcuts</h3><span class="close">Close window</span></div>'+
                '<div id="kbd" class="modalBody">' +
                '<ul>' +
                '<li><kbd>Control</kbd> + <kbd>Return</kbd> <span>Run fiddle</span></li>' +
                '<li><kbd>Control</kbd> + <kbd>s</kbd> <span>Save fiddle (Save or Update)</span></li>' +
                '<li><kbd>Control</kbd> + <kbd>Shift</kbd> + <kbd>Return</kbd> <span>Load draft</span></li>' +
                '<li><kbd>Control</kbd> + <kbd>&uarr;</kbd> or <kbd>Control</kbd> + <kbd>&darr;</kbd> <span>Switch editor windows</span></li>' +
                '<li><kbd>Control</kbd> + <kbd>Shift</kbd> + <kbd>&uarr;</kbd> <span>Toggle sidebar</span></li>' +
                '</ul>' +
                '</div></div>';

    new StickyWin({
      content: html,
      relativeTo: $(document.body),
      position: 'center',
      edge: 'center',
      closeClassName: 'close',
      draggable: true,
      dragHandleSelector: 'h3',
      closeOnEsc: true,
      destroyOnClose: true,
      allowMultiple: false,
      onDisplay: this.showModalFx
    }).show();
  },
  showModalFx: function(){
      $$('.modalWrap')[0].addClass('show');
  },
  switchTo: function(index) {
    Layout.current_editor = Layout.editors_order[index];
    Layout.editors[Layout.current_editor].editor.focus();
  },
  switchNext: function() {
    // find current and switch to the next
    var index = Layout.editors_order.indexOf(Layout.current_editor);
    var nextindex = (index + 1) % 3;
    this.switchTo(nextindex);
  },
  switchPrev: function() {
    // find current and switch to previous
    var index = Layout.editors_order.indexOf(Layout.current_editor);
    var nextindex = (index - 1) % 3;
    if (nextindex < 0) nextindex = 2;
    this.switchTo(nextindex);
  },
  
  // rename iframe label to present the current URL
  displayExampleURL: function() {
    var resultInput = document.id(this.options.resultInput);
    if (resultInput) {
      if (Browser.Engine.gecko) {
        resultInput.setStyle('padding-top', '4px');
      }
      // resultInput.select();
    }
  },
  loadLibraryVersions: function(group_id) {
    if (group_id) {
      new Request.JSON({
        url: this.options.loadLibraryVersionsURL.substitute({group_id: group_id}),
        onSuccess: function(response) {
          $('js_lib').empty();
          $('js_dependency').empty();
          response.libraries.each( function(lib) {
            new Element('option', {
              value: lib.id,
              text: "{group_name} {version}".substitute(lib)
            }).inject($('js_lib'));
            if (lib.selected) $('js_lib').set('value',lib.id);
          });
          response.dependencies.each(function (dep) {
            new Element('li', {
              html: [
                "<input id='dep_{id}' type='checkbox' name='js_dependency[{id}]' value='{id}'/>",
                "<label for='dep_{id}'>{name}</label>"
                ].join('').substitute(dep)
            }).inject($('js_dependency'));
            if (dep.selected) $('dep_'+dep.id).set('checked', true);
          });
        }
      }).send();
    } else {
      // XXX: would be good to send an error somehow
    }
  },
  loadDependencies: function(lib_id) {
    if (lib_id) {
      new Request.JSON({
        url: this.options.loadDependenciesURL.substitute({lib_id: lib_id}),
        method: 'get',
        onSuccess: function(response) {
          $('js_dependency').empty();
          response.each(function (dep) {
            new Element('li', {
              html: [
                "<input id='dep_{id}' type='checkbox' name='js_dependency[{id}]' value='{id}'/>",
                "<label for='dep_{id}'>{name}</label>"
                ].join('').substitute(dep)
            }).inject($('js_dependency'));
            if (dep.selected) $('dep_'+dep.id).set('checked', true);
          });
        }
      }).send();
    } else {
      // XXX: would be good to send an error somehow
    }
  }
});

/**
*
*  Base64 encode / decode
*  http://www.webtoolkit.info/
*
**/
 
var Base64 = {
 
  // private property
  _keyStr : "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
 
  // public method for encoding
  encode : function (input) {
    var output = "";
    input = input || "";
    var chr1, chr2, chr3, enc1, enc2, enc3, enc4;
    var i = 0;
 
    input = Base64._utf8_encode(input);
 
    while (i < input.length) {
 
      chr1 = input.charCodeAt(i++);
      chr2 = input.charCodeAt(i++);
      chr3 = input.charCodeAt(i++);
 
      enc1 = chr1 >> 2;
      enc2 = ((chr1 & 3) << 4) | (chr2 >> 4);
      enc3 = ((chr2 & 15) << 2) | (chr3 >> 6);
      enc4 = chr3 & 63;
 
      if (isNaN(chr2)) {
        enc3 = enc4 = 64;
      } else if (isNaN(chr3)) {
        enc4 = 64;
      }
 
      output = output +
      this._keyStr.charAt(enc1) + this._keyStr.charAt(enc2) +
      this._keyStr.charAt(enc3) + this._keyStr.charAt(enc4);
 
    }
 
    return output;
  },
 
  // public method for decoding
  decode : function (input) {
    var output = "";
    var chr1, chr2, chr3;
    var enc1, enc2, enc3, enc4;
    var i = 0;
 
    input = input.replace(/[^A-Za-z0-9\+\/\=]/g, "");
 
    while (i < input.length) {
 
      enc1 = this._keyStr.indexOf(input.charAt(i++));
      enc2 = this._keyStr.indexOf(input.charAt(i++));
      enc3 = this._keyStr.indexOf(input.charAt(i++));
      enc4 = this._keyStr.indexOf(input.charAt(i++));
 
      chr1 = (enc1 << 2) | (enc2 >> 4);
      chr2 = ((enc2 & 15) << 4) | (enc3 >> 2);
      chr3 = ((enc3 & 3) << 6) | enc4;
 
      output = output + String.fromCharCode(chr1);
 
      if (enc3 != 64) {
        output = output + String.fromCharCode(chr2);
      }
      if (enc4 != 64) {
        output = output + String.fromCharCode(chr3);
      }
 
    }
 
    output = Base64._utf8_decode(output);
 
    return output;
 
  },
 
  // private method for UTF-8 encoding
  _utf8_encode : function (string) {
    var utftext = "";
    string = string.replace(/\r\n/g,"\n");
 
    for (var n = 0; n < string.length; n++) {
 
      var c = string.charCodeAt(n);
 
      if (c < 128) {
        utftext += String.fromCharCode(c);
      }
      else if((c > 127) && (c < 2048)) {
        utftext += String.fromCharCode((c >> 6) | 192);
        utftext += String.fromCharCode((c & 63) | 128);
      }
      else {
        utftext += String.fromCharCode((c >> 12) | 224);
        utftext += String.fromCharCode(((c >> 6) & 63) | 128);
        utftext += String.fromCharCode((c & 63) | 128);
      }
 
    }
    return utftext;
  },
 
  // private method for UTF-8 decoding
  _utf8_decode : function (utftext) {
    var string = "";
    var i = 0;
    var c = c1 = c2 = 0;
 
    while ( i < utftext.length ) {
 
      c = utftext.charCodeAt(i);
 
      if (c < 128) {
        string += String.fromCharCode(c);
        i++;
      }
      else if((c > 191) && (c < 224)) {
        c2 = utftext.charCodeAt(i+1);
        string += String.fromCharCode(((c & 31) << 6) | (c2 & 63));
        i += 2;
      }
      else {
        c2 = utftext.charCodeAt(i+1);
        c3 = utftext.charCodeAt(i+2);
        string += String.fromCharCode(((c & 15) << 12) | ((c2 & 63) << 6) | (c3 & 63));
        i += 3;
      }
      
    }
    
    return string;
  }
 
};

var Dropdown = new Class({
  
  initialize: function(){
    this.dropdown = {
      cont: document.getElements('.dropdownCont'),
      trigger: document.getElements('.dropdown a.aiButton')
    };
    
    this.setDefaults();
  },
  
  setDefaults: function(){
    this.dropdown.cont.fade('hide');
    this.dropdown.cont.set('tween', {
      duration: 200
    });
    
    this.dropdown.trigger.each(function(trigger){
      trigger.addEvents({
        click: this.toggle.bindWithEvent(trigger, this)
      });
    }, this);
    
    $(document.body).addEvents({
      click: function(e){
        if (!$(e.target).getParent('.dropdownCont')){
          this.hide();
          // this.dropdown.trigger.getElement('span').removeClass('selected')
        }
      }.bind(this)
    });
  },
  
  toggle: function(event, parent){
    var trigger = Element(event.target);
    event.stop();
    parent.dropdown.cont.fade('out');
    // trigger.removeClass('selected')
    
    if (this.getNext('.dropdownCont').getStyles('opacity')['opacity'] === 0){
      this.getNext('.dropdownCont').fade('in');
      // trigger.addClass('selected');
    }
  },
  
  hide: function(){
    this.dropdown.cont.fade('out');
  }
});
