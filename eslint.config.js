import js from "@eslint/js";
import globals from "globals";
import pluginVue from "eslint-plugin-vue";
import skipFormatting from "@vue/eslint-config-prettier/skip-formatting";

export default [
  {
    ignores: ["dist/**"]
  },
  js.configs.recommended,
  ...pluginVue.configs["flat/essential"],
  skipFormatting,
  {
    languageOptions: {
      globals: {
        ...globals.browser
      }
    },
    rules: {
      "no-console": "off"
    }
  }
];
