CREATE TABLE mw_users (
    user_id             int,
    username            varchar(50),
    first_name          varchar(50),
    last_name           varchar(50),
    email               varchar(500),
    account_enabled     int,
    created_date        datetime,
    created_by          varchar(50),
    last_login_date     datetime,
    num_logins_recorded int,
    mfa_status          varchar(50)
);
