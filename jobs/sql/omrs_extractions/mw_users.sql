-- Extract user accounts from OpenMRS
SELECT
    u.user_id,
    u.username,
    pn.given_name AS first_name,
    pn.family_name AS last_name,
    u.email,
    CASE WHEN u.retired = 1 THEN 0 ELSE 1 END AS account_enabled,
    u.date_created AS created_date,
    creator.username AS created_by,
    login_stats.last_login_date,
    login_stats.num_logins_recorded,
    mfa.mfa_status
FROM users u
JOIN users creator ON creator.user_id = u.creator
JOIN person_name pn ON pn.person_id = u.person_id AND pn.voided = 0
    AND pn.person_name_id = (
        SELECT pn2.person_name_id
        FROM person_name pn2
        WHERE pn2.person_id = u.person_id AND pn2.voided = 0
        ORDER BY pn2.preferred DESC, pn2.person_name_id ASC
        LIMIT 1
    )
LEFT JOIN (
    SELECT
        user_id,
        MAX(event_datetime) AS last_login_date,
        COUNT(user_id) AS num_logins_recorded
    FROM authentication_event_log
    WHERE event_type = 'LOGIN_SUCCEEDED'
    GROUP BY user_id
) login_stats ON login_stats.user_id = u.user_id
LEFT JOIN (
    SELECT
        u2.user_id,
        CASE
            WHEN up.property = 'authentication.secondaryType' AND up.property_value = 'totp' THEN 'authenticator'
            WHEN up.property = 'authentication.secondaryType' AND up.property_value = 'secret' THEN 'question'
            ELSE 'disabled'
        END AS mfa_status
    FROM users u2
    LEFT JOIN user_property up ON up.user_id = u2.user_id
        AND up.property = 'authentication.secondaryType'
    GROUP BY u2.user_id, up.property_value
) mfa ON mfa.user_id = u.user_id
WHERE u.voided = 0;
