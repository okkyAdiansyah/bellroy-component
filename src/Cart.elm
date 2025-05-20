module Cart exposing (..)

import Json.Decode as JD
import Json.Encode as JE

-- MODEL
type alias CartItem =
    { label : String
    , img : String
    , color_variant : String
    , qty : Int
    , price : Float
    }

type alias Model =
    { cart_items : List CartItem
    , price_total : Float
    }

-- DEFAULT
defaultCartItem : CartItem
defaultCartItem =
    { label = ""
    , img = ""
    , color_variant = ""
    , qty = 1
    , price = 0
    }

defaultModel : Model
defaultModel =
    { cart_items = []
    , price_total = 0
    }
 
-- DECODER
cartItemDecoder : JD.Decoder CartItem
cartItemDecoder =
    JD.map5 CartItem
        (JD.field "label" JD.string)
        (JD.field "img" JD.string)
        (JD.field "color_variant" JD.string)
        (JD.field "qty" JD.int)
        (JD.field "price" JD.float)

cartDecoder : JD.Decoder (List CartItem)
cartDecoder =
    JD.list cartItemDecoder

-- ENCODER
encodeCartItem : CartItem -> JE.Value
encodeCartItem item = 
    JE.object
        [ ("label", JE.string item.label)
        , ("img", JE.string item.img)
        , ("color_variant", JE.string item.color_variant)
        , ("qty", JE.int item.qty)
        , ("price", JE.float item.price)
        ]

encodeCart : List CartItem -> JE.Value
encodeCart cartItems =
    JE.list encodeCartItem cartItems

