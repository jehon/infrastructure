// @ts-check

import eslint from "@eslint/js";
import globals from "globals";

const config = [
  eslint.configs.recommended,
  {
    languageOptions: {
      ecmaVersion: "latest",
      sourceType: "module",
      globals: {
        ...globals.node
      }
    },
    rules: {
      "no-unused-vars": "off",
      "no-console": [
        "error",
        {
          allow: ["warn", "error", "info", "assert"]
        }
      ],
      "require-await": "error"
    }
  },
  {
    files: ["stacks/**/*.js"],
    languageOptions: {
      globals: {
        ...globals.browser
      }
    }
  },
  // https://github.com/eslint/eslint/issues/17400#issuecomment-1646873272
  // https://eslint.org/docs/latest/use/configure/configuration-files#globally-ignoring-files-with-ignores
  {
    ignores: ["**/data/**/*", "**/tmp/**"]
  }
];

export default config;
