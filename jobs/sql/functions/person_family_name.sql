#
DROP FUNCTION IF EXISTS person_family_name;
#
CREATE FUNCTION person_family_name(
    _person_id int
)
    RETURNS TEXT
    DETERMINISTIC

BEGIN
    DECLARE personFamilyName TEXT;

    select      family_name into personFamilyName
    from        person_name
    where       voided = 0
      and         person_id = _person_id
    order by    preferred desc, date_created desc
    limit       1;

    RETURN personFamilyName;

END
#