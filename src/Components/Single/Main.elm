module Components.Single.Main exposing (main)

import Json.Decode as JD
import Http
import Browser
import Gallery
import Product
import Cart
import Html exposing (..)
import Html.Attributes exposing (..)
import Platform.Cmd as Cmd

-- MODEL
type alias Flags =
    { cart_items : List Cart.CartItem }

type alias Model =
    { product : Product.Model
    , galleries : Gallery.Model
    , errorMsg : String
    }

-- DECODER
dataDecoder : JD.Decoder Product.Product
dataDecoder = 
    JD.field "data" Product.productDecoder

-- MESSAGES
type Msg
    = GotProducts (Result Http.Error Product.Product)
    | GalleryControl Gallery.Msg
    | ProductMsg Product.Msg

-- FETCH
fetchProductData : Cmd Msg
fetchProductData =
    Http.get
        { url = "http://localhost:4321/api/product/single-product.json"
        , expect = Http.expectJson GotProducts dataDecoder
        }

-- HELPER
defaultGallery : Gallery.Model
defaultGallery =
    { active = 0
    , contents = []
    }
     
-- UPDATE
update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        GotProducts (Ok rawProducts) ->
            let
                (initProductModel, _) =
                    Product.update (Product.SetInitModel rawProducts) model.product

                (initGalleryModel, _) =
                    Gallery.update (Gallery.InitGallery initProductModel.selected_variant.galleries) model.galleries
            in
             ( {model | product = initProductModel, galleries = initGalleryModel}, Cmd.none )
        GotProducts (Err err) ->
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
        GalleryControl subMsg ->
            let
                (updatedGallery, galleryCmd) =
                    Gallery.update subMsg model.galleries
            in
             ( {model | galleries = updatedGallery}, Cmd.map GalleryControl galleryCmd )
        ProductMsg subMsg ->
            let
                (updatedProduct, productCmd) =
                    Product.update subMsg model.product
                (updatedGallery, galleryCmd) =
                    Gallery.update (Gallery.InitGallery updatedProduct.selected_variant.galleries) model.galleries
            in
             ( {model | product = updatedProduct, galleries = updatedGallery}
             , Cmd.batch 
                [ Cmd.map ProductMsg productCmd
                , Cmd.map GalleryControl galleryCmd
                ] 
             )
            
            
-- VIEW
view : Model -> Html Msg
view model =
    div[class "h-auto grid py-6 px-4 auto-rows-min gap-y-4 lg:gap-y-0 lg:max-w-[920px] lg:gap-x-6 lg:grid-cols-[1fr_308px] lg:grid-rows-[180px_1fr] xl:max-w-[1150px] xl:grid-cols-[1fr_376px]"]
        [ Html.map ProductMsg (Product.viewProductHeader model.product)
        , Html.map GalleryControl (Gallery.view model.galleries)
        , Html.map ProductMsg (Product.view model.product)
        ]
        
-- INIT
init : Flags -> (Model, Cmd Msg)
init cart = 
    ( { product = 
        { product_data = Product.defaultProduct
        , selected_variable = Product.defaultVariable
        , selected_variant = Product.defaultVariant
        , add_to_cart = Cart.defaultCartItem
        , cart_items = cart.cart_items
        }
      , galleries = defaultGallery
      , errorMsg = ""
      }, fetchProductData)

-- MAIN
main : Program Flags Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


