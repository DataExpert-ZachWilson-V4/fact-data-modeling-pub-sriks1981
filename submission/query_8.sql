-- Load data into reduced fact host activity
INSERT INTO srik1981.host_activity_reduced
WITH yesterday AS ( -- Build snapshot from yesterday
    SELECT *
    FROM srik1981.host_activity_reduced
    WHERE month_start = '2023-08-01'
),
today AS ( -- Build latest snapshot
    SELECT *
    FROM srik1981.daily_web_metrics
    WHERE date = DATE'2023-08-02'
) -- Final query to load the data into the table
SELECT
    COALESCE(y.host, t.host) AS host,
    COALESCE(y.metric_name, t.metric_name) AS metric_name,
    COALESCE(y.metric_array, REPEAT(null, CAST(DATE_DIFF('day', DATE'2023-08-01', t.date) AS INTEGER))) || ARRAY[t.metric_value] AS metric_array,
    '2023-08-01' as date
FROM yesterday y
FULL OUTER JOIN today t ON y.host = t.host
    AND y.metric_name = t.metric_name