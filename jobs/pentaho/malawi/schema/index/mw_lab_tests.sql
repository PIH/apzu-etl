alter table mw_lab_tests add index mw_lab_tests_patient_idx (patient_id);
alter table mw_lab_tests add index mw_lab_tests_patient_type_idx (patient_id, test_type);
-- See KNOWN_ISSUES.md: this index was originally declared in
-- mw_lab_tests_recent_period.sql but targets mw_lab_tests; preserved here
-- to keep current behavior unchanged.
alter table mw_lab_tests add index mw_lab_tests_recent_idx (patient_id);
