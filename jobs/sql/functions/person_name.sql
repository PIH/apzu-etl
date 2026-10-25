#
DROP FUNCTION IF EXISTS person_name;
#
CREATE FUNCTION person_name(
    _person_id int
)
    RETURNS TEXT
    DETERMINISTIC

BEGIN
    DECLARE personName TEXT;

    select      concat(given_name, ' ', family_name) into personName
    from        person_name
    where       voided = 0
      and       person_id = _person_id
    order by    preferred desc, date_created desc
    limit       1;

    RETURN personName;

END
#