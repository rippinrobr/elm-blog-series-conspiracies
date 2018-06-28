module Conspiracies exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Json.Decode exposing (..)

-- type alias Category = Tag 
type alias Category = { 
    id : Int
    ,name : String
    ,approved : Int
}

type alias Conspiracy = {
    title : String
    ,page_id : String
    ,summary : String
    ,content : String
    ,bacground: String
}

type alias Model = {
    tags : List Category      
    , errorMsg : Maybe String
    , selectedTag : String
    , summaries : List Conspiracy
}

type Msg
    = SendGetTagsRequest (String)
    | SendConspiraciesRequest (Category)
    | DataReceived (Result Http.Error (List Category))
    | ConspiracyDataReceived (Result Http.Error (List Conspiracy))
    | SelectTag (String)

-- view Constructs the overall page layout calling viewTag and viewSummaries 
-- to  build out the navigation and display area.
view : Model -> (Html Msg)
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

-- viewSummaries creates the HTML that displays the Conspiracy
-- summaries for the selected category.
viewSummaries : Conspiracy -> (Html Msg)
viewSummaries summary = 
    div [ class "conspiracy-tease"]
        [ div [ class "conspiracy-title"] 
            [ text summary.title ]
        ,div [ class "conspiracy-summary"] 
            [ p [] [text summary.summary ]]
        ,div [] 
            [a [href "#"] [(text "More...")]]
        ]

-- viewTag creates the navigation div for each category.  The function als
-- determines if the current category is the one the user has selected. If 
-- it is then it adds the selected class.
viewTag : String -> Category -> (Html Msg)
viewTag selectedTag category =
    div
        [ classList [ ("tag",True), ( "selected", selectedTag == category.name ) ]
        , onClick (SendConspiraciesRequest category)
        ]
        [text category.name]


-- init does what you might think it does, it initializes the applicaiton.
-- In this app, I need to fetch the list of tags when the page loads so 
-- the user has some navigation to work with so I make the call to the
-- httpCommand function.
init : ( Model, Cmd Msg )
init = 
    let model = { tags = []
                , errorMsg = Nothing 
                , selectedTag = "All"
                , summaries = []
                }

    in 
        ( model,  getTagsCommand) 

-- conspiracyDecoder is the code that pulls the data out of the JSON object
-- and creates a Conspiracy object
conspiracyDecoder : Decoder Conspiracy
conspiracyDecoder = 
    map5 Conspiracy  
        (field "title" string)
        (field "page_id" string)
        (field "summary" string)
        (field "content" string)
        (field "background" string)


-- categoryDecoder is the code that pulls the data out of the JSON object
-- and creates a Category object
categoryDecoder : Decoder Category
categoryDecoder = 
    map3 Category   
        (field "id" int)
        (field "name" string)
        (field "approved" int)

-- getTagsCommand is responsible for making the HTTP GET
-- call to fetch the tags.  |> is a pipe operator and I'm using to create a 'pipeline'.  
-- The Json.Decode.list tagDecoder is passed to the Http.get call as the last parameter
-- and is responsible for turning the JSON Array of tag object into an Elm list of Tags.
-- The List of tags from the decoder become the parameter of the DataRecieved Msg and
-- eventually become the navigation list
getTagsCommand : Cmd Msg
getTagsCommand =
    Json.Decode.list categoryDecoder
        |> Http.get "http://localhost:8088/tags"
        |> Http.send DataReceived

-- getConspiracies is responsible for making the HTTP GET
-- call to fetch the conspiracies for a given tag.  The |> is a pipe operator and I'm 
-- using to create a 'pipeline'.  The Json.Decode.list conspiracyDecoder is passed to 
-- the Http.get call as the last parameter  and is responsible for turning the JSON 
-- Array of tag object into an Elm list of Conspiracies.  The List of conspiracies 
-- from the decoder become the parameter of the DataRecieved Msg and
-- eventually become the content on the right of the page
getConspiracies : Int -> Cmd Msg
getConspiracies category_id =
    Json.Decode.list conspiracyDecoder
        |> Http.get (String.concat ["http://localhost:8088/tags/", (toString category_id), "/conspiracies"])
        |> Http.send ConspiracyDataReceived


-- update drives the changes in the UI and interaction with the server.
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    
    case msg of 
        DataReceived (Ok tags) -> 
            ({ model | tags = tags, errorMsg = Nothing }, Cmd.none)

        DataReceived (Err httpError) ->
            ({ model | errorMsg = Just (createErrorMessage httpError) }, Cmd.none)
        
        ConspiracyDataReceived (Ok conspiracies) -> 
            ({ model | summaries = conspiracies, errorMsg = Nothing }, Cmd.none)

        ConspiracyDataReceived (Err httpError) ->
            ({ model | errorMsg = Just (createErrorMessage httpError) }, Cmd.none)
        
        SendConspiraciesRequest category ->
            ( { model | selectedTag = category.name }, (getConspiracies category.id) )
            
        SendGetTagsRequest category ->  
            ( { model | selectedTag = category }, getTagsCommand )

        SelectTag category -> 
            ({ model | selectedTag = category }, Cmd.none)

-- createErrorMessage generates a string that gives the user a 
-- human understandable error message 
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