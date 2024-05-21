-- Create table for tracking reduced fact host activity
CREATE OR REPLACE TABLE srik1981.host_activity_reduced (
    -- HOst name
    host VARCHAR,
    -- Name of the metric
    metric_name VARCHAR,
    -- Tracking when active
    metric_array ARRAY(INTEGER),
    -- Start of month
    month_start VARCHAR
)
WITH (
    -- PARQUET format
    format = 'PARQUET',
    -- Partitioning stratergy
    partitioning = ARRAY['metric_name','month_start']
)