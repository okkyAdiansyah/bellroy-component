module Components.Showcase.Main exposing (main)

import Product
import Http
import Json.Decode as JD
import Browser
import Html exposing (..)
import Html.Attributes exposing (..)

-- MODEL
type alias Model = 
    { products : List Product.Model
    , errorMsg : Maybe String
    }

emptyProductModel : Product.Model
emptyProductModel=
    { activeProduct = { thumb = "", code = ""}
    , product = emptyProduct
    }

emptyProduct : Product.Product
emptyProduct =
    { productSKU = ""
    , geoID = ""
    , isAvailable = False
    , productName = ""
    , productSizeOptions = []
    , productGallery = []
    , productPrice = ""
    , productOptions = []
    }

-- MESSAGES
fetchProduct : Cmd Msg
fetchProduct =
    Http.get
        { url = "http://localhost:4321/api/products.json"
        , expect = Http.expectJson GotProducts productListDecoder
        }

type Msg
    = GotProducts ( Result Http.Error (List Product.Product) )
    | ProductMsg Int Product.Msg

-- DECODER
productListDecoder : JD.Decoder (List Product.Product)
productListDecoder =
    JD.list Product.productDecoder

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        GotProducts (Ok rawProducts) ->
            let
                productModels =
                    List.map
                        (\product ->
                            let
                                (productModel, _) = Product.update (Product.UpdateModel product) emptyProductModel
                            in
                            productModel
                        )
                        rawProducts
            in
            ( {model | products = productModels}, Cmd.none )
            
        
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
            ( {model | errorMsg = Just message}, Cmd.none )
        
        ProductMsg index subMsg ->
            let
                updatedAtIndex i list =
                    List.indexedMap
                        (\j productModel ->
                             if i == j then
                                Tuple.first (Product.update subMsg productModel)
                             else
                                productModel
                        )
                        list
            in
            ( {model | products = updatedAtIndex index model.products}, Cmd.none )
-- VIEW
view : Model -> Html Msg
view model =
    div[class "test"]
        (List.indexedMap
            (\i productModel -> 
                Html.map (ProductMsg i) (Product.view productModel)
            )
            model.products
        )

-- INIT
init : () -> (Model, Cmd Msg)
init _ =
    ({products = [], errorMsg = Nothing}, fetchProduct)

-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
