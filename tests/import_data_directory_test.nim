###
# Test for Nimporters import_source_files - Macro.
#
# Run Tests:
#   $ nim compile --run tests/import_data_file_test.nim
#
# :Author: Raimund Hübel <raimund.huebel@googlemail.com>
###

import unittest
import strutils
import nimporter


const FIXTURE_FS: ImportFs = import_data_directory "fixtures/"


suite "nimporter.import_data_directory":

    test "fixtures directory got imported":
        check compiles(FIXTURE_FS) == true



    test "imported directory fs should have correct file count (20 files)":
        check FIXTURE_FS.countFiles() == 20



    test "#countFiles()":
        check FIXTURE_FS.countFiles() >= 0



    test "#isExistingFile() with existing files":
        check true == FIXTURE_FS.isExistingFile("/data_file_00.txt")
        check true == FIXTURE_FS.isExistingFile("/data_file_01.md")
        check true == FIXTURE_FS.isExistingFile("/data_file_02.adoc")
        check true == FIXTURE_FS.isExistingFile("/data_file_03.json")

        check true == FIXTURE_FS.isExistingFile("/source_file_00_a.nim")
        check true == FIXTURE_FS.isExistingFile("/source_file_00_b.nim")
        check true == FIXTURE_FS.isExistingFile("/source_file_00_c.nim")
        check true == FIXTURE_FS.isExistingFile("/source_file_01_a.nim")
        check true == FIXTURE_FS.isExistingFile("/source_file_01_b.nim")
        check true == FIXTURE_FS.isExistingFile("/source_file_01_c.nim")

        check true == FIXTURE_FS.isExistingFile("/dir_00/lorem_ipsum.txt")
        check true == FIXTURE_FS.isExistingFile("/dir_00/nim_lang.md")
        check true == FIXTURE_FS.isExistingFile("/dir_00/test00.txt")
        check true == FIXTURE_FS.isExistingFile("/dir_00/test01.txt")
        check true == FIXTURE_FS.isExistingFile("/dir_00/test02.txt")

        check true == FIXTURE_FS.isExistingFile("/dir_01/nim-logo.png")
        check true == FIXTURE_FS.isExistingFile("/dir_01/nimble_js.svg")
        check true == FIXTURE_FS.isExistingFile("/dir_01/test00.txt")
        check true == FIXTURE_FS.isExistingFile("/dir_01/test01.txt")
        check true == FIXTURE_FS.isExistingFile("/dir_01/test02.txt")

    test "#isExistingFile() with non existing files":
        check false == FIXTURE_FS.isExistingFile("/")
        check false == FIXTURE_FS.isExistingFile("/NOT_EXISTING")
        check false == FIXTURE_FS.isExistingFile("/dir_99/test00.txt")
        check false == FIXTURE_FS.isExistingFile("/nodir_00/NOT_EXISTING")

    test "#isExistingFile() with non valid file paths":
        check false == FIXTURE_FS.isExistingFile("")
        check false == FIXTURE_FS.isExistingFile("NOT_VALID")
        check false == FIXTURE_FS.isExistingFile("NOT_VALID/")



    test "#isExistingDir() with existing dirs":
        check true == FIXTURE_FS.isExistingDir("/")
        check true == FIXTURE_FS.isExistingDir("/dir_00")
        check true == FIXTURE_FS.isExistingDir("/dir_00/")
        check true == FIXTURE_FS.isExistingDir("/dir_01")
        check true == FIXTURE_FS.isExistingDir("/dir_01/")

    test "#isExistingDir() with non existing dirs":
        check false == FIXTURE_FS.isExistingDir("/NOT_EXISTING")
        check false == FIXTURE_FS.isExistingDir("/NOT_EXISTING/")
        check false == FIXTURE_FS.isExistingDir("/dir_99")
        check false == FIXTURE_FS.isExistingDir("/dir_99/")
        check false == FIXTURE_FS.isExistingDir("/nodir_00/NOT_EXISTING")
        check false == FIXTURE_FS.isExistingDir("/nodir_00/NOT_EXISTING/")

    test "#isExistingDir() with invalid file paths":
        check false == FIXTURE_FS.isExistingDir("")
        check false == FIXTURE_FS.isExistingDir("NOT_VALID")
        check false == FIXTURE_FS.isExistingDir("NOT_VALID/")



    test "#isExisting() with existing dirs":
        check true == FIXTURE_FS.isExisting("/")
        check true == FIXTURE_FS.isExisting("/dir_00")
        check true == FIXTURE_FS.isExisting("/dir_00/")
        check true == FIXTURE_FS.isExisting("/dir_01")
        check true == FIXTURE_FS.isExisting("/dir_01/")

    test "#isExisting() with existing files":
        check true == FIXTURE_FS.isExistingFile("/data_file_00.txt")
        check true == FIXTURE_FS.isExistingFile("/source_file_00_a.nim")
        check true == FIXTURE_FS.isExistingFile("/dir_00/lorem_ipsum.txt")
        check true == FIXTURE_FS.isExistingFile("/dir_01/test00.txt")

    test "#isExisting() with incorrect references":
        check false == FIXTURE_FS.isExisting("//")
        check false == FIXTURE_FS.isExisting("/dir_00//")
        check false == FIXTURE_FS.isExisting("/dir_01//")

        check false == FIXTURE_FS.isExistingFile("/data_file_00.txt/")
        check false == FIXTURE_FS.isExistingFile("/source_file_00_a.nim/")
        check false == FIXTURE_FS.isExistingFile("/dir_00/lorem_ipsum.txt/")
        check false == FIXTURE_FS.isExistingFile("/dir_01/test00.txt/")

    test "#isExisting() with non existing files":
        check false == FIXTURE_FS.isExistingDir("/NOT_EXISTING")
        check false == FIXTURE_FS.isExistingDir("/NOT_EXISTING/")
        check false == FIXTURE_FS.isExistingDir("/dir_99")
        check false == FIXTURE_FS.isExistingDir("/dir_99/")
        check false == FIXTURE_FS.isExistingDir("/nodir_00/NOT_EXISTING")
        check false == FIXTURE_FS.isExistingDir("/nodir_00/NOT_EXISTING/")

    test "#isExisting() with invalid paths":
        check false == FIXTURE_FS.isExistingDir("")
        check false == FIXTURE_FS.isExistingDir("NOT_VALID")
        check false == FIXTURE_FS.isExistingDir("NOT_VALID/")



    test "#listAllFiles()":
        check FIXTURE_FS.listAllFiles() == @[
            "/data_file_00.txt",
            "/data_file_01.md",
            "/data_file_02.adoc",
            "/data_file_03.json",
            "/dir_00/lorem_ipsum.txt",
            "/dir_00/nim_lang.md",
            "/dir_00/test00.txt",
            "/dir_00/test01.txt",
            "/dir_00/test02.txt",
            "/dir_01/nim-logo.png",
            "/dir_01/nimble_js.svg",
            "/dir_01/test00.txt",
            "/dir_01/test01.txt",
            "/dir_01/test02.txt",
            "/source_file_00_a.nim",
            "/source_file_00_b.nim",
            "/source_file_00_c.nim",
            "/source_file_01_a.nim",
            "/source_file_01_b.nim",
            "/source_file_01_c.nim",
        ]


    test "#readFile(): with existing file 00":
        check FIXTURE_FS.readFile("/data_file_00.txt").strip() == "Sample import data file 00"

    test "#readFile(): with existing file 01":
        check FIXTURE_FS.readFile("/data_file_01.md").strip() == "Sample import data file 01"

    test "#readFile(): with existing file 02":
        check FIXTURE_FS.readFile("/data_file_02.adoc").strip() == "Sample import data file 02"

    test "#readFile(): with existing file 03":
        check FIXTURE_FS.readFile("/dir_00/test00.txt").strip() == "Samplefile: fixtures/dir_00/test00.txt"

    test "#readFile(): with existing file 04":
        check FIXTURE_FS.readFile("/dir_00/test01.txt").strip() == "Samplefile: fixtures/dir_00/test01.txt"

    test "#readFile(): with existing file 05":
        check FIXTURE_FS.readFile("/dir_01/test00.txt").strip() == "Samplefile: fixtures/dir_01/test00.txt"

    test "#readFile(): with existing file 06":
        check FIXTURE_FS.readFile("/dir_01/test02.txt").strip() == "Samplefile: fixtures/dir_01/test02.txt"

    test "#readFile(): with non existing filepath should raise IOError":
        expect IOError:
            discard FIXTURE_FS.readFile("/NOT_EXISTING")

    test "#readFile(): with invalid filepath should raise IOError":
        expect IOError:
            discard FIXTURE_FS.readFile("NOT VALID")



    test "#fileSize(): with existing file 00":
        check FIXTURE_FS.fileSize("/data_file_00.txt") == 27

    test "#fileSize(): with existing file 01":
        check FIXTURE_FS.fileSize("/dir_00/test00.txt") == 39

    test "#fileSize(): with existing file 02":
        check FIXTURE_FS.fileSize("/dir_01/nim-logo.png") == 10396

    test "#fileSize(): with directory should raise IOError":
        expect IOError:
            discard FIXTURE_FS.fileSize("/dir_00")

    test "#fileSize(): with non existing filepath should raise IOError":
        expect IOError:
            discard FIXTURE_FS.fileSize("/NOT_EXISTING")

    test "#fileSize(): with invalid filepath should raise IOError":
        expect IOError:
            discard FIXTURE_FS.fileSize("NOT VALID")



    test "#dirSize(): with existing dir 00":
        check FIXTURE_FS.dirSize("/") == 14894

    test "#dirSize(): with existing dir 01":
        check FIXTURE_FS.dirSize("/dir_00") == 1384

    test "#dirSize(): with existing dir 02":
        check FIXTURE_FS.dirSize("/dir_01") == 12891

    test "#dirSize(): with file should return raise IOError 00":
        expect IOError:
            discard FIXTURE_FS.dirSize("/data_file_00.txt")

    test "#dirSize(): with file should return raise IOError 01":
        expect IOError:
            discard FIXTURE_FS.dirSize("/dir_00/test00.txt")

    test "#dirSize(): with non existing file/dir-path should raise IOError 00":
        expect IOError:
            discard FIXTURE_FS.dirSize("/NOT_EXISTING")

    test "#dirSize(): with non existing file/dir-path should raise IOError 01":
        expect IOError:
            discard FIXTURE_FS.dirSize("/dir_00/NOT_EXISTING")

    test "#dirSize(): with invalid filepath should raise IOError 00":
        expect IOError:
            discard FIXTURE_FS.dirSize("")

    test "#dirSize(): with invalid filepath should raise IOError 00":
        expect IOError:
            discard FIXTURE_FS.dirSize("NOT VALID")



    test "#fsItemSize(): with existing dir 00":
        check FIXTURE_FS.fsItemSize("/") == 14894

    test "#fsItemSize(): with existing dir 01":
        check FIXTURE_FS.fsItemSize("/dir_00") == 1384

    test "#fsItemSize(): with existing dir 02":
        check FIXTURE_FS.fsItemSize("/dir_01") == 12891

    test "#fsItemSize(): with file should return file size in bytes 00":
        check FIXTURE_FS.fsItemSize("/data_file_00.txt") == 27

    test "#fsItemSize(): with file should return file size in bytes 01":
        check FIXTURE_FS.fsItemSize("/dir_00/test00.txt") == 39

    test "#fsItemSize(): with non existing file/dir-path should raise IOError 00":
        expect IOError:
            discard FIXTURE_FS.fsItemSize("/NOT_EXISTING")

    test "#fsItemSize(): with non existing file/dir-path should raise IOError 01":
        expect IOError:
            discard FIXTURE_FS.fsItemSize("/dir_00/NOT_EXISTING")

    test "#fsItemSize(): with invalid filepath should raise IOError 00":
        expect IOError:
            discard FIXTURE_FS.fsItemSize("")

    test "#fsItemSize(): with invalid filepath should raise IOError 00":
        expect IOError:
            discard FIXTURE_FS.fsItemSize("NOT VALID")



    test "#listDir(): with valid filepath 00":
        check FIXTURE_FS.listDir("/") == @[
            "/data_file_00.txt",
            "/data_file_01.md",
            "/data_file_02.adoc",
            "/data_file_03.json",
            "/source_file_00_a.nim",
            "/source_file_00_b.nim",
            "/source_file_00_c.nim",
            "/source_file_01_a.nim",
            "/source_file_01_b.nim",
            "/source_file_01_c.nim",
        ]

    test "#listDir(): with valid filepath 01":
        check FIXTURE_FS.listDir("/dir_00") == @[
            "/dir_00/lorem_ipsum.txt",
            "/dir_00/nim_lang.md",
            "/dir_00/test00.txt",
            "/dir_00/test01.txt",
            "/dir_00/test02.txt",
        ]

    test "#listDir(): with valid filepath 02":
        check FIXTURE_FS.listDir("/dir_01/") == @[
            "/dir_01/nim-logo.png",
            "/dir_01/nimble_js.svg",
            "/dir_01/test00.txt",
            "/dir_01/test01.txt",
            "/dir_01/test02.txt",
        ]

    test "#listDir(): with non existent filepath 00":
        check FIXTURE_FS.listDir("/NOT_EXISTING") == newSeq[string]()

    test "#listDir(): with non existent filepath 01":
        check FIXTURE_FS.listDir("/NOT_EXISTING/") == newSeq[string]()

    test "#listDir(): should raise IOError on invalid Filepath 00":
        expect IOError:
            discard FIXTURE_FS.listDir("")

    test "#listDir(): should raise IOError on invalid Filepath 01":
        expect IOError:
            discard FIXTURE_FS.listDir("NOT VALID")
