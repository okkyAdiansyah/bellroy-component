module Components.Single.Main exposing (main)

import Json.Decode as JD
import Http
import Browser
import Gallery
import Html exposing (..)
import Html.Attributes exposing (..)

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
    { selected_product : Variable
    , product_data : Product
    , galleries : Gallery.Model
    , errorMsg : String
    }

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

dataDecoder : JD.Decoder Product
dataDecoder = 
    JD.field "data" productDecoder

-- MESSAGES
type Msg
    = GotProducts (Result Http.Error Product)
    | GalleryControl Gallery.Msg

-- FETCH
fetchProductData : Cmd Msg
fetchProductData =
    Http.get
        { url = "http://localhost:4321/api/product/single-product.json"
        , expect = Http.expectJson GotProducts dataDecoder
        }

-- HELPER
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

defaultGallery : Gallery.Model
defaultGallery =
    { active = 0
    , contents = []
    }

defaultProduct : Product
defaultProduct =
    { product_label = ""
    , product_video = ""
    , features = []
    , variables = []
    , warranty_time = ""
    }

default : Model
default = 
    { selected_product = defaultVariable
    , product_data = defaultProduct
    , galleries = defaultGallery
    , errorMsg = ""
    }

getSelectedProduct : Product -> Variable
getSelectedProduct product =
    product.variables
        |> List.head
        |> Maybe.withDefault defaultVariable

getInitGalleriesFromSelected : Variable -> (List String)
getInitGalleriesFromSelected selected =
    selected.color_variant
        |> List.head
        |> Maybe.map .galleries
        |> Maybe.withDefault []
     
-- UPDATE
update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        GotProducts (Ok rawProducts) ->
            let
                selectedProduct = getSelectedProduct rawProducts

                (initGalleryModel, _) =
                    Gallery.update (Gallery.InitGallery (getInitGalleriesFromSelected selectedProduct)) model.galleries
            in
             ( {model | selected_product = selectedProduct, product_data = rawProducts, galleries = initGalleryModel}, Cmd.none )
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
                (updatedGalley, galleryCmd) =
                    Gallery.update subMsg model.galleries
            in
             ( {model | galleries = updatedGalley}, Cmd.map GalleryControl galleryCmd )
            
            

-- VIEW
view : Model -> Html Msg
view model =
    div[class "w-full h-auto flex flex-col p-6"]
        [
            Html.map GalleryControl (Gallery.view model.galleries)
        ]
        
-- INIT
init : () -> (Model, Cmd Msg)
init _ = 
    ( default
    , fetchProductData
    )

-- MAIN
main : Program () Model Msg
main =
    Browser.element
        { init = init
        , update = update
        , view = view
        , subscriptions = \_ -> Sub.none
        }


