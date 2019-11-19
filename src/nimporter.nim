###
# Nimporter is a library to extend Nim Lang with extended import capabilities.
#
# Example usage:
# --------------
#
#     import nimporter
#
#     import_source_files "test/*_test.nim"
#     import_source_files "test/*_test2.nim"
#
# :Author:   Raimund Hübel <raimund.huebel@googlemail.com>
#
# :See: https://hookrace.net/blog/introduction-to-metaprogramming-in-nim/
###


import macros
import strutils
import sequtils
import tables
import algorithm
import os


#---------------------------------------------------------------------------------------------------
# Nim-Src-File-Import using with recursive directory travel ...
#---------------------------------------------------------------------------------------------------


macro import_source_files_impl(
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


template import_source_files*(
    file_glob: static[string],
    max_depth: static[Natural] = 0
): untyped =
    ## Import the files addressed by the given file glob which is relative to the nim file
    ## that uses import_source_files.
    ## example:
    ##   import_source_files "./test/*_test.nim"
    ##   -> expands to
    ##   import ./test/sample00_test.nim
    ##   import ./test/sample01_test.nim
    ##   import ./test/dir/sample02_test.nim
    # see: https://nim-lang.org/docs/tut3.html
    # see: https://nim-lang.org/docs/macros.html
    # see: https://nim-lang.org/blog/2018/06/07/create-a-simple-macro.html
    import_source_files_impl( file_glob, instantiationInfo(0, true).filename )



#---------------------------------------------------------------------------------------------------
# File-Import ...
#---------------------------------------------------------------------------------------------------



proc import_data_file_impl(
    filePath: string,
    importingFilePath: string
): string {.compileTime.} =
    ## Helper um Dateien relativ zu den Aufrufer Verzeichnis referenzieren zu können.
    ## Der Zwischenweg über ein template ist wichtig, da für den import das Verzeichnis des Aufrufers
    ## wichtig ist, dieser aber nur bei templates richtig zu funktionieren scheint.
    let importingFileDirectory = importingFilePath.parentDir()
    let importFileName = os.joinPath(importingFileDirectory, filePath)
    echo "[IMPORT DATA FILE] import '", importFileName, "'"
    return importFileName.readFile()


template import_data_file*( filePath: string ): string =
    ## Import the content of the given fileName wich is relative to the nim_file
    ## that uses import_data_file.
    ## example:
    ##   const SAMPLE_LOGO_JPG    : string = import_data_file "./test/sample.jpg"
    ##   const DEFAULT_CONFIG_JSON: string = import_data_file "./test/config.json"
    import_data_file_impl( filePath, instantiationInfo(0, true).filename )



#---------------------------------------------------------------------------------------------------
# Directory-Import ...
#---------------------------------------------------------------------------------------------------


type ImportFs* = object
    ## Type which gets returned by
    fileEntries: Table[string, string]

proc normalizeDirPath(dirPath: string): string {.raises: [IOError].}

proc newImportFs*(): ImportFs {.compileTime, noSideEffect.}  =
    ## Returns a new empty ImportFs.
    result = ImportFs()


proc addFile*(self: var ImportFs, filePath: string, fileContent: string) {.compileTime.} =
    ## Adds the given file (incl. content) to the ImportFs.
    self.fileEntries[filePath] = fileContent


proc removeFile*(self: var ImportFs, filePath: string, fileContent: string) {.compileTime.} =
    ## Removes the given file from the ImportFs.
    self.fileEntries.del(filePath)


proc countFiles*(self: ImportFs): int {.noSideEffect.} =
    ## Returns the number of files which are included in the ImportFs.
    return self.fileEntries.len


proc isExistingFile*(self: ImportFs, filePath: string): bool {.noSideEffect.} =
    ## Returns true if the given filePath is included into the current ImportFs.
    return self.fileEntries.hasKey(filePath)


proc isExistingDir*(self: ImportFs, dirPath: string): bool {.raises: [IOError].} =
    ## Returns true if the given dirPath is included into the current ImportFs.
    let normalizedDirPath = normalizeDirPath(dirPath)
    if normalizedDirPath != "":
        for fileEntryName in self.fileEntries.keys:
            if fileEntryName.startsWith( normalizedDirPath ):
                return true
    return false


proc isExisting*(self: ImportFs, fileOrDirPath: string): bool =
    ## Returns true if the given file or dir Path is included into the current ImportFs.
    return self.isExistingFile(fileOrDirPath) or self.isExistingDir(fileOrDirPath)


proc readFile*(self: ImportFs, filePath: string): string {.raises: [IOError].} =
    ## Returns the content of the file. Raises an IOError if the given filepath does not exist.
    if not self.fileEntries.hasKey(filePath):
        raise newException(IOError, "ImportFs - cannot read: " & filePath)
    return self.fileEntries.getOrDefault(filePath, "")


proc fileSize*(self: ImportFs, filePath: string): int {.raises: [IOError], noSideEffect.} =
    ## Returns the size of the file in bytes.
    if not self.fileEntries.hasKey(filePath):
        raise newException(IOError, "ImportFs - cannot read: " & filePath)
    return self.fileEntries.getOrDefault(filePath, "").len


proc dirSize*(self: ImportFs, dirPath: string): int {.raises: [IOError].} =
    ## Returns the size of the directory in bytes, accumulating the sizes of all files in the directory.
    let normalizedDirPath = normalizeDirPath(dirPath)
    if normalizedDirPath == "":
        raise newException(IOError, "ImportFs - cannot list: " & dirPath & " (invalid dirPath)")
    result = 0
    var foundFiles = 0
    for fileEntryName, fileEntryContent in self.fileEntries.pairs:
        if not fileEntryName.startsWith( normalizedDirPath ):
            continue
        result += fileEntryContent.len
        foundFiles.inc
    if foundFiles <= 0:
        raise newException(IOError, "ImportFs - no directory: " & dirPath & " (or no content)")
    return result


proc fsItemSize*(self: ImportFs, fileOrDirPath: string): int {.raises: [IOError].} =
    ## Returns the size of the file or the directory in bytes.
    # Case: file is addressed ...
    if self.fileEntries.hasKey(fileOrDirPath):
        return self.fileEntries.getOrDefault(fileOrDirPath, "").len
    # Case: directory is addressed ...
    let normalizedDirPath = normalizeDirPath(fileOrDirPath)
    if normalizedDirPath != "":
        result = 0
        var foundFiles = 0
        for fileEntryName, fileEntryContent in self.fileEntries.pairs:
            if not fileEntryName.startsWith( normalizedDirPath ):
                continue
            result += fileEntryContent.len
            foundFiles.inc
        if foundFiles > 0:
            return result
    # Case: Nothing suitable found ...
    raise newException(IOError, "ImportFs - no file/directory: " & fileOrDirPath)


proc listAllFiles*(self: ImportFs): seq[string] {.noSideEffect.} =
    ## Returns all Filepaths which are included into the current ImportFs.
    result = toSeq(self.fileEntries.keys)
    result.sort()
    return result


proc listDir*(self: ImportFs, dirPath: string): seq[string] {.raises: [IOError].} =
    ## Lists the direct content of the given directory.
    ## Raises an IOError if the directory does not exist.
    let normalizedDirPath = normalizeDirPath(dirPath)
    if normalizedDirPath == "":
        raise newException(IOError, "ImportFs - cannot list: " & dirPath & " (invalid dirPath)")
    let separatorCount: int = normalizedDirPath.count('/')
    result = @[]
    for fileEntryName in self.fileEntries.keys:
        if not fileEntryName.startsWith( normalizedDirPath ):
            continue
        if fileEntryName.count('/') != separatorCount:
            continue
        result.add( fileEntryName )
    result.sort()
    return result


#INTERNAL
proc normalizeDirPath(dirPath: string): string =
    ## Returns the directoryPath in normalized form (ending with: /)
    if not dirPath.startsWith("/"):
        return ""
    var normalizedDirPath = dirPath
    if not normalizedDirPath.endsWith("/"):
        normalizedDirPath.add("/")
    return normalizedDirPath



proc import_data_directory_impl(
    dirPath: string,
    importingFilePath: string
): ImportFs {.compileTime.} =
    let importDirectory: string = joinPath(importingFilePath.parentDir(), dirPath)
    echo "[IMPORT DATA DIRECTORY] import directory '", importDirectory, "'"
    var importFs = newImportFs()
    for importFileName in walkDirRec(
        importDirectory,
        yieldFilter  = {pcFile, pcLinkToFile},
        followFilter = {pcDir, pcLinkToDir},
        relative     = true
    ):
        echo "[IMPORT DATA DIRECTORY] - import ", importFileName
        let importContent: string =  joinPath(importDirectory, importFileName).readFile()
        importFs.addFile("/" & importFileName, importContent)
    echo "[IMPORT DATA DIRECTORY] import directory finished (", importFs.countFiles, " files imported)"
    return importFs

template import_data_directory*( dirPath: string ): ImportFs =
    ## Import the contents of the given directory wich is relative to the nim_file
    ## that uses import_data_directory.
    ## example:
    ##   const SAMPLE_FS_00: ImportFs  = import_data_directory "test/fixtures"
    ##   const SAMPLE_FS_01: ImportFs  = import_data_directory "test/fixtures/"
    import_data_directory_impl( dirPath, instantiationInfo(0, true).filename )
