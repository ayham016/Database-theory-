USE EmployeeLifecycleDB;


INSERT INTO DEPARTMENTS VALUES (1,'Software Engineering','Core development and architecture team','Active');
INSERT INTO DEPARTMENTS VALUES (2,'Human Resources','Talent acquisition and onboarding','Active');
INSERT INTO DEPARTMENTS VALUES (3,'Quality Assurance','Testing and validation protocols','Active');

INSERT INTO DESIGNATIONS VALUES (10,'Junior Developer',1,'Entry level engineering track','Active');
INSERT INTO DESIGNATIONS VALUES (11,'HR Specialist',2,'Onboarding workflow administrator','Active');
INSERT INTO DESIGNATIONS VALUES (12,'QA Lead',3,'Testing lifecycle coordinator','Active');

INSERT INTO POSTAL_CODES VALUES ('25000','Peshawar','KPK','Pakistan');
INSERT INTO POSTAL_CODES VALUES ('44000','Islamabad','ICT','Pakistan');
INSERT INTO POSTAL_CODES VALUES ('75210','Karachi','Sindh','Pakistan');


INSERT INTO EMPLOYEES VALUES (101,'EMP-001','Almir','Ayham','almir@imsciences.edu.pk','03001234567','2005-01-15','Male','Single','17301-1111111-1','2026-01-10',1,10,NULL,'Full-Time','Active');
INSERT INTO EMPLOYEES VALUES (102,'EMP-002','Mohasin','Nawaz','mohasin@imsciences.edu.pk','03119876543','2004-05-22','Male','Single','17301-2222222-2','2026-01-12',2,11,101,'Full-Time','Active');
INSERT INTO EMPLOYEES VALUES (103,'EMP-003','Sarah','Khan','sarah@imsciences.edu.pk','03215554433','1998-11-05','Female','Married','17301-3333333-3','2026-02-01',3,12,101,'Contract','Active');

INSERT INTO ADDRESSES VALUES (1,101,'Permanent','House 45 Sector E','Hayatabad','25000');
INSERT INTO ADDRESSES VALUES (2,102,'Current','Apartment 12-B','Blue Area','44000');
INSERT INTO ADDRESSES VALUES (3,103,'Permanent','Plot 88 Phase 2','DHA','75210');

INSERT INTO EMERGENCY_CONTACTS VALUES (1,101,'Asif Khan','Father','03339998887','asif@mail.com','Hayatabad Peshawar');
INSERT INTO EMERGENCY_CONTACTS VALUES (2,102,'Nawaz Ahmad','Father','03451112223','nawaz@mail.com','Islamabad');

INSERT INTO EDUCATION VALUES (1,101,'BS','Software Engineering','IMSciences',2026,'A');
INSERT INTO EDUCATION VALUES (2,102,'MBA','Human Resource Management','NUST',2024,'B+');

INSERT INTO PREVIOUS_EMPLOYMENT VALUES (1,103,'TechSolutions','Senior QA','2023-01-01','2026-01-25',120000.00,'Career Growth','Ali Shah','03009991112');
INSERT INTO BANK_DETAILS VALUES (1,101,'Meezan Bank','Almir Ayham','1234009922','PK12MEZN00001234009922','Hayatabad','TX-99881');
INSERT INTO BANK_DETAILS VALUES (2,102,'HBL','Mohasin Nawaz','5566112233','PK88HABB00005566112233','Main Branch','TX-44552');


INSERT INTO USERS VALUES (501,101,'Almir Ayham','almir@imsciences.edu.pk','$2b$12$ExMPleSHasH12345','Admin','Active');
INSERT INTO USERS VALUES (502,102,'Mohasin Nawaz','mohasin@imsciences.edu.pk','$2b$12$ExMPleSHasH67890','HR','Active');


INSERT INTO DOCUMENTS VALUES (1,101,'CNIC','cnic_front.pdf','/uploads/docs/101_cnic.pdf','2026-01-10',502,'Verified','Clear scan matches database records');
INSERT INTO ONBOARDING_TASKS VALUES (1,101,'Configure Corporate Email Profile',501,'2026-01-12','Completed','2026-01-11');
INSERT INTO ONBOARDING_TASKS VALUES (2,102,'Submit Signed NDA and Code of Conduct',502,'2026-01-15','Pending',NULL);
INSERT INTO ONBOARDING_FORMS VALUES (1,101,'Medical Declaration Form','2026-01-10',502,'Approved','No medical flags raised');


INSERT INTO TRAINING_PROGRAMS VALUES (1,'Corporate Orientation 2026','Orientation','Introduction to company standards',3,1,'Active');
INSERT INTO TRAINING_PROGRAMS VALUES (2,'Advanced MySQL & Optimization','Technical','Deep dive query tuning',5,0,'Active');

INSERT INTO TRAINERS VALUES (401,'Dr. Ali Hassan','ali.hassan@trainer.com','03334445556',1,12,'Active');

INSERT INTO TRAINING_BATCHES VALUES (301,1,401,'Spring Batch A','2026-03-01','2026-03-03','Lab 2','Completed');
INSERT INTO TRAINING_BATCHES VALUES (302,2,401,'MySQL Optimization Mastery','2026-04-10','2026-04-15','Executive Suite','Active');

INSERT INTO TRAINING_ASSIGNMENTS VALUES (801,101,301,'2026-02-20','Completed','Attended all initial workshops');
INSERT INTO TRAINING_ASSIGNMENTS VALUES (802,101,302,'2026-04-01','Ongoing','Specialized system optimization track');

INSERT INTO TRAINING_SESSIONS VALUES (901,301,'Welcome & Corporate Values','2026-03-01','09:00:00','12:00:00','Overview of employee code of conduct and standard policies');
INSERT INTO TRAINING_ATTENDANCE VALUES (1,801,901,'Present','Arrived on time');
INSERT INTO TRAINING_ASSESSMENTS VALUES (1,801,'Quiz',100.00,92.50,'2026-03-03',501,'Excellent understanding of compliance concepts');
INSERT INTO TRAINING_FEEDBACK VALUES (1,801,'Employee','The orientation course pacing was highly professional and clear','2026-03-03',5);
INSERT INTO TRAINING_CERTIFICATES VALUES (1,801,'Corporate Onboarding Completion Badge','2026-03-05','/certs/c_801.pdf',501);
INSERT INTO TRAINING_REPORTS VALUES (1,'Q1 Onboarding Performance Metrics',501,'2026-04-01','batch_id=301;format=pdf');