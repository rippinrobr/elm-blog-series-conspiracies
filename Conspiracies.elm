module PhotoGroove exposing (..)
 
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
 
  
view model =
    div [ class "container-fluid" ]
        [ div  [ class "row" ] [
         div [ 
            class "col-md-2 d-none d-md-block bg-light sidebar"
            ]
            
            (List.map (viewTag model.selectedTag) model.tags)
        , div [ class "col-md-9 ml-sm-auto col-lg-10 px-4" ]
            [ div [ class "conspicies" ] 
               [ h2 [] [ text (model.selectedTag ++ " Conspiracies") ]]]
        ]]
 
 
viewTag selectedTag tag =
    div
        [ classList [ ("tag",True), ( "selected", selectedTag == tag ) ]
        , onClick { operation = "SELECT_TAG", data = tag }
        ]
        [text tag]
 
 
initialModel =
    { tags = ["All"
              , "9/11"
              , "Deep State"
              , "New World Order"
              , "UFO"]       
     , selectedTag = "All"
    }
 
update msg model =
    if msg.operation == "SELECT_TAG" then
        { model | selectedTag = msg.data }
    else
        model
 
 
main =
    Html.beginnerProgram
        { model = initialModel
        , view = view
        , update = update
        }