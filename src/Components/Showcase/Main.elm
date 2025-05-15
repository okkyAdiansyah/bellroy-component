module Components.Showcase.Main exposing (main)

import FeaturedProduct
import Http
import Json.Decode as JD
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL
type alias Model =
    { data : List FeaturedProduct.Model
    , errorMsg : String
    }

-- FEEDER
emptyProductModel : FeaturedProduct.Model
emptyProductModel =
    { active_product = { product_img = ""
    , product_color_code = ""
    , product_color_name = ""
    }
    , product_data = emptyProduct}

emptyProduct : FeaturedProduct.Product
emptyProduct =
    { product_sku = ""
    , is_new = False
    , product_name = ""
    , product_slug = ""
    , product_price = ""
    , product_feat = ""
    , product_options = []
    }

-- DECODER
jsonDataDecoder : JD.Decoder (List FeaturedProduct.Product)
jsonDataDecoder =
    JD.field "data" (JD.list FeaturedProduct.productDecoder)

-- MESSAGES
type Msg
    = GotProducts (Result Http.Error (List FeaturedProduct.Product))
    | UpdateProductData Int FeaturedProduct.Msg

-- FETCH
fetchProducts : Cmd Msg
fetchProducts =
    Http.get
        { url = "http://localhost:4321/api/product/featured-product.json"
        , expect = Http.expectJson GotProducts jsonDataDecoder}

-- UPDATE
update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        GotProducts (Ok rawProducts) ->
            let
                productModels =
                    List.map
                        (\product ->
                            let
                                (productModel, _) = FeaturedProduct.update (FeaturedProduct.UpdateInitialModel product) emptyProductModel
                            in
                                productModel
                        )
                        rawProducts
            in
             ( {model | data = productModels}, Cmd.none )
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
        UpdateProductData index subMsg ->
            let
                updatedAtIndex i list =
                    List.indexedMap
                        (\j products ->
                            if i == j then
                                Tuple.first (FeaturedProduct.update subMsg products)
                            else
                                products
                        )
                        list
            in
             ( {model | data = updatedAtIndex index model.data}, Cmd.none )

-- VIEW
view : Model -> Html Msg
view model =
    div[ class "w-screen h-auto px-32 py-16 flex flex-column items-center gap-x-2"]
        ( List.indexedMap
            (\i products ->
                Html.map (UpdateProductData i) (FeaturedProduct.view products)
            )
            model.data
        )

-- INIT
init : () -> (Model, Cmd Msg)
init _ =
    (
        { data = []
        , errorMsg = ""
        },
        fetchProducts
    )

-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
