WITH activity_periods AS (
    SELECT
        user_id,
        date,
        log,
        ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY date) -
        ROW_NUMBER() OVER (PARTITION BY user_id, log ORDER BY date) AS period_id
    FROM
        users_log
),
activity_periods_summary AS (
    SELECT
        user_id,
        MIN(date) AS start_date,
        MAX(date) AS end_date,
        log,
        COUNT(*) AS length
    FROM
        activity_periods
    GROUP BY
        user_id,
        log,
        period_id
)
SELECT
    user_id,
    start_date,
    end_date,
    log,
    SUM(length) AS length
FROM
    activity_periods_summary
GROUP BY
    user_id,
    start_date,
    end_date,
    log
ORDER BY
    user_id,
    start_date,
    end_date;
