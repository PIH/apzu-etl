CREATE TABLE mw_mental_health_followup (
  mental_health_followup_visit_id 	int NOT NULL AUTO_INCREMENT,
  patient_id 				int NOT NULL,
  visit_date 				date DEFAULT NULL,
  location 				varchar(255) DEFAULT NULL,
  height 				int DEFAULT NULL,
  weight 				int DEFAULT NULL,
  phq_nine_score 		        int DEFAULT NULL,
  mse_depressed_mood 			varchar(255) DEFAULT NULL,
  mse_elevated_mood 			varchar(255) DEFAULT NULL,
  mse_disruptive_behaviour 		varchar(255) DEFAULT NULL,
  mse_disorganized_speech 		varchar(255) DEFAULT NULL,
  mse_delusions 			varchar(255) DEFAULT NULL,
  mse_hallucinations 			varchar(255) DEFAULT NULL,
  mse_Lack_of_insight 			varchar(255) DEFAULT NULL,
  mse_other 				varchar(255) DEFAULT NULL,
  patient_stable 			varchar(255) DEFAULT NULL,
  able_to_do_daily_activities  	varchar(255) DEFAULT NULL,
  current_use_marijuana 		varchar(255) DEFAULT NULL,
  current_use_alcohol 			varchar(255) DEFAULT NULL,
  current_use_other 			varchar(255) DEFAULT NULL,
  pregnant 				varchar(255) DEFAULT NULL,
  on_family_planning 			varchar(255) DEFAULT NULL,
  suicide_risk 			varchar(255) DEFAULT NULL,
  medications_side_effects 		varchar(255) DEFAULT NULL,
  hospitalized_since_last_visit 	varchar(255) DEFAULT NULL,
  counselling_provided			varchar(255) DEFAULT NULL,
  med_chloropromazine 			varchar(255) DEFAULT NULL,
  med_chloropromazine_dose		INT,
  med_chloropromazine_dosing_unit VARCHAR(50),
  med_chloropromazine_route		VARCHAR(50),
  med_chloropromazine_frequency		VARCHAR(50),
  med_chloropromazine_duration   INT,
  med_chloropromazine_duration_units  VARCHAR(50),
  med_haloperidol 			varchar(255) DEFAULT NULL,
  med_haloperidolp_dose		INT,
  med_haloperidol_dosing_unit VARCHAR(50),
  med_haloperidol_route		VARCHAR(50),
  med_haloperidol_frequency		VARCHAR(50),
  med_haloperidol_duration   INT,
  med_haloperidol_duration_units  VARCHAR(50),
  med_risperidone			varchar(255) DEFAULT NULL,
  med_risperidone_dose		INT,
  med_risperidone_dosing_unit VARCHAR(50),
  med_risperidone_route		VARCHAR(50),
  med_risperidone_frequency		VARCHAR(50),
  med_risperidone_duration   INT,
  med_risperidone_duration_units  VARCHAR(50),
  med_fluphenazine 			varchar(255) DEFAULT NULL,
  med_fluphenazine_dose		INT,
  med_fluphenazine_dosing_unit VARCHAR(50),
  med_fluphenazine_route		VARCHAR(50),
   med_fluphenazine_frequency		VARCHAR(50),
   med_fluphenazine_duration   INT,
   med_fluphenazine_duration_units  VARCHAR(50),
  med_carbamazepine 			varchar(255) DEFAULT NULL,
  med_carbamazepine_dose		INT,
  med_carbamazepine_dosing_unit VARCHAR(50),
  med_carbamazepine_route		VARCHAR(50),
  med_carbamazepine_frequency		VARCHAR(50),
  med_carbamazepine_duration   INT,
  med_carbamazepine_duration_units  VARCHAR(50),
  med_sodium_valproate 		varchar(255) DEFAULT NULL,
  med_sodium_valproate_dose		INT,
  med_sodium_valproate_dosing_unit VARCHAR(50),
  med_sodium_valproate_route		VARCHAR(50),
  med_sodium_valproate_frequency		VARCHAR(50),
  med_sodium_valproate_duration   INT,
  med_sodium_valproate_duration_units  VARCHAR(50),
  med_fluoxetine 			varchar(255) DEFAULT NULL,
  med_fluoxetine_dose		INT,
  med_fluoxetine_dosing_unit VARCHAR(50),
  med_fluoxetine_route		VARCHAR(50),
  med_fluoxetine_frequency		VARCHAR(50),
  med_fluoxetine_duration   INT,
  med_fluoxetine_duration_units  VARCHAR(50),
  med_olanzapine 			varchar(255) DEFAULT NULL,
  med_olanzapine_dose		INT,
  med_olanzapine_dosing_unit VARCHAR(50),
  med_olanzapine_route		VARCHAR(50),
  med_olanzapine_frequency		VARCHAR(50),
  med_olanzapine_duration   INT,
  med_olanzapine_duration_units  VARCHAR(50),
  med_clozapine 			varchar(255) DEFAULT NULL,
  med_clozapine_dose		INT,
  med_clozapine_dosing_unit VARCHAR(50),
  med_clozapine_route		VARCHAR(50),
  med_clozapine_frequency		VARCHAR(50),
  med_clozapine_duration   INT,
  med_clozapine_duration_units  VARCHAR(50),
  med_trifluoperazine 			varchar(255) DEFAULT NULL,
  med_trifluoperazine_dose		INT,
  med_trifluoperazine_dosing_unit VARCHAR(50),
  med_trifluoperazine_route		VARCHAR(50),
  med_trifluoperazine_frequency		VARCHAR(50),
  med_trifluoperazine_duration   INT,
  med_trifluoperazine_duration_units  VARCHAR(50),
  med_clopixol 			varchar(255) DEFAULT NULL,
  med_clopixol_dose		INT,
  med_clopixol_dosing_unit VARCHAR(50),
  med_clopixol_route		VARCHAR(50),
  med_clopixol_frequency		VARCHAR(50),
  med_clopixol_duration   INT,
  med_clopixol_duration_units  VARCHAR(50),
  med_amitriptyline                    varchar(255) DEFAULT NULL,
  med_amitriptyline_dose		INT,
  med_amitriptyline_dosing_unit VARCHAR(50),
  med_amitriptyline_route		VARCHAR(50),
  med_amitriptyline_frequency		VARCHAR(50),
  med_amitriptyline_duration   INT,
  med_amitriptyline_duration_units  VARCHAR(50),
  med_other 				varchar(255) DEFAULT NULL,
  comments 				varchar(2000) DEFAULT NULL,
  next_appointment_date 		date DEFAULT NULL,
  PRIMARY KEY (mental_health_followup_visit_id)
) ;
