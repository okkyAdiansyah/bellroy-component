module FeaturedProduct exposing (..)

import Json.Decode as JD
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import SrcsetGen as Generate

-- MODEL
type alias ProductOption =
    { product_img : String
    , product_color_code : String
    , product_color_name : String
    }

type alias Product =
    { product_sku : String
    , is_new : Bool
    , product_name : String
    , product_slug : String
    , product_price : String
    , product_feat : String
    , product_options : List ProductOption
    }

type alias Model =
    { active_product : ProductOption
    , product_data : Product
    }

-- DECODER
productOptionDecoder : JD.Decoder ProductOption
productOptionDecoder =
    JD.map3 ProductOption
        (JD.field "product_img" JD.string)
        (JD.field "product_color_code" JD.string)
        (JD.field "product_color_name" JD.string)

productOptionListDecoder : JD.Decoder (List ProductOption)
productOptionListDecoder =
    JD.list productOptionDecoder

productDecoder : JD.Decoder Product
productDecoder =
    JD.map7 Product
        (JD.field "product_sku" JD.string)
        (JD.field "is_new" JD.bool)
        (JD.field "product_name" JD.string)
        (JD.field "product_slug" JD.string)
        (JD.field "product_price" JD.string)
        (JD.field "product_feat" JD.string)
        (JD.field "product_options" productOptionListDecoder)

-- HELPER
imgSizes : List Generate.Size
imgSizes =
    [ { screen = "1024px"
      , size = "25vw"
      }
    , { screen = "768px"
      , size = "33vw"
      }
    , { screen = "640px"
      , size = "50vw"}
    ]

srcSet : List String
srcSet = ["160", "240", "320", "480", "640"]

-- MESSAGES
type Msg
    = ChangeActiveOption String
    | UpdateInitialModel Product

-- UPDATE
update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateInitialModel product ->
            let
                initialActiveOption =
                    product.product_options
                        |> List.head
                        |> Maybe.withDefault 
                            { product_img = ""
                            , product_color_code = ""
                            , product_color_name = ""
                            }
            in
            
             ( {model | active_product = initialActiveOption, product_data = product}, Cmd.none )

        ChangeActiveOption code ->
            let
                updatedActiveOption = 
                    model.product_data.product_options
                        |> List.filter(\item -> item.product_color_code == code)
                        |> List.head
                        |> Maybe.withDefault model.active_product
            in
            
             ( {model | active_product = updatedActiveOption}, Cmd.none )

-- VIEW
view : Model -> Html Msg
view model =
    div[ class "relative w-full min-h-[450px] flex flex-col gap-y-2 bg-gray-50 p-3"]
        [ div[ class "w-full h-auto flex items-center justify-center aspect-square"]
            [ img[ class "w-full h-full max-h-[400px] object-contain"
                 , src model.active_product.product_img
                 , attribute "sizes" (Generate.generateSizes imgSizes)
                 , attribute "srcset" (Generate.generateSrcSet model.active_product.product_img srcSet)
                 , alt (model.product_data.product_name ++ " - " ++ model.active_product.product_color_name)
                 , attribute "loading" "lazy"
                 , title (model.product_data.product_name ++ " - " ++ model.active_product.product_color_name)
                 ][]
            ]
        , p[ class "w-fit p-2 text-sm text-white font-bold rounded-sm" 
            , if model.product_data.is_new then
                class "bg-[#88B2AB]"
              else
                class ""
            ][text "New"]
        , a[ class "w-full flex flex-col mt-2"
           , href "/"]
            [ p[ class "text-base text-gray-400 capitalize"][text model.product_data.product_name]
            , p[ class "text-sm text-gray-600 uppercase font-bold" ][text ("$" ++ model.product_data.product_price)]
            , span[ class "absolute inset-0 z-10" ][]
            ]
        , viewOptionControl model model.product_data.product_options
        , p[ class "text-sm text-gray-500 font-base w-[75%] text-left line-clamp-3" ][text model.product_data.product_feat]
        ]

viewOptionControl : Model -> List ProductOption -> Html Msg
viewOptionControl model options =
    div [ class "w-full flex gap-x-3 mt-2 relative z-20" ]
        (List.map (\item ->
            let
                isSelected = item.product_color_code == model.active_product.product_color_code

                baseAtt =
                    [ onClick (ChangeActiveOption item.product_color_code)
                    , class "w-4 h-4 rounded-full cursor-pointer"
                    , style "background-color" item.product_color_code
                    , attribute "role" "radio"
                    , attribute "aria-checked" (if isSelected then "true" else "false")
                    , title item.product_color_name
                    ]

                selectedAtt =
                    if isSelected then
                        [ style "border" ("solid 1px " ++ item.product_color_code)
                        , style "box-shadow" "inset 0px 0px 0px 1.8px oklch(98.5% 0.002 247.839)" ]
                    else
                        []
            in
            button (baseAtt ++ selectedAtt) []
        ) options)