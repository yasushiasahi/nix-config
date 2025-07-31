{ ... }:
let
  # 共通で除外するアプリケーション
  excludedApps = [
    "^org\\.gnu\\.Emacs$"
    "^com\\.mitchellh\\.ghostty$"
    "^org\\.alacritty$"
  ];

  # 共通のconditions生成関数
  mkExcludeConditions = {
    type = "frontmost_application_unless";
    bundle_identifiers = excludedApps;
  };

  # 基本的なmanipulator生成関数
  mkBasicManipulator = { from, to, conditions ? [ mkExcludeConditions ] }: {
    type = "basic";
    inherit from to conditions;
  };

  # Control+キーの共通manipulator生成関数
  mkControlKeyManipulator = { key, to, conditions ? [ mkExcludeConditions ] }:
    mkBasicManipulator {
      from = {
        key_code = key;
        modifiers = {
          mandatory = ["control"];
          optional = ["any"];
        };
      };
      inherit to conditions;
    };

  # Option+キーの共通manipulator生成関数
  mkOptionKeyManipulator = { key, to, conditions ? [ mkExcludeConditions ] }:
    mkBasicManipulator {
      from = {
        key_code = key;
        modifiers = {
          mandatory = ["option"];
          optional = ["any"];
        };
      };
      inherit to conditions;
    };

  # 矢印キーへのマッピング用ヘルパー
  mkArrowMapping = direction: [{ key_code = "${direction}_arrow"; }];

  # Command+矢印キーへのマッピング用ヘルパー  
  mkCommandArrowMapping = direction: [{
    key_code = "${direction}_arrow";
    modifiers = ["command"];
  }];

  # Command+キーへのマッピング用ヘルパー
  mkCommandKeyMapping = key: [{
    key_code = key;
    modifiers = ["command"];
  }];

  # MOD-TAP manipulator生成関数
  mkModTapManipulator = { key, modifier }: {
    type = "basic";
    from = {
      key_code = key;
      modifiers = {
        optional = ["any"];
      };
    };
    to_if_alone = [{ key_code = key; }];
    to_if_held_down = [{ key_code = modifier; }];
    conditions = [{
      type = "device_if";
      identifiers = [{ is_built_in_keyboard = true; }];
    }];
  };

  # Emacs-like key bindings設定
  emacsLikeBindings = {
    "$schema" = "https://ale.sh/karabiner-jsonschema.json";
    title = "Emacs-like key bindings";
    rules = [
      {
        description = "Control+F/B/N/P to Arrow Keys";
        manipulators = [
          (mkControlKeyManipulator { key = "f"; to = mkArrowMapping "right"; })
          (mkControlKeyManipulator { key = "b"; to = mkArrowMapping "left"; })
          (mkControlKeyManipulator { key = "n"; to = mkArrowMapping "down"; })
          (mkControlKeyManipulator { key = "p"; to = mkArrowMapping "up"; })
        ];
      }
      {
        description = "Control+A/E to Bigining of line/End of line";
        manipulators = [
          (mkControlKeyManipulator { key = "a"; to = mkCommandArrowMapping "left"; })
          (mkControlKeyManipulator { key = "e"; to = mkCommandArrowMapping "right"; })
        ];
      }
      {
        description = "Control+M to Enter";
        manipulators = [
          (mkControlKeyManipulator { key = "m"; to = [{ key_code = "return_or_enter"; }]; conditions = []; })
        ];
      }
      {
        description = "Control+H/D to Delete/Forward Delete";
        manipulators = [
          (mkControlKeyManipulator { key = "h"; to = [{ key_code = "delete_or_backspace"; }]; })
          (mkControlKeyManipulator { key = "d"; to = [{ key_code = "delete_forward"; }]; })
        ];
      }
      {
        description = "Option+W to Copy";
        manipulators = [
          (mkOptionKeyManipulator { key = "w"; to = mkCommandKeyMapping "c"; })
        ];
      }
      {
        description = "Control+W to Cut";
        manipulators = [
          (mkControlKeyManipulator { key = "w"; to = mkCommandKeyMapping "x"; })
        ];
      }
      {
        description = "Control+K to delete to end of line";
        manipulators = [
          (mkControlKeyManipulator {
            key = "k";
            to = [
              { key_code = "right_arrow"; modifiers = ["command" "shift"]; }
              { key_code = "x"; modifiers = ["command"]; }
            ];
          })
        ];
      }
      {
        description = "Control+Y to Paste";
        manipulators = [
          (mkControlKeyManipulator { key = "y"; to = mkCommandKeyMapping "v"; })
        ];
      }
      {
        description = "Control+Shift+/ to Redo";
        manipulators = [
          (mkBasicManipulator {
            from = {
              key_code = "slash";
              modifiers = {
                mandatory = ["control" "shift"];
                optional = ["any"];
              };
            };
            to = [{ key_code = "z"; modifiers = ["command" "shift"]; }];
          })
        ];
      }
      {
        description = "Control+/ to Undo";
        manipulators = [
          (mkControlKeyManipulator { key = "slash"; to = mkCommandKeyMapping "z"; })
        ];
      }
      {
        description = "Control+I to Tab";
        manipulators = [
          (mkControlKeyManipulator { key = "i"; to = [{ key_code = "tab"; }]; })
        ];
      }
    ];
  };

  # MOD-TAP emulation設定
  modTapForInternalKeyboard = {
    "$schema" = "https://ale.sh/karabiner-jsonschema.json";
    title = "VIA's MOD-TAP emulation for Internal Keyboard";
    rules = [
      {
        description = "Long press Spacebar to Shift";
        manipulators = [
          (mkModTapManipulator { key = "spacebar"; modifier = "left_shift"; })
        ];
      }
      {
        description = "Long press Enter to Command";
        manipulators = [
          (mkModTapManipulator { key = "return_or_enter"; modifier = "left_command"; })
        ];
      }
      {
        description = "Long press Semicolon to Option";
        manipulators = [
          (mkModTapManipulator { key = "semicolon"; modifier = "left_option"; })
        ];
      }
      {
        description = "Long press Comma to Option";
        manipulators = [
          (mkModTapManipulator { key = "comma"; modifier = "left_option"; })
        ];
      }
    ];
  };
in
{
  xdg.configFile."karabiner/assets/complex_modifications/emacs-like-bindings.json".text =
    builtins.toJSON emacsLikeBindings;
  xdg.configFile."karabiner/assets/complex_modifications/mod-tap-for-internal-keyboard.json".text =
    builtins.toJSON modTapForInternalKeyboard;
}
