/*
 * jQuery Animated Table Sorter 0.2.2 (02/25/2013)
 *
 * http://www.matanhershberg.com/plugins/jquery-animated-table-sorter/
 *
*/


/* ARRAY STRUCTURE
Array - Specifc table
	Object - table row - each tr is its own object
		id - numeric, doesn't change, used for table row classes
		tds - all the tds in that row
		height - height of the tr
*/

(function( $ ){

	$.fn.tableSort = function( options ) {  

		// Create some defaults, extending them with any options that were provided
		var settings = $.extend( {
			animation			: 'slide',
			rowspan				: false,
			sortAs				: { },
			speed				: 300,
			distance			: '300px',
			delay				: 1
		}, options);
			
		return this.each(function() {
			/* SET VARIABLES */
			var table_data = new Array();  // Original table data
			var copied_tr = new Array(); // Keeps a copy of each tr, used for some animations
			var animating = false; // Used for disabling animation spamming for some animations
			var sorted_table_data = new Array(); // To contain sorted tables
			var sorting_history = new Array();
			var tsort_id = 0; // For applying classes for rows
			var column_widths = new Array();
			var sorting_criteria = new Array(); // User defined sorting methods
			var th_index_selected; // The header index that was clicked on
			var table = $(this); // The table element we are manipulating
			var animating = false; // Keep track of animation
			
			/* PERFORM INITIALIZATION */
			if (settings['rowspan'] == true) { // Fix table data cells with rowspans larger than 1
				rowspan();
			}
			if (settings['delay'] <= 0) { // For performance reasons, delay can not be smaller than 1
				settings['delay'] = 1;
			}
			
			/* GET SORTING CRITERIA */
			$(table).find('tr:first-child th').each(function(index) {
				
				// Check for user defined sorting criteria
				if ( settings['sortBy'] != undefined ) {
					switch ( settings['sortBy'][index] ) {
						case 'text':
						case 'numeric':
						case 'nosort':
							sorting_criteria[index] = settings['sortBy'][index];
							return;
					}
				}

				// Otherwise look for markup criteria				
				if ( $(this).attr('data-sort') != undefined ) {
					switch ( $(this).attr('data-sort') ) {
						case 'text':
						case 'numeric':
						case 'nosort':
							sorting_criteria[index] = $(this).attr('data-sort');
							return;
					}
				}
				
				// Last resort try auto-detecting
				sorting_criteria[index] = dataType($(table).find('tr:eq(1) td:eq(' + index + ')').text());
			});
			
			/* GET TABLE DATA */
			function getTableData() {
				
				/* PUT TABLE DATA INTO AN OBJECT ARRAY */
				$(table).find('tr').each(function(index) {
					if (index > 0) $(this).addClass('tsort_id-' + (index - 1)); // Add a class to each tr that corresponds with the object id (tsortid-0)
					$(this).find('td').each(function (td_index) {
						if ($(this).is(":first-child")) {
							table_data.push(new Object());
							table_data[table_data.length - 1].id = index - 1;
							table_data[table_data.length - 1].td = new Array();
							table_data[table_data.length - 1].height = $(this).parent().height();
						}
						
						if ( $(this).attr('data-sortAs') != undefined ) {
							table_data[table_data.length - 1].td.push($(this).attr('data-sortAs'));
						} else if ( typeof settings['sortAs'] != undefined && settings['sortAs'][$(this).text()] != undefined ) {
							table_data[table_data.length - 1].td.push(settings['sortAs'][$(this).text()]);
						} else if (sorting_criteria[td_index] == 'numeric') {
							table_data[table_data.length - 1].td.push(getNumber($(this).text()));
						} else {
							table_data[table_data.length - 1].td.push($(this).text());
						}
					});
				});
			}
			
			// Auto detect whether the column should be treated as text or numeric.
			// Uses the most used values (numbers include separators such as , and .)
			// Returns 'numeric' or 'text'
			function dataType(string) {
			
				var numbers = 0;
				var text = 0;
				
				for (var i = 0; i <= string.length - 1; i++) {
					if ( $.isNumeric(string.charAt(i)) || string.charAt(i) == ',' || string.charAt(i) == '.' ) {
						numbers++;
					} else {
						text++;
					}
				}
				
				if ( numbers > text ) {
					return 'numeric';
				} else {
					return 'text';
				}
				
			}
			
			/* STYLE TABLE */
			// Set table to position relative
			$(table).css('position', 'relative');
			
			// Add divs for directional arrows
			$(table).find('tr:first-child th').each(function(index) {
				if ( sorting_criteria[index] != 'nosort' ) {
					$('<div class="sortArrow"><div class="sortArrowAscending"></div><div class="sortArrowDescending"></div></div>').appendTo($(this));
				}
			});
			
			// Set each td's width
			$(table).find('tr:first-child th').each(function() {
				column_widths.push($(this).outerWidth(true));
			});
			
			$(table).find('tr td, tr th').each(function() {
				$(this).css( {
					minWidth: column_widths[$(this).index()]
				} );
			});
			
			// Set each row's height and width
			$(table).find('tr').each(function() {
				$(this).width($(this).outerWidth(true));
				$(this).height($(this).outerHeight(true));
			});
			
			// Set table height and width
			$(table).height($(this).outerHeight()).width($(this).outerWidth());
			
			// Put all the rows back in place
			var vertical_offset = 0; // Beginning distance of rows from the table body in pixels
			$(table).find('tr').each(function(index) {
				$(this).css('top', vertical_offset);
				vertical_offset += $(this).outerHeight();
			});

			// Set table cells position to absolute
			$(table).find('tr').each(function(index,el) {
				$(this).css('position', 'absolute');
			});
			
			// Set th hover cursor to pointer
			$(table).find('tr th').each(function(index) {
				if (sorting_criteria[index] != 'nosort') {
					$(this).css('cursor', 'pointer');
				}
			});
			
			
			
			/* FUNCTIONALITY */	
			$(table).find('tr th').click(function() {
				
				if (animating) return; // Disables animation spamming
				
				if ( sorting_criteria[$(this).index()] == 'nosort' ) { // Check if column is supposed to be sorted, otherwise exit function
					return;
				}
				
				th_index_selected = $(this).index();
				if (table_data.length == 0) { // Get the table data if we haven't already
					getTableData();
				}
				
				if (!sorted_table_data[th_index_selected]) {	// If we haven't sorted this column yet
						sorted_table_data[th_index_selected] = table_data.concat(); // Make a copy of the original table data
					if (sorting_criteria[th_index_selected] == 'numeric') {		// Sort numeric
						sorted_table_data[th_index_selected].sort(function(a,b) {
							return a.td[th_index_selected] - b.td[th_index_selected];
						});
					} else if (sorting_criteria[th_index_selected] == 'text') { // Sort text
						sorted_table_data[th_index_selected].sort(function(a,b) {
							return a.td[th_index_selected].localeCompare(b.td[th_index_selected]);
						});				
					}
				}

				// sorting_history keeps track of all the columns the user selected to sort, and their order
				// To also be used later for priority sorting in case two values are equal
				if ( sorting_history.length == 0 ) {
					sorting_history.push( { column_id: th_index_selected, direction: 'ascending' } ); // If this is the first column clicked, add to sorting_history
				} else if ( sorting_history.length != 0 ) { // If this is not the first column clicked
					if ( th_index_selected == sorting_history[sorting_history.length - 1]['column_id'] ) { // Check if it's the same column clicked as before to determine the asec/desc order
						switch ( sorting_history[sorting_history.length - 1]['direction'] ) {
							case 'ascending': {
								sorting_history.push( { column_id: th_index_selected, direction: 'descending' } );
							
								break;
							}
							
							case 'descending': {
								sorting_history.push( { column_id: th_index_selected, direction: 'ascending' } );
							
								break;
							}
						}
					} else { // If this is not the same column clicked as before, set to ascending
						sorting_history.push( { column_id: th_index_selected, direction: 'ascending' } );
					}
				}
				
				// Call the display_table function with the data array and direction requested
				display_table(sorted_table_data[th_index_selected], sorting_history[sorting_history.length -1]['direction']);
				display_arrow(th_index_selected, sorting_history[sorting_history.length -1]['direction']);
			});
			
			// Display arrow direction
			function display_arrow(column, direction) {
				$(table).find('tr:first-child th div.sortArrow div').stop(true,true).fadeOut(settings['speed'], 'swing');
				switch (direction) {
					case 'ascending': {
						$(table).find('tr:first-child th div.sortArrow div.sortArrowAscending').eq(column).fadeIn(settings['speed'], 'swing');
						
						break;
					}
					case 'descending': {
						$(table).find('tr:first-child th div.sortArrow div.sortArrowDescending').eq(column).fadeIn(settings['speed'], 'swing');
					
						break;
					}
				}
			}
			
			// This function receives the new sorted table data array and displays it
			function display_table(data, direction) {
				if (direction == 'ascending') {
					var data = data.concat(); // .concat() fixes function scope issues with references by saving a copy of it (function within function loading old data)
				} else {
					var data = data.concat().reverse();
				}
				
				vertical_offset = $(table).find('tr').height(); // Start at header height
				
				if ( settings['animation'] == 'none') {
				
					for ( index = 0; index < data.length; index++ ) {
						var el = data[index];
						$(table).find('tr.tsort_id-' + el.id).css({ top: vertical_offset }).appendTo(table);
						vertical_offset += el.height;
					}
					
				} else if ( settings['animation'] == 'slide') {
				
					for ( index = 0; index < data.length; index++) {
						var el = data[index];
						$(table).find('tr.tsort_id-' + el.id).stop().delay(settings['delay'] * index).animate({ top: vertical_offset}, settings['speed'], 'swing').appendTo(table);
						vertical_offset += el.height;
					}
				
				} else if ( settings['animation'] == 'fadeAll') {
				
					animating = true;
					
					$(table).find('tr:gt(0)').fadeOut(settings['speed']).promise().done(function() {
						for ( index = 0; index < data.length; index++) {
							var el = data[index];
							$(table).find('tr.tsort_id-' + el.id).css({ top: vertical_offset }).appendTo(table);
							vertical_offset += el.height;
							if (index == table_data.length - 1 ) {
								$(table).find('tr').delay(1).fadeIn(settings['speed'], 'swing').promise().done(function() {
								
									animating = false;

								});
							}
						};
					});
					
				} else if ( settings['animation'] == 'fade') {
				
					animating = true;
					
					if ( copied_tr.length == 0 ) {
						for ( index = 0; index < data.length; index++ ) {
							var el = data[index];
							copied_tr[el.id] = $(table).find('tr.tsort_id-' + el.id).clone();
						}
					}
					
					$(table).find('tr:gt(0)').each(function(index, el) {
						$(this).delay(index * settings['delay']).fadeOut(settings['speed'], 'swing', function() {
							$(this).remove();
							$(copied_tr[data[index]['id']]).clone().hide().css({ top: vertical_offset }).appendTo(table).delay(1).fadeIn(settings['speed'], 'swing', function() {
							
								if (index == table_data.length - 1) {
									animating = false;
								}
							
							});
							vertical_offset += data[index]['height'];
						});
					});
				
				} else if ( settings['animation'] == 'slideLeftAll') {
				
					animating = true;
					
					$(table).find('tr:gt(0)').each(function(index, element) {
						$(this).delay(index * settings['delay']).animate( { left: "-" + settings['distance'], opacity: 0} , settings['speed'], 'swing');
						if ( index == table_data.length - 1 ) {
							$(this).promise().done(function() {
								for ( index = 0; index < data.length; index++ ) {
									var el = data[index];
									$(table).find('tr.tsort_id-' + el.id).css({ top: vertical_offset, left: '', right: "-" + settings['distance'] }).appendTo(table).delay(index * settings['delay']).animate({ right: "0px", opacity: 1 }, settings['speed'], 'swing', function() {
										
										$(this).css('right','auto')
										
										if ($(this).is('tr:last-child')) {
											animating = false;
										}
									});
									
									vertical_offset += el.height;
									
								}
							});
						}
					});
				
				} else if ( settings['animation'] == 'slideLeft') {
				
					animating = true;
					
					if ( copied_tr.length == 0 ) {
						for ( index = 0; index < data.length; index++ ) {
							var el = data[index];
							copied_tr[el.id] = $(table).find('tr.tsort_id-' + el.id).clone();
						};
					}
					
					$(table).find('tr:gt(0)').each(function(index, el) {
						$(this).delay(index * settings['delay']).animate( { left: '-' + settings['distance'], opacity: 0} , settings['speed'], 'swing', function() {
							$(this).remove();
							$(copied_tr[data[index]['id']]).clone().css( { opacity: 0 } ).appendTo(table).css({ top: vertical_offset, left: '', right: '-' + settings['distance'] }).animate({ right: "0px", opacity: 1 }, settings['speed'], function() {
								$(this).css('right','auto');
								
								if (index == table_data.length - 1) {
									animating = false;
								}
							});
							
							vertical_offset += data[index]['height'];
							
						});	
					});
				
				}
				
			}
			
			// Removes all characters that are not a number or a period and returns the string
			function getNumber(string) {
				var number = '';
				for (var i = 0; i <= string.length; i++) {
					if ( $.isNumeric(string.charAt(i)) || string.charAt(i) == '.' ) {
						number += string.charAt(i);
					}
				}
				return number;
			}
			
			// Replace rowspans larger than 1 with actual tds		
			function rowspan() {
				$(table).find('td').each(function(index) {
					if ($(this).attr('rowspan') != undefined) {
						var rowspan = $(this).attr('rowspan');
						$(this).removeAttr('rowspan');
						
						var tr_index = $(this).parent().index();
						var tr_eq = 1;
						while (rowspan > 1) {
							switch ($(this).index()) {
								case 0:
									$(this).clone().prependTo($(this).parent().parent().children().eq(tr_index + tr_eq));
									break;
								default:
									$(this).clone().insertAfter($(this).parent().parent().children().eq(tr_index + tr_eq).children().eq($(this).index() - 1));
									break;
							}
							tr_eq++;
							rowspan--;
						}
					}
				});
			}
		});
	};
})( jQuery );