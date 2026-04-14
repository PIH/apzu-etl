CREATE TABLE mw_users (
    user_id             INT,
    username            VARCHAR(50),
    first_name          VARCHAR(50),
    last_name           VARCHAR(50),
    email               VARCHAR(500),
    account_enabled     INT,
    created_date        DATETIME,
    created_by          VARCHAR(50),
    last_login_date     DATETIME,
    num_logins_recorded INT,
    mfa_status          VARCHAR(50)
);
