const prettierrc = require('@equipindustry/prettierrc');
module.exports = {
  parser: 'babel-eslint',
  parserOptions: {
    ecmaFeatures: {
      jsx: true,
    },
    ecmaVersion: 2018,
    sourceType: 'module',
  },
  rules: {
    'prettier/prettier': [
      'error',
      prettierrc,
      {
        usePrettierrc: true,
      },
    ],
  },
  overrides: [
    {
      files: ['**/*.ts', '**/*.tsx'],
      env: { browser: true, es6: true, node: true },
      extends: ['@equipindustry/eslint-config'],
      parser: '@typescript-eslint/parser',
      parserOptions: {
        ecmaFeatures: { jsx: true },
        ecmaVersion: 2018,
        sourceType: 'module',
      },
      plugins: ['prettier', '@typescript-eslint'],
      rules: {
        'prettier/prettier': [
          'error',
          prettierrc,
          {
            usePrettierrc: true,
          },
        ],
      },
    },
  ],
};
