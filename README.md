# Nimporter

[![nimble](https://raw.githubusercontent.com/yglukhov/nimble-tag/master/nimble_js.png)](https://github.com/yglukhov/nimble-tag)


## Introduction

Library to extend the nim programming language of further ways to import source-files.
It also enables you to import single data files or whole directory structures, enabling the
user to add static content to the nim-output at build time.

## Example usages

- Import further test files by using a file glob instead of importing directly
  which may become cumbersome.
- Embed some file content into the binary, like a basic config file.
- Embed a whole directory structure like a www-public directory into the binary,
  to provide a single file deployment.


## Get Started

### Install Nimporter

   ```bash
   $ nimble install nimporter
   ```

### Use Nimporter

#### Sample: Import Source-Files by Glob

   ```nim
   import nimporter

   import_source_files "./test/*_test.nim"
   ```

#### Sample: Import a single Data-File

   ```nim
   import nimporter

   const SAMPLE_CONFIG_JSON_STR: string = import_data_file "./test/sample_config.json"

   let configJson = SAMPLE_CONFIG_JSON_STR.parseJson()
   ```

#### Sample: Import a Data-Directory with multiple files ...

   ```nim
   import nimporter

   const SAMPLE_FIXTURE_FS: ImportFs = import_data_directory "test/fixtures/"

   let logoData: string  = SAMPLE_FIXTURE_FS.readFile("/logo.png")

   let configJson: JsonNode = SAMPLE_FIXTURE_FS.readFile("/dir_00/sample_config.json").parseJson()
   ```


## Develop

### Running Tests (on local machine)

   ```bash
   $ nimble test
   ```

### Running Tests (using dev-environment provided through docker)

   ```bash
   # Using nimble
   $ ./nimporter-dev.sh nimble test

   # Using make (direkt test)
   $ ./nimporter-dev.sh make test

   # Using make (build & run tests)
   $ ./nimporter-dev.sh make build
   $ dist/debug/nimporter_tests
   $ dist/release/nimporter_tests

   # Using nim (debug build)
   $ ./nimporter-dev.sh nim compile --out:dist/debug/nimporter_tests --run tests/test_all.nim

   # Using nim (release build)
   $ ./nimporter-dev.sh nim compile --out:dist/release/nimporter_tests -d:release --opt:speed --run tests/test_all.nim
   ```

## Links

- [Repository of Nimporter](https://github.com/RaimundHuebel/nimporter)
