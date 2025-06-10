-- 1:
SELECT * FROM department;

-- 2:
SELECT * FROM dependent;

-- 3
SELECT * FROM dept_locations;

-- 4
SELECT * FROM employee;

-- 5
SELECT * FROM project;

-- 6
SELECT * FROM works_on;

-- 7: 1 e ultimo nome dos func homens 
select fname, lname from employee where sex = 'M';

-- 8: 1 nome de fun que nao tem supervisor
select fname from employee where sex = 'M' and superssn IS NULL;

-- 9: retornar o nome de fun e o nome do seu supervisor
SELECT e.fname AS funcionario, s.fname AS supervisor
FROM employee e JOIN employee s ON e.superssn = s.ssn;

-- 10: retornar o nome dos func em que o supervisor se chama 'franklin'
SELECT e.fname AS funcionario
FROM employee e JOIN employee s ON e.superssn = s.ssn WHERE s.fname = 'Franklin';


-- 9 
SELECT t2.fname, t1.fname FROM employee t1, employee t2 WHERE (t1.superssn IS NOT NULL AND t1.ssn = t2.superssn);

-- 10
SELECT t1.fname FROM employee t1, employee t2 WHERE (t1.superssn = t2.ssn AND t2.fname = 'Franklin');

--11 
SELECT d.dname, dp.dlocation FROM department d, dept_locations dp WHERE d.dnumber = dp.dnumber;

--12
SELECT d.dname FROM department d, dept_locations dp WHERE (d.dnumber = dp.dnumber AND SUBSTRING(dp.dlocation,1,1) = 'S');

--13
SELECT e.fname, e.lname, d.dependent_name FROM employee e, dependent d WHERE d.essn = e.ssn;

-- 14
SELECT (fname || ' ' || minit || ' ' || lname) AS full_name, salary FROM employee WHERE salary > 50000;

--15
SELECT p.pname, d.dname FROM project p, department d WHERE d.dnumber = p.dnum;

-- 16
SELECT p.pname, e.fname FROM project p, employee e, department d WHERE (p.pnumber > 30 AND p.dnum = d.dnumber AND e.ssn = d.mgrssn);

-- 17
SELECT p.pname, e.fname FROM project p, employee e, works_on w WHERE p.pnumber = w.pno AND e.ssn = w.essn;

--18 
SELECT e.fname, d.dependent_name, d.relationship FROM employee e, dependent d, works_on w WHERE  (e.ssn = w.essn AND w.pno = 91 AND d.essn = e.ssn);
