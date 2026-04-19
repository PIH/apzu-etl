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

insert into mw_art_followup_testing
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when o.concept = 'CD4 count' then o.value_numeric end) as cd4_count,
    max(case when o.concept = 'Cd4%' then o.value_numeric end) as cd4_pct,
    max(case when o.concept = 'PHQ 9 Score' then o.value_numeric end) as phq_nine_score,
    max(case when o.concept = 'Serum glucose' then o.value_numeric end) as serum_glucose,
    max(case when o.concept = 'Blood sugar test type' then o.value_coded end) as test_type
from omrs_encounter e
left join omrs_obs o on o.encounter_id = e.encounter_id
group by e.patient_id, e.encounter_date, e.location;