
CREATE DATABASE IF NOT EXISTS EmployeeLifecycleDB;
USE EmployeeLifecycleDB;


SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS TRAINING_REPORTS;
DROP TABLE IF EXISTS TRAINING_CERTIFICATES;
DROP TABLE IF EXISTS TRAINING_FEEDBACK;
DROP TABLE IF EXISTS TRAINING_ASSESSMENTS;
DROP TABLE IF EXISTS TRAINING_ATTENDANCE;
DROP TABLE IF EXISTS TRAINING_SESSIONS;
DROP TABLE IF EXISTS TRAINING_ASSIGNMENTS;
DROP TABLE IF EXISTS TRAINING_BATCHES;
DROP TABLE IF EXISTS TRAINERS;
DROP TABLE IF EXISTS TRAINING_PROGRAMS;
DROP TABLE IF EXISTS ONBOARDING_FORMS;
DROP TABLE IF EXISTS ONBOARDING_TASKS;
DROP TABLE IF EXISTS DOCUMENTS;
DROP TABLE IF EXISTS USERS;
DROP TABLE IF EXISTS BANK_DETAILS;
DROP TABLE IF EXISTS PREVIOUS_EMPLOYMENT;
DROP TABLE IF EXISTS EDUCATION;
DROP TABLE IF EXISTS EMERGENCY_CONTACTS;
DROP TABLE IF EXISTS ADDRESSES;
DROP TABLE IF EXISTS EMPLOYEES;
DROP TABLE IF EXISTS POSTAL_CODES;
DROP TABLE IF EXISTS DESIGNATIONS;
DROP TABLE IF EXISTS DEPARTMENTS;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE DEPARTMENTS (
    department_id INT NOT NULL,
    department_name VARCHAR(100) NOT NULL,
    description TEXT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    PRIMARY KEY (department_id),
    CONSTRAINT chk_dept_status CHECK (status IN ('Active', 'Inactive'))
) ENGINE=InnoDB;

CREATE TABLE DESIGNATIONS (
    designation_id INT NOT NULL,
    designation_name VARCHAR(100) NOT NULL,
    department_id INT NOT NULL,
    description TEXT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    PRIMARY KEY (designation_id),
    FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_desig_status CHECK (status IN ('Active', 'Inactive'))
) ENGINE=InnoDB;

CREATE TABLE POSTAL_CODES (
    postal_code VARCHAR(20) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    PRIMARY KEY (postal_code)
) ENGINE=InnoDB;

-- =========================================================================
-- 2. CORE EMPLOYEE MANAGEMENT
-- =========================================================================

CREATE TABLE EMPLOYEES (
    employee_id INT NOT NULL,
    employee_code VARCHAR(50) NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    date_of_birth DATE NULL,
    gender VARCHAR(15) NULL,
    marital_status VARCHAR(15) NULL,
    national_id_no VARCHAR(50) NOT NULL,
    join_date DATE NOT NULL,
    department_id INT NOT NULL,
    designation_id INT NOT NULL,
    manager_id INT NULL,
    employment_type VARCHAR(30) NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    PRIMARY KEY (employee_id),
    UNIQUE KEY uq_emp_code (employee_code),
    UNIQUE KEY uq_emp_email (email),
    UNIQUE KEY uq_emp_nat_id (national_id_no),
    FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (designation_id) REFERENCES DESIGNATIONS(designation_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_emp_status CHECK (status IN ('Active', 'Terminated', 'Suspended', 'On Leave')),
    CONSTRAINT chk_emp_type CHECK (employment_type IN ('Full-Time', 'Part-Time', 'Contract', 'Intern'))
) ENGINE=InnoDB;

CREATE TABLE ADDRESSES (
    address_id INT NOT NULL,
    employee_id INT NOT NULL,
    address_type VARCHAR(20) NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255) NULL,
    postal_code VARCHAR(20) NOT NULL,
    PRIMARY KEY (address_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (postal_code) REFERENCES POSTAL_CODES(postal_code) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_addr_type CHECK (address_type IN ('Permanent', 'Current', 'Office'))
) ENGINE=InnoDB;

CREATE TABLE EMERGENCY_CONTACTS (
    emergency_contact_id INT NOT NULL,
    employee_id INT NOT NULL,
    contact_name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50) NULL,
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100) NULL,
    address TEXT NULL,
    PRIMARY KEY (emergency_contact_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE EDUCATION (
    education_id INT NOT NULL,
    employee_id INT NOT NULL,
    degree VARCHAR(100) NOT NULL,
    field_of_study VARCHAR(100) NULL,
    institution VARCHAR(150) NULL,
    passing_year INT NOT NULL,
    grade VARCHAR(10) NULL,
    PRIMARY KEY (education_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_pass_year CHECK (passing_year >= 1950)
) ENGINE=InnoDB;

CREATE TABLE PREVIOUS_EMPLOYMENT (
    prev_emp_id INT NOT NULL,
    employee_id INT NOT NULL,
    company_name VARCHAR(150) NOT NULL,
    designation VARCHAR(100) NULL,
    from_date DATE NULL,
    to_date DATE NULL,
    last_salary DECIMAL(12,2) NULL,
    reason_for_leaving TEXT NULL,
    reference_name VARCHAR(100) NULL,
    reference_contact VARCHAR(20) NULL,
    PRIMARY KEY (prev_emp_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE BANK_DETAILS (
    bank_detail_id INT NOT NULL,
    employee_id INT NOT NULL,
    bank_name VARCHAR(100) NOT NULL,
    account_title VARCHAR(100) NOT NULL,
    account_number VARCHAR(50) NOT NULL,
    iban_number VARCHAR(50) NULL,
    branch_name VARCHAR(100) NULL,
    tax_number VARCHAR(50) NULL,
    PRIMARY KEY (bank_detail_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- =========================================================================
-- 3. IDENTITY ACCESS SECURITY MANAGEMENT
-- =========================================================================

CREATE TABLE USERS (
    user_id INT NOT NULL,
    employee_id INT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    PRIMARY KEY (user_id),
    UNIQUE KEY uq_user_email (email),
    UNIQUE KEY uq_user_emp (employee_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_user_role CHECK (role IN ('Admin', 'HR', 'Manager', 'Trainer')),
    CONSTRAINT chk_user_status CHECK (status IN ('Active', 'Disabled', 'Locked'))
) ENGINE=InnoDB;

-- =========================================================================
-- 4. PROCESS MANAGEMENT (ONBOARDING PIPELINES)
-- =========================================================================

CREATE TABLE DOCUMENTS (
    document_id INT NOT NULL,
    employee_id INT NOT NULL,
    document_type VARCHAR(50) NOT NULL,
    document_name VARCHAR(150) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    upload_date DATE NOT NULL,
    verified_by INT NULL,
    verification_status VARCHAR(20) DEFAULT 'Pending',
    remarks TEXT NULL,
    PRIMARY KEY (document_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES USERS(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_doc_v_status CHECK (verification_status IN ('Pending', 'Verified', 'Rejected'))
) ENGINE=InnoDB;

CREATE TABLE ONBOARDING_TASKS (
    task_id INT NOT NULL,
    employee_id INT NOT NULL,
    task_name VARCHAR(150) NOT NULL,
    assigned_to INT NULL,
    due_date DATE NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    completed_date DATE NULL,
    PRIMARY KEY (task_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES USERS(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_task_status CHECK (status IN ('Pending', 'In Progress', 'Completed'))
) ENGINE=InnoDB;

CREATE TABLE ONBOARDING_FORMS (
    form_id INT NOT NULL,
    employee_id INT NOT NULL,
    form_name VARCHAR(150) NOT NULL,
    submitted_date DATE NULL,
    submitted_by INT NULL,
    status VARCHAR(20) DEFAULT 'Pending',
    remarks TEXT NULL,
    PRIMARY KEY (form_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (submitted_by) REFERENCES USERS(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_form_status CHECK (status IN ('Pending', 'Submitted', 'Approved', 'Rejected'))
) ENGINE=InnoDB;

-- =========================================================================
-- 5. TRAINING OPERATION MODULES
-- =========================================================================

CREATE TABLE TRAINING_PROGRAMS (
    program_id INT NOT NULL,
    program_name VARCHAR(150) NOT NULL,
    program_type VARCHAR(50) NOT NULL,
    description TEXT NULL,
    duration_days INT NOT NULL,
    is_mandatory BOOLEAN DEFAULT FALSE,
    status VARCHAR(20) DEFAULT 'Active',
    PRIMARY KEY (program_id),
    CONSTRAINT chk_prog_days CHECK (duration_days > 0),
    CONSTRAINT chk_prog_status CHECK (status IN ('Active', 'Archived'))
) ENGINE=InnoDB;

CREATE TABLE TRAINERS (
    trainer_id INT NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NULL,
    department_id INT NOT NULL,
    designation_id INT NOT NULL,
    status VARCHAR(20) DEFAULT 'Active',
    PRIMARY KEY (trainer_id),
    UNIQUE KEY uq_trainer_email (email),
    FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (designation_id) REFERENCES DESIGNATIONS(designation_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_trainer_status CHECK (status IN ('Active', 'Inactive'))
) ENGINE=InnoDB;

CREATE TABLE TRAINING_BATCHES (
    batch_id INT NOT NULL,
    program_id INT NOT NULL,
    trainer_id INT NOT NULL,
    batch_name VARCHAR(100) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    location VARCHAR(100) NULL,
    status VARCHAR(20) DEFAULT 'Active',
    PRIMARY KEY (batch_id),
    FOREIGN KEY (program_id) REFERENCES TRAINING_PROGRAMS(program_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (trainer_id) REFERENCES TRAINERS(trainer_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_batch_status CHECK (status IN ('Active', 'Ongoing', 'Completed', 'Cancelled'))
) ENGINE=InnoDB;

CREATE TABLE TRAINING_ASSIGNMENTS (
    assignment_id INT NOT NULL,
    employee_id INT NOT NULL,
    batch_id INT NOT NULL,
    assigned_date DATE NOT NULL,
    status VARCHAR(30) DEFAULT 'Not Started',
    remarks TEXT NULL,
    PRIMARY KEY (assignment_id),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (batch_id) REFERENCES TRAINING_BATCHES(batch_id) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT chk_assign_status CHECK (status IN ('Not Started', 'Ongoing', 'Completed', 'Failed', 'Dropped'))
) ENGINE=InnoDB;

CREATE TABLE TRAINING_SESSIONS (
    session_id INT NOT NULL,
    batch_id INT NOT NULL,
    session_title VARCHAR(150) NOT NULL,
    session_date DATE NOT NULL,
    start_time TIME NULL,
    end_time TIME NULL,
    topics_covered TEXT NULL,
    PRIMARY KEY (session_id),
    FOREIGN KEY (batch_id) REFERENCES TRAINING_BATCHES(batch_id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE TRAINING_ATTENDANCE (
    attendance_id INT NOT NULL,
    assignment_id INT NOT NULL,
    session_id INT NOT NULL,
    status VARCHAR(20) NOT NULL,
    remarks TEXT NULL,
    PRIMARY KEY (attendance_id),
    FOREIGN KEY (assignment_id) REFERENCES TRAINING_ASSIGNMENTS(assignment_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (session_id) REFERENCES TRAINING_SESSIONS(session_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_att_status CHECK (status IN ('Present', 'Absent', 'Late'))
) ENGINE=InnoDB;

CREATE TABLE TRAINING_ASSESSMENTS (
    assessment_id INT NOT NULL,
    assignment_id INT NOT NULL,
    assessment_type VARCHAR(50) NOT NULL,
    max_score DECIMAL(5,2) NOT NULL,
    obtained_score DECIMAL(5,2) NOT NULL,
    assessment_date DATE NOT NULL,
    evaluated_by INT NULL,
    remarks TEXT NULL,
    PRIMARY KEY (assessment_id),
    FOREIGN KEY (assignment_id) REFERENCES TRAINING_ASSIGNMENTS(assignment_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (evaluated_by) REFERENCES USERS(user_id) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_assess_type CHECK (assessment_type IN ('Quiz', 'Practical', 'Final Evaluation'))
) ENGINE=InnoDB;

CREATE TABLE TRAINING_FEEDBACK (
    feedback_id INT NOT NULL,
    assignment_id INT NOT NULL,
    feedback_given_by VARCHAR(20) NOT NULL,
    feedback_text TEXT NOT NULL,
    feedback_date DATE NOT NULL,
    rating INT NOT NULL,
    PRIMARY KEY (feedback_id),
    FOREIGN KEY (assignment_id) REFERENCES TRAINING_ASSIGNMENTS(assignment_id) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_feed_by CHECK (feedback_given_by IN ('Trainer', 'Employee')),
    CONSTRAINT chk_feed_rating CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB;

CREATE TABLE TRAINING_CERTIFICATES (
    certificate_id INT NOT NULL,
    assignment_id INT NOT NULL,
    certificate_name VARCHAR(150) NOT NULL,
    issue_date DATE NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    issued_by INT NULL,
    PRIMARY KEY (certificate_id),
    FOREIGN KEY (assignment_id) REFERENCES TRAINING_ASSIGNMENTS(assignment_id) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (issued_by) REFERENCES USERS(user_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

CREATE TABLE TRAINING_REPORTS (
    report_id INT NOT NULL,
    report_name VARCHAR(150) NOT NULL,
    generated_by INT NULL,
    generated_date DATE NOT NULL,
    parameters TEXT NULL,
    PRIMARY KEY (report_id),
    FOREIGN KEY (generated_by) REFERENCES USERS(user_id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;