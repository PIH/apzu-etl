-- Derivation script for mw_pdc_initial
-- Generated from Pentaho transform: import-into-mw-pdc-initial.ktr

drop table if exists mw_pdc_initial;
create table mw_pdc_initial
(
    pdc_initial_visit_id                      int not null auto_increment,
    patient_id                                int not null,
    visit_date                                date         default null,
    location                                  varchar(255) default null,
    transfer_in_date                          date         default null,
    phone_number                              int          default null,
    relation_to_patient                       varchar(255) default null,
    agrees_to_fup                             varchar(10)  default null,
    guardian_name                             varchar(255) default null,
    guardian_age                              varchar(255) default null,
    guardian_phone                            varchar(255),
    marital_status                            varchar(255) default null,
    level_of_education                        varchar(255) default null,
    number_of_children                        int          default null,
    income_source                             varchar(255) default null,
    source_of_referral                        varchar(255) default null,
    mother_hiv_reactive                       varchar(255) default null,
    mother_on_art                             varchar(255) default null,
    child_hiv_reactive                        varchar(255) default null,
    child_on_art                              varchar(255) default null,
    eligible_for_poser                        varchar(10)  default null,
    referral_form_filled                      varchar(10)  default null,
    birth_site                                varchar(255) default null,
    birth_history_svd                         varchar(255) default null,
    birth_history_cs                          varchar(255) default null,
    birth_history_agpar                       varchar(255) default null,
    birth_history_bwt                         varchar(255) default null,
    perinatal_infection                       varchar(255) default null,
    perinatal_infection_specify               varchar(255) default null,
    antibiotics                               varchar(10)  default null,
    antibiotics_duration                      varchar(255) default null,
    currently_on_medication                   varchar(255) default null,
    currently_on_medication_specify           varchar(255) default null,
    type_of_feed_breast_milk                  varchar(255) default null,
    type_of_feed_infant_formula               varchar(255) default null,
    type_of_feed_mixed_feeding                varchar(255) default null,
    type_of_feed_solids                       varchar(255) default null,
    feeding_method_bf                         varchar(255) default null,
    feeding_method_cup                        varchar(255) default null,
    feeding_method_ogt                        varchar(255) default null,
    feeding_method_other                      varchar(255) default null,
    notes                                     varchar(255) default null,
    reason_for_referral_premature_birth       varchar(255) default null,
    reason_for_referral_hie                   varchar(255) default null,
    reason_for_referral_low_birth_weight      varchar(255) default null,
    reason_for_referral_hydrocephalus         varchar(255) default null,
    reason_for_referral_cleft_lip             varchar(255) default null,
    reason_for_referral_cleft_palate          varchar(255) default null,
    reason_for_referral_cns_infection         varchar(255) default null,
    reason_for_referral_cns_infection_specify varchar(255) default null,
    reason_for_referral_other                 varchar(255) default null,
    reason_for_referral_other_specify         varchar(255) default null,
    reason_for_referral_trisomy_21            varchar(255) default null,
    reason_for_referral_severe_malnutrition   varchar(255) default null,
    reason_for_referral_epilepsy              varchar(255) default null,
    enrolled_in_pdc                           varchar(255) default null,
    premature_birth                           varchar(255) default null,
    hie                                       varchar(255) default null,
    low_birth_weight                          varchar(255) default null,
    hydrocephalus                             varchar(255) default null,
    cleft_lip                                 varchar(255) default null,
    cleft_palate                              varchar(255) default null,
    cns_infection                             varchar(255) default null,
    cns_infection_specify                     varchar(255) default null,
    diagnosis_other                           varchar(255) default null,
    diagnosis_other_specify                   varchar(255) default null,
    trisomy_21                                varchar(255) default null,
    severe_malnutrition                       varchar(255) default null,
    epilepsy                                  varchar(255) default null,
    care_linked                               varchar(255) default null,
    clinical_care                             varchar(255) default null,
    nru                                       varchar(255) default null,
    ic3                                       varchar(255) default null,
    advanced_ncd                              varchar(255) default null,
    mental_health_clinic                      varchar(255) default null,
    palliative                                varchar(255) default null,
    physiotherapy                             varchar(255) default null,
    other_support                             varchar(255) default null,
    primary key (pdc_initial_visit_id)
);

drop temporary table if exists temp_care_linked_type;
create temporary table temp_care_linked_type as select encounter_id, value_coded from omrs_obs where concept = 'Care Linked Type';
alter table temp_care_linked_type add index temp_care_linked_type_encounter_idx (encounter_id);

drop temporary table if exists temp_follow_up_agreement;
create temporary table temp_follow_up_agreement as select encounter_id, value_coded from omrs_obs where concept = 'Follow up agreement';
alter table temp_follow_up_agreement add index temp_follow_up_agreement_encounter_idx (encounter_id);

drop temporary table if exists temp_or_last_week_taking_antibiotics;
create temporary table temp_or_last_week_taking_antibiotics as select encounter_id, value_coded from omrs_obs where concept = 'Currently (or in the last week) taking antibiotics';
alter table temp_or_last_week_taking_antibiotics add index temp_or_last_week_taking_antibiotics_encounter_idx (encounter_id);

drop temporary table if exists temp_duration_coded;
create temporary table temp_duration_coded as select encounter_id, value_coded from omrs_obs where concept = 'Duration (coded)';
alter table temp_duration_coded add index temp_duration_coded_encounter_idx (encounter_id);

drop temporary table if exists temp_method_of_delivery;
create temporary table temp_method_of_delivery as select encounter_id, value_coded from omrs_obs where concept = 'Method of delivery';
alter table temp_method_of_delivery add index temp_method_of_delivery_encounter_idx (encounter_id);

drop temporary table if exists temp_birth_location_type;
create temporary table temp_birth_location_type as select encounter_id, value_coded from omrs_obs where concept = 'Birth location type';
alter table temp_birth_location_type add index temp_birth_location_type_encounter_idx (encounter_id);

drop temporary table if exists temp_diagnosis;
create temporary table temp_diagnosis as select encounter_id, value_coded from omrs_obs where concept = 'Diagnosis';
alter table temp_diagnosis add index temp_diagnosis_encounter_idx (encounter_id);

drop temporary table if exists temp_care_linked;
create temporary table temp_care_linked as select encounter_id, value_coded from omrs_obs where concept = 'Care Linked';
alter table temp_care_linked add index temp_care_linked_encounter_idx (encounter_id);

drop temporary table if exists temp_hiv_status;
create temporary table temp_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'HIV status';
alter table temp_hiv_status add index temp_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_childs_current_hiv_status;
create temporary table temp_childs_current_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'Childs current HIV status';
alter table temp_childs_current_hiv_status add index temp_childs_current_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_drugs;
create temporary table temp_drugs as select encounter_id, value_text from omrs_obs where concept = 'drugs';
alter table temp_drugs add index temp_drugs_encounter_idx (encounter_id);

drop temporary table if exists temp_current_drugs_used;
create temporary table temp_current_drugs_used as select encounter_id, value_coded from omrs_obs where concept = 'Current drugs used';
alter table temp_current_drugs_used add index temp_current_drugs_used_encounter_idx (encounter_id);

drop temporary table if exists temp_poser_support;
create temporary table temp_poser_support as select encounter_id, value_coded from omrs_obs where concept = 'Poser Support';
alter table temp_poser_support add index temp_poser_support_encounter_idx (encounter_id);

drop temporary table if exists temp_enrolled_in_pdc;
create temporary table temp_enrolled_in_pdc as select encounter_id, value_coded from omrs_obs where concept = 'Enrolled in PDC';
alter table temp_enrolled_in_pdc add index temp_enrolled_in_pdc_encounter_idx (encounter_id);

drop temporary table if exists temp_infant_feeding_method;
create temporary table temp_infant_feeding_method as select encounter_id, value_coded from omrs_obs where concept = 'Infant feeding method';
alter table temp_infant_feeding_method add index temp_infant_feeding_method_encounter_idx (encounter_id);

drop temporary table if exists temp_other_non_coded_text;
create temporary table temp_other_non_coded_text as select encounter_id, value_text from omrs_obs where concept = 'Other non-coded (text)';
alter table temp_other_non_coded_text add index temp_other_non_coded_text_encounter_idx (encounter_id);

drop temporary table if exists temp_age_of_guardian;
create temporary table temp_age_of_guardian as select encounter_id, value_numeric from omrs_obs where concept = 'Age of guardian';
alter table temp_age_of_guardian add index temp_age_of_guardian_encounter_idx (encounter_id);

drop temporary table if exists temp_guardian_name_and_first_names;
create temporary table temp_guardian_name_and_first_names as select encounter_id, value_text from omrs_obs where concept = 'Guardian; name and first names';
alter table temp_guardian_name_and_first_names add index temp_guardian_name_and_first_names_encounter_idx (encounter_id);

drop temporary table if exists temp_next_of_kin_telephone;
create temporary table temp_next_of_kin_telephone as select encounter_id, value_text from omrs_obs where concept = 'Next of kin telephone';
alter table temp_next_of_kin_telephone add index temp_next_of_kin_telephone_encounter_idx (encounter_id);

drop temporary table if exists temp_income_source;
create temporary table temp_income_source as select encounter_id, value_text from omrs_obs where concept = 'Income Source';
alter table temp_income_source add index temp_income_source_encounter_idx (encounter_id);

drop temporary table if exists temp_highest_level_of_school_completed;
create temporary table temp_highest_level_of_school_completed as select encounter_id, value_coded from omrs_obs where concept = 'Highest level of school completed';
alter table temp_highest_level_of_school_completed add index temp_highest_level_school_completed_encounter_idx (encounter_id);

drop temporary table if exists temp_civil_status;
create temporary table temp_civil_status as select encounter_id, value_coded from omrs_obs where concept = 'Civil status';
alter table temp_civil_status add index temp_civil_status_encounter_idx (encounter_id);

drop temporary table if exists temp_mother_hiv_status;
create temporary table temp_mother_hiv_status as select encounter_id, value_coded from omrs_obs where concept = 'Mother HIV Status';
alter table temp_mother_hiv_status add index temp_mother_hiv_status_encounter_idx (encounter_id);

drop temporary table if exists temp_clinical_impression_comments;
create temporary table temp_clinical_impression_comments as select encounter_id, value_text from omrs_obs where concept = 'Clinical impression comments';
alter table temp_clinical_impression_comments add index temp_clinical_impression_comments_encounter_idx (encounter_id);

drop temporary table if exists temp_number_of_children;
create temporary table temp_number_of_children as select encounter_id, value_numeric from omrs_obs where concept = 'Number of children';
alter table temp_number_of_children add index temp_number_of_children_encounter_idx (encounter_id);

drop temporary table if exists temp_type_of_support;
create temporary table temp_type_of_support as select encounter_id, value_text from omrs_obs where concept = 'Type of support';
alter table temp_type_of_support add index temp_type_of_support_encounter_idx (encounter_id);

drop temporary table if exists temp_perinatal_infection;
create temporary table temp_perinatal_infection as select encounter_id, value_coded from omrs_obs where concept = 'Perinatal infection';
alter table temp_perinatal_infection add index temp_perinatal_infection_encounter_idx (encounter_id);

drop temporary table if exists temp_telephone_number;
create temporary table temp_telephone_number as select encounter_id, value_numeric from omrs_obs where concept = 'Telephone number';
alter table temp_telephone_number add index temp_telephone_number_encounter_idx (encounter_id);

drop temporary table if exists temp_pdc_reasons_for_referral;
create temporary table temp_pdc_reasons_for_referral as select encounter_id, value_coded from omrs_obs where concept = 'PDC Reasons for referral';
alter table temp_pdc_reasons_for_referral add index temp_pdc_reasons_for_referral_encounter_idx (encounter_id);

drop temporary table if exists temp_referral_form_filled;
create temporary table temp_referral_form_filled as select encounter_id, value_coded from omrs_obs where concept = 'Referral Form Filled';
alter table temp_referral_form_filled add index temp_referral_form_filled_encounter_idx (encounter_id);

drop temporary table if exists temp_relationships_of_contact;
create temporary table temp_relationships_of_contact as select encounter_id, value_text from omrs_obs where concept = 'Relationships of contact';
alter table temp_relationships_of_contact add index temp_relationships_of_contact_encounter_idx (encounter_id);

drop temporary table if exists temp_referral_source;
create temporary table temp_referral_source as select encounter_id, value_coded from omrs_obs where concept = 'Referral Source';
alter table temp_referral_source add index temp_referral_source_encounter_idx (encounter_id);

drop temporary table if exists temp_transfer_in_date;
create temporary table temp_transfer_in_date as select encounter_id, value_date from omrs_obs where concept = 'Transfer in date';
alter table temp_transfer_in_date add index temp_transfer_in_date_encounter_idx (encounter_id);

drop temporary table if exists temp_type_of_feed;
create temporary table temp_type_of_feed as select encounter_id, value_coded from omrs_obs where concept = 'Type of Feed';
alter table temp_type_of_feed add index temp_type_of_feed_encounter_idx (encounter_id);

insert into mw_pdc_initial (patient_id, visit_date, location, advanced_ncd, agrees_to_fup, antibiotics, antibiotics_duration, birth_history_agpar, birth_history_cs, birth_history_svd, birth_site, birth_history_bwt, cns_infection, care_linked, child_hiv_reactive, child_on_art, cleft_lip, cleft_palate, clinical_care, currently_on_medication_specify, currently_on_medication, diagnosis_other, premature_birth, eligible_for_poser, enrolled_in_pdc, epilepsy, feeding_method_bf, feeding_method_cup, feeding_method_ogt, feeding_method_other, guardian_age, guardian_name, guardian_phone, hie, hydrocephalus, ic3, income_source, level_of_education, low_birth_weight, marital_status, mental_health_clinic, mother_hiv_reactive, mother_on_art, nru, notes, number_of_children, other_support, palliative, perinatal_infection, perinatal_infection_specify, phone_number, physiotherapy, reason_for_referral_hie, reason_for_referral_cns_infection, reason_for_referral_cleft_lip, reason_for_referral_cleft_palate, reason_for_referral_epilepsy, reason_for_referral_hydrocephalus, reason_for_referral_low_birth_weight, reason_for_referral_other, reason_for_referral_premature_birth, reason_for_referral_severe_malnutrition, reason_for_referral_trisomy_21, referral_form_filled, relation_to_patient, severe_malnutrition, source_of_referral, transfer_in_date, trisomy_21, type_of_feed_breast_milk, type_of_feed_infant_formula, type_of_feed_solids, type_of_feed_mixed_feeding)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(case when care_linked_type.value_coded = 'Advanced NCD clinic' then care_linked_type.value_coded end) as advanced_ncd,
    max(follow_up_agreement.value_coded) as agrees_to_fup,
    max(currently_or_in_the_last_week_taking_antibiotics.value_coded) as antibiotics,
    max(duration_coded.value_coded) as antibiotics_duration,
    max(case when method_of_delivery.value_coded = 'Appearance, Grimace, Pulse rate, Activity, Respirations' then method_of_delivery.value_coded end) as birth_history_agpar,
    max(case when method_of_delivery.value_coded = 'Caesarean section' then method_of_delivery.value_coded end) as birth_history_cs,
    max(case when method_of_delivery.value_coded = 'Spontaneous vaginal delivery' then method_of_delivery.value_coded end) as birth_history_svd,
    max(birth_location_type.value_coded) as birth_site,
    max(case when method_of_delivery.value_coded = 'Birth weight' then method_of_delivery.value_coded end) as birth_history_bwt,
    max(case when diagnosis.value_coded = 'Nervous system diagnosis' then diagnosis.value_coded end) as cns_infection,
    max(care_linked.value_coded) as care_linked,
    max(hiv_status.value_coded) as child_hiv_reactive,
    max(childs_current_hiv_status.value_coded) as child_on_art,
    max(case when diagnosis.value_coded = 'Cleft Lip' then diagnosis.value_coded end) as cleft_lip,
    max(case when diagnosis.value_coded = 'Cleft Palate' then diagnosis.value_coded end) as cleft_palate,
    max(case when care_linked_type.value_coded = 'Clinical' then care_linked_type.value_coded end) as clinical_care,
    max(drugs.value_text) as currently_on_medication_specify,
    max(current_drugs_used.value_coded) as currently_on_medication,
    max(case when diagnosis.value_coded = 'Diagnosis, non-coded' then diagnosis.value_coded end) as diagnosis_other,
    max(case when diagnosis.value_coded = 'Premature Birth' then diagnosis.value_coded end) as premature_birth,
    max(poser_support.value_coded) as eligible_for_poser,
    max(enrolled_in_pdc.value_coded) as enrolled_in_pdc,
    max(case when diagnosis.value_coded = 'Epilepsy' then diagnosis.value_coded end) as epilepsy,
    max(case when infant_feeding_method.value_coded = 'Breast feeding' then infant_feeding_method.value_coded end) as feeding_method_bf,
    max(case when infant_feeding_method.value_coded = 'Cup-feeding' then infant_feeding_method.value_coded end) as feeding_method_cup,
    max(case when infant_feeding_method.value_coded = 'Orogastric tube' then infant_feeding_method.value_coded end) as feeding_method_ogt,
    max(other_non_coded_text.value_text) as feeding_method_other,
    max(age_of_guardian.value_numeric) as guardian_age,
    max(guardian_name_and_first_names.value_text) as guardian_name,
    max(next_of_kin_telephone.value_text) as guardian_phone,
    max(case when diagnosis.value_coded = 'Hypoxic Ischemic Encephalopathy' then diagnosis.value_coded end) as hie,
    max(case when diagnosis.value_coded = 'Hydrocephalus' then diagnosis.value_coded end) as hydrocephalus,
    max(case when care_linked_type.value_coded = 'IC3' then care_linked_type.value_coded end) as ic3,
    max(income_source.value_text) as income_source,
    max(highest_level_of_school_completed.value_coded) as level_of_education,
    max(case when diagnosis.value_coded = 'Low birth weight' then diagnosis.value_coded end) as low_birth_weight,
    max(civil_status.value_coded) as marital_status,
    max(case when care_linked_type.value_coded = 'Mental Health Clinic' then care_linked_type.value_coded end) as mental_health_clinic,
    max(hiv_status.value_coded) as mother_hiv_reactive,
    max(mother_hiv_status.value_coded) as mother_on_art,
    max(case when care_linked_type.value_coded = 'Nutrition Rehabilitation Unit' then care_linked_type.value_coded end) as nru,
    max(clinical_impression_comments.value_text) as notes,
    max(number_of_children.value_numeric) as number_of_children,
    max(type_of_support.value_text) as other_support,
    max(case when care_linked_type.value_coded = 'Paliative linked care' then care_linked_type.value_coded end) as palliative,
    max(perinatal_infection.value_coded) as perinatal_infection,
    max(other_non_coded_text.value_text) as perinatal_infection_specify,
    max(telephone_number.value_numeric) as phone_number,
    max(case when care_linked_type.value_coded = 'Physiotherapy linked care' then care_linked_type.value_coded end) as physiotherapy,
    max(case when pdc_reasons_for_referral.value_coded = 'Hypoxic Ischemic Encephalopathy' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_hie,
    max(case when pdc_reasons_for_referral.value_coded = 'Nervous system diagnosis' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_cns_infection,
    max(case when pdc_reasons_for_referral.value_coded = 'Cleft Lip' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_cleft_lip,
    max(case when pdc_reasons_for_referral.value_coded = 'Cleft Palate' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_cleft_palate,
    max(case when pdc_reasons_for_referral.value_coded = 'Epilepsy' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_epilepsy,
    max(case when pdc_reasons_for_referral.value_coded = 'Hydrocephalus' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_hydrocephalus,
    max(case when pdc_reasons_for_referral.value_coded = 'Low birth weight' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_low_birth_weight,
    max(case when pdc_reasons_for_referral.value_coded = 'Diagnosis, non-coded' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_other,
    max(case when pdc_reasons_for_referral.value_coded = 'Premature Birth' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_premature_birth,
    max(case when pdc_reasons_for_referral.value_coded = 'Severe malnutrition' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_severe_malnutrition,
    max(case when pdc_reasons_for_referral.value_coded = 'Trisomy 21' then pdc_reasons_for_referral.value_coded end) as reason_for_referral_trisomy_21,
    max(referral_form_filled.value_coded) as referral_form_filled,
    max(relationships_of_contact.value_text) as relation_to_patient,
    max(case when diagnosis.value_coded = 'Severe malnutrition' then diagnosis.value_coded end) as severe_malnutrition,
    max(referral_source.value_coded) as source_of_referral,
    max(transfer_in_date.value_date) as transfer_in_date,
    max(case when diagnosis.value_coded = 'Trisomy 21' then diagnosis.value_coded end) as trisomy_21,
    max(case when type_of_feed.value_coded = 'Breast Milk' then type_of_feed.value_coded end) as type_of_feed_breast_milk,
    max(case when type_of_feed.value_coded = 'Infant Formula' then type_of_feed.value_coded end) as type_of_feed_infant_formula,
    max(case when type_of_feed.value_coded = 'Food Package' then type_of_feed.value_coded end) as type_of_feed_solids,
    max(case when type_of_feed.value_coded = 'Mixed feeding' then type_of_feed.value_coded end) as type_of_feed_mixed_feeding
from omrs_encounter e
left join temp_care_linked_type care_linked_type on e.encounter_id = care_linked_type.encounter_id
left join temp_follow_up_agreement follow_up_agreement on e.encounter_id = follow_up_agreement.encounter_id
left join temp_or_last_week_taking_antibiotics currently_or_in_the_last_week_taking_antibiotics on e.encounter_id = currently_or_in_the_last_week_taking_antibiotics.encounter_id
left join temp_duration_coded duration_coded on e.encounter_id = duration_coded.encounter_id
left join temp_method_of_delivery method_of_delivery on e.encounter_id = method_of_delivery.encounter_id
left join temp_birth_location_type birth_location_type on e.encounter_id = birth_location_type.encounter_id
left join temp_diagnosis diagnosis on e.encounter_id = diagnosis.encounter_id
left join temp_care_linked care_linked on e.encounter_id = care_linked.encounter_id
left join temp_hiv_status hiv_status on e.encounter_id = hiv_status.encounter_id
left join temp_childs_current_hiv_status childs_current_hiv_status on e.encounter_id = childs_current_hiv_status.encounter_id
left join temp_drugs drugs on e.encounter_id = drugs.encounter_id
left join temp_current_drugs_used current_drugs_used on e.encounter_id = current_drugs_used.encounter_id
left join temp_poser_support poser_support on e.encounter_id = poser_support.encounter_id
left join temp_enrolled_in_pdc enrolled_in_pdc on e.encounter_id = enrolled_in_pdc.encounter_id
left join temp_infant_feeding_method infant_feeding_method on e.encounter_id = infant_feeding_method.encounter_id
left join temp_other_non_coded_text other_non_coded_text on e.encounter_id = other_non_coded_text.encounter_id
left join temp_age_of_guardian age_of_guardian on e.encounter_id = age_of_guardian.encounter_id
left join temp_guardian_name_and_first_names guardian_name_and_first_names on e.encounter_id = guardian_name_and_first_names.encounter_id
left join temp_next_of_kin_telephone next_of_kin_telephone on e.encounter_id = next_of_kin_telephone.encounter_id
left join temp_income_source income_source on e.encounter_id = income_source.encounter_id
left join temp_highest_level_of_school_completed highest_level_of_school_completed on e.encounter_id = highest_level_of_school_completed.encounter_id
left join temp_civil_status civil_status on e.encounter_id = civil_status.encounter_id
left join temp_mother_hiv_status mother_hiv_status on e.encounter_id = mother_hiv_status.encounter_id
left join temp_clinical_impression_comments clinical_impression_comments on e.encounter_id = clinical_impression_comments.encounter_id
left join temp_number_of_children number_of_children on e.encounter_id = number_of_children.encounter_id
left join temp_type_of_support type_of_support on e.encounter_id = type_of_support.encounter_id
left join temp_perinatal_infection perinatal_infection on e.encounter_id = perinatal_infection.encounter_id
left join temp_telephone_number telephone_number on e.encounter_id = telephone_number.encounter_id
left join temp_pdc_reasons_for_referral pdc_reasons_for_referral on e.encounter_id = pdc_reasons_for_referral.encounter_id
left join temp_referral_form_filled referral_form_filled on e.encounter_id = referral_form_filled.encounter_id
left join temp_relationships_of_contact relationships_of_contact on e.encounter_id = relationships_of_contact.encounter_id
left join temp_referral_source referral_source on e.encounter_id = referral_source.encounter_id
left join temp_transfer_in_date transfer_in_date on e.encounter_id = transfer_in_date.encounter_id
left join temp_type_of_feed type_of_feed on e.encounter_id = type_of_feed.encounter_id
where e.encounter_type in ('PDC_INITIAL')
group by e.patient_id, e.encounter_date, e.location;