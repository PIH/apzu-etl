#
DROP FUNCTION IF EXISTS person_address_state_province;
#
CREATE FUNCTION person_address_state_province(
    _person_id int
)
    RETURNS TEXT
    DETERMINISTIC

BEGIN
    DECLARE patientAddressStateProvince TEXT;

    select state_province into patientAddressStateProvince
    from person_address where voided = 0 and person_id = _person_id order by preferred desc, date_created desc limit 1;

    RETURN patientAddressStateProvince;

END
#