module Pagination exposing (..)

-- MODEL
type alias PaginationContext =
    { key : String
    , content : String 
    }

type alias Model =
    { active : String
    , contexts : List PaginationContext
    }

-- MESSAGES
type Msg
    = InitModel
    | ChangeActive String

-- UPDATE
update : Msg -> Model ->  ( Model, Cmd Msg )
update msg model =
    case msg of
        InitModel ->
            let
                initActive =
                    case List.head model.contexts of
                        Just ctx ->
                            ctx.content
                        Nothing ->
                            ""
            in
             ( {model | active = initActive}, Cmd.none )

        ChangeActive key ->
            let
                updatedModel = 
                    case List.head(List.filter(\item -> item.key == key) model.contexts) of
                        Just ctx ->
                            ctx.content
                        Nothing ->
                            ""
            in
             ( {model | active = updatedModel}, Cmd.none )