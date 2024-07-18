import globals from "globals";
import pluginJs from "@eslint/js";
import pluginReactConfig from "eslint-plugin-vue/configs/recommended.js";
import { fixupConfigRules } from "@eslint/compat";

export default [
  { files: ["**/*.{js,vue,ts}"] },
  { languageOptions: { parserOptions: { ecmaFeatures: { jsx: true } } } },
  { languageOptions: { globals: globals.browser } },
  pluginJs.configs.recommended,
  ...fixupConfigRules(pluginReactConfig),
];
