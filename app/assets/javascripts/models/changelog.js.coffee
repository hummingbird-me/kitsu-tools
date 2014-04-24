Hummingbird.Changelog = DS.Model.extend
  newdate: DS.attr('boolean')
  # Currently hooked php script is not returning valid dates,
  # don't need to reformat them, if just set to string for now.
  date: DS.attr('string')
  mesg: DS.attr('string')
  name: DS.attr('string')
  uimg: DS.attr('string')
  type: DS.attr('string')