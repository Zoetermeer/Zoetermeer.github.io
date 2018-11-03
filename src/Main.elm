module Main exposing (main)

import Array as Array
import Browser
import Html exposing (Attribute, Html, button, div, h1, img, table, text, td, tr)
import Html.Attributes exposing (align, class, height, src, style)
import Html.Events exposing (onClick)
import Time

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
    { teams : Array.Array Team
    , awayTeam : Team
    , awayTeamIndex : Int
    , homeTeam : Team
    , homeTeamIndex : Int
    , awayScore : Int
    , homeScore : Int
    , awayPowerPlayMs : Int
    , homePowerPlayMs : Int
    }


allTeams : List Team
allTeams =
    [ Team "Anaheim Ducks" "Ducks" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Ducks_Primary.png"
    , Team "Arizona Coyotes" "Coyotes" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Coyotes_Primary.png"
    , Team "Boston Bruins" "Bruins" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Bruins_Primary.png"
    , Team "Buffalo Sabres" "Sabres" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Sabres_Primary.png"
    , Team "Calgary Flames" "Flames" "http://www.capsinfo.com/images/NHL_Team_Logos/calgary.png"
    , Team "Carolina Hurricanes" "Hurricanes" "http://www.capsinfo.com/images/NHL_Team_Logos/carolina.png"
    , Team "Chicago Blackhawks" "Blackhawks" "http://www.capsinfo.com/images/NHL_Team_Logos/chicago.png"
    , Team "Colorado Avalanche" "Avalanche" "http://www.capsinfo.com/images/NHL_Team_Logos/colorado.png"
    , Team "Dallas Stars" "Stars" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Stars_Primary.png"
    , Team "Detroit Red Wings" "Red Wings" "http://www.capsinfo.com/images/NHL_Team_Logos/detroit.png"
    , Team "Edmonton Oilers" "Oilers" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Oilers_Primary.png"
    , Team "Florida Panthers" "Panthers" "http://content.sportslogos.net/logos/1/13/full/8078_florida_panthers-primary-2017.png"
    , Team "Hartford Whalers" "Whalers" "https://www.clipartmax.com/png/full/10-101501_whalers-hockey-team-based-on-their-percentage-of-the-nhl-logos-hartford.png"
    , Team "Los Angeles Kings" "Kings" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Kings_Primary.png"
    , Team "Montreal Canadiens" "Canadiens" "http://www.capsinfo.com/images/NHL_Team_Logos/montreal.png"
    , Team "Nashville Predators" "Predators" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Predators_Primary.png"
    , Team "New York Islanders" "Islanders" "http://www.capsinfo.com/images/NHL_Team_Logos/NY-Islanders-Primary.png"
    , Team "New York Rangers" "Rangers" "http://www.capsinfo.com/images/NHL_Team_Logos/newyorkr.png"
    , Team "Ottawa Senators" "Senators" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Senators_Primary.png"
    , Team "Philadelphia Flyers" "Flyers" "http://www.capsinfo.com/images/NHL_Team_Logos/philadelphia.gif"
    , Team "Pittsburgh Penguins" "Penguins" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Penguins_Primary.png"
    , Team "San Jose Sharks" "Sharks" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Sharks_Primary.png"
    , Team "St. Louis Blues" "Blues" "http://www.capsinfo.com/images/NHL_Team_Logos/stlouis.png"
    , Team "Tampa Bay Lightning" "Lightning" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Lightning_Primary.png"
    , Team "Toronto Maple Leafs" "Maple Leafs" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_MapleLeafs_Primary.png"
    , Team "Vegas Golden Knights" "Knights" "http://www.stickpng.com/assets/images/5a4fbbe1da2b4f099b95da21.png"
    , Team "Vancouver Canucks" "Canucks" "assets/images/canucks_logo.svg"
    , Team "Washington Capitals" "Capitals" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Capitals_Primary.png"
    , Team "Winnipeg Jets" "Jets" "http://www.capsinfo.com/images/NHL_Team_Logos/NHL_Jets_Primary.png"
    , Team "Chicago Cubs" "Cubs" "http://www.capsinfo.com/images/MLB_Team_Logos/Chicago_Cubs.png"
    , Team "Chicago White Sox" "White Sox" "http://www.capsinfo.com/images/MLB_Team_Logos/Chicago_White_Sox.png"
    , Team "Los Angeles Dodgers" "Dodgers" "http://www.capsinfo.com/images/MLB_Team_Logos/LosAngeles_Dodgers.png"
    , Team "Milwaukee Brewers" "Brewers" "http://www.capsinfo.com/images/MLB_Team_Logos/Milwaukee_Brewers.png"

-- NFL teams
    , Team "Carolina Panthers" "Panthers" "https://www.clipartmax.com/png/full/22-220847_being-a-panthers-fan-pays-off-in-more-ways-than-one-fathead.png"
    , Team "Dallas Cowboys" "Cowboys" "https://www.clipartmax.com/png/full/120-1207993_dallas-cowboys-logo-dallas-cowboys-helmet-logo.png"
    , Team "Jacksonville Jaguars" "Jaguars" "https://www.clipartmax.com/png/full/113-1133772_its-the-day-the-jaguars-along-with-every-other-team-jacksonville-jaguars.png"
    , Team "Washington Redskins" "Redskins" "https://www.clipartmax.com/png/full/216-2169983_redskins-helmet-clip-art-washington-redskins-helmet.png"

-- Soccer teams
    , Team "FC Barcelona" "Barcelona" "https://www.clipartmax.com/png/full/98-980533_bar%C3%A7a-logo-fc-barcelona.png"
    , Team "Arsenal FC" "Arsenal" "https://www.clipartmax.com/png/full/98-980720_arsenal-fc-png.png"

-- Random
    , Team "Galactic Empire" "Empire" "https://www.clipartmax.com/png/full/42-422348_imperial-navy-star-wars-empire-png.png"
    , Team "Rebel Alliance" "Alliance" "https://www.clipartmax.com/png/full/31-313022_resistance-by-pointingmonkey-star-wars-rebel-symbol.png"
    ]


main : Program () Model Msg
main =
    Browser.element
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


init : () -> (Model, Cmd Msg)
init _ =
    let teamArray = Array.fromList allTeams
        defaultAway = forceGet teamArray 0
        defaultHome = forceGet teamArray 1
        mtModel = { teams = teamArray
                  , awayTeam = defaultAway
                  , awayTeamIndex = 0
                  , homeTeam = defaultHome
                  , homeTeamIndex = 1
                  , awayScore = 0
                  , homeScore = 0
                  , awayPowerPlayMs = 0
                  , homePowerPlayMs = 0
                  }
    in (mtModel, Cmd.none)


type TeamType = Home | Away


type Msg
  = NextTeam TeamType
  | PrevTeam TeamType
  | IncrScore TeamType
  | Reset TeamType
  | StartPowerPlay TeamType
  | StopPowerPlay TeamType
  | Tick Time.Posix


powerPlayDurationMs : Int
powerPlayDurationMs = 2 * 60 * 1000


tickInterval : Float
tickInterval = 10


subscriptions : Model -> Sub Msg
subscriptions _ = Time.every tickInterval Tick


withNoCmd : Model -> (Model, Cmd Msg)
withNoCmd model = (model, Cmd.none)


updateTeam : TeamType -> Model -> (Array.Array Team -> Int -> Int) -> Model
updateTeam tp model getNewIndex =
  let getCurIndex = if tp == Home then .homeTeamIndex else .awayTeamIndex
      (i, newTeam) = selectTeam model getNewIndex getCurIndex
  in
  case tp of
    Home ->
      { model | homeTeam = newTeam, homeTeamIndex = i }
    Away ->
      { model | awayTeam = newTeam, awayTeamIndex = i }
  

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        Tick tm ->
            let awayPPMs = max 0 (model.awayPowerPlayMs - round tickInterval)
                homePPMs = max 0 (model.homePowerPlayMs - round tickInterval)
            in ({ model | awayPowerPlayMs = awayPPMs, homePowerPlayMs = homePPMs }, Cmd.none)
        PrevTeam tp ->
          updateTeam tp model prevIndex |> withNoCmd
        NextTeam tp ->
          updateTeam tp model nextIndex |> withNoCmd
        Reset tp ->
          withNoCmd <|
          case tp of
            Home ->
              { model | homeScore = 0, homePowerPlayMs = 0 }
            Away ->
              { model | awayScore = 0, awayPowerPlayMs = 0 }
        IncrScore tp ->
          withNoCmd <|
          case tp of
            Home ->
              { model | homeScore = model.homeScore + 1 }
            Away ->
              { model | awayScore = model.awayScore + 1 }
        StartPowerPlay tp ->
          withNoCmd <|
          case tp of
            Home ->
              { model | homePowerPlayMs = powerPlayDurationMs }
            Away ->
              { model | awayPowerPlayMs = powerPlayDurationMs }
        StopPowerPlay tp ->
          withNoCmd <|
          case tp of
            Home ->
              { model | homePowerPlayMs = 0 }
            Away ->
              { model | awayPowerPlayMs = 0 }


padNum : Int -> String
padNum n =
  if n < 10 then "0" ++ Debug.toString n else Debug.toString n


toDurationStr : Int -> String
toDurationStr ms =
  let min = ms // 1000 // 60
      sec = remainderBy 60000 ms // 1000
      hms = remainderBy 1000 ms // 10
  in padNum min ++ ":" ++ padNum sec ++ "." ++ padNum hms


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
  let (awayScoreGlow, homeScoreGlow) =
        if model.awayScore == model.homeScore
        then ("", "")
        else if model.awayScore > model.homeScore
             then ("glow", "")
             else ("", "glow")
      isAwayPP = model.awayPowerPlayMs > 0
      isHomePP = model.homePowerPlayMs > 0
      awayPPMsg = if isAwayPP then (StopPowerPlay Away) else (StartPowerPlay Away)
      homePPMsg = if isHomePP then (StopPowerPlay Home) else (StartPowerPlay Home)
  in
  table [ class "scoreboard" ]
  [ tr []
    [ td [ align "center", onClick (NextTeam Away), class "noselect", style "width" "50%" ]
      [ img [ src model.awayTeam.logoUrl, height 150 ] []
      ]
    , td [ align "center", onClick (NextTeam Home), class "noselect" ]
      [ img [ src model.homeTeam.logoUrl, height 150 ] []
      ]
    ]
  , tr []
    [ td [ class "bordered-dark", style "background" "#ccc" ]
      [ teamNameDiv isAwayPP model.awayTeam.fullName ]
    , td [ class "bordered-dark", style "background" "#ccc" ]
      [ teamNameDiv isHomePP model.homeTeam.fullName ]
    ]
  , tr []
    [ td [ onClick (IncrScore Away), class ("bordered noselect scoreboard-text large-font " ++ awayScoreGlow), align "center" ]
      [ text (Debug.toString model.awayScore) ]
    , td [ onClick (IncrScore Home), class ("bordered noselect scoreboard-text large-font " ++ homeScoreGlow), align "center" ]
      [ text (Debug.toString model.homeScore) ]
    ]
  , tr []
    [ td [ class "noselect", style "background" "#ccc" ]
      [ powerPlayButton model.awayPowerPlayMs awayPPMsg ]
    , td [ class "noselect", style "background" "#ccc" ]
      [ powerPlayButton model.homePowerPlayMs homePPMsg ]
    ]
  , tr []
    [ td []
      [ decrButton (Reset Away) [ ]
      ]
    , td []
      [ decrButton (Reset Home) [ ]
      ]
    ]
  ]


teamNameDiv : Bool -> String -> Html Msg
teamNameDiv isPP name =
  let cls = if isPP then "blue-bg big-white-text" else "sunken-text" in
  div [ align "center", class cls ] [ text (String.toUpper name) ]


powerPlayButton : Int -> Msg -> Html Msg
powerPlayButton msLeft msg =
  if msLeft > 0
  then 
    div [ align "center", class "pp-button blue-bg big-white-text", onClick msg ]
        [ text ("POWER PLAY " ++ (toDurationStr msLeft)) ]
  else
    div [ align "center", class "pp-button sunken-text", onClick msg ]
        [ text "POWER PLAY" ]


decrButton : Msg -> List (Attribute Msg) -> Html Msg
decrButton msg attrs = div ([ class "btn subtract-button noselect", onClick msg ] ++ attrs) [ text "RESET" ]


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

