module SrcsetGen exposing (..)

type alias Size =
    { screen : String
    , size : String
    }

generateSize : Size -> String
generateSize size =
    "(min-width:" ++ size.screen ++ ") " ++ size.size

generateSizes : (List Size) -> String
generateSizes sizes =
    String.join ", " (List.map(\item -> generateSize item) sizes) ++ ", 50vw"

generateSrcSet : String -> List String -> String
generateSrcSet src sizes =
    String.join ", " (List.map(\size -> src ++ "w=" ++ size ++ "&h=" ++ size ++ " " ++ size ++ "vw") sizes)
