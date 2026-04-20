-- Derivation script for mw_teen_club_intake_survey
-- Generated from Pentaho transform: import-into-mw-teen-club-intake-survey.ktr

drop table if exists mw_teen_club_intake_survey;
create table mw_teen_club_intake_survey (
  teen_club_intake_surevy_visit_id int not null auto_increment,
  patient_id int not null,
  visit_date date default null,
  location varchar(255) default null,
  interview_date date default null,
  interviewer_name varchar(255),
  village_name varchar(255),
  health_facility varchar(255),
  gender varchar(10),
  literate varchar(10),
  in_school varchar(10),
  dropout_class varchar(255),
  current_class varchar(255),
  plans_after_school varchar(255),
  primary_guardian varchar(255),
  parents_location varchar(255),
  staying_with_single_paren_reason varchar(255),
  num_of_household_members int,
  radio varchar(255),
  television varchar(255),
  mobile_phone varchar(255),
  fridge varchar(255),
  bicycle varchar(255),
  motorcycle varchar(255),
  animal_drawn_cart varchar(255),
  car varchar(255),
  source_of_lighting varchar(255),
  source_of_drinking_water varchar(255),
  toilet_at_home varchar(255),
  kind_of_toilet varchar(255),
  cooking_fuel varchar(255),
  type_of_house_floor varchar(255), 
  type_of_house_roof varchar(255), 
  enrolled_in_teen_club varchar(255),
  teen_club_purpose varchar(255),
  teen_club_activities varchar(255),
  teen_club_topics varchar(255),
  happy_with_teen_club varchar(255),
  social_support_from_teen_club varchar(255),
  kind_of_teen_club_social_support varchar(255),
  like_most varchar(255), 
  rate_social_support varchar(255),
  rate_changes_from_social_support varchar(255),
  challenges_in_daily_life varchar(255),
  can_a_healthy_person_have_hiv varchar(255),
  should_a_positive_student_be_allowed_at_your_school varchar(255),
  is_hiv_a_punishment varchar(255),
  is_hiv_bad_luck varchar(255), 
  can_an_hiv_person_live_longer varchar(255),
  are_people_afraid_to_be_around_you varchar(255),
  injectable_drugs varchar(255),
  ever_used_elicit_drugs varchar(255),
  have_sex_under_alcohol_influence varchar(255),
  have_sex_in_exchange_for_money varchar(255),
  have_sex_with_someone_older_or_younger varchar(255),
  have_you_started_thinking_about_your_future varchar(255),
  career_after_school varchar(255),
  area_of_study_interest varchar(255),
  involed_in_extra_curricular_activities varchar(255),
  extracurricular_activities varchar(255),
  careers_or_industries_interested varchar(255),
  have_role_models varchar(255),
  role_models varchar(255),
  what_kind_of_teen_club_support varchar(255),
  got_vocational_training varchar(255),
  what_do_you_want_to_do varchar(255),
  what_exactly_do_you_want_to_do varchar(255),
  staying_with_single_parent_reason varchar(255),
  can_hiv_be_cured varchar(255),
  how_is_hiv_prevented varchar(255),
  how_is_hiv_transmitted varchar(255),
  rate_your_hiv_knowledge varchar(255),
  primary key (teen_club_intake_surevy_visit_id)
);

drop temporary table if exists temp_own_an_animal_drawn_cart;
create temporary table temp_own_an_animal_drawn_cart as select encounter_id, value_coded from omrs_obs where concept = 'Own an animal-drawn Cart';
alter table temp_own_an_animal_drawn_cart add index temp_own_an_animal_drawn_cart_encounter_idx (encounter_id);

drop temporary table if exists temp_answer_for_teen_club_activities;
create temporary table temp_answer_for_teen_club_activities as select encounter_id, value_text from omrs_obs where concept = 'Answer for Teen Club Activities';
alter table temp_answer_for_teen_club_activities add index temp_answer_for_teen_club_activities_encounter_idx (encounter_id);

drop temporary table if exists temp_answer_for_teens_club_purpose;
create temporary table temp_answer_for_teens_club_purpose as select encounter_id, value_text from omrs_obs where concept = 'Answer for Teens Club Purpose';
alter table temp_answer_for_teens_club_purpose add index temp_answer_for_teens_club_purpose_encounter_idx (encounter_id);

drop temporary table if exists temp_answer_for_teen_club_topics;
create temporary table temp_answer_for_teen_club_topics as select encounter_id, value_text from omrs_obs where concept = 'Answer for Teen Club Topics';
alter table temp_answer_for_teen_club_topics add index temp_answer_for_teen_club_topics_encounter_idx (encounter_id);

drop temporary table if exists temp_are_people_afraid_to_be_around_you;
create temporary table temp_are_people_afraid_to_be_around_you as select encounter_id, value_coded from omrs_obs where concept = 'Are people afraid to be around you?';
alter table temp_are_people_afraid_to_be_around_you add index temp_people_afraid_around_encounter_idx (encounter_id);

drop temporary table if exists temp_subjects_or_areas_study_interest_most;
create temporary table temp_subjects_or_areas_study_interest_most as select encounter_id, value_coded from omrs_obs where concept = 'What subjects or areas of study interest you the most?';
alter table temp_subjects_or_areas_study_interest_most add index temp_subjects_or_areas_study_interest_most_2 (encounter_id);

drop temporary table if exists temp_own_a_bicycle;
create temporary table temp_own_a_bicycle as select encounter_id, value_coded from omrs_obs where concept = 'Own a bicycle';
alter table temp_own_a_bicycle add index temp_own_a_bicycle_encounter_idx (encounter_id);

drop temporary table if exists temp_healthy_looking_person_hiv_infection;
create temporary table temp_healthy_looking_person_hiv_infection as select encounter_id, value_coded from omrs_obs where concept = 'Can a healthy-looking person have HIV infection?';
alter table temp_healthy_looking_person_hiv_infection add index temp_healthy_looking_person_hiv_infection_2 (encounter_id);

drop temporary table if exists temp_can_an_hiv_infected_person_live_longer;
create temporary table temp_can_an_hiv_infected_person_live_longer as select encounter_id, value_coded from omrs_obs where concept = 'Can an HIV infected person live longer?';
alter table temp_can_an_hiv_infected_person_live_longer add index temp_hiv_infected_person_live_longer_encounter_idx (encounter_id);

drop temporary table if exists temp_can_hiv_aids_be_cured;
create temporary table temp_can_hiv_aids_be_cured as select encounter_id, value_coded from omrs_obs where concept = 'Can HIV/AIDS be cured?';
alter table temp_can_hiv_aids_be_cured add index temp_can_hiv_aids_be_cured_encounter_idx (encounter_id);

drop temporary table if exists temp_own_an_car_truck;
create temporary table temp_own_an_car_truck as select encounter_id, value_coded from omrs_obs where concept = 'Own an car/truck';
alter table temp_own_an_car_truck add index temp_own_an_car_truck_encounter_idx (encounter_id);

drop temporary table if exists temp_career_job_finish_school;
create temporary table temp_career_job_finish_school as select encounter_id, value_text from omrs_obs where concept = 'What career/job would you like to do when you finish school?';
alter table temp_career_job_finish_school add index temp_career_job_finish_school_encounter_idx (encounter_id);

drop temporary table if exists temp_careers_or_indust_curious_or_learn_more;
create temporary table temp_careers_or_indust_curious_or_learn_more as select encounter_id, value_coded from omrs_obs where concept = 'Are there any specific careers or industries that you are curious about or would like to learn more about?';
alter table temp_careers_or_indust_curious_or_learn_more add index temp_careers_or_indust_curious_or_learn_more_2 (encounter_id);

drop temporary table if exists temp_challenges_you_face_in_daily_life;
create temporary table temp_challenges_you_face_in_daily_life as select encounter_id, value_text from omrs_obs where concept = 'Challenges you face in daily life';
alter table temp_challenges_you_face_in_daily_life add index temp_challenges_face_daily_life_encounter_idx (encounter_id);

drop temporary table if exists temp_fuel_for_household_cooking;
create temporary table temp_fuel_for_household_cooking as select encounter_id, value_coded from omrs_obs where concept = 'Fuel for household cooking';
alter table temp_fuel_for_household_cooking add index temp_fuel_for_household_cooking_encounter_idx (encounter_id);

drop temporary table if exists temp_current_school_class;
create temporary table temp_current_school_class as select encounter_id, value_text from omrs_obs where concept = 'Current School class';
alter table temp_current_school_class add index temp_current_school_class_encounter_idx (encounter_id);

drop temporary table if exists temp_what_you_don;
create temporary table temp_what_you_don as select encounter_id, value_text from omrs_obs where concept = 'What you don';
alter table temp_what_you_don add index temp_what_you_don_encounter_idx (encounter_id);

drop temporary table if exists temp_dropped_out_school_class;
create temporary table temp_dropped_out_school_class as select encounter_id, value_text from omrs_obs where concept = 'Dropped out School Class';
alter table temp_dropped_out_school_class add index temp_dropped_out_school_class_encounter_idx (encounter_id);

drop temporary table if exists temp_enrolled_in_teen_club;
create temporary table temp_enrolled_in_teen_club as select encounter_id, value_coded from omrs_obs where concept = 'Enrolled in teen club';
alter table temp_enrolled_in_teen_club add index temp_enrolled_in_teen_club_encounter_idx (encounter_id);

drop temporary table if exists temp_have_you_ever_used_elicit_drugs;
create temporary table temp_have_you_ever_used_elicit_drugs as select encounter_id, value_coded from omrs_obs where concept = 'Have you ever used elicit drugs?';
alter table temp_have_you_ever_used_elicit_drugs add index temp_have_you_ever_used_elicit_drugs_encounter_idx (encounter_id);

drop temporary table if exists temp_extracurricular_activities;
create temporary table temp_extracurricular_activities as select encounter_id, value_text from omrs_obs where concept = 'Extracurricular activities';
alter table temp_extracurricular_activities add index temp_extracurricular_activities_encounter_idx (encounter_id);

drop temporary table if exists temp_own_a_refrigerator;
create temporary table temp_own_a_refrigerator as select encounter_id, value_coded from omrs_obs where concept = 'Own a refrigerator';
alter table temp_own_a_refrigerator add index temp_own_a_refrigerator_encounter_idx (encounter_id);

drop temporary table if exists temp_gender_of_contact;
create temporary table temp_gender_of_contact as select encounter_id, value_coded from omrs_obs where concept = 'Gender of contact';
alter table temp_gender_of_contact add index temp_gender_of_contact_encounter_idx (encounter_id);

drop temporary table if exists temp_vocat_training_or_certs_field;
create temporary table temp_vocat_training_or_certs_field as select encounter_id, value_coded from omrs_obs where concept = 'Have you obtained any vocational training or certifications in your desired field?';
alter table temp_vocat_training_or_certs_field add index temp_vocat_training_or_certs_field_encounter_idx (encounter_id);

drop temporary table if exists temp_are_you_happy_with_teen_club;
create temporary table temp_are_you_happy_with_teen_club as select encounter_id, value_coded from omrs_obs where concept = 'Are you happy with teen club?';
alter table temp_are_you_happy_with_teen_club add index temp_are_you_happy_with_teen_club_encounter_idx (encounter_id);

drop temporary table if exists temp_role_models_or_profs_field_look;
create temporary table temp_role_models_or_profs_field_look as select encounter_id, value_coded from omrs_obs where concept = 'Are there any role models or professionals in your desired field that you look up to?';
alter table temp_role_models_or_profs_field_look add index temp_role_models_or_profs_field_look_encounter_idx (encounter_id);

drop temporary table if exists temp_did_sex_exchange_money_goods_or_favor;
create temporary table temp_did_sex_exchange_money_goods_or_favor as select encounter_id, value_coded from omrs_obs where concept = 'Did you have sex in exchange for money, goods or favor?';
alter table temp_did_sex_exchange_money_goods_or_favor add index temp_did_sex_exchange_money_goods_or_favor_2 (encounter_id);

drop temporary table if exists temp_do_you_have_sex_when_you;
create temporary table temp_do_you_have_sex_when_you as select encounter_id, value_coded from omrs_obs where concept = 'Do you have sex when you';
alter table temp_do_you_have_sex_when_you add index temp_do_you_have_sex_when_you_encounter_idx (encounter_id);

drop temporary table if exists temp_did_ever_sex_someone_younger_or;
create temporary table temp_did_ever_sex_someone_younger_or as select encounter_id, value_coded from omrs_obs where concept = 'Did you ever have sex with someone who is younger or you';
alter table temp_did_ever_sex_someone_younger_or add index temp_did_ever_sex_someone_younger_or_encounter_idx (encounter_id);

drop temporary table if exists temp_started_thinking_future_career_and_job_aspir;
create temporary table temp_started_thinking_future_career_and_job_aspir as select encounter_id, value_coded from omrs_obs where concept = 'Have you started thinking about your future career and job aspirations?';
alter table temp_started_thinking_future_career_and_job_aspir add index temp_started_thinking_future_career_aspir (encounter_id);

drop temporary table if exists temp_health_facility_name;
create temporary table temp_health_facility_name as select encounter_id, value_text from omrs_obs where concept = 'Health facility name';
alter table temp_health_facility_name add index temp_health_facility_name_encounter_idx (encounter_id);

drop temporary table if exists temp_how_is_hiv_aids_prevented;
create temporary table temp_how_is_hiv_aids_prevented as select encounter_id, value_coded from omrs_obs where concept = 'How is HIV/AIDS prevented?';
alter table temp_how_is_hiv_aids_prevented add index temp_how_is_hiv_aids_prevented_encounter_idx (encounter_id);

drop temporary table if exists temp_answer_for_how_hiv_is_transmitted;
create temporary table temp_answer_for_how_hiv_is_transmitted as select encounter_id, value_text from omrs_obs where concept = 'Answer for How HIV is transmitted';
alter table temp_answer_for_how_hiv_is_transmitted add index temp_answer_hiv_transmitted_encounter_idx (encounter_id);

drop temporary table if exists temp_are_you_in_school;
create temporary table temp_are_you_in_school as select encounter_id, value_coded from omrs_obs where concept = 'Are you in school?';
alter table temp_are_you_in_school add index temp_are_you_in_school_encounter_idx (encounter_id);

drop temporary table if exists temp_have_you_ever_used_injectable_drugs;
create temporary table temp_have_you_ever_used_injectable_drugs as select encounter_id, value_coded from omrs_obs where concept = 'Have you ever used injectable drugs?';
alter table temp_have_you_ever_used_injectable_drugs add index temp_ever_used_injectable_drugs_encounter_idx (encounter_id);

drop temporary table if exists temp_data_collection_date;
create temporary table temp_data_collection_date as select encounter_id, value_date from omrs_obs where concept = 'Data collection date';
alter table temp_data_collection_date add index temp_data_collection_date_encounter_idx (encounter_id);

drop temporary table if exists temp_interviewer_name;
create temporary table temp_interviewer_name as select encounter_id, value_text from omrs_obs where concept = 'Interviewer Name';
alter table temp_interviewer_name add index temp_interviewer_name_encounter_idx (encounter_id);

drop temporary table if exists temp_extracurr_acts_or_clubs_career_intrsts;
create temporary table temp_extracurr_acts_or_clubs_career_intrsts as select encounter_id, value_coded from omrs_obs where concept = 'Are you currently involved in any extracurricular activities or clubs related to your career interests?';
alter table temp_extracurr_acts_or_clubs_career_intrsts add index temp_extracurr_acts_or_clubs_career_intrsts_2 (encounter_id);

drop temporary table if exists temp_is_hiv_a_punishment_for_bad_behaviour;
create temporary table temp_is_hiv_a_punishment_for_bad_behaviour as select encounter_id, value_coded from omrs_obs where concept = 'Is HIV a punishment for bad behaviour?';
alter table temp_is_hiv_a_punishment_for_bad_behaviour add index temp_hiv_punishment_bad_behaviour_encounter_idx (encounter_id);

drop temporary table if exists temp_is_hiv_just_a_matter_of_bad_luck;
create temporary table temp_is_hiv_just_a_matter_of_bad_luck as select encounter_id, value_coded from omrs_obs where concept = 'Is HIV just a matter of bad luck?';
alter table temp_is_hiv_just_a_matter_of_bad_luck add index temp_hiv_just_matter_bad_luck_encounter_idx (encounter_id);

drop temporary table if exists temp_answer_for_kind_of_teen_club_support;
create temporary table temp_answer_for_kind_of_teen_club_support as select encounter_id, value_text from omrs_obs where concept = 'Answer for Kind of teen club support';
alter table temp_answer_for_kind_of_teen_club_support add index temp_answer_kind_teen_club_supp_encounter_idx (encounter_id);

drop temporary table if exists temp_answer_kind_teen_club_supp_get;
create temporary table temp_answer_kind_teen_club_supp_get as select encounter_id, value_text from omrs_obs where concept = 'Answer for Kind of teen club support would you like to get';
alter table temp_answer_kind_teen_club_supp_get add index temp_answer_kind_teen_club_supp_get_encounter_idx (encounter_id);

drop temporary table if exists temp_kind_toilet_facility_used_household_members;
create temporary table temp_kind_toilet_facility_used_household_members as select encounter_id, value_coded from omrs_obs where concept = 'Kind of toilet facility used by household members';
alter table temp_kind_toilet_facility_used_household_members add index temp_kind_toilet_facility_used_household_members_2 (encounter_id);

drop temporary table if exists temp_what_you_like_most_at_teen_club;
create temporary table temp_what_you_like_most_at_teen_club as select encounter_id, value_text from omrs_obs where concept = 'What you like most at teen club?';
alter table temp_what_you_like_most_at_teen_club add index temp_what_you_like_most_at_teen_club_encounter_idx (encounter_id);

drop temporary table if exists temp_literate;
create temporary table temp_literate as select encounter_id, value_coded from omrs_obs where concept = 'Literate';
alter table temp_literate add index temp_literate_encounter_idx (encounter_id);

drop temporary table if exists temp_own_a_mobile_telephone;
create temporary table temp_own_a_mobile_telephone as select encounter_id, value_coded from omrs_obs where concept = 'Own a mobile telephone';
alter table temp_own_a_mobile_telephone add index temp_own_a_mobile_telephone_encounter_idx (encounter_id);

drop temporary table if exists temp_own_a_motorcycle;
create temporary table temp_own_a_motorcycle as select encounter_id, value_coded from omrs_obs where concept = 'Own a motorcycle';
alter table temp_own_a_motorcycle add index temp_own_a_motorcycle_encounter_idx (encounter_id);

drop temporary table if exists temp_total_number_of_household_members;
create temporary table temp_total_number_of_household_members as select encounter_id, value_numeric from omrs_obs where concept = 'Total number of household members';
alter table temp_total_number_of_household_members add index temp_total_number_household_members_encounter_idx (encounter_id);

drop temporary table if exists temp_parents_location;
create temporary table temp_parents_location as select encounter_id, value_text from omrs_obs where concept = 'Parents location';
alter table temp_parents_location add index temp_parents_location_encounter_idx (encounter_id);

drop temporary table if exists temp_plans_after_school;
create temporary table temp_plans_after_school as select encounter_id, value_coded from omrs_obs where concept = 'Plans after school';
alter table temp_plans_after_school add index temp_plans_after_school_encounter_idx (encounter_id);

drop temporary table if exists temp_primary_guardian;
create temporary table temp_primary_guardian as select encounter_id, value_coded from omrs_obs where concept = 'Primary Guardian';
alter table temp_primary_guardian add index temp_primary_guardian_encounter_idx (encounter_id);

drop temporary table if exists temp_own_a_radio;
create temporary table temp_own_a_radio as select encounter_id, value_coded from omrs_obs where concept = 'Own a radio';
alter table temp_own_a_radio add index temp_own_a_radio_encounter_idx (encounter_id);

drop temporary table if exists temp_rate_chgs_hppnd_life_social_supp_scale_1_3;
create temporary table temp_rate_chgs_hppnd_life_social_supp_scale_1_3 as select encounter_id, value_coded from omrs_obs where concept = 'Can you rate the changes that happened to your life from the social support a scale of 1 to 3?';
alter table temp_rate_chgs_hppnd_life_social_supp_scale_1_3 add index temp_rate_chgs_hppnd_life_social_supp_scale_1_3_2 (encounter_id);

drop temporary table if exists temp_rate_supp_scale_1_3;
create temporary table temp_rate_supp_scale_1_3 as select encounter_id, value_coded from omrs_obs where concept = 'How do you rate the support on a scale of 1 to 3?';
alter table temp_rate_supp_scale_1_3 add index temp_rate_supp_scale_1_3_encounter_idx (encounter_id);

drop temporary table if exists temp_rate_your_hiv_knowledge;
create temporary table temp_rate_your_hiv_knowledge as select encounter_id, value_coded from omrs_obs where concept = 'Rate your HIV knowledge';
alter table temp_rate_your_hiv_knowledge add index temp_rate_your_hiv_knowledge_encounter_idx (encounter_id);

drop temporary table if exists temp_reason_for_staying_with_single_parent;
create temporary table temp_reason_for_staying_with_single_parent as select encounter_id, value_coded from omrs_obs where concept = 'Reason for staying with single parent';
alter table temp_reason_for_staying_with_single_parent add index temp_reason_staying_single_parent_encounter_idx (encounter_id);

drop temporary table if exists temp_name_of_role_model_s;
create temporary table temp_name_of_role_model_s as select encounter_id, value_text from omrs_obs where concept = 'Name of role model(s)';
alter table temp_name_of_role_model_s add index temp_name_of_role_model_s_encounter_idx (encounter_id);

drop temporary table if exists temp_social_support_from_teen_club;
create temporary table temp_social_support_from_teen_club as select encounter_id, value_coded from omrs_obs where concept = 'Social support from teen club';
alter table temp_social_support_from_teen_club add index temp_social_support_from_teen_club_encounter_idx (encounter_id);

drop temporary table if exists temp_main_source_of_drinking_water_for_household;
create temporary table temp_main_source_of_drinking_water_for_household as select encounter_id, value_coded from omrs_obs where concept = 'Main source of drinking water for household';
alter table temp_main_source_of_drinking_water_for_household add index temp_main_source_drinking_water_household (encounter_id);

drop temporary table if exists temp_main_energy_source_for_household_lighting;
create temporary table temp_main_energy_source_for_household_lighting as select encounter_id, value_coded from omrs_obs where concept = 'Main energy source for household lighting';
alter table temp_main_energy_source_for_household_lighting add index temp_main_energy_source_household_lighting (encounter_id);

drop temporary table if exists temp_own_a_tv;
create temporary table temp_own_a_tv as select encounter_id, value_coded from omrs_obs where concept = 'Own a Tv';
alter table temp_own_a_tv add index temp_own_a_tv_encounter_idx (encounter_id);

drop temporary table if exists temp_do_you_have_a_toilet_at_home;
create temporary table temp_do_you_have_a_toilet_at_home as select encounter_id, value_coded from omrs_obs where concept = 'Do you have a toilet at home?';
alter table temp_do_you_have_a_toilet_at_home add index temp_do_you_have_a_toilet_at_home_encounter_idx (encounter_id);

drop temporary table if exists temp_type_of_house_floor;
create temporary table temp_type_of_house_floor as select encounter_id, value_coded from omrs_obs where concept = 'Type of house floor';
alter table temp_type_of_house_floor add index temp_type_of_house_floor_encounter_idx (encounter_id);

drop temporary table if exists temp_type_of_house_roof;
create temporary table temp_type_of_house_roof as select encounter_id, value_coded from omrs_obs where concept = 'Type of house roof';
alter table temp_type_of_house_roof add index temp_type_of_house_roof_encounter_idx (encounter_id);

drop temporary table if exists temp_village;
create temporary table temp_village as select encounter_id, value_text from omrs_obs where concept = 'Village';
alter table temp_village add index temp_village_encounter_idx (encounter_id);

drop temporary table if exists temp_what_courses_or_what_do_you_want_to_do_life;
create temporary table temp_what_courses_or_what_do_you_want_to_do_life as select encounter_id, value_text from omrs_obs where concept = 'What courses or what do you want to do life?';
alter table temp_what_courses_or_what_do_you_want_to_do_life add index temp_courses_or_want_life_encounter_idx (encounter_id);

drop temporary table if exists temp_what_exactly_do_you_want_to_do_in_this_life;
create temporary table temp_what_exactly_do_you_want_to_do_in_this_life as select encounter_id, value_text from omrs_obs where concept = 'What exactly do you want to do in this life?';
alter table temp_what_exactly_do_you_want_to_do_in_this_life add index temp_exactly_want_this_life_encounter_idx (encounter_id);

insert into mw_teen_club_intake_survey (patient_id, visit_date, location, animal_drawn_cart, teen_club_activities, teen_club_purpose, teen_club_topics, are_people_afraid_to_be_around_you, area_of_study_interest, bicycle, can_a_healthy_person_have_hiv, can_an_hiv_person_live_longer, can_hiv_be_cured, car, career_after_school, careers_or_industries_interested, challenges_in_daily_life, cooking_fuel, current_class, like_most, dropout_class, enrolled_in_teen_club, ever_used_elicit_drugs, extracurricular_activities, fridge, gender, got_vocational_training, happy_with_teen_club, have_role_models, have_sex_in_exchange_for_money, have_sex_under_alcohol_influence, have_sex_with_someone_older_or_younger, have_you_started_thinking_about_your_future, health_facility, how_is_hiv_prevented, how_is_hiv_transmitted, in_school, injectable_drugs, interview_date, interviewer_name, involed_in_extra_curricular_activities, is_hiv_a_punishment, is_hiv_bad_luck, kind_of_teen_club_social_support, what_kind_of_teen_club_support, kind_of_toilet, like_most, literate, mobile_phone, motorcycle, num_of_household_members, parents_location, plans_after_school, primary_guardian, radio, rate_changes_from_social_support, rate_social_support, rate_your_hiv_knowledge, staying_with_single_paren_reason, role_models, should_a_positive_student_be_allowed_at_your_school, social_support_from_teen_club, source_of_drinking_water, source_of_lighting, television, toilet_at_home, type_of_house_floor, type_of_house_roof, village_name, what_do_you_want_to_do, what_exactly_do_you_want_to_do, what_kind_of_teen_club_support)
select
    e.patient_id,
    date(e.encounter_date) as visit_date,
    e.location,
    max(own_an_animal_drawn_cart.value_coded) as animal_drawn_cart,
    max(answer_for_teen_club_activities.value_text) as ans_teen_club_activities,
    max(answer_for_teens_club_purpose.value_text) as ans_teen_club_purpose,
    max(answer_for_teen_club_topics.value_text) as ans_teen_club_topics,
    max(are_people_afraid_to_be_around_you.value_coded) as are_people_afraid_to_be_around_you,
    max(what_subjects_or_areas_of_study_interest_you_the_most.value_coded) as area_of_study_interest,
    max(own_a_bicycle.value_coded) as bicycle,
    max(can_a_healthy_looking_person_have_hiv_infection.value_coded) as can_a_healthy_person_have_hiv,
    max(can_an_hiv_infected_person_live_longer.value_coded) as can_an_hiv_person_live_longer,
    max(can_hiv_aids_be_cured.value_coded) as can_hiv_be_cured,
    max(own_an_car_truck.value_coded) as car,
    max(what_career_job_would_you_like_to_do_when_you_finish_school.value_text) as career_after_school,
    max(are_there_any_specific_careers_or_industries_that_you_are_curious_about_or_would_like_to_learn_more_about.value_coded) as careers_or_industries_interested,
    max(challenges_you_face_in_daily_life.value_text) as challenges_in_daily_life,
    max(fuel_for_household_cooking.value_coded) as cooking_fuel,
    max(current_school_class.value_text) as current_class,
    max(what_you_don.value_text) as like_most_at_teen_club,
    max(dropped_out_school_class.value_text) as dropout_class,
    max(enrolled_in_teen_club.value_coded) as enrolled_in_teen_club,
    max(have_you_ever_used_elicit_drugs.value_coded) as ever_used_elicit_drugs,
    max(extracurricular_activities.value_text) as extracurricular_activities,
    max(own_a_refrigerator.value_coded) as fridge,
    max(gender_of_contact.value_coded) as gender,
    max(have_you_obtained_any_vocational_training_or_certifications_in_your_desired_field.value_coded) as got_vocational_training,
    max(are_you_happy_with_teen_club.value_coded) as happy_with_teen_club,
    max(are_there_any_role_models_or_professionals_in_your_desired_field_that_you_look_up_to.value_coded) as have_role_models,
    max(did_you_have_sex_in_exchange_for_money_goods_or_favor.value_coded) as have_sex_in_exchange_for_money,
    max(do_you_have_sex_when_you.value_coded) as have_sex_under_alcohol_influence,
    max(did_you_ever_have_sex_with_someone_who_is_younger_or_you.value_coded) as have_sex_with_someone_older_or_younger,
    max(have_you_started_thinking_about_your_future_career_and_job_aspirations.value_coded) as have_you_started_thinking_about_your_future,
    max(health_facility_name.value_text) as health_facility,
    max(how_is_hiv_aids_prevented.value_coded) as how_hiv_is_prevented,
    max(answer_for_how_hiv_is_transmitted.value_text) as how_hiv_is_transmitted,
    max(are_you_in_school.value_coded) as in_school,
    max(have_you_ever_used_injectable_drugs.value_coded) as injectable_drugs,
    max(data_collection_date.value_date) as interview_date,
    max(interviewer_name.value_text) as interviewer_name,
    max(are_you_currently_involved_in_any_extracurricular_activities_or_clubs_related_to_your_career_interests.value_coded) as involed_in_extra_curricular_activities,
    max(is_hiv_a_punishment_for_bad_behaviour.value_coded) as is_hiv_a_punishment,
    max(is_hiv_just_a_matter_of_bad_luck.value_coded) as is_hiv_bad_luck,
    max(answer_for_kind_of_teen_club_support.value_text) as kind_of_teen_club_support,
    max(answer_for_kind_of_teen_club_support_would_you_like_to_get.value_text) as kind_of_teen_club_support_you_would_like,
    max(kind_of_toilet_facility_used_by_household_members.value_coded) as kind_of_toilet,
    max(what_you_like_most_at_teen_club.value_text) as like_most_at_teen_club,
    max(literate.value_coded) as literate,
    max(own_a_mobile_telephone.value_coded) as mobile_phone,
    max(own_a_motorcycle.value_coded) as motorcycle,
    max(total_number_of_household_members.value_numeric) as num_of_household_members,
    max(parents_location.value_text) as parents_location,
    max(plans_after_school.value_coded) as plans_after_school,
    max(primary_guardian.value_coded) as primary_guardian,
    max(own_a_radio.value_coded) as radio,
    max(can_you_rate_the_changes_that_happened_to_your_life_from_the_social_support_a_scale_of_1_to_3.value_coded) as rate_changes_from_social_support,
    max(how_do_you_rate_the_support_on_a_scale_of_1_to_3.value_coded) as rate_social_support,
    max(rate_your_hiv_knowledge.value_coded) as rate_your_hiv_knowledge,
    max(reason_for_staying_with_single_parent.value_coded) as staying_with_single_paren_reason,
    max(name_of_role_model_s.value_text) as role_models,
    max(can_a_healthy_looking_person_have_hiv_infection.value_coded) as should_a_positive_student_be_allowed_at_your_school,
    max(social_support_from_teen_club.value_coded) as social_support_from_teen_club,
    max(main_source_of_drinking_water_for_household.value_coded) as source_of_drinking_water,
    max(main_energy_source_for_household_lighting.value_coded) as source_of_lighting,
    max(own_a_tv.value_coded) as tv,
    max(do_you_have_a_toilet_at_home.value_coded) as toilet_at_home,
    max(type_of_house_floor.value_coded) as type_of_house_floor,
    max(type_of_house_roof.value_coded) as type_of_house_roof,
    max(village.value_text) as village_name,
    max(what_courses_or_what_do_you_want_to_do_life.value_text) as what_do_you_want_to_do,
    max(what_exactly_do_you_want_to_do_in_this_life.value_text) as what_exactly_do_you_want_to_do,
    max(answer_for_kind_of_teen_club_support_would_you_like_to_get.value_text) as what_kind_of_teen_club_support
from omrs_encounter e
left join temp_own_an_animal_drawn_cart own_an_animal_drawn_cart on e.encounter_id = own_an_animal_drawn_cart.encounter_id
left join temp_answer_for_teen_club_activities answer_for_teen_club_activities on e.encounter_id = answer_for_teen_club_activities.encounter_id
left join temp_answer_for_teens_club_purpose answer_for_teens_club_purpose on e.encounter_id = answer_for_teens_club_purpose.encounter_id
left join temp_answer_for_teen_club_topics answer_for_teen_club_topics on e.encounter_id = answer_for_teen_club_topics.encounter_id
left join temp_are_people_afraid_to_be_around_you are_people_afraid_to_be_around_you on e.encounter_id = are_people_afraid_to_be_around_you.encounter_id
left join temp_subjects_or_areas_study_interest_most what_subjects_or_areas_of_study_interest_you_the_most on e.encounter_id = what_subjects_or_areas_of_study_interest_you_the_most.encounter_id
left join temp_own_a_bicycle own_a_bicycle on e.encounter_id = own_a_bicycle.encounter_id
left join temp_healthy_looking_person_hiv_infection can_a_healthy_looking_person_have_hiv_infection on e.encounter_id = can_a_healthy_looking_person_have_hiv_infection.encounter_id
left join temp_can_an_hiv_infected_person_live_longer can_an_hiv_infected_person_live_longer on e.encounter_id = can_an_hiv_infected_person_live_longer.encounter_id
left join temp_can_hiv_aids_be_cured can_hiv_aids_be_cured on e.encounter_id = can_hiv_aids_be_cured.encounter_id
left join temp_own_an_car_truck own_an_car_truck on e.encounter_id = own_an_car_truck.encounter_id
left join temp_career_job_finish_school what_career_job_would_you_like_to_do_when_you_finish_school on e.encounter_id = what_career_job_would_you_like_to_do_when_you_finish_school.encounter_id
left join temp_careers_or_indust_curious_or_learn_more are_there_any_specific_careers_or_industries_that_you_are_curious_about_or_would_like_to_learn_more_about on e.encounter_id = are_there_any_specific_careers_or_industries_that_you_are_curious_about_or_would_like_to_learn_more_about.encounter_id
left join temp_challenges_you_face_in_daily_life challenges_you_face_in_daily_life on e.encounter_id = challenges_you_face_in_daily_life.encounter_id
left join temp_fuel_for_household_cooking fuel_for_household_cooking on e.encounter_id = fuel_for_household_cooking.encounter_id
left join temp_current_school_class current_school_class on e.encounter_id = current_school_class.encounter_id
left join temp_what_you_don what_you_don on e.encounter_id = what_you_don.encounter_id
left join temp_dropped_out_school_class dropped_out_school_class on e.encounter_id = dropped_out_school_class.encounter_id
left join temp_enrolled_in_teen_club enrolled_in_teen_club on e.encounter_id = enrolled_in_teen_club.encounter_id
left join temp_have_you_ever_used_elicit_drugs have_you_ever_used_elicit_drugs on e.encounter_id = have_you_ever_used_elicit_drugs.encounter_id
left join temp_extracurricular_activities extracurricular_activities on e.encounter_id = extracurricular_activities.encounter_id
left join temp_own_a_refrigerator own_a_refrigerator on e.encounter_id = own_a_refrigerator.encounter_id
left join temp_gender_of_contact gender_of_contact on e.encounter_id = gender_of_contact.encounter_id
left join temp_vocat_training_or_certs_field have_you_obtained_any_vocational_training_or_certifications_in_your_desired_field on e.encounter_id = have_you_obtained_any_vocational_training_or_certifications_in_your_desired_field.encounter_id
left join temp_are_you_happy_with_teen_club are_you_happy_with_teen_club on e.encounter_id = are_you_happy_with_teen_club.encounter_id
left join temp_role_models_or_profs_field_look are_there_any_role_models_or_professionals_in_your_desired_field_that_you_look_up_to on e.encounter_id = are_there_any_role_models_or_professionals_in_your_desired_field_that_you_look_up_to.encounter_id
left join temp_did_sex_exchange_money_goods_or_favor did_you_have_sex_in_exchange_for_money_goods_or_favor on e.encounter_id = did_you_have_sex_in_exchange_for_money_goods_or_favor.encounter_id
left join temp_do_you_have_sex_when_you do_you_have_sex_when_you on e.encounter_id = do_you_have_sex_when_you.encounter_id
left join temp_did_ever_sex_someone_younger_or did_you_ever_have_sex_with_someone_who_is_younger_or_you on e.encounter_id = did_you_ever_have_sex_with_someone_who_is_younger_or_you.encounter_id
left join temp_started_thinking_future_career_and_job_aspir have_you_started_thinking_about_your_future_career_and_job_aspirations on e.encounter_id = have_you_started_thinking_about_your_future_career_and_job_aspirations.encounter_id
left join temp_health_facility_name health_facility_name on e.encounter_id = health_facility_name.encounter_id
left join temp_how_is_hiv_aids_prevented how_is_hiv_aids_prevented on e.encounter_id = how_is_hiv_aids_prevented.encounter_id
left join temp_answer_for_how_hiv_is_transmitted answer_for_how_hiv_is_transmitted on e.encounter_id = answer_for_how_hiv_is_transmitted.encounter_id
left join temp_are_you_in_school are_you_in_school on e.encounter_id = are_you_in_school.encounter_id
left join temp_have_you_ever_used_injectable_drugs have_you_ever_used_injectable_drugs on e.encounter_id = have_you_ever_used_injectable_drugs.encounter_id
left join temp_data_collection_date data_collection_date on e.encounter_id = data_collection_date.encounter_id
left join temp_interviewer_name interviewer_name on e.encounter_id = interviewer_name.encounter_id
left join temp_extracurr_acts_or_clubs_career_intrsts are_you_currently_involved_in_any_extracurricular_activities_or_clubs_related_to_your_career_interests on e.encounter_id = are_you_currently_involved_in_any_extracurricular_activities_or_clubs_related_to_your_career_interests.encounter_id
left join temp_is_hiv_a_punishment_for_bad_behaviour is_hiv_a_punishment_for_bad_behaviour on e.encounter_id = is_hiv_a_punishment_for_bad_behaviour.encounter_id
left join temp_is_hiv_just_a_matter_of_bad_luck is_hiv_just_a_matter_of_bad_luck on e.encounter_id = is_hiv_just_a_matter_of_bad_luck.encounter_id
left join temp_answer_for_kind_of_teen_club_support answer_for_kind_of_teen_club_support on e.encounter_id = answer_for_kind_of_teen_club_support.encounter_id
left join temp_answer_kind_teen_club_supp_get answer_for_kind_of_teen_club_support_would_you_like_to_get on e.encounter_id = answer_for_kind_of_teen_club_support_would_you_like_to_get.encounter_id
left join temp_kind_toilet_facility_used_household_members kind_of_toilet_facility_used_by_household_members on e.encounter_id = kind_of_toilet_facility_used_by_household_members.encounter_id
left join temp_what_you_like_most_at_teen_club what_you_like_most_at_teen_club on e.encounter_id = what_you_like_most_at_teen_club.encounter_id
left join temp_literate literate on e.encounter_id = literate.encounter_id
left join temp_own_a_mobile_telephone own_a_mobile_telephone on e.encounter_id = own_a_mobile_telephone.encounter_id
left join temp_own_a_motorcycle own_a_motorcycle on e.encounter_id = own_a_motorcycle.encounter_id
left join temp_total_number_of_household_members total_number_of_household_members on e.encounter_id = total_number_of_household_members.encounter_id
left join temp_parents_location parents_location on e.encounter_id = parents_location.encounter_id
left join temp_plans_after_school plans_after_school on e.encounter_id = plans_after_school.encounter_id
left join temp_primary_guardian primary_guardian on e.encounter_id = primary_guardian.encounter_id
left join temp_own_a_radio own_a_radio on e.encounter_id = own_a_radio.encounter_id
left join temp_rate_chgs_hppnd_life_social_supp_scale_1_3 can_you_rate_the_changes_that_happened_to_your_life_from_the_social_support_a_scale_of_1_to_3 on e.encounter_id = can_you_rate_the_changes_that_happened_to_your_life_from_the_social_support_a_scale_of_1_to_3.encounter_id
left join temp_rate_supp_scale_1_3 how_do_you_rate_the_support_on_a_scale_of_1_to_3 on e.encounter_id = how_do_you_rate_the_support_on_a_scale_of_1_to_3.encounter_id
left join temp_rate_your_hiv_knowledge rate_your_hiv_knowledge on e.encounter_id = rate_your_hiv_knowledge.encounter_id
left join temp_reason_for_staying_with_single_parent reason_for_staying_with_single_parent on e.encounter_id = reason_for_staying_with_single_parent.encounter_id
left join temp_name_of_role_model_s name_of_role_model_s on e.encounter_id = name_of_role_model_s.encounter_id
left join temp_social_support_from_teen_club social_support_from_teen_club on e.encounter_id = social_support_from_teen_club.encounter_id
left join temp_main_source_of_drinking_water_for_household main_source_of_drinking_water_for_household on e.encounter_id = main_source_of_drinking_water_for_household.encounter_id
left join temp_main_energy_source_for_household_lighting main_energy_source_for_household_lighting on e.encounter_id = main_energy_source_for_household_lighting.encounter_id
left join temp_own_a_tv own_a_tv on e.encounter_id = own_a_tv.encounter_id
left join temp_do_you_have_a_toilet_at_home do_you_have_a_toilet_at_home on e.encounter_id = do_you_have_a_toilet_at_home.encounter_id
left join temp_type_of_house_floor type_of_house_floor on e.encounter_id = type_of_house_floor.encounter_id
left join temp_type_of_house_roof type_of_house_roof on e.encounter_id = type_of_house_roof.encounter_id
left join temp_village village on e.encounter_id = village.encounter_id
left join temp_what_courses_or_what_do_you_want_to_do_life what_courses_or_what_do_you_want_to_do_life on e.encounter_id = what_courses_or_what_do_you_want_to_do_life.encounter_id
left join temp_what_exactly_do_you_want_to_do_in_this_life what_exactly_do_you_want_to_do_in_this_life on e.encounter_id = what_exactly_do_you_want_to_do_in_this_life.encounter_id
where e.encounter_type in ('TEEN_CLUB_INTAKE_SURVEY')
group by e.patient_id, e.encounter_date, e.location;