###
# Test for Nimporters staticGlobMatch.
#
# Run Tests:
#   $ nim compile --run tests/import_static_glob_match_test.nim
#
# :Author: Raimund Hübel <raimund.huebel@googlemail.com>
###

import unittest
import nimporter/helper


suite "nimporter.helper.staticGlobMatch()":

    test "simple positive cases (no globbing) 00":
        check true == staticGlobMatch("", "")
        check true == staticGlobMatch(" ", " ")

    test "simple positive cases (no globbing) 01a":
        check true == staticGlobMatch("a", "a")
        check true == staticGlobMatch("b", "b")

    test "simple positive cases (no globbing) 01b":
        check true == staticGlobMatch("A", "A")
        check true == staticGlobMatch("B", "B")

    test "simple positive cases (no globbing) 02a":
        check true == staticGlobMatch("aa", "aa")
        check true == staticGlobMatch("bb", "bb")
        check true == staticGlobMatch("ab", "ab")
        check true == staticGlobMatch("ba", "ba")

    test "simple positive cases (no globbing) 02b":
        check true == staticGlobMatch("AA", "AA")
        check true == staticGlobMatch("BB", "BB")
        check true == staticGlobMatch("AB", "AB")
        check true == staticGlobMatch("BA", "BA")

    test "simple positive cases (no globbing) 02c":
        check true == staticGlobMatch("Aa", "Aa")
        check true == staticGlobMatch("Bb", "Bb")
        check true == staticGlobMatch("Ab", "Ab")
        check true == staticGlobMatch("Ba", "Ba")

    test "simple positive cases (no globbing) 02d":
        check true == staticGlobMatch("Aa", "Aa")
        check true == staticGlobMatch("Bb", "Bb")
        check true == staticGlobMatch("Ab", "Ab")
        check true == staticGlobMatch("Ba", "Ba")

    test "simple positive cases (no globbing) 03":
        check true == staticGlobMatch("superkalifragilistischexpialigorisch", "superkalifragilistischexpialigorisch")
        check true == staticGlobMatch("Schiffahrtdampfer", "Schiffahrtdampfer")



    test "simple negative cases (no globbing) 00":
        check false == staticGlobMatch("", " ")
        check false == staticGlobMatch("", "  ")
        check false == staticGlobMatch(" ", "")
        check false == staticGlobMatch(" ", "  ")
        check false == staticGlobMatch("  ", "")
        check false == staticGlobMatch("  ", " ")

    test "simple negative cases (no globbing) 01":
        check false == staticGlobMatch("a", "")
        check false == staticGlobMatch("a", " ")
        check false == staticGlobMatch("a", "A")
        check false == staticGlobMatch("a", "B")
        check false == staticGlobMatch("a", "a ")
        check false == staticGlobMatch("a", " a")
        check false == staticGlobMatch("a", "b")
        check false == staticGlobMatch("a", "c")
        check false == staticGlobMatch("a", "aa")
        check false == staticGlobMatch("a", "ab")

    test "simple negative cases (no globbing) 02":
        check false == staticGlobMatch("b", "")
        check false == staticGlobMatch("b", " ")
        check false == staticGlobMatch("b", "A")
        check false == staticGlobMatch("b", "B")
        check false == staticGlobMatch("b", "b ")
        check false == staticGlobMatch("b", " b")
        check false == staticGlobMatch("b", "a")
        check false == staticGlobMatch("b", "c")
        check false == staticGlobMatch("b", "aa")
        check false == staticGlobMatch("b", "ab")



    test "casesensetive (no globbing) 00":
        check true  == staticGlobMatch("a", "a")
        check false == staticGlobMatch("a", "A")

    test "casesensetive (no globbing) 01":
        check true  == staticGlobMatch("b", "b")
        check false == staticGlobMatch("b", "B")

    test "casesensetive (no globbing) 02":
        check true  == staticGlobMatch("ab", "ab")
        check false == staticGlobMatch("ab", "Ab")
        check false == staticGlobMatch("ab", "aB")
        check false == staticGlobMatch("ab", "AB")

    test "casesensetive (no globbing) 03":
        check true  == staticGlobMatch("AB", "AB")
        check false == staticGlobMatch("AB", "aB")
        check false == staticGlobMatch("AB", "Ab")
        check false == staticGlobMatch("AB", "ab")



    test "with globbing using '?' 00":
        check true == staticGlobMatch(" ", "?")
        check true == staticGlobMatch("a", "?")
        check true == staticGlobMatch("b", "?")
        check true == staticGlobMatch("A", "?")
        check true == staticGlobMatch("B", "?")
        check true == staticGlobMatch("ab", "a?")
        check true == staticGlobMatch("ab", "?b")

    test "with globbing using '?' 01":
        check true  == staticGlobMatch(" ", "?")
        check false == staticGlobMatch("  ", "?")
        check false == staticGlobMatch("", "?")

    test "with globbing using '?' 02":
        check true  == staticGlobMatch("a", "?")
        check false == staticGlobMatch("a ", "?")
        check false == staticGlobMatch(" a", "?")
        check false == staticGlobMatch("ba", "?")
        check false == staticGlobMatch("ab", "?")

    test "with globbing using '?' 02":
        check true  == staticGlobMatch("b", "?")
        check false == staticGlobMatch("b ", "?")
        check false == staticGlobMatch(" b", "?")
        check false == staticGlobMatch("ab", "?")
        check false == staticGlobMatch("ba", "?")

    test "with globbing using '?' 03":
        check true  == staticGlobMatch("ab", "??")
        check true  == staticGlobMatch("aa", "??")
        check true  == staticGlobMatch("bb", "??")
        check true  == staticGlobMatch("ba", "??")
        check false == staticGlobMatch("ab ", "??")
        check false == staticGlobMatch(" ab", "??")



    test "with globbing using '*' 00a":
        check true  == staticGlobMatch("hello_test.nim", "*_test.nim")
        check false == staticGlobMatch("hello_test.ni" , "*_test.nim")
        check false == staticGlobMatch("hello.nim"     , "*_test.nim")
        check false == staticGlobMatch("hello_tes.nim" , "*_test.nim")

    test "with globbing using '*' 00b":
        check true == staticGlobMatch("", "*")
        check true == staticGlobMatch("a", "*")
        check true == staticGlobMatch("b", "*")
        check true == staticGlobMatch("ab", "*")
        check true == staticGlobMatch("abc", "*")
        check true == staticGlobMatch("cba", "*")

    test "with globbing using '*' 01a":
        check true  == staticGlobMatch("a"  , "a*")
        check true  == staticGlobMatch("aa" , "a*")
        check true  == staticGlobMatch("ab" , "a*")
        check true  == staticGlobMatch("a " , "a*")
        check true  == staticGlobMatch("abb", "a*")
        check true  == staticGlobMatch("a  ", "a*")

    test "with globbing using '*' 01b":
        check false  == staticGlobMatch("b"  , "a*")
        check false  == staticGlobMatch("ba" , "a*")
        check false  == staticGlobMatch("b " , "a*")
        check false  == staticGlobMatch("baa", "a*")
        check false  == staticGlobMatch("b  ", "a*")

    test "with globbing using '*' 02a":
        check true  == staticGlobMatch("a"  , "*a")
        check true  == staticGlobMatch("aa" , "*a")
        check true  == staticGlobMatch("ba" , "*a")
        check true  == staticGlobMatch(" a" , "*a")
        check true  == staticGlobMatch("bba", "*a")

    test "with globbing using '*' 02b":
        check false == staticGlobMatch("b"  , "*a")
        check false == staticGlobMatch("ab" , "*a")
        check false == staticGlobMatch("bb" , "*a")
        check false == staticGlobMatch(" b" , "*a")
        check false == staticGlobMatch("aab" , "*a")
        check false == staticGlobMatch("bbb" , "*a")

    test "with globbing using '*' 03a":
        check true == staticGlobMatch("ab"   , "a*b")
        check true == staticGlobMatch("a b"  , "a*b")
        check true == staticGlobMatch("aab"  , "a*b")
        check true == staticGlobMatch("abb"  , "a*b")
        check true == staticGlobMatch("acb"  , "a*b")
        check true == staticGlobMatch("axyzb", "a*b")

    test "with globbing using '*' 03b":
        check true  == staticGlobMatch("ab" , "a*b")
        check false == staticGlobMatch("bb" , "a*b")
        check false == staticGlobMatch("aa" , "a*b")
        check false == staticGlobMatch(" ab" , "a*b")
        check false == staticGlobMatch("ab " , "a*b")
        check false == staticGlobMatch("cb" , "a*b")
        check false == staticGlobMatch("ac" , "a*b")
        check false == staticGlobMatch("Ab" , "a*b")
        check false == staticGlobMatch("aB" , "a*b")
        check false == staticGlobMatch("AB" , "a*b")
