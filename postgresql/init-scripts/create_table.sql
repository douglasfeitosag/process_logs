CREATE TABLE offsets
(
    metric_name TEXT PRIMARY KEY,
    last_offset BIGINT NOT NULL DEFAULT 0
);