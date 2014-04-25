Hummingbird.DraggableMixin = Em.Mixin.create(JQ.Widget,{
  uiType: 'draggable',
  uiOptions: ['disabled', 'addClasses', 'appendTo', 'axis', 'cancel', 'helper',
            'connectToSortable', 'containment', 'cursor', 'delay', 'revert',
            'opacity', 'scroll', 'appendTo', 'distance', 'grid', 'handle', 'snap', 
            'snapMode', 'stack', 'cursorAt'],
  uiEvents: ['create', 'start', 'drag', 'stop'],
  //jquery UI options
  revert: 'invalid',
  opacity: 0.8,
  scroll: 'true',
  appendTo: 'body',
  containment: 'window',
  distance: 5,
  cursor: 'move',
  cursorAt: {
    top: 25 + $(window).scrollTop(),
    left: 18
  }  
})
