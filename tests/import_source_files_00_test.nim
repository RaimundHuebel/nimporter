###
# Test for Nimporters import_source_files - Macro.
#
# Run Tests:
#   $ nim compile --run tests/import_source_files_00_test.nim
#
# :Author: Raimund Hübel <raimund.huebel@googlemail.com>
###

import unittest
import strutils
import nimporter

import_source_files "./fixtures/source_file_00_*.nim"

suite "nimporter.import_source_files 00":

    test "fixtures/source_file_00_a.nim got imported":
        check compiles(IMPORT_SOURCE_FILE_00_A) == true
        check IMPORT_SOURCE_FILE_00_A.strip() == "Test that SOURCE_FILE_00_A got imported"

    test "fixtures/source_file_00_b.nim got imported":
        check compiles(IMPORT_SOURCE_FILE_00_B) == true
        check IMPORT_SOURCE_FILE_00_B.strip() == "Test that SOURCE_FILE_00_B got imported"

    test "fixtures/source_file_00_c.nim got imported":
        check compiles(IMPORT_SOURCE_FILE_00_C) == true
        check IMPORT_SOURCE_FILE_00_C.strip() == "Test that SOURCE_FILE_00_C got imported"

    test "fixtures/source_file_01_*.nim did not got imported":
        check compiles(IMPORT_SOURCE_FILE_01  ) == false
        check compiles(IMPORT_SOURCE_FILE_01_A) == false
        check compiles(IMPORT_SOURCE_FILE_01_B) == false
        check compiles(IMPORT_SOURCE_FILE_01_C) == false
