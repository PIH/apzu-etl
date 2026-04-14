DROP PROCEDURE IF EXISTS create_age_groups#
CREATE PROCEDURE `create_age_groups`()
BEGIN
	DROP TEMPORARY TABLE IF EXISTS age_groups;

    CREATE TEMPORARY TABLE age_groups(
		sort_value INT PRIMARY KEY auto_increment,
		age_group Varchar(50),
		gender varchar(10),
		gender_full varchar(10)
	) DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
    INSERT INTO age_groups (age_group,gender, gender_full)
    VALUES
    ("<1 year","F","Female"),
    ("1-4 years","F","Female"),
    ("5-9 years","F","Female"),
    ("10-14 years","F","Female"),
	("15-19 years","F","Female"),
    ("20-24 years","F","Female"),
    ("25-29 years","F","Female"),
    ("30-34 years","F","Female"),
    ("35-39 years","F","Female"),
    ("40-44 years","F","Female"),
    ("45-49 years","F","Female"),
    ("50-54 years","F","Female"),
    ("55-59 years","F","Female"),
    ("60-64 years","F","Female"),
    ("65-69 years","F","Female"),
    ("70-74 years","F","Female"),
    ("75-79 years","F","Female"),
    ("80-84 years","F","Female"),
    ("85-89 years","F","Female"),
    ("90 plus years","F","Female"),
    ("<1 year","M","Male"),
    ("1-4 years","M","Male"),
    ("5-9 years","M","Male"),
    ("10-14 years","M","Male"),
    ("15-19 years","M","Male"),
    ("20-24 years","M","Male"),
    ("25-29 years","M","Male"),
    ("30-34 years","M","Male"),
    ("35-39 years","M","Male"),
    ("40-44 years","M","Male"),
    ("45-49 years","M","Male"),
	("50-54 years","M","Male"),
    ("55-59 years","M","Male"),
    ("60-64 years","M","Male"),
    ("65-69 years","M","Male"),
    ("70-74 years","M","Male"),
    ("75-79 years","M","Male"),
    ("80-84 years","M","Male"),
    ("85-89 years","M","Male"),
    ("90 plus years","M","Male")
    
;
END
#
