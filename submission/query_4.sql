-- Build a CTE of previous day snapshot
WITH today AS (
    SELECT * 
    FROM srik1981.user_devices_cumulated
    WHERE date = DATE'2023-01-07'
),
date_list_int AS ( -- Build the CTE for 
    SELECT 
        user_id,
        browser_type,
        CAST(SUM(
            CASE 
                WHEN CONTAINS(dates_active, sequence_date) THEN
                    POW(2, 31 - DATE_DIFF('day', sequence_date, date))
                ELSE 0
            END ) 
        AS BIGINT) AS history_int
    FROM today
    CROSS JOIN UNNEST(SEQUENCE(DATE('2023-01-01'), DATE('2023-01-07'))) AS t(sequence_date)
    GROUP BY 
        user_id,
        browser_type
)
SELECT -- Final query to convert the date list implementation to base-2 integer datelist representation
    *,
    to_base(history_int,2) AS history_in_binary,
    to_base(from_base('11111110000000000000000000000000', 2), 2) AS weekly_base,
    BIT_COUNT(history_int, 64) AS num_days_active,
    BIT_COUNT(BITWISE_AND(history_int, FROM_BASE('11111110000000000000000000000000', 2)), 64) > 0 AS is_weekly_active,
    BIT_COUNT(BITWISE_AND(history_int,FROM_BASE('00000001111111000000000000000000', 2)),64) > 0 AS is_weekly_active_last_week,
    BIT_COUNT(BITWISE_AND(history_int, FROM_BASE('11100000000000000000000000000000', 2)), 64) > 0 AS is_active_in_last_3_days
FROM date_list_int