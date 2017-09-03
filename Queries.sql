/*
-- Test queries
SELECT Count(*) gender_type
FROM Patient
INNER JOIN Gender ON Patient.gender_id = Gender.gender_id WHERE gender_type='female';

-- Test wait time added to WL to FSA Date
SELECT CONCAT(Patient.pat_fName, " ", Patient.pat_lName) AS Patient, DATEDIFF(
        IF( fsa_date != "0000-00-00", fsa_date, DATE(NOW())), added_to_wl
    ) AS 'Wait time',
    fsa_date,
    added_to_wl
    FROM Referral
INNER JOIN Patient ON Referral.nhi = Patient.nhi;

-- Test to get Dept name from Referral.
SELECT dept_name FROM Referral
INNER JOIN Surgeon ON Referral.surgeon_id = Surgeon.surgeon_id
INNER JOIN Department ON Surgeon.dept_id = Department.dept_id;

SELECT * FROM Referral where fsa_date = "0000-00-00";

SELECT DATEDIFF(   IF( fsa_date != "0000-00-00", fsa_date, DATE(NOW())), ref_date) from referral;
*/
select * from patient where nhi='IXF414';
select * from referral;
-- Query 1: How many people have been referred for surgery?
-- Note, I read this as "how many individuals" rather than "how many surguries"
-- so I would not count multiple referrals for the same person.
SELECT COUNT(*) AS 'Total Number of Patients Referred:' FROM Patient;

-- Query 2: What is the average time taken to see a Surgeon by Department?
SELECT Department.dept_name  AS 'Department', AVG(
	DATEDIFF(
        IF( fsa_date != "0000-00-00", fsa_date, DATE(NOW())), added_to_wl
    )
)
AS 'Average Days To Be Seen:'
FROM Referral
INNER JOIN Surgeon ON Referral.surgeon_id = Surgeon.surgeon_id
INNER JOIN Department ON Surgeon.dept_id = Department.dept_id
GROUP BY dept_name;

-- Query 3: Who has each Surgeon had on their list and how long have they been waiting or did they wait?
SELECT 
	CONCAT(Surgeon.surgeon_lName, ", ", Surgeon.surgeon_fName) AS Surgeon,
	CONCAT(Patient.pat_fName, " ", Patient.pat_lName) AS Patient,
    CONCAT(DATEDIFF(
        IF( fsa_date != "0000-00-00", fsa_date, DATE(NOW())), added_to_wl
    ), " days")
    AS 'Wait time',
    IF(fsa_date != "0000-00-00", 'yes', 'NO') AS 'Px has been seen?'
FROM Surgeon
INNER JOIN Referral ON Surgeon.surgeon_id = Referral.surgeon_id
INNER JOIN Patient ON Referral.nhi = Patient.nhi
ORDER BY surgeon_lName;

-- Query 4: Assuming that all patients under 18 need to be seen by Paediatric Surgery,
-- are there any patients who need to be reassigned?
SELECT
	CONCAT(Patient.pat_lName, ", ", Patient.pat_fName)
    AS 'Reassign Px to Paediatric Surgery',
    CONCAT(TRUNCATE((DATEDIFF(DATE(NOW()), Patient.dob) / 6570), 0), "yrs")
    AS 'Current Age',
    Department.dept_name
    AS 'Current Department'
FROM Referral
INNER JOIN Patient ON Referral.nhi = Patient.nhi
INNER JOIN Surgeon ON Referral.surgeon_id = Surgeon.surgeon_id
INNER JOIN Department ON Surgeon.dept_id = Department.dept_id
WHERE(
	DATEDIFF(DATE(NOW()), Patient.dob) > 6570
	AND Department.dept_name != 'Paediatric Surgery'
);

-- Query 5: What percentage of patient were seen within the target of 80 days by department?
SELECT Department.dept_name  AS 'Department',
	CONCAT(TRUNCATE(COUNT(
		 CASE WHEN DATEDIFF( IF( fsa_date != "0000-00-00", fsa_date, DATE(NOW())), ref_date) < 80 THEN 1 END
    ) / (COUNT(
		 CASE WHEN DATEDIFF( IF( fsa_date != "0000-00-00", fsa_date, DATE(NOW())), ref_date) < 80 THEN 1 END
    ) + COUNT(
		 CASE WHEN DATEDIFF( IF( fsa_date != "0000-00-00", fsa_date, DATE(NOW())), ref_date) > 80 THEN 1 END
    ))*100, 0), "%")
    AS '% Seen within 80 days.'
	FROM Referral
    INNER JOIN Surgeon ON Referral.surgeon_id = Surgeon.surgeon_id
	INNER JOIN Department ON Surgeon.dept_id = Department.dept_id
	GROUP BY dept_name;
    


