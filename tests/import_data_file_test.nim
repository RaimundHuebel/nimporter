###
# Test for Nimporters import_files - Macro.
#
# Run Tests:
#   $ nim compile --run tests/import_data_file_test.nim
#
# :Author: Raimund Hübel <raimund.huebel@googlemail.com>
###

import unittest
import strutils
import nimporter


const DATA_FILE_00: string = import_data_file "fixtures/data_file_00.txt"
const DATA_FILE_01: string = import_data_file "fixtures/data_file_01.md"
const DATA_FILE_02: string = import_data_file "fixtures/data_file_02.adoc"
const DATA_FILE_03: string = import_data_file "fixtures/data_file_03.json"


suite "nimporter.import_data_file":

    test "fixtures/data_file_00.txt got imported":
        check compiles(DATA_FILE_00) == true
        check DATA_FILE_00.strip() == "Sample import data file 00"


    test "fixtures/data_file_01.md got imported":
        check compiles(DATA_FILE_01) == true
        check DATA_FILE_01.strip() == "Sample import data file 01"


    test "fixtures/data_file_02.adoc got imported":
        check compiles(DATA_FILE_02) == true
        check DATA_FILE_02.strip() == "Sample import data file 02"


    test "fixtures/data_file_03.json got imported":
        check compiles(DATA_FILE_03) == true
        check DATA_FILE_03.strip() == "{ \"msg\": \"Sample import data file 03\" }"
