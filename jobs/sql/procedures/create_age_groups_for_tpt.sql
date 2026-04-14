DROP PROCEDURE IF EXISTS create_age_groups_for_tpt#
CREATE PROCEDURE `create_age_groups_for_tpt`()
BEGIN
	DROP TEMPORARY TABLE IF EXISTS age_groups_tpt;

    CREATE TEMPORARY TABLE age_groups_tpt(
		sort_value INT PRIMARY KEY auto_increment,
        district varchar(50),
		age_group Varchar(50),
		gender varchar(10)
	) DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;
    INSERT INTO age_groups_tpt (district, age_group, gender)
    VALUES
	("Neno","<1 year","F"),
	("Neno","1-4 years","F"),
	("Neno","5-9 years","F"),
	("Neno","10-14 years","F"),
	("Neno","15-19 years","F"),
	("Neno","20-24 years","F"),
	("Neno","25-29 years","F"),
	("Neno","30-34 years","F"),
	("Neno","35-39 years","F"),
	("Neno","40-44 years","F"),
	("Neno","45-49 years","F"),
	("Neno","50-54 years","F"),
	("Neno","55-59 years","F"),
	("Neno","60-64 years","F"),
	("Neno","65-69 years","F"),
	("Neno","70-74 years","F"),
	("Neno","75-79 years","F"),
	("Neno","80-84 years","F"),
	("Neno","85-89 years","F"),
    	("Neno","90 plus years","F"),
	("Neno","<1 year","M"),
	("Neno","1-4 years","M"),
	("Neno","5-9 years","M"),
	("Neno","10-14 years","M"),
	("Neno","15-19 years","M"),
	("Neno","20-24 years","M"),
	("Neno","25-29 years","M"),
	("Neno","30-34 years","M"),
	("Neno","35-39 years","M"),
	("Neno","40-44 years","M"),
	("Neno","45-49 years","M"),
	("Neno","50-54 years","M"),
	("Neno","55-59 years","M"),
	("Neno","60-64 years","M"),
	("Neno","65-69 years","M"),
	("Neno","70-74 years","M"),
	("Neno","75-79 years","M"),
	("Neno","80-84 years","M"),
	("Neno","85-89 years","M"),
	("Neno","90 plus years","M")
;
END
#
