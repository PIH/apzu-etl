DROP PROCEDURE IF EXISTS create_tb_age_groups#
CREATE PROCEDURE `create_tb_age_groups`()
BEGIN
	DROP TEMPORARY TABLE IF EXISTS tb_age_groups;

    CREATE TEMPORARY TABLE tb_age_groups(
		sort_value INT PRIMARY KEY auto_increment,
		age_group Varchar(50),
		gender varchar(10),
		gender_full varchar(10)
	) DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
    INSERT INTO tb_age_groups (age_group,gender, gender_full)
    VALUES
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
END
#
