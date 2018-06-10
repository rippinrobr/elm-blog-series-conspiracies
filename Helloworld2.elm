module Helloworld2 exposing (..)
   
import Html exposing (..)
import Html.Attributes exposing (..)

view = 
    div [ class "container-fluid" ]
        [ div  [ class "row"] 
               [ text "Do you know about Area 52? BTW, I'm now in a child div!"]]

main =
    view

-- The Output of the code 
-- <div id="elm-area">
--     <div class="container-fluid">
--         <div class="row">Do you know about Area 52? BTW, I'm now in a child div!</div>
--     </div>
-- </div>