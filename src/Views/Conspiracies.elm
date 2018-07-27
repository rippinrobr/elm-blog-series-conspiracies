module Views.Conspiracies exposing (summaries)

import Data.Conspiracies exposing (Conspiracy)
import Messages exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)

-- summaries creates the HTML that displays the Conspiracy
-- summaries for the selected category.
summaries : Conspiracy -> (Html Msg)
summaries summary = 
    div [ class "conspiracy-tease"]
        [ div [ class "conspiracy-title"] 
            [ text summary.title ]
        ,div [ class "conspiracy-summary"] 
            [ p [] [text summary.summary ]]
        ,div [] 
            [a [href "#"] [(text "More...")]]
        ]