module Conspiracies exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Json.Decode exposing (..)

type alias Tag = {
    id : Int
    ,name : String
    ,approved : Int
}

type alias ConspiracySummary = {
    id : Int
    ,title : String
    ,summary : String

}
type alias Model = {
    tags : List Tag      
    , errorMsg : Maybe String
    , selectedTag : String
    , summaries : List ConspiracySummary
}

type Msg
    = SendHttpRequest --(String)
    | DataReceived (Result Http.Error (List Tag))
    | SelectTag (String)

view model =
    div [ class "container-fluid" ] --[]
        [ div  [ class "row" ] 
          [
            div [ class "col-md-2 d-none d-md-block bg-light sidebar"]
             (List.map (viewTag model.selectedTag) model.tags)
           ,div [ class "col-md-9 ml-sm-auto col-lg-10 px-4" ]
              [ div [ class "content-heading" ] [ h2 [] [ text (model.selectedTag ++ " Conspiracies") ]]
              , div [] (List.map (viewSummaries) model.summaries)
              ]
          ]
        ]

viewSummaries summary = 
    div [ class "conspiracy-tease"]
        [ div [ class "conspiracy-title"] 
            [ text summary.title ]
        ,div [ class "conspiracy-summary"] 
            [ p [] [text summary.summary ]]
        ,div [] 
           [a [href "#"] [(text "View More Link Here")]]
        ]

viewTag selectedTag tag =
    div
        [ classList [ ("tag",True), ( "selected", selectedTag == tag.name ) ]
        , onClick SendHttpRequest
        ]
        [text tag.name]
 

init : ( Model, Cmd Msg )
init =
    ({ tags = [ { id = 1
                , name = "All" 
                , approved = 1 }]
    , errorMsg = Nothing 
    , selectedTag = "All"
    , summaries = []
    }
    , Cmd.none
    )

tagDecoder : Decoder Tag
tagDecoder = 
    map3 Tag  
        (field "id" int)
        (field "name" string)
        (field "approved" int)

httpCommand : Cmd Msg
httpCommand =
    Json.Decode.list tagDecoder
        |> Http.get "http://localhost:8088/tags"
        |> Http.send DataReceived

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of 
        DataReceived (Ok tags) -> 
            ({ model | tags = tags, errorMsg = Nothing }, Cmd.none)

        DataReceived (Err httpError) ->
            ({ model | errorMsg = Just (createErrorMessage httpError) }, Cmd.none)

        SendHttpRequest ->  
            ( model, httpCommand )

        SelectTag tag -> 
            ({ model | selectedTag = tag }, Cmd.none)

        -- _ -> (model, Cmd.none)

createErrorMessage : Http.Error -> String
createErrorMessage httpError =
    case httpError of
        Http.BadUrl message ->
            message

        Http.Timeout ->
            "Server is taking too long to respond. Please try again later."

        Http.NetworkError ->
            "It appears you don't have an Internet connection right now."

        Http.BadStatus response ->
            response.status.message

        Http.BadPayload message response ->
            message

main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }