module Data.Categories exposing (Category, decoder)

import Json.Decode exposing (..)

type alias Category = { 
    id : Int
    ,name : String
    ,approved : Int
}

-- decoder is the code that pulls the data out of the JSON object
-- and creates a Category object
decoder : Decoder Category
decoder = 
    map3 Category   
        (field "id" int)
        (field "name" string)
        (field "approved" int)


