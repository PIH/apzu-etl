# Known issues

This file tracks suspected bugs and stale code in the ETL pipeline that have
been noticed but not yet fixed. The intent is to keep them visible until they
can be triaged into proper tickets.

## Suspected bugs

### `mw_sickle_cell_disease_history_of_hospitalization` is never populated

`jobs/pentaho/malawi/transforms/import-into-mw-sickle-cell-disease-history-of-hospitalization.ktr`
writes to the table `mw_pdc_history_of_hospitalization`, not the
`mw_sickle_cell_disease_history_of_hospitalization` table that its filename
implies.

- The table `mw_sickle_cell_disease_history_of_hospitalization` is declared in
  `jobs/pentaho/malawi/schema/schema.csv` and has a DDL file at
  `jobs/pentaho/malawi/schema/table/mw_sickle_cell_disease_history_of_hospitalization.sql`,
  but no transform writes to it — so it is created empty on every refresh.
- A side effect is that `mw_pdc_history_of_hospitalization` ends up with two
  writers (the legitimate `import-into-pdc-history-of-hospitalization.ktr`
  plus this misrouted sickle-cell transform).
- Introduced in commit `596a04f` (MLW-1616, "add sickle cell disease history
  of hospitalization table in the data warehouse"). The .sql was added
  correctly but the .ktr's TableOutput step points at the wrong destination.

The current refactor preserves this behavior unchanged so as not to mix a fix
with a structural refactor. Resolving it likely means redirecting the
TableOutput step in the .ktr to its matching table.

### `mw_lab_tests_recent_period.sql` adds an index to the wrong table

`jobs/pentaho/malawi/schema/table/mw_lab_tests_recent_period.sql` ends with:

```sql
alter table mw_lab_tests add index mw_lab_tests_recent_idx (patient_id);
```

i.e. it creates the `mw_lab_tests_recent_period` table but then alters the
unrelated `mw_lab_tests` table — and the index it adds (`patient_id`) is
already covered by `mw_lab_tests_patient_idx` from `mw_lab_tests.sql`, so it's
a misnamed duplicate. The `mw_lab_tests_recent_period` table itself is left
without any indexes.

Likely intent: the index should have been on
`mw_lab_tests_recent_period(patient_id)`. The current refactor preserves the
existing (buggy) behavior — the orphan index lives in the `mw_lab_tests`
index file.

## Orphaned / dead code

### `import-into-mw-art-trace.ktr` and `import-into-mw-eid-trace.ktr`

These transforms write to tables `mw_art_trace` and `mw_eid_trace`. Neither
table is declared in `schema.csv`, neither table name appears anywhere else in
the repository, and no job (`.kjb`), pipeline (`.yml`), or other transform
references either `.ktr` file. They appear to be dead code.

Recommended action: delete both transforms (and confirm with the team that
nothing external invokes them) as part of the Pentaho cleanup phase of the
PETL converge effort.
