module Main exposing (main)

import Array as Array
import Browser
import Html exposing (Attribute, Html, br, button, div, h1, img, span, table, text, td, tr)
import Html.Attributes exposing (align, class, height, src, style)
import Html.Events exposing (onClick)
import Time

type alias Team =
    { city : String
    , fullName : String
    , nickname : String
    , logoUrl : String
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


defaultHome : Team
defaultHome = Team "Anaheim" "Anaheim Ducks" "Ducks" "assets/images/anaheim-ducks.svg"


defaultAway : Team
defaultAway = Team "Arizona" "Arizona Coyotes" "Coyotes" "assets/images/arizona-coyotes.svg"


allTeams : List Team
allTeams =
    [ defaultHome
    , defaultAway
    , Team "Boston" "Boston Bruins" "Bruins" "assets/images/boston-bruins.svg"
    , Team "Buffalo" "Buffalo Sabres" "Sabres" "assets/images/buffalo-sabres.svg"
    , Team "Calgary" "Calgary Flames" "Flames" "assets/images/calgary-flames.svg"
    , Team "Carolina" "Carolina Hurricanes" "Hurricanes" "assets/images/carolina-hurricanes.svg"
    , Team "Chicago" "Chicago Blackhawks" "Blackhawks" "assets/images/chicago-blackhawks.svg"
    , Team "Chicago" "Falcons" "Falcons" "assets/images/falcons.jpg"
    , Team "Colorado" "Colorado Avalanche" "Avalanche" "assets/images/colorado-avalanche.svg"
    , Team "Columbus" "Columbus Blue Jackets" "Blue Jackets" "assets/images/columbus-blue-jackets.svg"
    , Team "Dallas" "Dallas Stars" "Stars" "assets/images/dallas-stars.svg"
    , Team "Detroit" "Detroit Red Wings" "Red Wings" "assets/images/detroit-red-wings.svg"
    , Team "Edmonton" "Edmonton Oilers" "Oilers" "assets/images/edmonton-oilers.svg"
    , Team "Florida" "Florida Panthers" "Panthers" "assets/images/florida-panthers.svg"
    , Team "Glacier" "Glacier Ice Dogs" "Ice Dogs" "assets/images/glacier-ice-dogs.png"
    , Team "Hartford" "Hartford Whalers" "Whalers" "assets/images/hartford-whalers.svg"
    , Team "Los Angeles" "Los Angeles Kings" "Kings" "assets/images/los-angeles-kings.svg"
    , Team "Minnesota" "Minnesota Wild" "Wild" "assets/images/minnesota-wild.svg"
    , Team "Montreal" "Montreal Canadiens" "Canadiens" "assets/images/montreal-canadiens.svg"
    , Team "Nashville" "Nashville Predators" "Predators" "assets/images/nashville-predators.svg"
    , Team "New Jersey" "New Jersey Devils" "Devils" "assets/images/new-jersey-devils.svg"
    , Team "New York" "New York Islanders" "Islanders" "assets/images/ny-islanders.svg"
    , Team "New York" "New York Rangers" "Rangers" "assets/images/ny-rangers.svg"
    , Team "North Shore" "Cyclones" "Cyclones" "assets/images/cyclones.png"
    , Team "Northwest" "Northwest Chargers" "Chargers" "assets/images/northwest-chargers.png"
    , Team "Ottawa" "Ottawa Senators" "Senators" "assets/images/ottawa-senators.svg"
    , Team "Philadelphia" "Philadelphia Flyers" "Flyers" "assets/images/philadelphia-flyers.svg"
    , Team "Pittsburgh" "Pittsburgh Penguins" "Penguins" "assets/images/pittsburgh-penguins.svg"
    , Team "Quebec" "Quebec Nordiques" "Nordiques" "assets/images/quebec-nordiques.svg"
    , Team "San Jose" "San Jose Sharks" "Sharks" "assets/images/san-jose-sharks.svg"
    , Team "St. Louis" "St. Louis Blues" "Blues" "assets/images/st-louis-blues.svg"
    , Team "Tampa Bay" "Tampa Bay Lightning" "Lightning" "assets/images/tampa-bay-lightning.svg"
    , Team "Toronto" "Toronto Maple Leafs" "Leafs" "assets/images/toronto-maple-leafs.svg"
    , Team "Vancouver" "Vancouver Canucks" "Canucks" "assets/images/vancouver-canucks.svg"
    , Team "Vegas" "Vegas Golden Knights" "Knights" "assets/images/las-vegas-knights.svg"
    , Team "Washington" "Washington Capitals" "Capitals" "assets/images/washington-capitals.svg"
    , Team "Winnipeg" "Winnipeg Jets" "Jets" "assets/images/winnipeg-jets.svg"

-- MLB teams
    , Team "Arizona" "Arizona Diamondbacks" "Diamondbacks" "assets/images/arizona-diamondbacks.svg"
    , Team "Atlanta" "Atlanta Braves" "Braves" "assets/images/atlanta-braves.svg"
    , Team "Baltimore" "Baltimore Orioles" "Orioles" "assets/images/baltimore-orioles.svg"
    , Team "Boston" "Boston Red Sox" "Red Sox" "assets/images/boston-red-sox.svg"
    , Team "Chicago" "Chicago Cubs" "Cubs" "assets/images/chicago-cubs.svg"
    , Team "Chicago" "Chicago White Sox" "White Sox" "assets/images/chicago-white-sox.svg"
    , Team "Cincinnati" "Cincinnati Reds" "Reds" "assets/images/cincinnati-reds.svg"
    , Team "Cleveland" "Cleveland Indians" "Indians" "assets/images/cleveland-indians.svg"
    , Team "Colorado" "Colorado Rockies" "Rockies" "assets/images/colorado-rockies.svg"
    , Team "Detroit" "Detroit Tigers" "Tigers" "assets/images/detroit-tigers.svg"
    , Team "Houston" "Houston Astros" "Astros" "assets/images/houston-astros.svg"
    , Team "Kansas City" "Kansas City Royals" "Royals" "assets/images/kc-royals.svg"
    , Team "Los Angeles" "Los Angeles Angels" "Angels" "assets/images/la-angels.svg"
    , Team "Los Angeles" "Los Angeles Dodgers" "Dodgers" "assets/images/la-dodgers.svg"
    , Team "Miami" "Miami Marlins" "Marlins" "assets/images/miami-marlins.svg"
    , Team "Milwaukee" "Milwaukee Brewers" "Brewers" "assets/images/milwaukee-brewers.svg"
    , Team "Minnesota" "Minnesota Twins" "Twins" "assets/images/minnesota-twins.svg"
    , Team "New York" "New York Mets" "Mets" "assets/images/new-york-mets.svg"
    , Team "New York" "New York Yankees" "Yankees" "assets/images/ny-yankees.svg"
    , Team "Oakland" "Oakland Athletics" "Athletics" "assets/images/oakland-athletics.svg"
    , Team "Philadelphia" "Philadelphia Phillies" "Phillies" "assets/images/philadelphia-phillies.svg"
    , Team "Pittsburgh" "Pittsburgh Pirates" "Pirates" "assets/images/pittsburgh-pirates.svg"
    , Team "San Francisco" "San Francisco Giants" "Giants" "assets/images/sf-giants.svg"
    , Team "San Diego" "San Diego Padres" "Padres" "assets/images/san-diego-padres.svg"
    , Team "Seattle" "Seattle Mariners" "Mariners" "assets/images/seattle-mariners.svg"
    , Team "St. Louis" "St. Louis Cardinals" "Cardinals" "assets/images/st-louis-cardinals.svg"
    , Team "Tampa Bay" "Tampa Bay Rays" "Rays" "assets/images/tb-rays.svg"
    , Team "Texas" "Texas Rangers" "Rangers" "assets/images/texas-rangers.svg"
    , Team "Toronto" "Toronto Blue Jays" "Blue Jays" "assets/images/toronto-blue-jays.svg"
    , Team "Washington" "Washington Nationals" "Nationals" "assets/images/washington-nationals.svg"

-- NFL teams
    , Team "Carolina" "Carolina Panthers" "Panthers" "assets/images/carolina-panthers.svg"
    , Team "Dallas" "Dallas Cowboys" "Cowboys" "assets/images/dallas-cowboys.svg"
    , Team "Jacksonville" "Jacksonville Jaguars" "Jaguars" "assets/images/jacksonville-jaguars.svg"
    , Team "Los Angeles" "Los Angeles Rams" "Rams" "assets/images/los-angeles-rams.svg"
    , Team "Minnesota" "Minnesota Vikings" "Vikings" "assets/images/minnesota-vikings.svg"
    , Team "New England" "New England Patriots" "Patriots" "assets/images/new-england-patriots.svg"
    , Team "Oakland" "Oakland Raiders" "Raiders" "assets/images/oakland-raiders.svg"
    , Team "Philadelphia" "Philadelphia Eagles" "Eagles" "assets/images/philadelphia-eagles.svg"
    , Team "Tennessee" "Tennessee Titans" "Titans" "assets/images/tennessee-titans.svg"
    , Team "Washington" "Washington Redskins" "Redskins" "assets/images/washington-redskins.svg"

-- Soccer teams
    , Team "FC" "FC Barcelona" "Barcelona" "https://www.clipartmax.com/png/full/98-980533_bar%C3%A7a-logo-fc-barcelona.png"
    , Team "The" "Arsenal FC" "Arsenal" "https://www.clipartmax.com/png/full/98-980720_arsenal-fc-png.png"
    , Team "Liverpool" "Liverpool" "" "assets/images/liverpool.svg"
    , Team "Tottenham" "Tottenham Hostpur" "Hotspur" "assets/images/tottenham-hotspur.svg"

-- Random
    , Team "Galactic" "Galactic Empire" "Empire" "https://www.clipartmax.com/png/full/42-422348_imperial-navy-star-wars-empire-png.png"
    , Team "Rebel" "Rebel Alliance" "Alliance" "https://www.clipartmax.com/png/full/31-313022_resistance-by-pointingmonkey-star-wars-rebel-symbol.png"
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
  if n < 10 then "0" ++ String.fromInt n else String.fromInt n


toDurationStr : Int -> String
toDurationStr ms =
  let min = ms // 1000 // 60
      sec = remainderBy 60000 ms // 1000
      hms = remainderBy 1000 ms // 10
  in padNum min ++ ":" ++ padNum sec ++ "." ++ padNum hms


selectTeam : Model -> (Array.Array Team -> Int -> Int) -> (Model -> Int) -> (Int, Team)
selectTeam model getNewIndex getCurIndex =
    let i = getNewIndex model.teams (getCurIndex model)
        newTeam = Array.get i model.teams
    in
    case newTeam of
      Nothing -> (0, defaultHome)
      Just team -> (i, team)


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
      [ img [ class "noselect", src model.awayTeam.logoUrl, style "height" "150px", style "max-width" "150px" ] []
      ]
    , td [ align "center", onClick (NextTeam Home), class "noselect", style "width" "50%" ]
      [ img [ src model.homeTeam.logoUrl, style "max-height" "150px", style "max-width" "150px", style "width" "auto", style "height" "auto"] []
      ]
    ]
  , tr []
    [ td [ class "bordered-dark", style "background" "#ccc" ]
      [ teamNameDiv isAwayPP model.awayTeam ]
    , td [ class "bordered-dark", style "background" "#ccc" ]
      [ teamNameDiv isHomePP model.homeTeam ]
    ]
  , tr []
    [ td [ onClick (IncrScore Away), class ("bordered noselect scoreboard-text large-font " ++ awayScoreGlow), align "center" ]
      [ text (String.fromInt model.awayScore) ]
    , td [ onClick (IncrScore Home), class ("bordered noselect scoreboard-text large-font " ++ homeScoreGlow), align "center" ]
      [ text (String.fromInt model.homeScore) ]
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


teamNameDiv : Bool -> Team -> Html Msg
teamNameDiv isPP team =
  let cls = if isPP then "blue-bg big-white-text" else "sunken-text" in
  div [ align "center", class cls ]
      [ span [ style "font-size" ".3em" ] [ text (String.toUpper team.city) ]
      , br [] []
      ,  text (String.toUpper team.nickname) ]


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


nextIndex : Array.Array a -> Int -> Int
nextIndex xs curInd =
    if curInd == Array.length xs - 1 then 0 else curInd + 1


prevIndex : Array.Array a -> Int -> Int
prevIndex xs curInd =
    if curInd == 0 then Array.length xs - 1 else curInd - 1

