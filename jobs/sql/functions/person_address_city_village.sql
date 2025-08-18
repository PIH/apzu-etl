#
DROP FUNCTION IF EXISTS person_address_city_village;
#
CREATE FUNCTION person_address_city_village(
    _person_id int
)
	RETURNS TEXT
    DETERMINISTIC

BEGIN
    DECLARE patientAddressCityVillage TEXT;

	select city_village into patientAddressCityVillage
    from person_address where voided = 0 and person_id = _person_id order by preferred desc, date_created desc limit 1;

    RETURN patientAddressCityVillage;

END
#