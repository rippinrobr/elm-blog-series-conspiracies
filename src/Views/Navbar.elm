module Views.Navbar exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

view catView selectedCat categories =
    div [ class "col-md-2 d-none d-md-block bg-light sidebar"]
        (List.map (catView selectedCat) categories)
