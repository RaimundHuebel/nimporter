###
# Nimporter Helpers to support the implementation of the main functionality.
#
# :Author:   Raimund Hübel <raimund.huebel@googlemail.com>
###



#BAD # Geht nicht, da importc während compileTime nicht erlaubt ist
#BAd import posix
#BAD proc staticGlobMatch*(filePath: string, glob: string): bool =
#BAD      return 0 == posix.fnmatch(glob, filePath, posix.FNM_NOESCAPE)



proc staticGlobMatch*(filePath: string, glob: string): bool =
    # Own plattform independent implementation of glob-Matching.
    # This is needed because all native ways to get glob-Matching are not allowed on compile-time.
    # Supported is: * and ? for globbing.
    #echo "[TRACE], "filePath, ", ", glob
    if filePath.len == 0 and glob.len == 0:
        return true
    if filePath.len == 0 and glob == "*":
        return true
    if filePath.len == 0:
        return false
    if glob.len == 0:
        return false
    if glob[0] == '*':
        if staticGlobMatch(filePath[1..^1], glob[1..^1]) == true:
            return true
        elif staticGlobMatch(filePath[1..^1], glob) == true:
            return true
        elif staticGlobMatch(filePath, glob[1..^1]) == true:
            return true
        else:
            return false
    if glob[0] == '?' or glob[0] == filePath[0]:
        return staticGlobMatch(filePath[1..^1], glob[1..^1])
    return false

