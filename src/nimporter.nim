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
#
# :See: https://hookrace.net/blog/introduction-to-metaprogramming-in-nim/
###


import macros
import strutils
import sequtils
import os


macro import_files_impl(
    file_glob: static[string],
    importing_file_path: static[string]
): untyped =
    ## Helper um Dateien relativ zu den Aufrufer Verzeichnis referenzieren zu können.
    ## Der Zwischenweg über ein template ist wichtig, da für den import das Verzeichnis des Aufrufers
    ## wichtig ist, dieser aber nur bei templates richtig zu funktionieren scheint.
    let importing_file_directory = importing_file_path.parentDir()
    echo "[IMPORT FILES] import files using '", file_glob, "' in '", importing_file_directory, "'"
    let scannedFilePaths: seq[string] = (
        staticExec( "cd '" & importing_file_directory & "'; find . -type f -wholename '" & file_glob & "'")
        .split("\n")
        .filter( proc(x: string): bool = x.len > 0 )
    )
    result = newStmtList()
    for scannedFilePath in scannedFilePaths:
        #echo "[IMPORT FILES] import '", scannedFilePath, "'"
        let importFilePath: string = importing_file_directory.joinPath(scannedFilePath)
        echo "[IMPORT FILES] import '", importFilePath, "'"
        result.add(
            quote do:
                import `importFilePath`
        )
    echo "[IMPORT FILES] ", scannedFilePaths.len, " files imported"
    return result


template import_files*(
    file_glob: static[string],
    max_depth: static[Natural] = 0
): untyped =
    ## Import the files addressed by the given file glob which is relative to the nim file
    ## that uses import_files.
    ## example:
    ##   import_files "./test/*_test.nim"
    ##   -> expands to
    ##   import ./test/sample00_test.nim
    ##   import ./test/sample01_test.nim
    ##   import ./test/dir/sample02_test.nim
    # see: https://nim-lang.org/docs/tut3.html
    # see: https://nim-lang.org/docs/macros.html
    # see: https://nim-lang.org/blog/2018/06/07/create-a-simple-macro.html
    import_files_impl( file_glob, instantiationInfo(0, true).filename )





proc import_data_file_impl(
    fileName: string,
    importingFilePath: string = "."
): string {.compileTime.} =
    ## Helper um Dateien relativ zu den Aufrufer Verzeichnis referenzieren zu können.
    ## Der Zwischenweg über ein template ist wichtig, da für den import das Verzeichnis des Aufrufers
    ## wichtig ist, dieser aber nur bei templates richtig zu funktionieren scheint.
    let importingFileDirectory = importingFilePath.parentDir()
    let importFileName = os.joinPath(importingFileDirectory, fileName)
    return importFileName.readFile()


template import_data_file*( filePath: string ): untyped =
    ## Import the content of the given fileName wich is relative to the nim_file
    ## that uses import_data_file.
    ## example:
    ##   const SAMPLE_LOGO_JPG     = import_data_file "./test/sample.jpg"
    ##   const DEFAULT_CONFIG_JSON = import_data_file "./test/config.json"
    import_data_file_impl( filePath, instantiationInfo(0, true).filename )
