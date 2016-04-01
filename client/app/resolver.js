import computed from 'ember-computed';
import Resolver from 'ember-resolver';

export default Resolver.extend({
  moduleNameLookupPatterns: computed({
    get() {
      const defaultLookup = this._super();
      return [
        this.modelResolver,
        this.componentResolver
      ].concat(defaultLookup);
    }
  }),

  /*
    app/models/<name>/model
    app/models/<name>/serializer
    app/models/<name>/adapter
  */
  modelResolver(parsedName) {
    const { fullNameWithoutType, type } = parsedName;
    if (type === 'model' || type === 'serializer' || type === 'adapter') {
      return `${this.prefix(parsedName)}/models/${fullNameWithoutType}/${type}`;
    }
  },

  // app/components/<name>/component
  // app/components/<name>/template
  componentResolver(parsedName) {
    const { fullNameWithoutType, type } = parsedName;
    if (type === 'component') {
      return `${this.prefix(parsedName)}/components/${fullNameWithoutType}/${type}`;
    } else if (type === 'template') {
      return `${this.prefix(parsedName)}/${fullNameWithoutType}/${type}`;
    }
  }
});
