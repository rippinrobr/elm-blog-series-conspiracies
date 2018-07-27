module Messages exposing (..)

import Http exposing (Error)
import Data.Categories exposing (Category)
import Data.Conspiracies exposing (Conspiracy)

type Msg
    = SendGetCategoriesRequest (String)
    | SendConspiraciesRequest (Category)
    | DataReceived (Result Http.Error (List Category))
    | ConspiracyDataReceived (Result Http.Error (List Conspiracy))
    | SelectCategory (String)
