-- QUESTÃO 1:

CREATE VIEW vw_dptmgr AS SELECT dnumber, fname FROM department AS DP, employee AS EP WHERE EP.ssn = DP.mgrssn;

CREATE VIEW vw_empl_houston AS SELECT ssn, fname FROM employee WHERE address LIKE '%Houston%';

CREATE VIEW vw_deptstats AS SELECT DP.dnumber, DP.dname, COUNT(EP.ssn) AS total_empregados FROM department DP INNER JOIN employee EP ON EP.dno = DP.dnumber GROUP BY DP.dnumber, DP.dname;

CREATE VIEW vw_projstats AS SELECT PJ.pnumber AS pno, COUNT(EP.ssn) AS total_empregados FROM project PJ INNER JOIN works_on W ON PJ.pnumber = W.pno INNER JOIN employee EP ON W.essn = EP.ssn GROUP BY PJ.pnumber;


-- QUESTÃO 2

SELECT * FROM vw_dptmgr;

SELECT * FROM vw_empl_houston;

SELECT * FROM vw_deptstats;

SELECT * FROM vw_projstats;

-- QUESTÃO 3

DROP VIEW vw_dptmgr;

DROP VIEW vw_empl_houston;

DROP VIEW vw_deptstats;

DROP VIEW vw_projstats;


-- QUESTÃO 4

CREATE OR REPLACE FUNCTION check_age(current_ssn CHAR)
RETURNS VARCHAR AS $$
DECLARE
    age INTEGER;
BEGIN
    SELECT EXTRACT(YEAR FROM AGE(CURRENT_DATE, bdate)) INTO age FROM employee WHERE ssn = current_ssn;
    IF (age IS NULL) THEN 
        RETURN 'UNKNOWN';
    ELSIF (age >= 50) THEN 
        RETURN 'SENIOR';
    ELSIF (age < 0) THEN 
        RETURN 'INVALID';
    ELSE
        RETURN 'YOUNG';
    END IF;
END;
$$ LANGUAGE plpgsql;


-- QUESTÃO 5

CREATE OR REPLACE FUNCTION check_mgr() 
RETURNS trigger AS $check_mgr$
DECLARE 
    subordinados INTEGER;
    dept INTEGER;
BEGIN
    SELECT COUNT(ssn) INTO subordinados FROM employee WHERE superssn = NEW.mgrssn;
    SELECT dno INTO dept FROM employee WHERE ssn = NEW.mgrssn;
    IF (dept IS NULL OR dept::INTEGER != NEW.dnumber::INTEGER) THEN 
       RAISE EXCEPTION 'manager must be a department''s employee';
    ELSIF (subordinados = 0 OR subordinados IS NULL) THEN 
        RAISE EXCEPTION 'manager must have supevisees';
    ELSIF (check_age(NEW.mgrssn)::VARCHAR != 'SENIOR') THEN 
        RAISE EXCEPTION 'manager must be a SENIOR employee';
    END IF;
    RETURN NEW;
END;
$check_mgr$ LANGUAGE plpgsql;

CREATE TRIGGER check_mgr 
BEFORE INSERT OR UPDATE ON department
FOR EACH ROW EXECUTE PROCEDURE check_mgr();
