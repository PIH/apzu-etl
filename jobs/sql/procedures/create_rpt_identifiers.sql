drop procedure if exists create_rpt_identifiers#
/************************************************************************
Get identifiers for the patient at the given location and overall
*************************************************************************/
create procedure create_rpt_identifiers(in _location varchar(255)) begin

  drop TEMPORARY table if exists rpt_identifiers;
  create TEMPORARY table rpt_identifiers (
    patient_id          	int not null primary key,
    art_number          	varchar(50),
    all_art_numbers     	varchar(1000),
    eid_number          	varchar(50),
    all_eid_numbers     	varchar(1000),
    pre_art_number      	varchar(50),
    all_pre_art_numbers 	varchar(1000),
    ncd_number     		varchar(50),
    pdc_number     		varchar(50),
    all_ncd_numbers		varchar(1000),
    yendanafe_number		varchar(50),
    all_yendanafe_numbers	varchar(1000)
  );
  create index rpt_identifiers_patient_id_idx on rpt_identifiers(patient_id);

  insert into rpt_identifiers (patient_id, art_number)
    select r.patient_id, r.art_number from mw_art_register r where r.location = _location
  on DUPLICATE key update art_number = values(art_number);

  insert into rpt_identifiers (patient_id, all_art_numbers)
    select r.patient_id, group_concat(distinct art_number order by art_number asc SEPARATOR ', ') from mw_art_register r group by r.patient_id
  on DUPLICATE key update all_art_numbers = values(all_art_numbers);

  insert into rpt_identifiers (patient_id, eid_number)
    select r.patient_id, r.eid_number from mw_eid_register r where r.location = _location
  on DUPLICATE key update eid_number = values(eid_number);

  insert into rpt_identifiers (patient_id, all_eid_numbers)
    select r.patient_id, group_concat(distinct eid_number order by eid_number asc SEPARATOR ', ') from mw_eid_register r group by r.patient_id
  on DUPLICATE key update all_eid_numbers = values(all_eid_numbers);

  insert into rpt_identifiers (patient_id, pre_art_number)
    select r.patient_id, r.pre_art_number from mw_pre_art_register r where r.location = _location
  on DUPLICATE key update pre_art_number = values(pre_art_number);

  insert into rpt_identifiers (patient_id, all_pre_art_numbers)
    select r.patient_id, group_concat(distinct pre_art_number order by pre_art_number asc SEPARATOR ', ') from mw_pre_art_register r group by r.patient_id
  on DUPLICATE key update all_pre_art_numbers = values(all_pre_art_numbers);

  insert into rpt_identifiers (patient_id, ncd_number)
    select r.patient_id, r.ncd_number from mw_ncd_register r where r.location = _location
  on DUPLICATE key update ncd_number = values(ncd_number);

  insert into rpt_identifiers (patient_id, all_ncd_numbers)
    select r.patient_id, group_concat(distinct ncd_number order by ncd_number asc SEPARATOR ', ') from mw_ncd_register r group by r.patient_id
  on DUPLICATE key update all_ncd_numbers = values(all_ncd_numbers);

  insert into rpt_identifiers (patient_id, pdc_number)
  select r.patient_id, r.pdc_number from mw_pdc_register r where r.location = _location
  on DUPLICATE key update pdc_number = values(pdc_number);
  
  insert into rpt_identifiers (patient_id, yendanafe_number)
    select opi.patient_id, opi.identifier as yendanafe_number from omrs_patient_identifier opi where opi.location = _location and opi.type = "Yendanafe Identifier"
  on DUPLICATE key update yendanafe_number = values(yendanafe_number);
  
  insert into rpt_identifiers (patient_id, all_yendanafe_numbers)
    select opi.patient_id, group_concat(distinct opi.identifier order by opi.identifier asc SEPARATOR ', ') as all_yendanafe_numbers
    from omrs_patient_identifier opi where opi.type = "Yendanafe Identifier" group by opi.patient_id
  on DUPLICATE key update all_yendanafe_numbers = values(all_yendanafe_numbers);

end
#
