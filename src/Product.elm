port module Product exposing (..)

import Json.Decode as JD
import Json.Encode as JE
import SrcsetGen as Generate
import Cart
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- MODEL
type alias Spec =
    { capacity : String
    , weight : String
    , dimension : String
    , materials : String
    , composition : String
    }

type alias ColorVariant =
    { variant_code : String
    , variant_label : String
    , is_stock : Bool
    , galleries : List String
    }

type alias Variable =
    { var_label : String
    , var_sku : String
    , price : String
    , slug : String
    , subtext : String
    , color_variant : List ColorVariant
    , spec : Spec
    }

type alias Product =
    { product_label : String
    , product_video : String
    , features : List String
    , variables : List Variable
    , warranty_time : String
    }

type alias Model = 
    { product_data : Product
    , selected_variable : Variable
    , selected_variant : ColorVariant
    , add_to_cart : Cart.CartItem 
    , cart_items : List Cart.CartItem
    }

-- PORTS
port sendCartToJs : JE.Value -> Cmd msg

-- DECODER
specDecoder : JD.Decoder Spec
specDecoder =
    JD.map5 Spec
        (JD.field "capacity" JD.string)
        (JD.field "weight" JD.string)
        (JD.field "dimension" JD.string)
        (JD.field "materials" JD.string)
        (JD.field "composition" JD.string)

colorVariantDecoder : JD.Decoder ColorVariant
colorVariantDecoder =
    JD.map4 ColorVariant
        (JD.field "variant_code" JD.string)
        (JD.field "variant_label" JD.string)
        (JD.field "is_stock" JD.bool)
        (JD.field "galleries" (JD.list JD.string))

variableDecoder : JD.Decoder Variable
variableDecoder =
    JD.map7 Variable
        (JD.field "var_label" JD.string)
        (JD.field "var_sku" JD.string)
        (JD.field "price" JD.string)
        (JD.field "slug" JD.string)
        (JD.field "subtext" JD.string)
        (JD.field "color_variant" (JD.list colorVariantDecoder))
        (JD.field "spec" specDecoder)

productDecoder : JD.Decoder Product
productDecoder =
    JD.map5 Product
        (JD.field "product_label" JD.string)
        (JD.field "product_video" JD.string)
        (JD.field "features" (JD.list JD.string))
        (JD.field "variables" (JD.list variableDecoder))
        (JD.field "warranty_time" JD.string)

-- HELPER
setCartItem : Model -> Cart.CartItem
setCartItem model =
    { label = model.selected_variable.var_label
    , img =
        model.selected_variant.galleries
            |> List.head
            |> Maybe.withDefault ""
    , color_variant = model.selected_variant.variant_label
    , qty = 1
    , price = 
        model.selected_variable.price
            |> String.toFloat
            |> Maybe.withDefault 0.0
    }

updateCartItems : Cart.CartItem -> List Cart.CartItem -> List Cart.CartItem
updateCartItems newItem existingItems =
    let
        sameItem item =
            item.label == newItem.label && item.color_variant == newItem.color_variant

        updatedCart =
            case List.filter sameItem existingItems of
                [] ->
                    newItem :: existingItems
                _ ->
                    List.map
                        (\cart_item ->
                            if sameItem cart_item then
                                let
                                    newQty = cart_item.qty + newItem.qty
                                    newPrice = (cart_item.price / toFloat cart_item.qty) * toFloat newQty
                                in
                                 {cart_item | qty = newQty, price = newPrice}
                            else
                                cart_item
                        )
                        existingItems
    in
    updatedCart
    
    
    

-- DEFAULT
defaultVariable : Variable
defaultVariable =
    { var_label = ""
    , var_sku = ""
    , price = ""
    , slug = ""
    , subtext = ""
    , color_variant = []
    , spec = 
        { capacity = ""
        , weight = ""
        , dimension = ""
        , materials = ""
        , composition = ""
        }
    }

defaultProduct : Product
defaultProduct =
    { product_label = ""
    , product_video = ""
    , features = []
    , variables = []
    , warranty_time = ""
    }

defaultVariant : ColorVariant
defaultVariant = 
    { variant_code = ""
    , variant_label = ""
    , is_stock = True
    , galleries = []
    }    

defaultModel : Model
defaultModel =
    { product_data = defaultProduct
    , selected_variable = defaultVariable
    , selected_variant = defaultVariant
    , add_to_cart = Cart.defaultCartItem
    , cart_items = []
    }

-- MESSAGES
type Msg
    = SetInitModel Product
    | ChangeVariable String
    | ChangeVariant String
    | AddToCart
    
-- UPDATE
update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        SetInitModel product ->
            let
                selectedProduct =
                    product.variables
                        |> List.head
                        |> Maybe.withDefault defaultVariable
                selectedVariant =
                    selectedProduct.color_variant
                        |> List.head
                        |> Maybe.withDefault defaultVariant
                        
            in
             ( {model | product_data = product, selected_variable = selectedProduct, selected_variant = selectedVariant}, Cmd.none )
        ChangeVariable label ->
            let
                updatedVariable = 
                    model.product_data.variables
                        |> List.filter (\var -> var.var_label == label)
                        |> List.head
                        |> Maybe.withDefault defaultVariable

                updatedVariant =
                    model.selected_variable.color_variant
                        |> List.head
                        |> Maybe.withDefault defaultVariant
            in
             ( {model | selected_variable = updatedVariable, selected_variant = updatedVariant}, Cmd.none )
        ChangeVariant label ->
            let
                updatedVariant =
                    model.selected_variable.color_variant
                        |> List.filter (\variant -> variant.variant_label == label)
                        |> List.head
                        |> Maybe.withDefault defaultVariant
            in
             ( {model | selected_variant = updatedVariant}, Cmd.none )
        AddToCart ->
            let
                cartItem = setCartItem model
                updatedCarts = updateCartItems cartItem model.cart_items
                encodedCarts = Cart.encodeCart updatedCarts
            in
             ( {model | add_to_cart = cartItem, cart_items = updatedCarts}, sendCartToJs encodedCarts )

-- VIEW
view : Model -> Html Msg
view model =
    div[ class "w-full h-auto flex flex-col gap-y-4 lg:order-4" ]
    [ viewSizeSelect model
    , viewColorSelect model
    , viewAddToCart model
    ]

viewSizeSelect : Model -> Html Msg
viewSizeSelect model =
    div[ class "w-full flex flex-col gap-y-2" ]
    [ h3[ class "text-lg text-black-500 font-medium" ][text "SELECT SIZE :"]
    , select
        [ class "bg-white border-[.5px] border-gray-300 p-3 text-sm text-gray-400"
        , value model.selected_variable.var_label
        , onInput ChangeVariable
        ]
        (List.map
            (\var ->
                option [ value var.var_label ] [ text var.var_label ]
            )
            model.product_data.variables
        )
    ]
viewProductHeader : Model -> Html Msg
viewProductHeader model =
    div[ class "w-full flex flex-col gap-y-2 lg:order-1" ]
    [div[ class "w-full flex flex-col gap-y-1 border-b-2 border-b-gray-200 pb-4" ]
        [ h1[ class "text-2xl text-black-500 font-bold" ][ text model.selected_variable.var_label ]
        , h2[ class "text-lg text-black-500 font-medium" ][ text ("$" ++ model.selected_variable.price) ]]
    , p[ class "text-base text-gray-500 font-thin" ][ text model.selected_variable.subtext ]
    ]

viewColorSelect : Model -> Html Msg
viewColorSelect model =
    div [ class "w-full flex flex-col gap-y-2" ]
        [ div [ class "w-full flex gap-x-2" ]
            [ p [ class "text-lg text-black-500 font-medium" ] [ text "SELECT COLOR:" ]
            , p [ class "text-lg text-black-500 font-medium" ] [ text model.selected_variant.variant_label ]
            ]
        , div [ class "w-full h-auto grid grid-cols-5 gap-x-2" ]
            (List.map
                (\variant ->
                    let
                        imageUrl =
                            variant.galleries |> List.head |> Maybe.withDefault ""
                    in
                    button
                        [ classList
                            [ ( "aspect-square cursor-pointer border-solid border-[.5px] border-black-300", True )
                            , ( "border-orange-500"
                              , variant.variant_label == model.selected_variant.variant_label
                              )
                            ]
                        , onClick (ChangeVariant variant.variant_label)
                        ]
                        [ img
                            [ src (imageUrl ++ "?w=160&h=160")
                            , class "w-full h-full object-contain"
                            , attribute "sizes" "160vw"
                            , attribute "srcset" (Generate.generateSrcSet imageUrl ["160"])
                            ]
                            []
                        ]
                )
                model.selected_variable.color_variant
            )
        ]

viewAddToCart : Model -> Html Msg
viewAddToCart model =
    if model.selected_variant.is_stock then
        button
        [ class "w-full rounded-sm px-4 py-2 text-lg uppercase text-gray-100 bg-orange-500 font-bold shadow-lg cursor-pointer"
        , onClick AddToCart]
        [text "Add To Cart"]
    else
        button
        [ class "w-full rounded-sm px-4 py-2 text-lg uppercase text-orange-500 bg-gray-100 font-bold shadow-lg cursor-disabled"
        , disabled True
        ]
        [text "Out Of Stock"]            
            
