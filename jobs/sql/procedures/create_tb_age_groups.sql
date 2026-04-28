drop procedure if exists create_tb_age_groups#
create procedure `create_tb_age_groups`()
begin
	drop TEMPORARY table if exists tb_age_groups;

    create TEMPORARY table tb_age_groups(
		sort_value int primary key auto_increment,
		age_group varchar(50),
		gender varchar(10),
		gender_full varchar(10)
	) default CHARACTER set utf8 default COLLATE utf8_general_ci;
    insert into tb_age_groups (age_group,gender, gender_full)
    values
	("0-4 years","M","Male"),
    ("0-4 years","F","Female"),
    ("5-14 years","M","Male"),
    ("5-14 years","F","Female"),
    ("15-24 years","M","Male"),
	("15-24 years","F","Female"),
    ("25-34 years","M","Male"),
	("25-34 years","F","Female"),
    ("35-44 years","M","Male"),
	("35-44 years","F","Female"),
    ("45-54 years","M","Male"),
	("45-54 years","F","Female"),
    ("55-64 years","M","Male"),
	("55-64 years","F","Female"),
    ("65 +> years","M","Male"),
    ("65 +> years","F","Female")
;
end
#
