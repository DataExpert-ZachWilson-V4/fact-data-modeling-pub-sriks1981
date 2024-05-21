-- Load into hosts_cumulated table
INSERT INTO srik1981.hosts_cumulated
WITH yesterday AS ( -- Select previous day's data from cumulative table
    SELECT * 
    FROM srik1981.hosts_cumulated
    WHERE date = DATE'2023-01-01'
),
today AS ( -- Select today's data from web_events table
  SELECT * 
  FROM bootcamp.web_events
  WHERE DATE(event_time) = DATE'2023-01-02'
)
-- Build the query to load into cumulative table
SELECT 
    coalesce(y.host, t.host) AS host,
    CASE 
        WHEN y.host_activity_datelist IS NOT NULL AND t.event_time IS NOT NULL THEN ARRAY[cast(t.event_time AS date)] || y.host_activity_datelist 
        WHEN t.event_time IS NOT NULL THEN ARRAY[cast(t.event_time AS date)]
        ELSE y.host_activity_datelist
    END AS host_activity_datelist,
    DATE(t.event_time) AS date -- Date which represents the row
FROM today t 
FULL OUTER JOIN yesterday y ON y.host = t.host
