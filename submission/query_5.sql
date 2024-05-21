-- Cumulative table for host activity tracking
CREATE OR REPLACE TABLE srik1981.hosts_cumulated (
    -- Host Name
    host VARCHAR,
    -- Host activity datelist array
    host_activity_datelist ARRAY(DATE),
    -- Date the row represents
    date DATE
)
WITH (
    -- Store in PARQUET
    format = 'PARQUET',
    -- Partition by Array of dates.
    partitioning = ARRAY['date']
)