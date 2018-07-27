module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Json.Decode exposing (..)
import Data.Conspiracies  exposing (Conspiracy, decoder)
import Data.Categories exposing (Category, decoder)
import Views.Frame exposing (..)
import Views.Navbar
import Views.Conspiracies
import Messages exposing (..)

type alias Model = {
    categories : List Category      
    , errorMsg : Maybe String
    , selectedCategory : String
    , summaries : List Conspiracy
}


-- view Constructs the overall page layout calling viewCategory and viewSummaries 
-- to  build out the navigation and display area.
view : Model -> (Html Msg) 
view model =
    div [ class "container-fluid" ] 
        [   
            div  [ class "row" ] 
            [
                Views.Navbar.view viewCategory model.selectedCategory model.categories
            ,   viewport Views.Conspiracies.summaries model
            ]
        ]

-- viewCategory creates the navigation div for each category.  The function als
-- determines if the current category is the one the user has selected. If 
-- it is then it adds the selected class.
viewCategory : String -> Category -> (Html Msg)
viewCategory selectedCategory category =
    div
        [ classList [ ("category",True), ( "selected", selectedCategory == category.name ) ]
        , onClick (SendConspiraciesRequest category)
        ]
        [text category.name]


-- init does what you might think it does, it initializes the applicaiton.
-- In this app, I need to fetch the list of tags when the page loads so 
-- the user has some navigation to work with so I make the call to the
-- httpCommand function.
init : ( Model, Cmd Msg )
init = 
    let model = { categories = []
                , errorMsg = Nothing 
                , selectedCategory = "All"
                , summaries = []
                }
    in 
        ( model,  getCategoriesCommand) 

-- getCategoriesCommand is responsible for making the HTTP GET
-- call to fetch the tags.  |> is a pipe operator and I'm using to create a 'pipeline'.  
-- The Json.Decode.list tagDecoder is passed to the Http.get call as the last parameter
-- and is responsible for turning the JSON Array of categories into an Elm list of Categories.
-- The List of Categories from the decoder become the parameter of the DataRecieved Msg and
-- eventually become the navigation list
getCategoriesCommand : Cmd Msg
getCategoriesCommand =
    Json.Decode.list Data.Categories.decoder
        |> Http.get "http://localhost:8088/categories"
        |> Http.send DataReceived

-- getConspiracies is responsible for making the HTTP GET
-- call to fetch the conspiracies for a given category.  The |> is a pipe operator and I'm 
-- using to create a 'pipeline'.  The Json.Decode.list conspiracyDecoder is passed to 
-- the Http.get call as the last parameter  and is responsible for turning the JSON 
-- Array of Category object into an Elm list of Conspiracies.  The List of conspiracies 
-- from the decoder become the parameter of the DataRecieved Msg and
-- eventually become the content on the right of the page
getConspiracies : Int -> Cmd Msg
getConspiracies category_id =
    Json.Decode.list Data.Conspiracies.decoder
        |> Http.get (String.concat ["http://localhost:8088/categories/", (toString category_id), "/conspiracies"])
        |> Http.send ConspiracyDataReceived


-- update drives the changes in the UI and interaction with the server.
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    
    case msg of 
        DataReceived (Ok categories) -> 
            ({ model | categories = categories, errorMsg = Nothing }, Cmd.none)

        DataReceived (Err httpError) ->
            ({ model | errorMsg = Just (createErrorMessage httpError) }, Cmd.none)
        
        ConspiracyDataReceived (Ok conspiracies) -> 
            ({ model | summaries = conspiracies, errorMsg = Nothing }, Cmd.none)

        ConspiracyDataReceived (Err httpError) ->
            ({ model | errorMsg = Just (createErrorMessage httpError) }, Cmd.none)
        
        SendConspiraciesRequest category ->
            ( { model | selectedCategory = category.name }, (getConspiracies category.id) )
            
        SendGetCategoriesRequest category ->  
            ( { model | selectedCategory = category }, getCategoriesCommand )

        SelectCategory category -> 
            ({ model | selectedCategory = category }, Cmd.none)

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