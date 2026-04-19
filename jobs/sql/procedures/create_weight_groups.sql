drop procedure if exists create_weight_groups#
create procedure `create_weight_groups`()
begin
	drop TEMPORARY table if exists weight_groups;

    create TEMPORARY table weight_groups(
		sort_value int primary key auto_increment,
		weight_group varchar(50),
		gender varchar(10),
        gender_full varchar(10)
	) default CHARACTER set utf8 default COLLATE utf8_general_ci;
    insert into weight_groups (weight_group, gender, gender_full)
    values
("3 - 3.9 Kg", "F", "Female"),
("4 - 4.9 Kg", "F", "Female"),
("5 - 9.9 Kg", "F", "Female"),
("10 - 13.9 Kg", "F", "Female"),
("14 - 19.9 Kg", "F", "Female"),
("20 - 24.9 Kg", "F", "Female"),
("25 - 29.9 Kg", "F", "Female"),
("30 - 34.9 Kg", "F", "Female"),
("35 - 39.9 Kg", "F", "Female"),
("40 - 49.9 Kg", "F", "Female"),
("50 Kg +", "F", "Female"),
("Unknown", "F", "Female"),
("3 - 3.9 Kg", "M", "Male"),
("4 - 4.9 Kg", "M", "Male"),
("5 - 9.9 Kg", "M", "Male"),
("10 - 13.9 Kg", "M", "Male"),
("14 - 19.9 Kg", "M", "Male"),
("20 - 24.9 Kg", "M", "Male"),
("25 - 29.9 Kg", "M", "Male"),
("30 - 34.9 Kg", "M", "Male"),
("35 - 39.9 Kg", "M", "Male"),
("40 - 49.9 Kg", "M", "Male"),
("50 Kg +", "M", "Male"),
("Unknown", "M", "Male")
;
end
#
