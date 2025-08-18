#
DROP FUNCTION IF EXISTS phone_number;
#
CREATE FUNCTION phone_number(
    _person_id int)

    RETURNS VARCHAR(50)
    DETERMINISTIC

BEGIN
    DECLARE  attVal VARCHAR(50);

    select      a.value into attVal
    from        person_attribute a
    inner join  person_attribute_type t on a.person_attribute_type_id = t.person_attribute_type_id
    where       t.name = 'Cell Phone Number'
    and         a.voided = 0
    and         a.person_id = _person_id
    order by    a.date_created desc
    limit       1;

    RETURN attVal;

END
#