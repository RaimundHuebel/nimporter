###
# Test for Nimporters import_files - Macro.
#
# Run Tests:
#   $ nim compile --run tests/import_files_01_test.nim
#
# :Author: Raimund Hübel <raimund.huebel@googlemail.com>
###

import unittest
import nimporter

import_files "./fixtures/import_files_01_*.nim"

suite "nimporter.import_files 01":

    test "fixtures/import_files_01_a.nim got imported":
        check compiles(IMPORT_FILES_01_A) == true

    test "fixtures/import_files_01_b.nim got imported":
        check compiles(IMPORT_FILES_01_B) == true

    test "fixtures/import_files_01_c.nim got imported":
        check compiles(IMPORT_FILES_01_C) == true

    test "fixtures/import_files_00_*.nim did not got imported":
        check compiles(IMPORT_FILES_00  ) == false
        check compiles(IMPORT_FILES_00_A) == false
        check compiles(IMPORT_FILES_00_B) == false
        check compiles(IMPORT_FILES_00_C) == false
