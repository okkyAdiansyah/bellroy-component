module Mini exposing (..)


import Browser
import Html exposing (Html, div, button, text, select, img, option)
import Html.Events exposing (onClick, onInput)
import Html.Attributes exposing (class, style, width, height, value, src)

--Main
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }

init : () -> ( Model, Cmd Msg )
init _ = 
    ( { isOpen = True
        , items = 
            [ { id = 1
                , img = "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/BIVA-BLK-228/0?auto=format&h=60&w=90"
                , detail = {
                    color = "black"
                    , finish = "black"
                }
                , price = 89.96
                , qty = 1
             } 
             , { id = 2
                , img = "https://bellroy-product-images.imgix.net/bellroy_dot_com_range_page_image/USD/BIVA-BLK-228/0?auto=format&h=60&w=90"
                , detail = {
                    color = "black"
                    , finish = "black"
                }
                , price = 89.96
                , qty = 1
              }
             ]
     }, Cmd.none )

-- Model
type alias Item =
    {
        id: Int,
        img: String,
        detail: {
            color: String,
            finish: String
        },
        price: Float,
        qty: Int
    }

type alias Model =
    {
        isOpen: Bool,
        items : List Item
    }

--Msg
type Msg
    = ToggleCart
    | RemoveItem Int
    | SetQty Int String --itemId and selected value

--Update
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of 
        ToggleCart ->
            ( { model | isOpen = not model.isOpen }, Cmd.none )
        RemoveItem id ->
            ( { model | items = List.filter (\item -> item.id /= id) model.items }, Cmd.none )
        SetQty id qtyStr ->
            case String.toInt qtyStr of
                Just qty ->
                    let 
                        updatedItems =
                            List.map (updateQty id qty) model.items
                    in
                    ( { model | items = updatedItems }, Cmd.none )
                Nothing ->
                    (model, Cmd.none)

updateQty : Int -> Int -> Item -> Item
updateQty targetId newQty item =
    if item.id == targetId then
        { item | qty = max 1 newQty }
    else
        item
        
--View
view : Model -> Html Msg
view model = 
    div []
        [ button [ onClick ToggleCart ] [ text (if model.isOpen then "Close Cart" else "Open Cart") ]
        , if model.isOpen then
            div [ class "mini-cart" ]
                (List.map viewItem model.items ++ [ viewTotal model.items ])
          else
            text ""
        ]

viewItem : Item -> Html Msg
viewItem item =
    div [ class "cart-item", style "margin" "1rem 0" ]
        [ img [ src item.img, width 80, height 80 ] []
        , div [] [ text (item.detail.color ++ " / " ++ item.detail.finish) ]
        , div [] [ text ("$" ++ String.fromFloat item.price) ]
        , select
            [ onInput (\val -> SetQty item.id val) ]
            (List.map qtyOption (List.range 1 10))
        , button [ onClick (RemoveItem item.id) ] [ text "Remove" ]
        ]

viewTotal : List Item -> Html Msg
viewTotal items =
    let
        total =
            List.foldl (\item acc -> acc + (item.price * toFloat item.qty)) 0 items
    in
    div [ class "total", style "margin-top" "1rem" ]
        [ text ("Total: $" ++ String.fromFloat total) ]

qtyOption : Int -> Html Msg
qtyOption n =
    option [ value (String.fromInt n) ] [ text (String.fromInt n) ]