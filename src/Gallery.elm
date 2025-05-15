module Gallery exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

-- MODEL
type alias Content =
    { id : Int
    , url : String
    }

type alias Model =
    { active : Int
    , contents : List Content
    }

-- MESSAGES
type Msg
    = UpdateGallery (List Content)
    | ChangeActiveGallery Int
    | NextImage
    | PrevImage

-- UPDATE
update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        UpdateGallery contents ->
            let
                initialGallery : (List Content)
                initialGallery =
                    List.indexedMap(\id item ->
                        { id = id, url = item.url}
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
                        List.length model.contents
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
    div[]
        [ viewSlides model.contents
        , viewControl model.contents
        ]

viewSlides : List Content -> Html Msg
viewSlides contents =
    div[]
        [ button[ onClick NextImage ][]
        , div[]
            [ div[]
                (List.map(\item ->
                    img[src item.url][]
                )
                contents
                )
            ]
        , button[ onClick PrevImage ][]
        ]

viewControl : List Content -> Html Msg
viewControl contents =
    div[]
        (List.map(\item ->
            button[ onClick (ChangeActiveGallery item.id) ][
                img[src item.url][]
            ]
        )
        contents
        )

            