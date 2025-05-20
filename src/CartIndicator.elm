port module CartIndicator exposing (main, update, Msg, Model, view)

import Html exposing (..)
import Html.Attributes exposing (class, src, attribute)
import Svg exposing (Svg, svg, circle, path)
import Svg.Attributes exposing (viewBox, d, cx, cy, r, width, height, fill, stroke, strokeWidth)
import Browser

-- PORT
port recieveCartFromJs : (Int -> msg) -> Sub msg

-- Model
type alias Model =
    { cartItem : Int
    , mode : String
    }

type alias Flags =
    { cartItem : Int
    , mode : String
    }

-- MESSAGES
type Msg
    = UpdateModel Int

-- UPDATE
update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateModel count ->
             ( {model | cartItem = count}, Cmd.none )

-- VIEW
view : Model -> Html Msg
view model =
    div [ class "relative flex items-center justify-center" ]
        (if model.mode == "cart-toggle" then
            [ button [ class "inline-block cursor-pointer" ] [ cartIcon ]
            , if model.cartItem /= 0 then
                cartBadge model
              else
                text ""
            ]
         else
            [ div [] [ cartIcon ] ]
        )

cartIcon : Html Msg
cartIcon = 
    svg [ viewBox "0 0 31 28", width "24", height "24", fill "none", stroke "#666666", strokeWidth "2"]
        [ circle [ cx "13", cy "24", r "2" ] []
        , circle [ cx "24", cy "24", r "2" ] []
        , path
            [ d "M1.5 2h3s1.5 0 2 2l4 13s.4 1 1 1h13s3.6-.3 4-4l1-5s0-1-2-1h-19s.2-3.3 1.5-4 3.1-.3 4 0c2 .5 3.4-.3 5-1 4-1.8 8 1.2 8 5" ]
            []
        ]

cartBadge : Model -> Html Msg
cartBadge model = 
    span[ class "absolute text-[9px] text-white bg-orange-500 h-[13px] min-w-[8px] rounded-full font-bold border-2 border-solid border-white px-[2.5px] -top-[5px] -right-[5px] text-center box-content" ][ text (String.fromInt model.cartItem) ]
    

-- INIT
init : Flags -> (Model, Cmd Msg)
init flags = 
    ( { cartItem = flags.cartItem
      , mode = flags.mode
      }
    , Cmd.none
    )
-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
    recieveCartFromJs UpdateModel

-- Main 
main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }