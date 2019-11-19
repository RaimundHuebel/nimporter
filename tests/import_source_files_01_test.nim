###
# Test for Nimporters import_source_files - Macro.
#
# Run Tests:
#   $ nim compile --run tests/import_source_files_01_test.nim
#
# :Author: Raimund Hübel <raimund.huebel@googlemail.com>
###

import unittest
import strutils
import nimporter

import_source_files "./fixtures/source_file_01_*.nim"

suite "nimporter.import_source_files 01":

    test "fixtures/source_file_01_a.nim got imported":
        check compiles(IMPORT_SOURCE_FILE_01_A) == true
        check IMPORT_SOURCE_FILE_01_A.strip() == "Test that SOURCE_FILE_01_A got imported"

    test "fixtures/source_file_01_b.nim got imported":
        check compiles(IMPORT_SOURCE_FILE_01_B) == true
        check IMPORT_SOURCE_FILE_01_B.strip() == "Test that SOURCE_FILE_01_B got imported"

    test "fixtures/source_file_01_c.nim got imported":
        check compiles(IMPORT_SOURCE_FILE_01_C) == true
        check IMPORT_SOURCE_FILE_01_C.strip() == "Test that SOURCE_FILE_01_C got imported"

    test "fixtures/source_file_00_*.nim did not got imported":
        check compiles(IMPORT_SOURCE_FILE_00  ) == false
        check compiles(IMPORT_SOURCE_FILE_00_A) == false
        check compiles(IMPORT_SOURCE_FILE_00_B) == false
        check compiles(IMPORT_SOURCE_FILE_00_C) == false
