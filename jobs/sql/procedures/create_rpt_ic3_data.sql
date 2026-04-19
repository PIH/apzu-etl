drop procedure if exists create_rpt_ic3_data#
create procedure create_rpt_ic3_data(in _endDate date, in _location varchar(255)) begin

	-- Get initial cohort to operate on (for convenience)
	drop table if exists rpt_ic3_patient_ids;
	create TEMPORARY table rpt_ic3_patient_ids as
	select distinct(patient_id) 
							from mw_art_register 
							where art_number is not null
							
	union				

	select distinct(patient_id) 
							from mw_ncd_register 
							where ncd_number is not null
							
	union				

	select distinct(patient_id) 
							from mw_eid_register 
							where eid_number is not null;	

	create index patient_id_index on rpt_ic3_patient_ids(patient_id);
							
	-- Create lookup (row-per-patient) table to calculate ic3 indicators
	drop table if exists rpt_ic3_data_table;
	create table rpt_ic3_data_table as
	-- Define columns
	select 	ic3.patient_id,
					birthdate,
					htnDx,	
					htnDxDate,
					dmDx,
					dmDxDate,
					dmDx1,
					dmDx2,
					cvDisease,
					asthmaDx,
					asthmaDxDate,
					copdDx,
		      copdDxDate,
					epilepsyDx,
					artStartDate, 
					artStartLocation, 
					ncdStartDate, 
					ncdStartLocation,
					eidStartDate, 
					eidStartLocation,
					hivCurrentStateStart,
					currentHivState,				
					hivCurrentLocation,
					ncdCurrentStateStart,
					currentNcdState,				
					ncdCurrentLocation,
					artVisits.lastArtVisit,
					ncdVisits.lastNcdVisit,
					eidVisits.lastEidVisit,
					lastMentalHealthVisitDate,
					lastAsthmaVisitDate,
          lastHtnDmVisitDate,
					case 
						when artVisits.lastArtVisit is null then ncdVisits.lastNcdVisit
						when ncdVisits.lastNcdVisit is null then artVisits.lastArtVisit
						when artVisits.lastArtVisit > ncdVisits.lastNcdVisit then artVisits.lastArtVisit
						else ncdVisits.lastNcdVisit
					end as lastIc3Visit,
					nextHtnDmAppt,
					nextAsthmaAppt,
          lastEpilepsyVisit,
					nextEpilepsyAppt,
					mentalHealthVisit.nextMentalHealthAppt,
					mentalStatusExam,
					mentalHospitalizedSinceLastVisit,
					mentalHealthRxSideEffectsAtLastVisit,
					mentalStableAtLastVisit,
					artVisits.nextArtAppt,
					case when	GREATEST(ifnull(nextHtnDmAppt,"01-01-1500"), 
										ifnull(nextAsthmaAppt,"01-01-1500"), 
										ifnull(nextEpilepsyAppt,"01-01-1500"),
										ifnull(nextMentalHealthAppt,"01-01-1500"),
										ifnull(nextArtAppt,"01-01-1500")) <> "01-01-1500"
						then  GREATEST(ifnull(nextHtnDmAppt,"01-01-1500"), 
										ifnull(nextAsthmaAppt,"01-01-1500"), 
										ifnull(nextEpilepsyAppt,"01-01-1500"),
										ifnull(nextMentalHealthAppt,"01-01-1500"),
										ifnull(nextArtAppt,"01-01-1500")) 
					end as latestAppt,
					viralLoad.lastViralLoadTest,
					artRegimen.lastArtRegimen,
					motherArtNumber,
					motherEnrollmentHivStatus,
					dnaPcr.lastDnaPcrTest,
					dnaPcr.lastDnaPcrResult,
					rapid.lastRapidTest,
					rapid.lastRapidResult,
					systolicBpAtLastVisit,
					diastolicBpAtLastVisit,
					visualAcuityAtLastVisit,
					cvRiskAtLastVisit,
					htnDmHospitalizedSinceLastVisit,
					lastProteinuria,
					lastProteinuriaDate,
					lastCreatinine,
					lastCreatinineDate,
					lastFundoscopy,
					lastFundoscopyDate,
					lastHba1c,
					lastHba1cVisitDate,
					fingerStickAtLastVisit,
					footCheckAtLastVisit,
					shortActingInsulin,
          longActingInsulin,
					hba1cAtLastVisit,
					seizuresSinceLastVisit,
					seizures,
					lastSeizureActivityRecorded,
					epilepsyHospitalizedSinceLastVisit,
          epilepsySeizuresSinceLastVsit,
					asthmaClassificationAtLastVisit,
					ablePerformDailyActivitiesAtLastVisit,
					suicideRiskAtLastVisit
	from 			rpt_ic3_patient_ids ic3
	left join 		(select patient_id,
					birthdate
					from omrs_patient
					) pdetails
					on pdetails.patient_id = ic3.patient_id
	left join 		(select * from		
						(select patient_id, start_date as artStartDate, location as artStartLocation
						from omrs_program_state
						where state = "On antiretrovirals"
						and program = "HIV Program"
						and (location = _location or _location is null)
						and start_date <= _endDate
						order by artStartDate asc) artStateInner 
					group by patient_id) artState
					on artState.patient_id = ic3.patient_id
	left join 		(select * from		
						(select patient_id, start_date as ncdStartDate, location as ncdStartLocation
						from omrs_program_state
						where state = "On treatment"
						and program = "Chronic Care Program"
						and (location = _location or _location is null)
						and start_date <= _endDate
						order by ncdStartDate asc) ncdStateInner 
					group by patient_id) ncdState
					on ncdState.patient_id = ic3.patient_id
	left join 		(select * from		
						(select patient_id, start_date as eidStartDate, location as eidStartLocation
						from omrs_program_state
						where state = "Exposed Child (Continue)"
						and program = "HIV Program"
						and (location = _location or _location is null)
						and start_date <= _endDate
						order by eidStartDate asc) eidStateInner 
					group by patient_id) eidState
					on eidState.patient_id = ic3.patient_id
	left join 		(select * from		
						(select patient_id, 
						state as currentHivState, 
						start_date as hivCurrentStateStart, 
						location as hivCurrentLocation
						from omrs_program_state
						join (select program_enrollment_id, enrollment_date, completion_date, program 
							 from omrs_program_enrollment) e 
						on e.program_enrollment_id = omrs_program_state.program_enrollment_id
						where e.program = "HIV Program"
						and (location = _location or _location is null)
						and start_date <= _endDate
						and (end_date is null or end_date > _endDate)					
						order by hivCurrentStateStart desc, enrollment_date desc, completion_date asc) hivStateInner 
					group by patient_id) hivCurrentState
					on hivCurrentState.patient_id = ic3.patient_id	
	left join 		(select * from		
						(select patient_id, state as currentNcdState, 
						start_date as ncdCurrentStateStart, 
						location as ncdCurrentLocation
						from omrs_program_state
						join (select program_enrollment_id, enrollment_date, completion_date, program 
							 from omrs_program_enrollment) e 
						on e.program_enrollment_id = omrs_program_state.program_enrollment_id
						where e.program = "Chronic Care Program"
						and (location = _location or _location is null)
						and start_date <= _endDate
						and (end_date is null or end_date > _endDate)
						order by ncdCurrentStateStart desc, enrollment_date desc, completion_date asc) ncdCurrentStateInner 
					group by patient_id) ncdCurrentState
					on ncdCurrentState.patient_id = ic3.patient_id	
	left join		(select * 
					from 	(select patient_id, 
							visit_date as lastArtVisit,
							next_appointment_date as nextArtAppt
							from mw_art_visits
							-- WHERE (location = _location OR _location IS NULL)
							where visit_date <= _endDate
							order by visit_date desc
							) artVisitsInner
					group by patient_id	
					) artVisits	
					on artVisits.patient_id = ic3.patient_id	
	left join		(select * 
					from 	(select patient_id, 
							visit_date as lastEidVisit,
							next_appointment_date as nextEidAppt
							from mw_eid_visits
							-- WHERE (location = _location OR _location IS NULL)
							where visit_date <= _endDate
							order by visit_date desc
							) eidVisitsInner
					group by patient_id	
					) eidVisits	
					on eidVisits.patient_id = ic3.patient_id						
	left join		(select * 
					from 	(select patient_id, 
							visit_date as lastNcdVisit
							from mw_ncd_visits
							-- WHERE (location = _location OR _location IS NULL)
							where visit_date <= _endDate
							order by visit_date desc
							) ncdVisitsInner
					group by patient_id	
					) ncdVisits	
					on ncdVisits.patient_id = ic3.patient_id
	left join 		(select patient_id,
					case when diagnosis is not null then 'X' end as asthmaDx 
					from mw_ncd_diagnoses
					where diagnosis = "Asthma"
					and diagnosis_date < _endDate
					group by patient_id
					) asthmaDx
					on asthmaDx.patient_id = ic3.patient_id
	left join 		(select patient_id,
					diagnosis_date as asthmaDxDate 
					from mw_ncd_diagnoses
					where diagnosis = "Asthma"
					and diagnosis_date < _endDate
					group by patient_id
					) asthmaDxDate
					on asthmaDxDate.patient_id = ic3.patient_id	
	left join 		(select patient_id,
					case when diagnosis is not null then 'X' end as copdDx 
					from mw_ncd_diagnoses
					where diagnosis = "Chronic obstructive pulmonary disease"
					and diagnosis_date < _endDate
					group by patient_id
					) copdDx
					on copdDx.patient_id = ic3.patient_id
      left join 		(select patient_id,
					diagnosis_date  as copdDxDate 
					from mw_ncd_diagnoses
					where diagnosis = "Chronic obstructive pulmonary disease"
					and diagnosis_date < _endDate
					group by patient_id
					) copdDxDate
					on copdDxDate.patient_id = ic3.patient_id     				
	left join 		(select patient_id,
					case when diagnosis is not null then 'X' end as htnDx 
					from mw_ncd_diagnoses
					where diagnosis = "Hypertension"
					and diagnosis_date < _endDate
					group by patient_id
					) htnDx
					on htnDx.patient_id = ic3.patient_id
    left join 		(select patient_id,
					diagnosis_date as htnDxDate
					from mw_ncd_diagnoses
					where diagnosis = "Hypertension"
					and diagnosis_date < _endDate
					group by patient_id
					) htnDxDate
					on htnDxDate.patient_id = ic3.patient_id				
	left join 		(select patient_id,
					case when diagnosis is not null then 'X' end as dmDx 
					from mw_ncd_diagnoses
					where diagnosis in ("Diabetes", "Type 1 diabetes", "Type 2 diabetes")
					and diagnosis_date < _endDate
					group by patient_id
					) dmDx
					on dmDx.patient_id = ic3.patient_id	
	left join 		(select patient_id,
					diagnosis_date as dmDxDate 
					from mw_ncd_diagnoses
					where diagnosis in ("Diabetes", "Type 1 diabetes", "Type 2 diabetes")
					and diagnosis_date < _endDate
					group by patient_id
					) dmDxDate
					on dmDxDate.patient_id = ic3.patient_id				
	left join 		(select patient_id,
					case when diagnosis is not null then 'X' end as dmDx1 
					from mw_ncd_diagnoses
					where diagnosis = "Type 1 diabetes"
					and diagnosis_date < _endDate
					group by patient_id
					) dmDx1
					on dmDx1.patient_id = ic3.patient_id		
	left join 		(select patient_id,
					case when diagnosis is not null then 'X' end as dmDx2 
					from mw_ncd_diagnoses
					where diagnosis = "Type 2 diabetes"
					and diagnosis_date < _endDate
					group by patient_id
					) dmDx2
					on dmDx2.patient_id = ic3.patient_id																	
	left join 		(select patient_id,
					case when diagnosis is not null then 'X' end as epilepsyDx 
					from mw_ncd_diagnoses
					where diagnosis = "Epilepsy"
					and diagnosis_date < _endDate
					group by patient_id
					) epilepsyDx
					on epilepsyDx.patient_id = ic3.patient_id	
	left join 		(select patient_id, 
					cv_disease as cvDisease
					from mw_ncd_register
					where cv_disease = 1
					group by patient_id
					) cvDisease on cvDisease.patient_id = ic3.patient_id
	left join 		(select * 
					from 	(select patient_id,
							date_collected as lastViralLoadTest
							from mw_lab_tests
							where date_collected <= _endDate
							and test_type = "Viral Load"
							order by date_collected desc
							) viralLoadInner group by patient_id
					) viralLoad 
					on viralLoad.patient_id = ic3.patient_id
	left join 		(select *
					from 	(select patient_id, 
							art_drug_regimen as lastArtRegimen
							from mw_art_visits
							where visit_date < _endDate
							and art_drug_regimen is not null
							order by visit_date desc
							) artRegimenInner group by patient_id
					) artRegimen
					on artRegimen.patient_id = ic3.patient_id
	left join 		(select patient_id,
					mother_art_number as motherArtNumber
					from mw_eid_register
					group by patient_id) mwEid
					on mwEid.patient_id = ic3.patient_id	
	left join 		(select * 
					from 	(select patient_id,
							date_collected as lastDnaPcrTest,
							result_coded as lastDnaPcrResult
							from mw_lab_tests
							where date_collected <= _endDate
							and test_type = "HIV DNA polymerase chain reaction"
							order by date_collected desc
							) dnaPcrInner group by patient_id
					) dnaPcr 
					on dnaPcr.patient_id = ic3.patient_id	
	left join 		(select * 
					from 	(select patient_id,
							case when date_collected is null and date_result_entered is not null then date_result_entered
								when date_result_entered is null and date_collected is not null then date_collected
								else date_collected
							end as lastRapidTest,
							result_coded as lastRapidResult
							from mw_lab_tests
							where (date_collected <= _endDate or date_result_entered < _endDate)
							and test_type in ("HIV rapid test, qualitative", "HIV test")
							order by lastRapidTest desc
							) rapidInner group by patient_id
					) rapid 
					on rapid.patient_id = ic3.patient_id				
	left join 		(select *
					from 	(select patient_id,
							value_coded as motherEnrollmentHivStatus
							from omrs_obs
							where concept = 'Mother HIV Status'
							and obs_date < _endDate
							and encounter_type = 'EXPOSED_CHILD_INITIAL'
							order by obs_date desc
							) motherHivStatusInner group by patient_id
					) motherHivStatus
					on motherHivStatus.patient_id = ic3.patient_id			
    left join 		(select *
					from	(select patient_id,
							seizure_since_last_visit as epilepsySeizuresSinceLastVsit
							from mw_epilepsy_followup
							where visit_date < _endDate
							order by visit_date desc
							) epilepsyFollowupInner group by patient_id
					) epilepsyFollowup
					on epilepsyFollowup.patient_id = ic3.patient_id
	left join 		(select *
					from	(select patient_id,
							hba1c as hba1cAtLastVisit,
							serum_glucose as fingerStickAtLastVisit,
							foot_check as footCheckAtLastVisit,
							systolic_bp as systolicBpAtLastVisit,
							diastolic_bp as diastolicBpAtLastVisit,
							visual_acuity as visualAcuityAtLastVisit,
							cv_risk as cvRiskAtLastVisit,
							hospitalized_since_last_visit as htnDmHospitalizedSinceLastVisit,
						 	visit_date as lastHtnDmVisitDate,
							next_appointment_date as nextHtnDmAppt						
							from mw_ncd_visits
							where diabetes_htn_followup = 1
							and visit_date < _endDate
							order by visit_date desc
							) htnDmVisitInner group by patient_id 
					) htnDmVisit
					on htnDmVisit.patient_id = ic3.patient_id
	left join 		(select * 
					from (select patient_id, 											
						    diabetes_med_long_acting as longActingInsulin, 
						    diabetes_med_short_acting as shortActingInsulin 
						    from mw_diabetes_hypertension_followup 
						    where visit_date < @endDate 
						    order by visit_date desc
						) htnDmFollowupInner group by patient_id
					) htnDmFollowupEnc 
					on htnDmFollowupEnc.patient_id = ic3.patient_id 				
	left join 		(select *
					from 	(select patient_id,
							hba1c as lastHba1c,
							visit_date as lastHba1cVisitDate
							from mw_ncd_visits
							where visit_date < _endDate
							and hba1c is not null
							order by visit_date desc
					) hba1cInner group by patient_id
					) hba1c
					on hba1c.patient_id = ic3.patient_id					
	left join 		(select *
					from 	(select patient_id,
							proteinuria as lastProteinuria,
							visit_date as lastProteinuriaDate
							from mw_ncd_visits
							where visit_date < _endDate
							and proteinuria is not null
							order by visit_date desc
					) proteinuriaInner group by patient_id
					) proteinuria
					on proteinuria.patient_id = ic3.patient_id
	left join 		(select *
					from 	(select patient_id,
							creatinine as lastCreatinine,
							visit_date as lastCreatinineDate
							from mw_ncd_visits
							where visit_date < _endDate
							and creatinine is not null
							order by visit_date desc
					) creatinineInner group by patient_id
					) creatinine
					on creatinine.patient_id = ic3.patient_id	
	left join 		(select *
					from 	(select patient_id,
							fundoscopy as lastFundoscopy,
							visit_date as lastFundoscopyDate
							from mw_ncd_visits
							where visit_date < _endDate
							and fundoscopy is not null
							order by visit_date desc
					) fundoscopyInner group by patient_id
					) fundoscopy
					on fundoscopy.patient_id = ic3.patient_id
					
	left join		(select * 
					from 	(select patient_id,
							seizure_activity as seizuresSinceLastVisit,
							num_seizures as seizures,
							hospitalized_since_last_visit as epilepsyHospitalizedSinceLastVisit,
              visit_date as lastEpilepsyVisit,
							next_appointment_date as nextEpilepsyAppt
							from mw_ncd_visits
							where epilepsy_followup = 1
							and visit_date < _endDate
							order by visit_date desc					
							) epilepsyInner group by patient_id
					) epilepsyVisit on epilepsyVisit.patient_id = ic3.patient_id
	left join 		(select * 
					from 	(select patient_id,
							visit_date as lastSeizureActivityRecorded
							from mw_ncd_visits
							where visit_date < _endDate
							and 	(num_seizures is not null
									or 
									seizure_activity is not null)
							order by visit_date desc
							) seizureInner group by patient_id
					) seizure 
					on seizure.patient_id = ic3.patient_id						
	left join 		(select *
					from 	(select omrs_encounter.patient_id,
							omrs_encounter.encounter_id,
							ablePerformDailyActivitiesAtLastVisit,
							suicideRiskAtLastVisit
							from omrs_encounter
							left join 	(select encounter_id, value_coded as ablePerformDailyActivitiesAtLastVisit
										from omrs_obs 
					   					where concept = 'Able to perform daily activities'
					   					) ablePerformDailyActivities
					   		on ablePerformDailyActivities.encounter_id = omrs_encounter.encounter_id	
							left join 	(select encounter_id, value_coded as suicideRiskAtLastVisit
										from omrs_obs 
					   					where concept = 'Suicide risk'
					   					) suicideRisk
					   		on suicideRisk.encounter_id = omrs_encounter.encounter_id
							where encounter_type = 'MENTAL_HEALTH_FOLLOWUP'
							and encounter_date < _endDate
							order by encounter_date desc
							) mentalHealthVisitInner group by patient_id) mentalHealthVisit1
					on mentalHealthVisit1.patient_id = ic3.patient_id											
	left join		(select * 
					from 	(select patient_id,
							visit_date as lastAsthmaVisitDate,
							asthma_classification as asthmaClassificationAtLastVisit,
							next_appointment_date as nextAsthmaAppt
							from mw_ncd_visits
							where asthma_followup = 1
							and visit_date < _endDate
							order by visit_date desc					
							) asthmaInner group by patient_id
					) asthmaVisit on asthmaVisit.patient_id = ic3.patient_id	
	left join		(select * 
					from 	(select patient_id,
							visit_date as lastMentalHealthVisitDate,
							hospitalized_since_last_visit as mentalHospitalizedSinceLastVisit,
							mental_health_drug_side_effect as mentalHealthRxSideEffectsAtLastVisit,
							mental_status_exam as mentalStatusExam,
							mental_stable as mentalStableAtLastVisit,
							next_appointment_date as nextMentalHealthAppt
							from mw_ncd_visits
							where mental_health_followup = 1
							and visit_date < _endDate
							order by visit_date desc					
							) asthmaInner group by patient_id
					) mentalHealthVisit on mentalHealthVisit.patient_id = ic3.patient_id																									
	;		


	drop table if exists rpt_ic3_patient_ids;

end	
#
