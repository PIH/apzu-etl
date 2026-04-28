CREATE  PROCEDURE `create_rpt_mh_data`(IN _endDate DATE, IN _location VARCHAR(255))
BEGIN

  
  DROP TABLE IF EXISTS rpt_ic3_patient_ids;
  CREATE TEMPORARY TABLE rpt_ic3_patient_ids AS
    SELECT DISTINCT(patient_id)
    FROM mw_mental_health_initial

    UNION

    SELECT DISTINCT(patient_id)
    FROM mw_mental_health_followup

    UNION

    SELECT DISTINCT(patient_id)
    FROM mw_epilepsy_initial

    UNION

    SELECT DISTINCT(patient_id)
    FROM mw_epilepsy_followup;

  CREATE INDEX patient_id_index ON rpt_ic3_patient_ids(patient_id);

  
  DROP TABLE IF EXISTS rpt_mh_data_table;
  CREATE TABLE rpt_mh_data_table AS
    
    SELECT
      ic3.patient_id,
      birthdate,
      gender,
      epilepsyDx,
      epilepsyIntakeVisitDate,
      epilepsyIntakeLocation,
      YEAR(epilepsyIntakeVisitDate) - YEAR(birthdate)
      - (DATE_FORMAT(epilepsyIntakeVisitDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d')) as ageAtEpilepsyIntake,
      lastEpilepsyVisitDate,
      lastEpilepsyVisitLocation,
      YEAR(lastEpilepsyVisitDate) - YEAR(birthdate)
      - (DATE_FORMAT(lastEpilepsyVisitDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d')) as ageAtLastEpilepsyVisit,
      nextEpilepsyAppt,
      mhIntakeVisitDate,
      YEAR(mhIntakeVisitDate) - YEAR(birthdate)
      - (DATE_FORMAT(mhIntakeVisitDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d')) as ageAtMHIntake,
      mhIntakeLocation,
      dx_organic_mental_disorder_chronic,
      dx_date_organic_mental_disorder_chronic,
      dx_organic_mental_disorder_acute,
      dx_date_organic_mental_disorder_acute,
      dx_alcohol_use_mental_disorder,
      dx_date_alcohol_use_mental_disorder,
      dx_drug_use_mental_disorder,
      dx_date_drug_use_mental_disorder,
      dx_schizophrenia,
      dx_acute_and_transient_psychotic,
      dx_schizoaffective_disorder,
      dx_mood_affective_disorder_manic,
      dx_mood_affective_disorder_depression,
      dx_anxiety_disorder,
      dx_bipolar_mood_disorder,
      dx_dissociative_mood_disorder,
      dx_hyperkinetic_disorder,
      dx_puerperal_mental_disorder,
      dx_stress_reactive_adjustment_disorder,
      dx_psych_development_disorder,
      dx_mental_retardation_disorder,
      dx_personality_disorder,
      dx_somatoform_disorder,
      dx_mh_other_1,
      dx_mh_other_2,
      dx_mh_other_3,
      lastMHVisitDate,
      YEAR(lastMHVisitDate) - YEAR(birthdate)
      - (DATE_FORMAT(lastMHVisitDate, '%m%d') < DATE_FORMAT(birthdate, '%m%d')) as ageAtLastMHVisit,
      visitLocation,
      nextMHAppt
    FROM 			rpt_ic3_patient_ids ic3
      INNER JOIN 		(SELECT patient_id,
                      birthdate,
                      gender
                    FROM mw_patient
                   ) pdetails
        ON pdetails.patient_id = ic3.patient_id
      LEFT JOIN 		(SELECT patient_id,
                      CASE WHEN diagnosis IS NOT NULL THEN 'X' END AS epilepsyDx
                    FROM mw_ncd_diagnoses
                    WHERE diagnosis = "Epilepsy"
                          AND diagnosis_date < _endDate
                    GROUP BY patient_id
                   ) epilepsyDx
        ON epilepsyDx.patient_id = ic3.patient_id
      LEFT JOIN		(SELECT *
                    FROM 	(SELECT patient_id,
                             visit_date AS epilepsyIntakeVisitDate,
                             location AS epilepsyIntakeLocation
                           FROM mw_epilepsy_initial
                           ORDER BY visit_date DESC
                          ) epilepsyInner GROUP BY patient_id
                   ) epilepsyIntake ON epilepsyIntake.patient_id = ic3.patient_id
      LEFT JOIN		(SELECT *
                    FROM 	(SELECT patient_id,
                             visit_date AS lastEpilepsyVisitDate,
                             location AS lastEpilepsyVisitLocation,
                             next_appointment_date AS nextEpilepsyAppt
                           FROM mw_epilepsy_followup
                           WHERE location= _location
                                 AND visit_date < _endDate
                           ORDER BY visit_date DESC
                          ) epilepsyFollowupInner GROUP BY patient_id
                   ) epilepsyVisit ON epilepsyVisit.patient_id = ic3.patient_id
      LEFT JOIN		(SELECT *
                    FROM 	(SELECT patient_id,
                             visit_date AS mhIntakeVisitDate,
                             location AS mhIntakeLocation,
                             diagnosis_organic_mental_disorder_chronic as dx_organic_mental_disorder_chronic,
                             CASE WHEN diagnosis_organic_mental_disorder_chronic IS NOT NULL AND diagnosis_date_organic_mental_disorder_chronic IS NOT NULL THEN diagnosis_date_organic_mental_disorder_chronic
                                  WHEN diagnosis_organic_mental_disorder_chronic IS NOT NULL AND diagnosis_date_organic_mental_disorder_chronic IS NULL THEN visit_date
                              ELSE NULL
                             END AS dx_date_organic_mental_disorder_chronic,
                             diagnosis_organic_mental_disorder_acute as dx_organic_mental_disorder_acute,
                             CASE WHEN diagnosis_organic_mental_disorder_acute IS NOT NULL AND diagnosis_date_organic_mental_disorder_acute IS NOT NULL THEN diagnosis_date_organic_mental_disorder_acute
                                  WHEN diagnosis_organic_mental_disorder_acute IS NOT NULL AND diagnosis_date_organic_mental_disorder_acute IS NULL THEN visit_date
                             ELSE NULL
                             END AS dx_date_organic_mental_disorder_acute,
                             diagnosis_alcohol_use_mental_disorder as dx_alcohol_use_mental_disorder,
                             CASE WHEN diagnosis_alcohol_use_mental_disorder IS NOT NULL AND diagnosis_date_alcohol_use_mental_disorder IS NOT NULL THEN diagnosis_date_alcohol_use_mental_disorder
                                  WHEN diagnosis_alcohol_use_mental_disorder IS NOT NULL AND diagnosis_date_alcohol_use_mental_disorder IS NULL THEN visit_date
                             ELSE NULL
                             END AS dx_date_alcohol_use_mental_disorder,
                             diagnosis_drug_use_mental_disorder as dx_drug_use_mental_disorder,
                             CASE WHEN diagnosis_drug_use_mental_disorder IS NOT NULL AND diagnosis_date_drug_use_mental_disorder IS NOT NULL THEN diagnosis_date_drug_use_mental_disorder
                                  WHEN diagnosis_drug_use_mental_disorder IS NOT NULL AND diagnosis_date_drug_use_mental_disorder IS NULL THEN visit_date
                             ELSE NULL
                             END AS dx_date_drug_use_mental_disorder,
                             diagnosis_schizophrenia as dx_schizophrenia,
                             diagnosis_acute_and_transient_psychotic as dx_acute_and_transient_psychotic,
                             diagnosis_schizoaffective_disorder as dx_schizoaffective_disorder,
                             diagnosis_mood_affective_disorder_manic as dx_mood_affective_disorder_manic,
                             diagnosis_mood_affective_disorder_depression as dx_mood_affective_disorder_depression,
                             diagnosis_anxiety_disorder as dx_anxiety_disorder,
                             diagnosis_bipolar_mood_disorder as dx_bipolar_mood_disorder,
			     diagnosis_stress_reactive_adjustment_disorder as dx_stress_reactive_adjustment_disorder,
			     diagnosis_dissociative_mood_disorder as dx_dissociative_mood_disorder,
			     diagnosis_hyperkinetic_disorder as dx_hyperkinetic_disorder,
			     diagnosis_puerperal_mental_disorder as dx_puerperal_mental_disorder,
			     diagnosis_somatoform_disorder as dx_somatoform_disorder,
			     diagnosis_personality_disorder as dx_personality_disorder,
			     diagnosis_mental_retardation_disorder as dx_mental_retardation_disorder,
			     diagnosis_psych_development_disorder as dx_psych_development_disorder,
                             diagnosis_other_1 as dx_mh_other_1,
                             diagnosis_other_2 as dx_mh_other_2,
                             diagnosis_other_3 as dx_mh_other_3
                           FROM mw_mental_health_initial
                           ORDER BY visit_date DESC
                          ) mhInner GROUP BY patient_id
                   ) mhIntake ON mhIntake.patient_id = ic3.patient_id
      LEFT JOIN		(SELECT *
                    FROM 	(SELECT patient_id,
                             visit_date AS lastMHVisitDate,
                             location AS visitLocation,
                             next_appointment_date AS nextMHAppt
                           FROM mw_mental_health_followup
                           WHERE location= _location
                                 AND visit_date < _endDate
                           ORDER BY visit_date DESC
                          ) mhFollowupInner GROUP BY patient_id
                   ) mentalHealthVisit ON mentalHealthVisit.patient_id = ic3.patient_id
  ;

  DROP TABLE IF EXISTS rpt_ic3_patient_ids;

END
