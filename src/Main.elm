module Main exposing (main)

import Array as Array
import Browser
import Html exposing (Attribute, Html, button, div, h1, img, text)
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
    , Team "Chicago Blackhawks" "Blackhawks" "http://www.capsinfo.com/images/NHL_Team_Logos/chicago.png"
    , Team "Dallas Stars" "Stars" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Stars_Primary.png"
    , Team "Detroit Red Wings" "Red Wings" "http://www.capsinfo.com/images/NHL_Team_Logos/detroit.png"
    , Team "New York Rangers" "Rangers" "http://www.capsinfo.com/images/NHL_Team_Logos/newyorkr.png"
    , Team "Philadelphia Flyers" "Flyers" "http://www.capsinfo.com/images/NHL_Team_Logos/philadelphia.gif"
    , Team "Pittsburgh Penguins" "Penguins" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Penguins_Primary.png"
    , Team "Toronto Maple Leafs" "Maple Leafs" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_MapleLeafs_Primary.png"
    , Team "Chicago Cubs" "Cubs" "http://www.capsinfo.com/images/MLB_Team_Logos/Chicago_Cubs.png"
    , Team "Chicago White Sox" "White Sox" "http://www.capsinfo.com/images/MLB_Team_Logos/Chicago_White_Sox.png"
    , Team "Los Angeles Dodgers" "Dodgers" "http://www.capsinfo.com/images/MLB_Team_Logos/LosAngeles_Dodgers.png"
    , Team "Milwaukee Brewers" "Brewers" "http://www.capsinfo.com/images/MLB_Team_Logos/Milwaukee_Brewers.png"
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
    div [ class "scoreboard" ]
				[ mainTable model ]


mainTable : Model -> Html Msg
mainTable model =
  table []
  [ tr []
    [ td [ align "center", onClick NextAwayTeam, class "noselect" ]
      [ img [ src model.awayTeam.logoUrl, height 150 ] []
      ]
    , td [ align "center", onClick NextHomeTeam, class "noselect" ]
      [ img [ src model.homeTeam.logoUrl ] []
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
    [ td []
      [ h1 [ onClick IncrAwayScore, class "btn noselect", align "center", class "scoreboard-text large-font" ] [ text (Debug.toString model.awayScore) ]       
      ]
    , td []
      [ h1 [ onClick IncrHomeScore, class "btn noselect", align "center", class "scoreboard-text large-font", gridRow 3, gridColSpan 4 7 ] [ text (Debug.toString model.homeScore) ]
      ]
    ]
  , tr []
    [ td []
      [ decrButton DecrAwayScore [ gridRow 4, gridCol 2 ]
      ]
    , td []
      [ decrButton DecrHomeScore [ gridRow 4, gridCol 5 ]
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

