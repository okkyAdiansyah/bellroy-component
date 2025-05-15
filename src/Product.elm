module Product exposing (..)

import Json.Decode as JD
import Html exposing (..)
import Html.Events exposing (..)
import Html.Attributes exposing (..)

-- MODEL
-- type alias ProductOption = 
--     { optionColor : String
--     , optionImg : String 
--     , optionCode : String 
--     }

-- type alias SizeOption = 
--     { sizeCode : String
--     , sizeLabel : String 
--     }

-- type alias Product =
--     { productSKU : String
--     , geoID : String
--     , isAvailable : Bool
--     , productName : String
--     , productSizeOptions : List SizeOption
--     , productGallery : List String
--     , productPrice : String
--     , productOptions : List ProductOption }

-- type alias ActiveProductOption = 
--     { thumb : String
--     , code : String
--     }

-- type alias Model = 
--     { activeProduct : ActiveProductOption
--     , product : Product}

--DECODER
productOptionDecoder : JD.Decoder ProductOption
productOptionDecoder = 
    JD.map3 ProductOption
        (JD.field "optionColor" JD.string)
        (JD.field "optionImg" JD.string)
        (JD.field "optionCode" JD.string)

productOptionListDecoder : JD.Decoder (List ProductOption)
productOptionListDecoder =  
    JD.list productOptionDecoder

sizeOptionDecoder : JD.Decoder SizeOption
sizeOptionDecoder = 
    JD.map2 SizeOption
        (JD.field "sizeCode" JD.string)
        (JD.field "sizeLabel" JD.string)

sizeOptionListDecoder : JD.Decoder (List SizeOption)
sizeOptionListDecoder = 
    JD.list sizeOptionDecoder

productDecoder : JD.Decoder Product
productDecoder = 
    JD.map8 Product
        (JD.field "productSKU" JD.string)
        (JD.field "geoID" JD.string)
        (JD.field "isAvailable" JD.bool)
        (JD.field "productName" JD.string)
        (JD.field "productSizeOptions" sizeOptionListDecoder)
        (JD.field "productGallery" (JD.list JD.string))
        (JD.field "productPrice" JD.string)
        (JD.field "productOptions" productOptionListDecoder)

-- HELPER
productOptionToActive : ProductOption -> ActiveProductOption
productOptionToActive option =
    { thumb = option.optionImg
    , code = option.optionCode
    }

colorCode : String -> String
colorCode code =
    "bg-[#" ++ code ++ "]"

-- MESSAGES
type Msg
    = ChangeProductOption String
    | UpdateModel Product

-- UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        ChangeProductOption code ->
            let
                updatedActiveOption =
                    model.product.productOptions
                        |> List.filter(\item -> item.optionCode == code)
                        |> List.head
                        |> Maybe.map productOptionToActive
                        |> Maybe.withDefault model.activeProduct
            in
            ({model | activeProduct = updatedActiveOption}, Cmd.none)
        UpdateModel product ->
            let
                activeOption =
                    product.productOptions
                        |> List.head
                        |> Maybe.map productOptionToActive
                        |> Maybe.withDefault {thumb = "", code = ""}
            in
            ({ model | activeProduct = activeOption, product = product }, Cmd.none)
            
-- VIEW
view : Model -> Html Msg
view model =
    a[ class "w-full flex flex-col gap-y-2 bg-gray-50 p-3"
     , href ("/product/" ++ model.product.productSKU)
     ]
        [ div[ class "w-full h-auto flex items-center justify-center" ][
            img[ src model.activeProduct.thumb
            , class "w-full h-[400px] object-contain" ][]
        ]
        , div[ class "w-full flex flex-col mt-2"][
             p[ class "text-base text-gray-400 capitalize"][text model.product.productName]
            ,p[ class "text-sm text-gray-600 uppercase font-bold" ][text ("$" ++ model.product.productPrice)] 
        ]
        , viewControl model
    ]

viewControl : Model -> Html Msg
viewControl model =
    div[ class "w-full flex gap-x-3 mt-2 relative z-20" ]
        (List.map
            (\item ->
                let
                    baseAtt =
                        [ onClick (ChangeProductOption item.optionCode)
                        , class "w-4 h-4 rounded-full cursor-pointer"
                        , style "background-color" ("#" ++ item.optionCode)
                        ]
                    activeAtt =
                        if item.optionCode == model.activeProduct.code then
                            [ style "border" ("solid 1px #" ++ item.optionCode)
                            , style "box-shadow" "inset 0px 0px 0px 1.8px oklch(98.5% 0.002 247.839)"
                            ]
                        else
                            []
                in
                button (baseAtt ++ activeAtt)[]
            )
            model.product.productOptions
        )