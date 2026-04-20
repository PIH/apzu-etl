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

drop temporary table if exists temp_colposcopy_of_cervix_with_acetic_acid;
create temporary table temp_colposcopy_of_cervix_with_acetic_acid as select encounter_id, value_coded from omrs_obs where concept = 'Colposcopy of cervix with acetic acid';
alter table temp_colposcopy_of_cervix_with_acetic_acid add index temp_colposcopy_of_cervix_with_acetic_acid_encounter_idx (encounter_id);

drop temporary table if exists temp_sample_taken_for_viral_load;
create temporary table temp_sample_taken_for_viral_load as select encounter_id, value_coded from omrs_obs where concept = 'Sample taken for Viral Load';
alter table temp_sample_taken_for_viral_load add index temp_sample_taken_for_viral_load_encounter_idx (encounter_id);

drop temporary table if exists temp_adherence_counseling_coded;
create temporary table temp_adherence_counseling_coded as select encounter_id, value_coded from omrs_obs where concept = 'Adherence counseling (coded)';
alter table temp_adherence_counseling_coded add index temp_adherence_counseling_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_adherence_session_number;
create temporary table temp_adherence_session_number as select encounter_id, value_coded from omrs_obs where concept = 'Adherence session number';
alter table temp_adherence_session_number add index temp_adherence_session_number_encounter_idx (encounter_id);

drop temporary table if exists temp_age;
create temporary table temp_age as select encounter_id, value_numeric from omrs_obs where concept = 'Age';
alter table temp_age add index temp_age_encounter_idx (encounter_id);

drop temporary table if exists temp_appointment_date;
create temporary table temp_appointment_date as select encounter_id, value_date from omrs_obs where concept = 'Appointment date';
alter table temp_appointment_date add index temp_appointment_date_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_blood_sample;
create temporary table temp_date_of_blood_sample as select encounter_id, value_date from omrs_obs where concept = 'Date of blood sample';
alter table temp_date_of_blood_sample add index temp_date_of_blood_sample_encounter_idx (encounter_id);

drop temporary table if exists temp_date_of_returned_result;
create temporary table temp_date_of_returned_result as select encounter_id, value_date from omrs_obs where concept = 'Date of returned result';
alter table temp_date_of_returned_result add index temp_date_of_returned_result_encounter_idx (encounter_id);

drop temporary table if exists temp_date_result_to_guardian;
create temporary table temp_date_result_to_guardian as select encounter_id, value_date from omrs_obs where concept = 'Date result to guardian';
alter table temp_date_result_to_guardian add index temp_date_result_to_guardian_encounter_idx (encounter_id);

drop temporary table if exists temp_diastolic_blood_pressure;
create temporary table temp_diastolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Diastolic blood pressure';
alter table temp_diastolic_blood_pressure add index temp_diastolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_height_cm;
create temporary table temp_height_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Height (cm)';
alter table temp_height_cm add index temp_height_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_time_period;
create temporary table temp_hiv_test_time_period as select encounter_id, value_coded from omrs_obs where concept = 'HIV test time period';
alter table temp_hiv_test_time_period add index temp_hiv_test_time_period_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_test_type;
create temporary table temp_hiv_test_type as select encounter_id, value_coded from omrs_obs where concept = 'HIV test type';
alter table temp_hiv_test_type add index temp_hiv_test_type_encounter_idx (encounter_id);

drop temporary table if exists temp_lab_id;
create temporary table temp_lab_id as select encounter_id, value_text from omrs_obs where concept = 'Lab ID';
alter table temp_lab_id add index temp_lab_id_encounter_idx (encounter_id);

drop temporary table if exists temp_location_of_laboratory;
create temporary table temp_location_of_laboratory as select encounter_id, value_coded from omrs_obs where concept = 'Location of laboratory';
alter table temp_location_of_laboratory add index temp_location_of_laboratory_encounter_idx (encounter_id);

drop temporary table if exists temp_lab_test_serial_number;
create temporary table temp_lab_test_serial_number as select encounter_id, value_text from omrs_obs where concept = 'Lab test serial number';
alter table temp_lab_test_serial_number add index temp_lab_test_serial_number_encounter_idx (encounter_id);

drop temporary table if exists temp_less_than_limit;
create temporary table temp_less_than_limit as select encounter_id, value_numeric from omrs_obs where concept = 'Less than limit';
alter table temp_less_than_limit add index temp_less_than_limit_encounter_idx (encounter_id);

drop temporary table if exists temp_lower_than_detection_limit;
create temporary table temp_lower_than_detection_limit as select encounter_id, value_coded from omrs_obs where concept = 'Lower than Detection limit';
alter table temp_lower_than_detection_limit add index temp_lower_than_detection_limit_encounter_idx (encounter_id);

drop temporary table if exists temp_medication_adherence_percent;
create temporary table temp_medication_adherence_percent as select encounter_id, value_numeric from omrs_obs where concept = 'Medication Adherence percent';
alter table temp_medication_adherence_percent add index temp_medication_adherence_percent_encounter_idx (encounter_id);

drop temporary table if exists temp_middle_upper_arm_circumference_cm;
create temporary table temp_middle_upper_arm_circumference_cm as select encounter_id, value_numeric from omrs_obs where concept = 'Middle upper arm circumference (cm)';
alter table temp_middle_upper_arm_circumference_cm add index temp_middle_upper_arm_circumference_cm_encounter_idx (encounter_id);

drop temporary table if exists temp_name_of_support_provider;
create temporary table temp_name_of_support_provider as select encounter_id, value_text from omrs_obs where concept = 'Name of support provider';
alter table temp_name_of_support_provider add index temp_name_of_support_provider_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_missed_medication_doses_in_past_7_days;
create temporary table temp_number_of_missed_medication_doses_in_past_7_days as select encounter_id, value_numeric from omrs_obs where concept = 'Number of missed medication doses in past 7 days';
alter table temp_number_of_missed_medication_doses_in_past_7_days add index temp_number_of_missed_medication_doses_in_past_7_days_encounter_idx (encounter_id);

drop temporary table if exists temp_outcome;
create temporary table temp_outcome as select encounter_id, value_coded from omrs_obs where concept = 'Outcome';
alter table temp_outcome add index temp_outcome_encounter_idx (encounter_id);

drop temporary table if exists temp_is_patient_pregnant;
create temporary table temp_is_patient_pregnant as select encounter_id, value_coded from omrs_obs where concept = 'Is patient pregnant?';
alter table temp_is_patient_pregnant add index temp_is_patient_pregnant_encounter_idx (encounter_id);

drop temporary table if exists temp_pulse;
create temporary table temp_pulse as select encounter_id, value_numeric from omrs_obs where concept = 'Pulse';
alter table temp_pulse add index temp_pulse_encounter_idx (encounter_id);

drop temporary table if exists temp_qualitative_time;
create temporary table temp_qualitative_time as select encounter_id, value_coded from omrs_obs where concept = 'Qualitative time';
alter table temp_qualitative_time add index temp_qualitative_time_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_no_result;
create temporary table temp_reason_for_no_result as select encounter_id, value_coded from omrs_obs where concept = 'Reason for no result';
alter table temp_reason_for_no_result add index temp_reason_for_no_result_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_no_sample;
create temporary table temp_reason_for_no_sample as select encounter_id, value_coded from omrs_obs where concept = 'Reason for no sample';
alter table temp_reason_for_no_sample add index temp_reason_for_no_sample_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_testing_coded;
create temporary table temp_reason_for_testing_coded as select encounter_id, value_coded from omrs_obs where concept = 'Reason for testing (coded)';
alter table temp_reason_for_testing_coded add index temp_reason_for_testing_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_to_stop_care_text;
create temporary table temp_reason_to_stop_care_text as select encounter_id, value_text from omrs_obs where concept = 'Reason to stop care (text)';
alter table temp_reason_to_stop_care_text add index temp_reason_to_stop_care_text_encounter_idx (encounter_id);

drop temporary table if exists temp_refer_to_screening_station;
create temporary table temp_refer_to_screening_station as select encounter_id, value_coded from omrs_obs where concept = 'Refer to screening station';
alter table temp_refer_to_screening_station add index temp_refer_to_screening_station_encounter_idx (encounter_id);

drop temporary table if exists temp_result_of_hiv_test;
create temporary table temp_result_of_hiv_test as select encounter_id, value_coded from omrs_obs where concept = 'Result of HIV test';
alter table temp_result_of_hiv_test add index temp_result_of_hiv_test_encounter_idx (encounter_id);

drop temporary table if exists temp_viral_load_sample_id;
create temporary table temp_viral_load_sample_id as select encounter_id, value_text from omrs_obs where concept = 'Viral Load Sample ID';
alter table temp_viral_load_sample_id add index temp_viral_load_sample_id_encounter_idx (encounter_id);

drop temporary table if exists temp_symptom_absent;
create temporary table temp_symptom_absent as select encounter_id, value_coded from omrs_obs where concept = 'Symptom absent';
alter table temp_symptom_absent add index temp_symptom_absent_encounter_idx (encounter_id);

drop temporary table if exists temp_symptom_present;
create temporary table temp_symptom_present as select encounter_id, value_coded from omrs_obs where concept = 'Symptom present';
alter table temp_symptom_present add index temp_symptom_present_encounter_idx (encounter_id);

drop temporary table if exists temp_systolic_blood_pressure;
create temporary table temp_systolic_blood_pressure as select encounter_id, value_numeric from omrs_obs where concept = 'Systolic blood pressure';
alter table temp_systolic_blood_pressure add index temp_systolic_blood_pressure_encounter_idx (encounter_id);

drop temporary table if exists temp_transfer_out_to;
create temporary table temp_transfer_out_to as select encounter_id, value_text from omrs_obs where concept = 'Transfer out to';
alter table temp_transfer_out_to add index temp_transfer_out_to_encounter_idx (encounter_id);

drop temporary table if exists temp_units_of_age_of_child;
create temporary table temp_units_of_age_of_child as select encounter_id, value_coded from omrs_obs where concept = 'Units of age of child';
alter table temp_units_of_age_of_child add index temp_units_of_age_of_child_encounter_idx (encounter_id);

drop temporary table if exists temp_viral_load_counseling;
create temporary table temp_viral_load_counseling as select encounter_id, value_coded from omrs_obs where concept = 'Viral load counseling';
alter table temp_viral_load_counseling add index temp_viral_load_counseling_encounter_idx (encounter_id);

drop temporary table if exists temp_weight_kg;
create temporary table temp_weight_kg as select encounter_id, value_numeric from omrs_obs where concept = 'Weight (kg)';
alter table temp_weight_kg add index temp_weight_kg_encounter_idx (encounter_id);

insert into mw_poc
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(colposcopy_of_cervix_with_acetic_acid.value_coded) as colposcopy_of_cervix_with_acetic_acid,
    max(sample_taken_for_viral_load.value_coded) as sample_taken_for_viral_Load,
    max(adherence_counseling_coded.value_coded) as adherence_counselling,
    max(adherence_session_number.value_coded) as adherence_session_number,
    max(age.value_numeric) as age,
    max(appointment_date.value_date) as appointment_date,
    max(clinical_impression_comments.value_text) as clinical_impression_comments,
    max(date_of_blood_sample.value_date) as date_of_blood_sample,
    max(date_of_returned_result.value_date) as date_of_returned_result,
    max(date_result_to_guardian.value_date) as date_result_to_guardian,
    max(diastolic_blood_pressure.value_numeric) as diastolic_blood_pressure,
    max(height_cm.value_numeric) as height,
    max(hiv_test_time_period.value_coded) as hiv_test_time_period,
    max(hiv_test_type.value_coded) as hiv_test_type,
    max(hiv_test_type.value_coded) as hiv_test_type_htc,
    max(lab_id.value_text) as lab_id,
    max(location_of_laboratory.value_coded) as lab_location,
    max(lab_test_serial_number.value_text) as lab_test_serial_number,
    max(less_than_limit.value_numeric) as less_than_limit,
    max(lower_than_detection_limit.value_coded) as lower_than_detection_limit,
    max(medication_adherence_percent.value_numeric) as medication_adherence_percent,
    max(middle_upper_arm_circumference_cm.value_numeric) as muac,
    max(name_of_support_provider.value_text) as name_of_support_provider,
    max(number_of_missed_medication_doses_in_past_7_days.value_numeric) as number_of_missed_medication_doses_in_past_week,
    max(outcome.value_coded) as outcome,
    max(is_patient_pregnant.value_coded) as is_patient_preg,
    max(pulse.value_numeric) as pulse,
    max(qualitative_time.value_coded) as qualitative_time,
    max(reason_for_no_result.value_coded) as reason_for_no_result,
    max(reason_for_no_sample.value_coded) as reason_for_no_sample,
    max(reason_for_no_sample.value_coded) as reason_for_no_sample_eid,
    max(reason_for_testing_coded.value_coded) as reason_for_testing,
    max(reason_for_testing_coded.value_coded) as reason_for_testing_coded,
    max(reason_to_stop_care_text.value_text) as reason_to_stop_care,
    max(refer_to_screening_station.value_coded) as refer_to_screening_station,
    max(result_of_hiv_test.value_coded) as result_of_hiv_test,
    max(result_of_hiv_test.value_coded) as result_of_hiv_test_htc,
    max(viral_load_sample_id.value_text) as viral_load_sample_id,
    max(symptom_absent.value_coded) as symptom_absent,
    max(symptom_present.value_coded) as symptom_present,
    max(systolic_blood_pressure.value_numeric) as systolic_blood_pressure,
    max(transfer_out_to.value_text) as transfer_out_to,
    max(units_of_age_of_child.value_coded) as units_of_age_of_child,
    max(viral_load_counseling.value_coded) as viral_load_counseling,
    max(weight_kg.value_numeric) as weight
from omrs_encounter e
left join temp_colposcopy_of_cervix_with_acetic_acid colposcopy_of_cervix_with_acetic_acid on e.encounter_id = colposcopy_of_cervix_with_acetic_acid.encounter_id
left join temp_sample_taken_for_viral_load sample_taken_for_viral_load on e.encounter_id = sample_taken_for_viral_load.encounter_id
left join temp_adherence_counseling_coded adherence_counseling_coded on e.encounter_id = adherence_counseling_coded.encounter_id
left join temp_adherence_session_number adherence_session_number on e.encounter_id = adherence_session_number.encounter_id
left join temp_age age on e.encounter_id = age.encounter_id
left join temp_appointment_date appointment_date on e.encounter_id = appointment_date.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_date_of_blood_sample date_of_blood_sample on e.encounter_id = date_of_blood_sample.encounter_id
left join temp_date_of_returned_result date_of_returned_result on e.encounter_id = date_of_returned_result.encounter_id
left join temp_date_result_to_guardian date_result_to_guardian on e.encounter_id = date_result_to_guardian.encounter_id
left join temp_diastolic_blood_pressure diastolic_blood_pressure on e.encounter_id = diastolic_blood_pressure.encounter_id
left join temp_height_cm height_cm on e.encounter_id = height_cm.encounter_id
left join temp_hiv_test_time_period hiv_test_time_period on e.encounter_id = hiv_test_time_period.encounter_id
left join temp_hiv_test_type hiv_test_type on e.encounter_id = hiv_test_type.encounter_id
left join temp_lab_id lab_id on e.encounter_id = lab_id.encounter_id
left join temp_location_of_laboratory location_of_laboratory on e.encounter_id = location_of_laboratory.encounter_id
left join temp_lab_test_serial_number lab_test_serial_number on e.encounter_id = lab_test_serial_number.encounter_id
left join temp_less_than_limit less_than_limit on e.encounter_id = less_than_limit.encounter_id
left join temp_lower_than_detection_limit lower_than_detection_limit on e.encounter_id = lower_than_detection_limit.encounter_id
left join temp_medication_adherence_percent medication_adherence_percent on e.encounter_id = medication_adherence_percent.encounter_id
left join temp_middle_upper_arm_circumference_cm middle_upper_arm_circumference_cm on e.encounter_id = middle_upper_arm_circumference_cm.encounter_id
left join temp_name_of_support_provider name_of_support_provider on e.encounter_id = name_of_support_provider.encounter_id
left join temp_number_of_missed_medication_doses_in_past_7_days number_of_missed_medication_doses_in_past_7_days on e.encounter_id = number_of_missed_medication_doses_in_past_7_days.encounter_id
left join temp_outcome outcome on e.encounter_id = outcome.encounter_id
left join temp_is_patient_pregnant is_patient_pregnant on e.encounter_id = is_patient_pregnant.encounter_id
left join temp_pulse pulse on e.encounter_id = pulse.encounter_id
left join temp_qualitative_time qualitative_time on e.encounter_id = qualitative_time.encounter_id
left join temp_reason_for_no_result reason_for_no_result on e.encounter_id = reason_for_no_result.encounter_id
left join temp_reason_for_no_sample reason_for_no_sample on e.encounter_id = reason_for_no_sample.encounter_id
left join temp_reason_for_testing_coded reason_for_testing_coded on e.encounter_id = reason_for_testing_coded.encounter_id
left join temp_reason_to_stop_care_text reason_to_stop_care_text on e.encounter_id = reason_to_stop_care_text.encounter_id
left join temp_refer_to_screening_station refer_to_screening_station on e.encounter_id = refer_to_screening_station.encounter_id
left join temp_result_of_hiv_test result_of_hiv_test on e.encounter_id = result_of_hiv_test.encounter_id
left join temp_viral_load_sample_id viral_load_sample_id on e.encounter_id = viral_load_sample_id.encounter_id
left join temp_symptom_absent symptom_absent on e.encounter_id = symptom_absent.encounter_id
left join temp_symptom_present symptom_present on e.encounter_id = symptom_present.encounter_id
left join temp_systolic_blood_pressure systolic_blood_pressure on e.encounter_id = systolic_blood_pressure.encounter_id
left join temp_transfer_out_to transfer_out_to on e.encounter_id = transfer_out_to.encounter_id
left join temp_units_of_age_of_child units_of_age_of_child on e.encounter_id = units_of_age_of_child.encounter_id
left join temp_viral_load_counseling viral_load_counseling on e.encounter_id = viral_load_counseling.encounter_id
left join temp_weight_kg weight_kg on e.encounter_id = weight_kg.encounter_id
where e.encounter_type in ('Check-in')
group by e.patient_id, e.encounter_date, e.location;