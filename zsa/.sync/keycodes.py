"""Lookup tables and Voyager layout constants used across conversion modules."""

from __future__ import annotations

# Oryx stores keys half-by-half: all 26 left keys (rows 0-3 + 2 thumbs) then
# all 26 right keys. keymap-drawer/QMK expects row-interleaved order:
# row0_left(6) + row0_right(6) + row1_left(6) + ... + thumb_left(2) + thumb_right(2).
# This list gives the Oryx source index for each keymap-drawer position.
VOYAGER_KEY_ORDER: list[int] = (
    list(range(0, 6))   + list(range(26, 32))  # row 0
    + list(range(6, 12))  + list(range(32, 38))  # row 1
    + list(range(12, 18)) + list(range(38, 44))  # row 2
    + list(range(18, 24)) + list(range(44, 50))  # row 3
    + list(range(24, 26)) + list(range(50, 52))  # thumbs
)

# Left-half indices in keymap-drawer/QMK order (after reordering)
VOYAGER_LEFT_INDICES: frozenset[int] = frozenset(
    list(range(0, 6))    # row 0 left
    + list(range(12, 18))  # row 1 left
    + list(range(24, 30))  # row 2 left
    + list(range(36, 42))  # row 3 left
    + [48, 49]             # thumbs left
)

# Codes that mean "no key here" (intentional gap, not transparent)
EMPTY_CODES: frozenset[str] = frozenset({"KC_NO", "XXXXXXX"})

# Codes that mean "pass through to layer below"
TRANSPARENT_CODES: frozenset[str] = frozenset({"KC_TRANSPARENT", "KC_TRNS"})

# Shifted output for non-alphabetic US layout keys only (Oryx verbose names).
# Alpha keys intentionally excluded; uppercase is self-evident.
US_SHIFT_MAP: dict[str, str] = {
    "KC_1": "!", "KC_2": "@", "KC_3": "#", "KC_4": "$", "KC_5": "%",
    "KC_6": "^", "KC_7": "&", "KC_8": "*", "KC_9": "(", "KC_0": ")",
    "KC_GRAVE": "~", "KC_MINUS": "_", "KC_EQUAL": "+",
    "KC_LBRC": "{", "KC_RBRC": "}", "KC_BSLS": "|",
    "KC_SCLN": ":", "KC_QUOTE": '"',
    "KC_COMMA": "<", "KC_DOT": ">", "KC_SLASH": "?",
}

# Oryx modifier field names → QMK modifier mask names
QMK_MOD_MAP: dict[str, str] = {
    "leftCtrl": "MOD_LCTL", "rightCtrl": "MOD_RCTL",
    "leftShift": "MOD_LSFT", "rightShift": "MOD_RSFT",
    "leftAlt": "MOD_LALT", "rightAlt": "MOD_RALT",
    "leftGui": "MOD_LGUI", "rightGui": "MOD_RGUI",
}

# QMK modifier mask → human-readable display label
MOD_DISPLAY: dict[str, str] = {
    "MOD_LCTL": "Ctrl", "MOD_RCTL": "Ctrl",
    "MOD_LSFT": "Shift", "MOD_RSFT": "Shift",
    "MOD_LALT": "Alt", "MOD_RALT": "AltGr",
    "MOD_LGUI": "Cmd", "MOD_RGUI": "Cmd",
}

# Oryx verbose modifier codes → QMK shorthand (for QMK JSON output)
ORYX_MOD_TO_QMK: dict[str, str] = {
    "KC_LEFT_CTRL": "KC_LCTL", "KC_RIGHT_CTRL": "KC_RCTL",
    "KC_LEFT_SHIFT": "KC_LSFT", "KC_RIGHT_SHIFT": "KC_RSFT",
    "KC_LEFT_ALT": "KC_LALT", "KC_RIGHT_ALT": "KC_RALT",
    "KC_LEFT_GUI": "KC_LGUI", "KC_RIGHT_GUI": "KC_RGUI",
}

# Keycodes that render as Material Symbols glyphs via keymap-drawer's built-in fetcher
KEYCODE_GLYPHS: dict[str, str] = {
    "KC_SPACE": "$$material:space_bar$$",
    "KC_ENTER": "$$material:keyboard_return$$",
    "KC_BSPC": "$$material:backspace$$",
    "KC_DELETE": "$$material:delete$$",
    "KC_TAB": "$$material:keyboard_tab$$",
    "KC_LEFT": "$$material:keyboard_arrow_left$$",
    "KC_RIGHT": "$$material:keyboard_arrow_right$$",
    "KC_UP": "$$material:keyboard_arrow_up$$",
    "KC_DOWN": "$$material:keyboard_arrow_down$$",
    "KC_MS_BTN1": "$$material:left_click$$",
    "KC_MS_BTN2": "$$material:right_click$$",
    "KC_MEDIA_PLAY_PAUSE": "$$material:play_arrow$$",
    "KC_MEDIA_NEXT_TRACK": "$$material:skip_next$$",
    "KC_MEDIA_PREV_TRACK": "$$material:skip_previous$$",
    "KC_AUDIO_VOL_UP": "$$material:volume_up$$",
    "KC_AUDIO_VOL_DOWN": "$$material:volume_down$$",
}

# Keycodes whose display is their literal character
KEYCODE_SYMBOLS: dict[str, str] = {
    "KC_MINUS": "-", "KC_EQUAL": "=",
    "KC_LBRC": "[", "KC_RBRC": "]",
    "KC_BSLS": "\\", "KC_SCLN": ";",
    "KC_QUOTE": "'", "KC_COMMA": ",",
    "KC_DOT": ".", "KC_SLASH": "/", "KC_GRAVE": "`",
    "KC_TILD": "~", "KC_EXLM": "!", "KC_AT": "@",
    "KC_HASH": "#", "KC_DLR": "$", "KC_PERC": "%",
    "KC_CIRC": "^", "KC_AMPR": "&", "KC_ASTR": "*",
    "KC_LPRN": "(", "KC_RPRN": ")", "KC_UNDS": "_",
    "KC_PLUS": "+", "KC_LCBR": "{", "KC_RCBR": "}",
    "KC_PIPE": "|",
}

# Keycodes with explicit text or glyph label overrides
KEYCODE_LABELS: dict[str, str] = {
    "KC_ESCAPE": "Esc",
    "KC_HOME": "Home",
    "KC_END": "End",
    "KC_PAGE_UP": "PgUp",
    "KC_PGDN": "PgDn",
    "CW_TOGG": "CW",
    "ALL_T": "Hyper",
    "TOGGLE_LAYER_COLOR": "$$material:backlight_high$$",
    "KC_LEFT_CTRL": "$$material:keyboard_control_key$$",
    "KC_RIGHT_CTRL": "$$material:keyboard_control_key$$",
    "KC_LEFT_SHIFT": "$$material:shift$$",
    "KC_RIGHT_SHIFT": "$$material:shift$$",
    "KC_LEFT_ALT": "$$material:keyboard_option_key$$",
    "KC_RIGHT_ALT": "$$material:keyboard_option_key$$",
    "KC_LEFT_GUI": "$$material:keyboard_command_key$$",
    "KC_MS_UP": "$$material:arrow_drop_up$$",
    "KC_MS_DOWN": "$$material:arrow_drop_down$$",
    "KC_MS_LEFT": "$$material:arrow_left$$",
    "KC_MS_RIGHT": "$$material:arrow_right$$",
    "KC_MS_WH_UP": "$$material:swipe_up$$",
    "KC_MS_WH_DOWN": "$$material:swipe_down$$",
}
