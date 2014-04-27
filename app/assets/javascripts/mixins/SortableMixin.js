Hummingbird.SortableMixin = Em.Mixin.create(JQ.Widget,{
  uiType: 'sortable',
  uiOptions: ['disabled', 'appendTo', 'axis', 'cancel', 'helper',
            'containment', 'cursor', 'delay', 'revert', 'tolerance',
            'opacity', 'scroll', 'distance', 'grid', 'handle',
            'stack', 'cursorAt', 'connectWith'],
  uiEvents: ['create', 'start', 'drag', 'stop', 'update'],
  //jquery UI options
  revert: 'invalid',
  cursor: 'move',
  tolerance: 'pointer',
})
