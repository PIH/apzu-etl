-- Extract user accounts from OpenMRS
select
    u.user_id,
    u.username,
    pn.given_name as first_name,
    pn.family_name as last_name,
    u.email,
    case when u.retired = 1 then 0 else 1 end as account_enabled,
    u.date_created as created_date,
    creator.username as created_by,
    login_stats.last_login_date,
    login_stats.num_logins_recorded,
    mfa.mfa_status
from users u
left join users creator on creator.user_id = u.creator
left join person_name pn on pn.person_id = u.person_id
    and pn.person_name_id = (
        select pn2.person_name_id
        from person_name pn2
        where pn2.person_id = u.person_id and pn2.voided = 0
        order by pn2.preferred desc, pn2.person_name_id
        limit 1
    )
left join (
    select
        user_id,
        max(event_datetime) as last_login_date,
        count(user_id) as num_logins_recorded
    from authentication_event_log
    where event_type = 'LOGIN_SUCCEEDED'
    group by user_id
) login_stats on login_stats.user_id = u.user_id
left join (
    select
        u2.user_id,
        case
            when up.property = 'authentication.secondaryType' and up.property_value = 'totp' then 'authenticator'
            when up.property = 'authentication.secondaryType' and up.property_value = 'secret' then 'question'
            else 'disabled'
        end as mfa_status
    from users u2
    left join user_property up on up.user_id = u2.user_id
        and up.property = 'authentication.secondaryType'
    group by u2.user_id, up.property_value
) mfa on mfa.user_id = u.user_id
;
