module Data.Conspiracies exposing (Conspiracy, decoder)

import Json.Decode exposing (..)

type alias Conspiracy = {
    title : String
    ,page_id : String
    ,summary : String
    ,content : String
    ,background: String
}

-- decoder is the code that pulls the data out of the JSON object
-- and creates a Conspiracy object
decoder : Decoder Conspiracy
decoder = 
    map5 Conspiracy  
        (field "title" string)
        (field "page_id" string)
        (field "summary" string)
        (field "content" string)
        (field "background" string)

