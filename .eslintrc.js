module.exports = {
  extends: [
    'standard',
    'plugin:react/recommended', // Uses the recommended rules from @eslint-plugin-react
    'plugin:import/errors',
    'plugin:import/warnings',
    'plugin:import/typescript',
    'plugin:promise/recommended',
    'plugin:react-hooks/recommended',
    'plugin:prettier/recommended', // Enables eslint-plugin-prettier and displays prettier errors as ESLint errors. Make sure this is always the last configuration in the extends array.
    'prettier',
  ],
  plugins: ['prettier'],
  settings: {
    react: {
      version: 'detect', // Tells eslint-plugin-react to automatically detect the version of React to use
    },
    'import/resolver': {
      'babel-module': {},
    },
  },
  env: {
    browser: true,
    jest: true,
  },
  overrides: [
    {
      files: ['*.ts', '*.tsx'],
      parser: '@typescript-eslint/parser',
      extends: [
        'standard',
        'plugin:react/recommended', // Uses the recommended rules from @eslint-plugin-react
        'plugin:@typescript-eslint/recommended',
        'plugin:import/errors',
        'plugin:import/warnings',
        'plugin:import/typescript',
        'plugin:promise/recommended',
        'plugin:react-hooks/recommended',
        'plugin:prettier/recommended', // Enables eslint-plugin-prettier and displays prettier errors as ESLint errors. Make sure this is always the last configuration in the extends array.
        'plugin:jsx-a11y/recommended',
        'prettier',
        'prettier/@typescript-eslint',
      ],
      plugins: ['prettier', 'react-hooks', 'jsx-a11y'],
      parserOptions: {
        ecmaversion: 2018,
        project: './tsconfig.json',
        sourceType: 'module',
        ecmaFeatures: {
          jsx: true,
        },
      },
      settings: {
        react: {
          version: 'detect',
        },
        'import/resolver': {
          'babel-module': {},
        },
      },
      rules: {
        'react/react-in-jsx-scope': 0,
        'ordered-imports': 0,
        quotemark: 0,
        'no-console': 0,
        semicolon: 0,
        'jsx-no-lambda': 0,
        camelcase: 0,
        '@typescript-eslint/interface-name-prefix': 0,
        '@typescript-eslint/naming-convention': [
          'error',
          {
            selector: 'default',
            format: ['camelCase', 'PascalCase'],
            leadingUnderscore: 'forbid',
          },
          {
            selector: 'class',
            format: ['PascalCase'],
          },
          {
            selector: 'property',
            modifiers: ['readonly'],
            format: ['camelCase', 'UPPER_CASE'],
          },
          {
            selector: 'memberLike',
            modifiers: ['protected'],
            format: ['camelCase'],
            leadingUnderscore: 'require',
          },
          {
            selector: 'memberLike',
            modifiers: ['private'],
            format: ['camelCase'],
            leadingUnderscore: 'require',
          },
          {
            selector: 'variable',
            format: ['PascalCase', 'camelCase', 'UPPER_CASE'],
          },
          {
            selector: 'interface',
            format: ['PascalCase'],
            prefix: ['I'],
          },
        ],
      },
    },
    {
      files: ['**/*.tsx'],
      rules: {
        'react/prop-types': 'off',
      },
    },
  ],
}
