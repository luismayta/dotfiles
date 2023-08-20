module.exports = {
  parser: "@typescript-eslint/parser",
  env: {
    node: true,
    es2021: true
  },
  parserOptions: {
    ecmaVersion: 6,
    sourceType: "module" // Allows for the use of imports
  },
  extends: [
    "plugin:prettier/recommended",
    "plugin:@typescript-eslint/recommended", // Uses the recommended rules from the @typescript-eslint/eslint-plugin
    "plugin:import/warnings"
  ],
  plugins: ["@typescript-eslint"],
  rules: {
    "@typescript-eslint/semicolon": "off",
    "@typescript-eslint/member-delimiter-style": "off",
    "@typescript-eslint/naming-convention": "warn",
    "@typescript-eslint/semi": "off",
    "no-throw-literal": "warn",
    curly: "warn",
    eqeqeq: "warn",
    semi: "off"
  },
  ignorePatterns: ["**/*.d.ts"]
}
