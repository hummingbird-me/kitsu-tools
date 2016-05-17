const ENUM_KEYS = ['current', 'planned', 'completed', 'on_hold', 'dropped'];

export function getEnumKeys() {
  return ENUM_KEYS;
}

// Number -> *
export function numberToEnum(status) {
  return ENUM_KEYS[status - 1];
}

// Enum -> *
export function enumToNumber(status) {
  return ENUM_KEYS.indexOf(status) + 1;
}
