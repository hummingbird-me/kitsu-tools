var update_resource_input = function(value) {
	if (value) {
		if (resources.contains(value)) {
			return false;
		}
		resources.push(value);
	}
	$('external_resources_id').set('value', resources.join(','));
	return true;
};
var remove_resource = function(value) {
	if (resources.contains(value)) {
		resources.erase(value);
	}
	update_resource_input();
	
	this.external_resource_el = $('external_resource_'+value);
	new Fx.Reveal(this.external_resource_el, {
		onComplete: function(){
			this.destroy();
		}.bind(this.external_resource_el)
	}).dissolve();
	
};
var submit_external_resource = function(e) {
	if (e) e.stop();
	// save url, after success update current list of resources and clean up the input
	var url = $('external_resource').value;
	if (url && url != $('external_resource').retrieve('default_value') && $('external_resource').value.length > 7) {
		new Request.JSON({
			url: add_external_resource_url,
			method: 'post',
			data: {url: url},
			onSuccess: function(response) {
				// push resource id to the list
				if (update_resource_input(response.id)) {
					// create external resource DOM element
					var li = new Element('li', {
						'id': 'external_resource_' + response.id
					}).inject($('external_resources_list'));
					new Element('a', {
						'text': response.filename,
						'title': response.url,
						'class': 'filename',
						'href': response.url,
						'target': '_blank'
					}).inject(li);
					
					new Element('a', {
						'text': 'Remove',
						'rel': response.id,
						'class': 'remove',
						'events': {
							'click': function(e) {
								e.stop();
								remove_resource(this.get('rel').toInt());
							}
						}
					}).inject(li);
				} else {
					// this resource was already included in the list
				}
				var inp = $('external_resource');
				inp.value = '';
				if (e && e.target.get('tag') != 'input') { 
					set_default_input_value.bind($('external_resource'))();
				}
			}
		}).send();
	}
};
var change_default_input_value = function(show) {
	// set or remove the default value from input
	if (show && !this.value) {
		this.set('value', this.retrieve('default_value'));
		this.addClass('default');
	} else if (!show && this.value == this.retrieve('default_value')) {
		this.set('value', '');
		this.removeClass('default');
	}
};
var set_default_input_value = function() {
	change_default_input_value.bind(this)(true);
};
var remove_default_input_value = function() {
	change_default_input_value.bind(this)(false);
};

window.addEvent('domready', function() {
	var inp = $('external_resource');
	inp.store('default_value', default_text);
	if (!inp.value) {
		inp.set('value', default_text);
	}
	update_resource_input();
	inp.addEvents({
		'change': set_default_input_value,
		'blur': set_default_input_value,
		'focus': remove_default_input_value,
		'keydown': function(e) {
			if (e.key == 'enter') {
				submit_external_resource.bind(this)(e);
			}
		},
		'submit': submit_external_resource
	});
	$('add_external_resource').addEvent('click', submit_external_resource);
    if (preload_resources) {
        preload_resources.each(function(res){
            $('external_resource').set('value',res);
            submit_external_resource();
        })
    }
});
