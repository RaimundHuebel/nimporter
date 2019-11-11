# Nimporter

[![nimble](https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble_js.png)](https://github.com/yglukhov/nimble-tag)


## Introduction

This library extends the nim programming language of further ways to import other nim-files.
It also enables you to import single data files or whole directory structures, enabling the
user to add static content to the nim-output at build time.

## Example usages

- Import further test files by using a file glob instead of importing directly
  which may become cumbersome.
- Embed some file content into the binary, like a basic config file.
- Embed a whole directory structure like a www-public directory into the binary,
  to provide a single file deployment.



## Get Started

Install Nimporter

   ```bash
   nimble install nimporter
   ```

Use Nimporter

   ```nim
   import nimporter

   import_files "./test/*_test.nim"

   const SAMPLE_CONFIG_JSON_STR = import_data_file( "./test/sample_config.json" )
   ```


## Develop

### Running Tests

   ```bash
   nimble test
   ```



## Links

- [Repository of Nimporter](https://github.com/RaimundHuebel/nimporter)
