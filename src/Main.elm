module Main exposing (main)

import Array as Array
import Browser
import Html exposing (Attribute, Html, button, div, h1, img, table, text, td, tr)
import Html.Attributes exposing (align, class, height, src, style)
import Html.Events exposing (onClick)

type alias Team =
    { fullName : String
    , nickname : String
    , logoUrl : String
    }
    

mkTeam : String -> String -> String -> String -> String -> String -> Team
mkTeam fullName nickname logoUrl color1 color2 color3 =
    { fullName = fullName
    , nickname = nickname
    , logoUrl = logoUrl
    }


type alias Model =
    { count : Int
    , teams : Array.Array Team
    , awayTeam : Team
    , awayTeamIndex : Int
    , homeTeam : Team
    , homeTeamIndex : Int
    , awayScore : Int
    , homeScore : Int
    }


nhlTeams : List Team
nhlTeams =
    [ Team "Boston Bruins" "Bruins" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Bruins_Primary.png"
    , Team "Carolina Hurricans" "Hurricanes" "http://www.capsinfo.com/images/NHL_Team_Logos/carolina.png"
    , Team "Chicago Blackhawks" "Blackhawks" "http://www.capsinfo.com/images/NHL_Team_Logos/chicago.png"
    , Team "Colorado Avalanche" "Avalanche" "http://www.capsinfo.com/images/NHL_Team_Logos/colorado.png"
    , Team "Dallas Stars" "Stars" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Stars_Primary.png"
    , Team "Detroit Red Wings" "Red Wings" "http://www.capsinfo.com/images/NHL_Team_Logos/detroit.png"
    , Team "Los Angeles Kings" "Kings" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Kings_Primary.png"
    , Team "Montreal Canadiens" "Canadiens" "http://www.capsinfo.com/images/NHL_Team_Logos/montreal.png"
    , Team "Nashville Predators" "Predators" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Predators_Primary.png"
    , Team "New York Rangers" "Rangers" "http://www.capsinfo.com/images/NHL_Team_Logos/newyorkr.png"
    , Team "Ottawa Senators" "Senators" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Senators_Primary.png"
    , Team "Philadelphia Flyers" "Flyers" "http://www.capsinfo.com/images/NHL_Team_Logos/philadelphia.gif"
    , Team "Pittsburgh Penguins" "Penguins" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Penguins_Primary.png"
    , Team "St. Louis Blues" "Blues" "http://www.capsinfo.com/images/NHL_Team_Logos/stlouis.png"
    , Team "Toronto Maple Leafs" "Maple Leafs" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_MapleLeafs_Primary.png"
    , Team "Vegas Golden Knights" "Knights" "http://www.stickpng.com/assets/images/5a4fbbe1da2b4f099b95da21.png"
    , Team "Washington Capitals" "Capitals" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Capitals_Primary.png"
    , Team "Winnipeg Jets" "Jets" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Jets_Primary.png"
    , Team "Chicago Cubs" "Cubs" "http://www.capsinfo.com/images/MLB_Team_Logos/Chicago_Cubs.png"
    , Team "Chicago White Sox" "White Sox" "http://www.capsinfo.com/images/MLB_Team_Logos/Chicago_White_Sox.png"
    , Team "Los Angeles Dodgers" "Dodgers" "http://www.capsinfo.com/images/MLB_Team_Logos/LosAngeles_Dodgers.png"
    , Team "Milwaukee Brewers" "Brewers" "http://www.capsinfo.com/images/MLB_Team_Logos/Milwaukee_Brewers.png"

-- NFL teams
    , Team "Carolina Panthers" "Panthers" "https://www.clipartmax.com/png/full/22-220847_being-a-panthers-fan-pays-off-in-more-ways-than-one-fathead.png"
    , Team "Dallas Cowboys" "Cowboys" "https://www.clipartmax.com/png/full/120-1207993_dallas-cowboys-logo-dallas-cowboys-helmet-logo.png"
    , Team "Washington Redskins" "Redskins" "https://www.clipartmax.com/png/full/216-2169983_redskins-helmet-clip-art-washington-redskins-helmet.png"

-- Soccer teams
    , Team "FC Barcelona" "Barcelona" "https://www.clipartmax.com/png/full/98-980533_bar%C3%A7a-logo-fc-barcelona.png"
    , Team "Arsenal FC" "Arsenal" "https://www.clipartmax.com/png/full/98-980720_arsenal-fc-png.png"

-- Random
    , Team "Galactic Empire" "Empire" "https://www.clipartmax.com/png/full/42-422348_imperial-navy-star-wars-empire-png.png"
    , Team "Rebel Alliance" "Alliance" "https://www.clipartmax.com/png/full/31-313022_resistance-by-pointingmonkey-star-wars-rebel-symbol.png"
    ]

initialModel : Model
initialModel =
    let teamArray = Array.fromList nhlTeams
        defaultAway = forceGet teamArray 0
        defaultHome = forceGet teamArray 1
    in
    { count = 0
    , teams = teamArray
    , awayTeam = defaultAway
    , awayTeamIndex = 0
    , homeTeam = defaultHome
    , homeTeamIndex = 1
    , awayScore = 0
    , homeScore = 0
    }


type Msg
    = NextAwayTeam
    | PrevAwayTeam
    | NextHomeTeam
    | PrevHomeTeam
    | IncrAwayScore
    | DecrAwayScore
    | IncrHomeScore
    | DecrHomeScore
    | Decrement


update : Msg -> Model -> Model
update msg model =
    case msg of
        PrevAwayTeam ->
            let (i, newTeam) = selectTeam model prevIndex .awayTeamIndex
            in
            { model | awayTeam = newTeam, awayTeamIndex = i }
        NextAwayTeam ->
            let (i, newTeam) = selectTeam model nextIndex .awayTeamIndex
            in
            { model | awayTeam = newTeam, awayTeamIndex = i }
        PrevHomeTeam ->
            let (i, newTeam) = selectTeam model prevIndex .homeTeamIndex
            in
            { model | homeTeam = newTeam, homeTeamIndex = i }
        NextHomeTeam ->
            let (i, newTeam) = selectTeam model nextIndex .homeTeamIndex
            in
            { model | homeTeam = newTeam, homeTeamIndex = i }
        DecrAwayScore -> { model | awayScore = max 0 (model.awayScore - 1) }
        IncrAwayScore -> { model | awayScore = model.awayScore + 1 }
        DecrHomeScore -> { model | homeScore = max 0 (model.homeScore - 1) }
        IncrHomeScore -> { model | homeScore = model.homeScore + 1 }
        Decrement ->
            { model | count = model.count - 1 }


selectTeam : Model -> (Array.Array Team -> Int -> Int) -> (Model -> Int) -> (Int, Team)
selectTeam model getNewIndex getCurIndex =
    let i = getNewIndex model.teams (getCurIndex model)
        newTeam = forceGet model.teams i
    in (i, newTeam)


view : Model -> Html Msg
view model =
    div [ ]
        [ mainTable model ]


mainTable : Model -> Html Msg
mainTable model =
  table [ class "scoreboard" ]
  [ tr []
    [ td [ align "center", onClick NextAwayTeam, class "noselect", style "width" "50%" ]
      [ img [ src model.awayTeam.logoUrl, height 150 ] []
      ]
    , td [ align "center", onClick NextHomeTeam, class "noselect" ]
      [ img [ src model.homeTeam.logoUrl, height 150 ] []
      ]
    ]
  , tr []
    [ td []
      [ div [ align "center" ] [ text model.awayTeam.fullName ]
      ]
    , td []
      [ div [ align "center" ] [ text model.homeTeam.fullName ]
      ]
    ]
  , tr []
    [ td [ onClick IncrAwayScore, class "noselect scoreboard-text large-font", align "center" ]
      [ text (Debug.toString model.awayScore) ]
    , td [ onClick IncrHomeScore, class "noselect scoreboard-text large-font", align "center" ]
      [ text (Debug.toString model.homeScore) ]
    ]
  , tr []
    [ td []
      [ decrButton DecrAwayScore [ ]
      ]
    , td []
      [ decrButton DecrHomeScore [ ]
      ]
    ]
  ]


decrButton : Msg -> List (Attribute Msg) -> Html Msg
decrButton msg attrs = div ([ class "btn subtract-button noselect", onClick msg ] ++ attrs) [ text "SUBTRACT" ]


main : Program () Model Msg
main =
    Browser.sandbox
        { init = initialModel
        , view = view
        , update = update
        }


gridRow : Int -> Attribute Msg
gridRow r = style "grid-row" (Debug.toString r)


gridCol : Int -> Attribute Msg
gridCol c = style "grid-column" (Debug.toString c)


gridColSpan : Int -> Int -> Attribute Msg
gridColSpan c1 c2 = style "grid-column" (Debug.toString c1 ++ " / " ++ Debug.toString c2)


forceGet : Array.Array a -> Int -> a
forceGet xs i =
    let x = Array.get i xs in
    case x of
        Just v -> v
        _      -> Debug.todo "Cannot happen"


nextIndex : Array.Array a -> Int -> Int
nextIndex xs curInd =
    if curInd == Array.length xs - 1 then 0 else curInd + 1


prevIndex : Array.Array a -> Int -> Int
prevIndex xs curInd =
    if curInd == 0 then Array.length xs - 1 else curInd - 1

