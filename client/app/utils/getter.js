class Getter {
  constructor(func) {
    this.isDescriptor = true;
    this._getter = func;
  }

  get(obj) {
    return this._getter.call(obj);
  }
}

export default function getter(func) {
  return new Getter(func);
}
