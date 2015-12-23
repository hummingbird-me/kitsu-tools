const ENUM_KEYS = ['current', 'planned', 'completed', 'on_hold', 'dropped'];
const SHOW_KEYS = ['Currently Watching', 'Plan to Watch', 'Completed', 'On Hold', 'Dropped'];

// TODO: Support Manga words
export function getHumanStatuses() {
  return SHOW_KEYS;
}

export function humanToEnum(status) {
  const index = SHOW_KEYS.indexOf(status);
  return ENUM_KEYS[index];
}

export function humanToNumber(status) {
  return SHOW_KEYS.indexOf(status) + 1;
}

export function numberToHuman(status) {
  return SHOW_KEYS[status - 1];
}

export function enumToNumber(status) {
  return ENUM_KEYS.indexOf(status) + 1;
}

export function enumToHuman(status) {
  const index = ENUM_KEYS.indexOf(status);
  return SHOW_KEYS[index];
}
