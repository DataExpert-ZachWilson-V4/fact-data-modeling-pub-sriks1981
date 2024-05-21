-- Incrementally load into the table user_devices_cumulated
INSERT INTO srik1981.user_devices_cumulated
WITH yesterday AS ( -- Build data from previous day
    SELECT * 
    FROM srik1981.user_devices_cumulated
    WHERE date = DATE'2022-12-31'
),
today AS ( -- Build current day's data using the tables web_events and devices
    SELECT 
        w.user_id, 
        d.browser_type, 
        CAST(date_trunc('day', event_time) AS DATE) AS event_date
    FROM bootcamp.web_events w
    JOIN bootcamp.devices d ON w.device_id = d.device_id
    WHERE DATE(event_time) = DATE'2023-01-01'
    GROUP BY w.user_id, 
        d.browser_type, 
        CAST(date_trunc('day', event_time) AS DATE)
) -- Build the final query for loading
SELECT 
    coalesce(y.user_id, t.user_id) AS user_id,
    coalesce(y.browser_type, t.browser_type) AS browser_type,
    CASE 
        WHEN y.dates_active IS NOT NULL THEN ARRAY[t.event_date] || y.dates_active
        ELSE ARRAY[t.event_date]
    END AS dates_active,
    t.event_date AS date -- Date which represents the row
FROM today t FULL OUTER JOIN yesterday y
ON t.user_id = y.user_id