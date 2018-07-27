module Views.Frame exposing (viewport)

import Html exposing (..)
import Html.Attributes exposing (..)

displayError : { a | errorMsg : Maybe String } -> Html msg
displayError model =
    case model.errorMsg of 
        Nothing ->
            div [class "noerror"] []

        Just val ->
            div [class "row"] [ text val ]

viewport: (a -> Html msg)
    -> { b
        | errorMsg : Maybe String
        , selectedCategory : String
        , summaries : List a
    }
    -> Html msg
viewport summariesView model = 
    div [ class "col-md-9 ml-sm-auto col-lg-10 px-4" ]
            [ div [ class "content-heading" ] [ h2 [] [ text (model.selectedCategory ++ " Conspiracies") ]]
            , displayError model
            , div [] (List.map (summariesView) model.summaries)
            ]
