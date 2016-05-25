{- This Source Code Form is subject to the terms of the Mozilla Public License,
   v. 2.0. If a copy of the MPL was not distributed with this file, you can
   obtain one at http://mozilla.org/MPL/2.0/.

   Copyright 2016 by Ian Mackenzie
   ian.e.mackenzie@gmail.com
-}


module Tests.Vector2d exposing (suite)

import Json.Decode as Decode exposing (decodeString)
import Json.Encode as Encode exposing (encode)
import ElmTest exposing (Test, test, assert)
import Check exposing (Claim, claim, true, that, is, for, quickCheck)
import Check.Test exposing (evidenceToTest)
import OpenSolid.Core.Types exposing (..)
import OpenSolid.Vector2d as Vector2d
import OpenSolid.Core.Decode as Decode
import OpenSolid.Core.Encode as Encode
import TestUtils exposing (areApproximatelyEqual)
import Producers exposing (vector2d)


normalizationWorksProperly : Claim
normalizationWorksProperly =
    let
        normalizeResultIsCorrect vector =
            case (Vector2d.normalize vector) of
                Nothing ->
                    -- If normalized result is Nothing, input must have been the
                    -- zero vector
                    vector == Vector2d.zero

                Just normalized ->
                    -- Otherwise, normalized length should be nearly 1
                    areApproximatelyEqual (Vector2d.length normalized) 1
    in
        claim "Normalization works properly"
            `true` normalizeResultIsCorrect
            `for` vector2d


jsonRoundTrips : Claim
jsonRoundTrips =
    claim "JSON conversion round-trips properly"
        `that` (Encode.vector2d >> encode 0 >> (decodeString Decode.vector2d))
        `is` Ok
        `for` vector2d


suite : Test
suite =
    ElmTest.suite "Vector2d tests"
        [ evidenceToTest (quickCheck normalizationWorksProperly)
        , evidenceToTest (quickCheck jsonRoundTrips)
        ]
