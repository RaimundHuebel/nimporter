###
# Nimporter is a library to extend Nim Lang with extended import capabilities.
#
# Example usage:
# --------------
#
#     import nimporter
#
#     import_files "test/*_test.nim"
#     import_files "test/*_test2.nim"
#
# :Author:   Raimund Hübel <raimund.huebel@googlemail.com>
###

import macros
import strutils
import sequtils


macro import_files*(file_glob: static[string]): untyped =
    ## Import the files addressed by the given file glob which is relative to the nim file
    ## that used this macro.
    ## example:
    ##   import_files "test/*_test.nim"
    ##   -> expands to
    ##   import ./test/sample00_test.nim
    ##   import ./test/sample01_test.nim
    ##   import ./test/dir/sample02_test.nim
    # see: https://nim-lang.org/docs/tut3.html
    # see: https://nim-lang.org/docs/macros.html
    # see: https://nim-lang.org/blog/2018/06/07/create-a-simple-macro.html
    result = newStmtList()
    let testFiles: seq[string] = (
        staticExec( "find . -name '" & file_glob & "'")
        .split("\n")
        # Remove empty entries
        .filter( proc(x: string): bool = x.len > 0 )
    )
    echo "[IMPORT FILES] import files using '", file_glob, "'"
    for testFile in testFiles:
        echo "[IMPORT FILES] import '", testFile, "'"
        result.add(
            quote do:
                import `testFile`
        )
    echo "[IMPORT FILES] ", testFiles.len, " files imported"
    return result
