/*
 * Settings loader
 */

var MooShellSettings = new Class({
	Implements: [Options],
	options: {
		library_id: 'js_library',
		dependency_id: 'js_dependency'
	},
	initialize: function(options){
		this.setOptions(options);
		this.libEl = $(this.options.library_id);
		this.depEl = $(this.options.dependency_id);
		this.libEl.addEvent('change', function() {
			this.changeDeps();
		}.bind(this));
		this.changeDeps();
	},
	changeDeps: function() {
		new Request.JSON({
			url: get_dependencies_url.substitute({
				"lib_id": this.libEl.value
			}), 
			onSuccess: function(result) {
				this.depEl.empty();
				result.each( function(dep) {
					new Element('li', {
						'html': "<input type='checkbox' id='dep_{id}' name='dep_{id}'/><label for='dep_{id}'>{name}</label>".substitute(dep)
					}).inject(this.depEl, 'top');
				}, this);
			}.bind(this)
		}).send();
	}
});