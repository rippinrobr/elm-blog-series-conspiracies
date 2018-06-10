module Conspiracies exposing (..)
 
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
 
  
view model =
    div [ class "container-fluid" ]
        [ div  [ class "row" ] 
          [
            div [ class "col-md-2 d-none d-md-block bg-light sidebar"]
             (List.map (viewTag model.selectedTag) model.tags)
           ,div [ class "col-md-9 ml-sm-auto col-lg-10 px-4" ]
              [ div [ class "content-heading" ] [ h2 [] [ text (model.selectedTag ++ " Conspiracies") ]]
              , div [] (List.map (viewSummaries) model.summaryPlaceholders)
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
     , summaryPlaceholders = [
         { title = "Conspiracy Title Placeholder"
           ,summary = "Concept of the number one, rogue with pretty stories for which there's little good evidence from which we spring Hypatia a mote of dust suspended in a sunbeam hydrogen atoms take root and flourish gathered by gravity Hypatia! Vangelis extraplanetary made in the interiors of collapsing stars vanquish the impossible! Birth galaxies. Inconspicuous motes of rock and gas Tunguska event, Orion's sword trillion! Worldlets vastness is bearable only through love rich in heavy atoms as a patch of light tesseract and billions upon billions upon billions upon billions upon billions upon billions upon billions!"
         }
         ,{ title = "Conspiracy Title Placeholder"
            ,summary = "Emerged into consciousness intelligent beings, science the sky calls to us the ash of stellar alchemy laws of physics, dream of the mind's eye. Something incredible is waiting to be known billions upon billions decipherment not a sunrise but a galaxyrise descended from astronomers radio telescope concept of the number one muse about Euclid tesseract billions upon billions, preserve and cherish that pale blue dot intelligent beings tingling of the spine Sea of Tranquility Hypatia. Globular star cluster rich in mystery culture descended from astronomers ship of the imagination Apollonius of Perga. Birth Apollonius of Perga. Dispassionate extraterrestrial observer. How far away and billions upon billions upon billions upon billions upon billions upon billions upon billions!"
         }
         ,{ title = "Conspiracy Title Placeholder"
            ,summary = "Colonies, hydrogen atoms Flatland tingling of the spine quasar. Billions upon billions! As a patch of light decipherment consciousness permanence of the stars cosmic fugue brain is the seed of intelligence from which we spring astonishment science, take root and flourish explorations! Apollonius of Perga intelligent beings. Cambrian explosion? Consciousness, network of wormholes. Intelligent beings a mote of dust suspended in a sunbeam encyclopaedia galactica, Euclid laws of physics the only home we've ever known a billion trillion? A mote of dust suspended in a sunbeam, great turbulent clouds Vangelis with pretty stories for which there's little good evidence brain is the seed of intelligence hearts of the stars and billions upon billions upon billions upon billions upon billions upon billions upon billions."
         }
     ]
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