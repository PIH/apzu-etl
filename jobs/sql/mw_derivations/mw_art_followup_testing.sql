-- Derivation script for mw_art_followup_testing
-- Generated from Pentaho transform: import-into-mw-art-followup-testing.ktr

drop table if exists mw_art_followup_testing;
create table mw_art_followup_testing (
  art_followup_testing_visit_id int not null auto_increment,
  patient_id int(11) not null,
  visit_date date null default null,
  location varchar(255) null default null,
  cd4_count int null default null,
  cd4_pct int null default null,
  serum_glucose int null default null,
  phq_nine_score int null,
  test_type varchar(255) null default null,
  primary key (art_followup_testing_visit_id));

drop temporary table if exists temp_cd4_count;
create temporary table temp_cd4_count as select encounter_id, value_numeric from omrs_obs where concept = 'CD4 count';
alter table temp_cd4_count add index temp_cd4_count_encounter_idx (encounter_id);

drop temporary table if exists temp_cd4;
create temporary table temp_cd4 as select encounter_id, value_numeric from omrs_obs where concept = 'Cd4%';
alter table temp_cd4 add index temp_cd4_encounter_idx (encounter_id);

drop temporary table if exists temp_phq_9_score;
create temporary table temp_phq_9_score as select encounter_id, value_numeric from omrs_obs where concept = 'PHQ 9 Score';
alter table temp_phq_9_score add index temp_phq_9_score_encounter_idx (encounter_id);

drop temporary table if exists temp_serum_glucose;
create temporary table temp_serum_glucose as select encounter_id, value_numeric from omrs_obs where concept = 'Serum glucose';
alter table temp_serum_glucose add index temp_serum_glucose_encounter_idx (encounter_id);

drop temporary table if exists temp_blood_sugar_test_type;
create temporary table temp_blood_sugar_test_type as select encounter_id, value_coded from omrs_obs where concept = 'Blood sugar test type';
alter table temp_blood_sugar_test_type add index temp_blood_sugar_test_type_encounter_idx (encounter_id);

insert into mw_art_followup_testing (patient_id, visit_date, location, cd4_count, cd4_pct, phq_nine_score, serum_glucose, test_type)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(cd4_count.value_numeric) as cd4_count,
    max(cd4.value_numeric) as cd4_pct,
    max(phq_9_score.value_numeric) as phq_nine_score,
    max(serum_glucose.value_numeric) as serum_glucose,
    max(blood_sugar_test_type.value_coded) as test_type
from omrs_encounter e
left join temp_cd4_count cd4_count on e.encounter_id = cd4_count.encounter_id
left join temp_cd4 cd4 on e.encounter_id = cd4.encounter_id
left join temp_phq_9_score phq_9_score on e.encounter_id = phq_9_score.encounter_id
left join temp_serum_glucose serum_glucose on e.encounter_id = serum_glucose.encounter_id
left join temp_blood_sugar_test_type blood_sugar_test_type on e.encounter_id = blood_sugar_test_type.encounter_id
group by e.patient_id, e.encounter_date, e.location;