module Gallery exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import SrcsetGen as Generate

-- MODEL
type alias Content = 
    { id: Int
    , url: String
    }
    
type alias Model =
    { active : Int
    , contents : List Content
    }

-- HELPER
srcSet : List String
srcSet = ["750", "1000", "1200", "1500"]

-- MESSAGES
type Msg
    = InitGallery (List String)
    | ChangeActiveGallery Int
    | NextImage
    | PrevImage

-- UPDATE
update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        InitGallery contents ->
            let
                initialGallery =
                    List.indexedMap(\id url ->
                        { id = id, url = url}
                    )
                    contents
            in
            ( {model | active = 0, contents = initialGallery}, Cmd.none )
        ChangeActiveGallery id ->
            ( {model | active = id}, Cmd.none )
        NextImage ->
            let
                updatedId = 
                    if model.active + 1 >= List.length model.contents then
                        List.length model.contents - 1
                    else
                        model.active + 1
            in
            ( {model | active = updatedId}, Cmd.none )
        PrevImage ->
            let
                updatedId = 
                    if model.active - 1 < 0 then
                        0
                    else
                        model.active - 1
            in
            ( {model | active = updatedId}, Cmd.none )

-- VIEW
view : Model -> Html Msg
view model =
    div[ class "h-auto gap-y-2 flex flex-col lg:col-start-1 lg:row-start-1 lg:row-span-2"]
        [ viewSlides model.contents model
        , viewControl model.contents model
        ]

viewSlides : List Content -> Model -> Html Msg
viewSlides contents model =
    div[ class "w-full h-auto flex items-center gap-x-4 relative" ]
        [ button
            [ onClick PrevImage
            , class "transparent text-[48px] flex items-center justify-center text-gray-500 absolute left-0 p-1 cursor-pointer z-[799] lg:hidden"]
            [text "<"]
        , div[ class "w-full h-auto flex items-center overflow-x-scroll lg:overflow-x-hidden" ]
            [ div
                [ class "w-full h-auto flex items-center transition-transform duration-500 ease-in-out"
                , style "transform" ("translateX(-" ++ String.fromInt (model.active * 100) ++ "%)")]
                    (List.map(\item ->
                        div[ class "w-full h-auto aspect-[3/2] shrink-0 lg:aspect-square" ]
                         [ img
                            [ src (item.url ++ "w=750&h=750")
                            , class "w-full h-full object-contain"
                            , alt ""
                            , height 750
                            , width 750
                            , attribute "sizes" "750vw"
                            , attribute "srcset" (Generate.generateSrcSet item.url srcSet)][]
                         ]
                    )
                    contents
                    )
            ]
        , button
            [ onClick NextImage
            , class "transparent text-[48px] flex items-center justify-center text-gray-500 absolute right-0 p-1 cursor-pointer z-[799] lg:hidden"]
            [ text ">"]
        ]

viewControl : List Content -> Model -> Html Msg
viewControl contents model=
    div[ class "w-full h-auto hidden lg:grid lg:grid-cols-9 lg:grid-rows-2 lg:gap-2 " ]
        (List.map(\item ->
            button
            [ onClick (ChangeActiveGallery item.id)
            , classList
                    [ ("aspect-square cursor-pointer", True)
                    , ("border-b-3 border-orange-500 border-solid", item.id == model.active)
                    ]
            ][
                img
                [ src (item.url ++ "w=160&h=160")
                , class "w-full h-full object-contain"
                , attribute "sizes" "160vw"
                , attribute "srcset" (Generate.generateSrcSet item.url ["160"])]
                []
            ]
        )
        contents
        )

            