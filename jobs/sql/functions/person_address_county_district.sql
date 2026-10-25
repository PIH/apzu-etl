#
DROP FUNCTION IF EXISTS person_address_county_district;
#
CREATE FUNCTION person_address_county_district(
    _person_id int
)
    RETURNS TEXT
    DETERMINISTIC

BEGIN
    DECLARE personAddressCountyDistrict TEXT;

    select county_district into personAddressCountyDistrict
    from person_address where voided = 0 and person_id =  _person_id order by preferred desc, date_created desc limit 1;

    RETURN personAddressCountyDistrict;

END
#