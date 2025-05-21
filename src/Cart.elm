port module Cart exposing (main, Model, defaultCartItem, CartItem, encodeCart)

import Json.Decode as JD
import Json.Encode as JE
import CartIndicator
import Http
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Browser

-- PORTS OUT
port removeItemFromCart : JE.Value -> Cmd msg
port updateItemQty : JE.Value -> Cmd msg

-- PORTS IN
port openMiniCart : (Bool -> msg) -> Sub msg
port recieveCartfromProduct : (List CartItem -> msg) -> Sub msg

-- MODEL
type alias CartItem =
    { label : String
    , img : String
    , color_variant : String
    , qty : Int
    , price : Float
    }

type alias Model =
    { cart_mode : String
    , cart_isOpen : Bool
    , cart_items : List CartItem
    , price_total : Float
    , errorMsg : String
    , cart_indicator : CartIndicator.Model
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
    { cart_mode = ""
    , cart_isOpen = False
    , cart_items = []
    , price_total = 0
    , errorMsg = ""
    , cart_indicator =
        { cartItem = 0 
        , mode = "cart-indicator"
        }
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

-- FETCH
fetchCartData : Cmd Msg
fetchCartData = 
    Http.get
    { url = "http://localhost:4321/api/product/addToCart.json"
    , expect = Http.expectJson GotCartFromAPI cartDecoder
    }

-- HELPER
countItemTotalPrice : String -> CartItem -> List CartItem -> List CartItem
countItemTotalPrice val newItem items =
    let
        updatedItem = {newItem | qty = String.toInt val |> Maybe.withDefault newItem.qty}
        sameItem item =
            item.label == updatedItem.label && item.color_variant == updatedItem.color_variant
        updatedCart =
            case List.filter sameItem items of
                [] ->
                    items
                _ ->
                    List.map
                        (\item ->
                            if sameItem item then
                                let
                                    newPrice = (item.price / toFloat item.qty) * toFloat updatedItem.qty
                                in
                                 {item | qty = updatedItem.qty, price = newPrice}
                            else
                                item
                        )
                        items
    in
    updatedCart

calculateTotalPrice : List CartItem -> Float
calculateTotalPrice items =
    List.foldl (\item acc -> acc + item.price) 0 items

-- MESSAGES
type Msg
    = GotCartFromAPI (Result Http.Error (List CartItem))
    | GotCartFromPort (List CartItem)
    | UpdateItemQty String CartItem
    | ToggleMiniCart Bool
    | RemoveItem CartItem
    | CartIndicatorMsg CartIndicator.Msg

-- UPDATE
update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GotCartFromAPI (Ok cartItems) ->
            let
                cartItemCount = {cartItem = List.length cartItems, mode = "cart-indicator"} 
            in
             ( {model | cart_items = cartItems, price_total = calculateTotalPrice cartItems, cart_indicator = cartItemCount}, Cmd.none )
        GotCartFromAPI (Err err) ->
            let
                message =
                   case err of
                       Http.BadUrl _ -> "Invalid URL"
                       Http.Timeout -> "Request timed out"
                       Http.NetworkError -> "Network error"
                       Http.BadStatus status -> "Bad response: " ++ String.fromInt status
                       Http.BadBody _ -> "Invalid response format"

                _= Debug.log "HTTP ERROR" err
            in
             ( {model | errorMsg = message}, Cmd.none )
        UpdateItemQty val item ->
            let
                updatedCart =
                    countItemTotalPrice val item model.cart_items
                encodedCart = encodeCart updatedCart
            in
             ( {model | cart_items = updatedCart, price_total = calculateTotalPrice updatedCart}, updateItemQty encodedCart )
        ToggleMiniCart _ ->
            ( {model | cart_isOpen = not model.cart_isOpen}, Cmd.none )
        RemoveItem item ->
            let
                removedItem =
                    List.filter 
                        (\cartItem ->
                            not (cartItem.label == item.label && cartItem.color_variant == item.color_variant)
                        )
                        model.cart_items
                encodedCart = encodeCart removedItem
            in
             ( {model | cart_items = removedItem, price_total = calculateTotalPrice removedItem}, removeItemFromCart encodedCart )
        GotCartFromPort items ->
            let
                cartItemCount = {cartItem = List.length items, mode = "cart-indicator"} 
            in
             ( {model | cart_items = items, price_total = calculateTotalPrice items, cart_indicator = cartItemCount}, Cmd.none )
        CartIndicatorMsg subMsg ->
            let
                (updatedCart, cartIndicatorCmd) =
                    CartIndicator.update subMsg model.cart_indicator
            in
             ( {model | cart_indicator = updatedCart}, Cmd.map CartIndicatorMsg cartIndicatorCmd )

-- VIEW
view : Model -> Html Msg
view model =
    div
    [ classList
        [ ("mini-cart", True)
        , ("mini-cart--isActive", model.cart_isOpen == True)]
    ]
    [ viewHeader model.cart_indicator
    , viewBody model]

viewHeader : CartIndicator.Model -> Html Msg
viewHeader indicator =
    div[ class "mini-cart-head" ]
    [ Html.map CartIndicatorMsg (CartIndicator.view indicator)
    , button
        [ class "mini-cart__close-button"
        , onClick (ToggleMiniCart False)
        ][ text "x" ]
    ]

viewBody : Model -> Html Msg
viewBody model =
    div[ class "mini-cart-body" ]
    [ div[ class "mini-cart-body__item-container" ]
     ( if List.length model.cart_items == 0 then
            [ p[ class "mini-cart__empty-label" ][text "You have no items in your shopping cart."] ]
         else
             ( List.map
                 (\item ->
                     div[ class "mini-cart__item" ]
                     [ div[ class "mini-cart__thumb-container" ]
                         [ img
                             [ class "mini-cart__thumb"
                             , src item.img]
                             []
                         ]
                     , div[ class "mini-cart__detail-container"]
                         [ a
                             [ class "mini-cart__item-label" 
                             , href "/"
                             ]
                             [text item.label]
                         , p[ class "mini-cart__item-variant" ][text ("Color: " ++ item.color_variant)]
                         , p[ class "mini-cart__item-variant" ][text "Finish: Dura Lite Nylon"]
                         ]
                     , itemPrice item
                     ]
                 )
             )
             model.cart_items
         )
     , viewFooter model
    ]

viewFooter : Model -> Html Msg
viewFooter model =
    div[ class "mini-cart-footer" ]
    [ div[ class "mini-cart-footer__subtotal" ]
        [ p[ class "mini-cart__subtotal__text" ][ text "Subtotal" ]
        , p[ class "mini-cart__subtotal__text" ][ text ("$" ++ String.fromFloat model.price_total ++ " USD")]
        ]
    , a
        [ class "mini-cart__checkout-btn"
        , href "/"]
        [ text "GO TO CHECKOUT" ]
    ]

itemPrice : CartItem -> Html Msg
itemPrice item =
    div[ class "mini-cart__item-price-control" ]
    [ label[ class "mini-cart__item-variant" ][text "Qty:"]
    , select
        [ class "mini-cart__qty-selector test"
        , onInput (\val -> UpdateItemQty val item)
        ]
        ( List.map (qtyOption item.qty) (List.range 1 10))
    , p[ class "mini-cart__price" ][text ("$" ++ String.fromFloat item.price ++ " USD")]
    ]

qtyOption : Int -> Int -> Html Msg
qtyOption selectedQty n =
    option
        ([ value (String.fromInt n) ]
            ++ if n == selectedQty then [ selected True ] else []
        )
        [ text (String.fromInt n) ]

-- SUBSCRIPTION
subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.batch
        [ openMiniCart ToggleMiniCart
        , recieveCartfromProduct GotCartFromPort
        ]

-- INIT
init : () -> (Model, Cmd Msg)
init _ =
    ( defaultModel, fetchCartData)

-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }