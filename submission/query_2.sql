-- Cumulative user action table by device
CREATE OR REPLACE TABLE srik1981.user_devices_cumulated (
    -- Unique ID for each user
    user_id BIGINT,
    -- Type of browser
    browser_type VARCHAR,
    -- Datelist array representing active dates
    dates_active ARRAY(DATE),
    -- Row date
    date DATE
)WITH (
    -- Store in PARQUET
    format = 'PARQUET',
    -- Partition by Array of dates.
    partitioning = ARRAY['date']
)