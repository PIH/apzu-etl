DROP PROCEDURE IF EXISTS create_weight_groups#
CREATE PROCEDURE `create_weight_groups`()
BEGIN
	DROP TEMPORARY TABLE IF EXISTS weight_groups;

    CREATE TEMPORARY TABLE weight_groups(
		sort_value INT PRIMARY KEY auto_increment,
		weight_group Varchar(50),
		gender varchar(10),
        gender_full varchar(10)
	) DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
    INSERT INTO weight_groups (weight_group, gender, gender_full)
    VALUES
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
END
#
