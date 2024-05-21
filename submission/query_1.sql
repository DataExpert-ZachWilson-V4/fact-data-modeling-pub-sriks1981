-- Build a CTE which selects all columns from bootcamp.nba_game_details and ranks each row base don the combination of 
-- game_id, player_id and team_id
WITH dedup AS (
    SELECT 
        *, 
        row_number() OVER (PARTITION BY game_id, player_id, team_id 
            ORDER BY game_id, player_id, team_id) AS rn
    FROM bootcamp.nba_game_details
)
-- Select all the columns except the ranked column 
--  filter out only the first row from the group of duplicates
SELECT
    game_id, team_id, team_abbreviation, team_city, player_id, 
    player_name, nickname, start_position, comment, min, fgm, fga,
    fg_pct, fg3m, fg3a, fg3_pct, ftm, fta, ft_pct, oreb, dreb, 
    reb, ast, stl, blk, to,pf,pts, plus_minus
FROM dedup 
WHERE rn = 1 -- Select only the first value
