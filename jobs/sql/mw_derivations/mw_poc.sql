-- Derivation script for mw_poc
-- Generated from Pentaho transform: import-into-mw-poc.ktr

drop table if exists mw_poc;
create table mw_poc (
    poc_visit_id int not null auto_increment,
    patient_id int not null,
    visit_date date,
    location varchar(255),
    sample_taken_for_viral_load varchar(255),
    lower_than_detection_limit varchar(255),
    reason_for_testing varchar(255),
    lab_location varchar(255),
    less_than_limit varchar(255),
    reason_for_no_result varchar(255),
    viral_load_sample_id varchar(255),
    reason_for_no_sample varchar(255),
    lab_id varchar(255),
    symptom_present varchar(255),
    symptom_absent varchar(255),
    adherence_session_number varchar(255),
    name_of_support_provider varchar(255),
    number_of_missed_medication_doses_in_past_week varchar(255),
    viral_load_counseling varchar(255),
    medication_adherence_percent varchar(255),
    adherence_counselling varchar(255),
    date_of_blood_sample date,
    hiv_test_type varchar(255),
    reason_for_no_sample_eid varchar(255),
    result_of_hiv_test varchar(255),
    hiv_test_time_period varchar(255),
    age varchar(13),
    units_of_age_of_child varchar(255),
    lab_test_serial_number varchar(255),
    date_of_returned_result varchar(255),
    date_result_to_guardian date,
    reason_for_testing_coded varchar(255),
    height decimal(10,2),
    is_patient_preg varchar(255),
    muac varchar(255),
    weight decimal(10,2),
    diastolic_blood_pressure decimal(10,2),
    pulse decimal(10,2),
    systolic_blood_pressure decimal(10,2),
    result_of_hiv_test_htc varchar(255),
    hiv_test_type_htc varchar(255),
    colposcopy_of_cervix_with_acetic_acid varchar(255),
    appointment_date date,
    qualitative_time varchar(255),
    outcome varchar(255),
    clinical_impression_comments varchar(300),
    refer_to_screening_station varchar(255),
    transfer_out_to varchar(255),
    reason_to_stop_care varchar(255),
    primary key (poc_visit_id)
);

drop temporary table if exists temp_poc_obs;
create temporary table temp_poc_obs as
select encounter_id, obs_group_id, concept, value_coded, value_numeric, value_date, value_text
from omrs_obs
where encounter_type = 'Check-in';
alter table temp_poc_obs add index temp_poc_obs_concept_idx (concept);
alter table temp_poc_obs add index temp_poc_obs_encounter_idx (encounter_id);
alter table temp_poc_obs add index temp_poc_obs_group_idx (obs_group_id);

drop temporary table if exists temp_single_values;
create temporary table temp_single_values as
select
    encounter_id,
    max(case when concept = 'Adherence counseling (coded)'                      then value_coded   end) as adherence_counselling,
    max(case when concept = 'Adherence session number'                          then value_coded   end) as adherence_session_number,
    max(case when concept = 'Age'                                               then value_numeric end) as age,
    max(case when concept = 'Appointment date'                                  then value_date    end) as appointment_date,
    max(case when concept = 'Clinical impression comments'                      then value_text    end) as clinical_impression_comments,
    max(case when concept = 'Colposcopy of cervix with acetic acid'             then value_coded   end) as colposcopy_of_cervix_with_acetic_acid,
    max(case when concept = 'Date of blood sample'                              then value_date    end) as date_of_blood_sample,
    max(case when concept = 'Date of returned result'                           then value_date    end) as date_of_returned_result,
    max(case when concept = 'Date result to guardian'                           then value_date    end) as date_result_to_guardian,
    max(case when concept = 'Diastolic blood pressure'                          then value_numeric end) as diastolic_blood_pressure,
    max(case when concept = 'Height (cm)'                                       then value_numeric end) as height,
    max(case when concept = 'HIV test time period'                              then value_coded   end) as hiv_test_time_period,
    max(case when concept = 'HIV test type'                                     then value_coded   end) as hiv_test_type,
    max(case when concept = 'Is patient pregnant?'                              then value_coded   end) as is_patient_preg,
    max(case when concept = 'Lab ID'                                            then value_text    end) as lab_id,
    max(case when concept = 'Lab test serial number'                            then value_text    end) as lab_test_serial_number,
    max(case when concept = 'Less than limit'                                   then value_numeric end) as less_than_limit,
    max(case when concept = 'Location of laboratory'                            then value_coded   end) as lab_location,
    max(case when concept = 'Lower than Detection limit'                        then value_coded   end) as lower_than_detection_limit,
    max(case when concept = 'Medication Adherence percent'                      then value_numeric end) as medication_adherence_percent,
    max(case when concept = 'Middle upper arm circumference (cm)'               then value_numeric end) as muac,
    max(case when concept = 'Name of support provider'                          then value_text    end) as name_of_support_provider,
    max(case when concept = 'Number of missed medication doses in past 7 days'  then value_numeric end) as number_of_missed_medication_doses_in_past_week,
    max(case when concept = 'Outcome'                                           then value_coded   end) as outcome,
    max(case when concept = 'Pulse'                                             then value_numeric end) as pulse,
    max(case when concept = 'Qualitative time'                                  then value_coded   end) as qualitative_time,
    max(case when concept = 'Reason for no result'                              then value_coded   end) as reason_for_no_result,
    max(case when concept = 'Reason for no sample'                              then value_coded   end) as reason_for_no_sample,
    max(case when concept = 'Reason for testing (coded)'                        then value_coded   end) as reason_for_testing,
    max(case when concept = 'Reason to stop care (text)'                        then value_text    end) as reason_to_stop_care,
    max(case when concept = 'Refer to screening station'                        then value_coded   end) as refer_to_screening_station,
    max(case when concept = 'Result of HIV test'                                then value_coded   end) as result_of_hiv_test,
    max(case when concept = 'Sample taken for Viral Load'                       then value_coded   end) as sample_taken_for_viral_load,
    max(case when concept = 'Symptom absent'                                    then value_coded   end) as symptom_absent,
    max(case when concept = 'Symptom present'                                   then value_coded   end) as symptom_present,
    max(case when concept = 'Systolic blood pressure'                           then value_numeric end) as systolic_blood_pressure,
    max(case when concept = 'Transfer out to'                                   then value_text    end) as transfer_out_to,
    max(case when concept = 'Units of age of child'                             then value_coded   end) as units_of_age_of_child,
    max(case when concept = 'Viral load counseling'                             then value_coded   end) as viral_load_counseling,
    max(case when concept = 'Viral Load Sample ID'                              then value_text    end) as viral_load_sample_id,
    max(case when concept = 'Weight (kg)'                                       then value_numeric end) as weight
from temp_poc_obs
group by encounter_id;
alter table temp_single_values add index temp_single_values_encounter_idx (encounter_id);

insert into mw_poc (patient_id, visit_date, location, colposcopy_of_cervix_with_acetic_acid, sample_taken_for_viral_load, adherence_counselling, adherence_session_number, age, appointment_date, clinical_impression_comments, date_of_blood_sample, date_of_returned_result, date_result_to_guardian, diastolic_blood_pressure, height, hiv_test_time_period, hiv_test_type, hiv_test_type_htc, lab_id, lab_location, lab_test_serial_number, less_than_limit, lower_than_detection_limit, medication_adherence_percent, muac, name_of_support_provider, number_of_missed_medication_doses_in_past_week, outcome, is_patient_preg, pulse, qualitative_time, reason_for_no_result, reason_for_no_sample, reason_for_no_sample_eid, reason_for_testing, reason_for_testing_coded, reason_to_stop_care, refer_to_screening_station, result_of_hiv_test, result_of_hiv_test_htc, viral_load_sample_id, symptom_absent, symptom_present, systolic_blood_pressure, transfer_out_to, units_of_age_of_child, viral_load_counseling, weight)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(sv.colposcopy_of_cervix_with_acetic_acid) as colposcopy_of_cervix_with_acetic_acid,
    max(sv.sample_taken_for_viral_load) as sample_taken_for_viral_load,
    max(sv.adherence_counselling) as adherence_counselling,
    max(sv.adherence_session_number) as adherence_session_number,
    max(sv.age) as age,
    max(sv.appointment_date) as appointment_date,
    max(sv.clinical_impression_comments) as clinical_impression_comments,
    max(sv.date_of_blood_sample) as date_of_blood_sample,
    max(sv.date_of_returned_result) as date_of_returned_result,
    max(sv.date_result_to_guardian) as date_result_to_guardian,
    max(sv.diastolic_blood_pressure) as diastolic_blood_pressure,
    max(sv.height) as height,
    max(sv.hiv_test_time_period) as hiv_test_time_period,
    max(sv.hiv_test_type) as hiv_test_type,
    max(sv.hiv_test_type) as hiv_test_type,
    max(sv.lab_id) as lab_id,
    max(sv.lab_location) as lab_location,
    max(sv.lab_test_serial_number) as lab_test_serial_number,
    max(sv.less_than_limit) as less_than_limit,
    max(sv.lower_than_detection_limit) as lower_than_detection_limit,
    max(sv.medication_adherence_percent) as medication_adherence_percent,
    max(sv.muac) as muac,
    max(sv.name_of_support_provider) as name_of_support_provider,
    max(sv.number_of_missed_medication_doses_in_past_week) as number_of_missed_medication_doses_in_past_week,
    max(sv.outcome) as outcome,
    max(sv.is_patient_preg) as is_patient_preg,
    max(sv.pulse) as pulse,
    max(sv.qualitative_time) as qualitative_time,
    max(sv.reason_for_no_result) as reason_for_no_result,
    max(sv.reason_for_no_sample) as reason_for_no_sample,
    max(sv.reason_for_no_sample) as reason_for_no_sample,
    max(sv.reason_for_testing) as reason_for_testing,
    max(sv.reason_for_testing) as reason_for_testing,
    max(sv.reason_to_stop_care) as reason_to_stop_care,
    max(sv.refer_to_screening_station) as refer_to_screening_station,
    max(sv.result_of_hiv_test) as result_of_hiv_test,
    max(sv.result_of_hiv_test) as result_of_hiv_test,
    max(sv.viral_load_sample_id) as viral_load_sample_id,
    max(sv.symptom_absent) as symptom_absent,
    max(sv.symptom_present) as symptom_present,
    max(sv.systolic_blood_pressure) as systolic_blood_pressure,
    max(sv.transfer_out_to) as transfer_out_to,
    max(sv.units_of_age_of_child) as units_of_age_of_child,
    max(sv.viral_load_counseling) as viral_load_counseling,
    max(sv.weight) as weight
from omrs_encounter e
left join temp_single_values sv on sv.encounter_id = e.encounter_id
where e.encounter_type in ('Check-in')
group by e.patient_id, e.encounter_date, e.location;

drop temporary table if exists temp_poc_obs;
drop temporary table if exists temp_single_values;
