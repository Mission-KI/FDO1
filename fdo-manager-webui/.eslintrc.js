module.exports = {
    "settings": {
      "react": {
        "version": "18",
      }
    },
    "env": {
        "browser": true,
        "es2021": true,
        "node": true
    },
    "extends": [
        "plugin:react/recommended",
        "standard-with-typescript",
        "plugin:@next/next/recommended"
    ],
    "overrides": [
    ],
    "parserOptions": {
        "ecmaVersion": "latest",
        "sourceType": "module"
    },
    "plugins": [
        "react"
    ],
    "rules": {
      "react/react-in-jsx-scope": "off",
      "react/prop-types": "off",
      "@typescript-eslint/no-unused-vars": "off",
      "@typescript-eslint/strict-boolean-expressions": "off",
      "@typescript-eslint/explicit-function-return-type": "off",
      "@typescript-eslint/consistent-type-imports": "off",
      "@typescript-eslint/prefer-nullish-coalescing": "off",
      "@typescript-eslint/ban-types": "off",
      "@typescript-eslint/return-await": "off",
      "@typescript-eslint/no-unsafe-argument": "off",
      "@typescript-eslint/consistent-type-assertions": "off",
      "@typescript-eslint/consistent-type-definitions": "off",
      "@typescript-eslint/no-empty-interface": "off",
      "@typescript-eslint/ban-ts-comment": "off",
      "@typescript-eslint/no-misused-promises": "off",
      "@typescript-eslint/no-floating-promises": "off",
      "@next/next/no-img-element": "off",

    }
}
