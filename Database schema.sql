
-- 1. MASTER TABLES & ORGANIZATIONAL INFRASTRUCTURE


-- DEPARTMENTS Master Table
CREATE TABLE DEPARTMENTS (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    description TEXT,
    status VARCHAR(20)
);

-- DESIGNATIONS Master Table
CREATE TABLE DESIGNATIONS (
    designation_id INT PRIMARY KEY,
    designation_name VARCHAR(100) NOT NULL,
    department_id INT,
    description TEXT,
    status VARCHAR(20),
    FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id)
);

-- POSTAL_CODES Reference Table 
CREATE TABLE POSTAL_CODES (
    postal_code VARCHAR(20) PRIMARY KEY,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL
);


-- 2. ONBOARDING MODULE (Core Employee Profiles)


-- EMPLOYEES Table (Central Hub)
CREATE TABLE EMPLOYEES (
    employee_id INT PRIMARY KEY,
    employee_code VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    date_of_birth DATE,
    gender VARCHAR(15),
    marital_status VARCHAR(15),
    national_id_no VARCHAR(50) UNIQUE NOT NULL,
    join_date DATE,
    department_id INT,
    designation_id INT,
    manager_id INT,
    employment_type VARCHAR(30),
    status VARCHAR(20),
    FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id),
    FOREIGN KEY (designation_id) REFERENCES DESIGNATIONS(designation_id),
    FOREIGN KEY (manager_id) REFERENCES EMPLOYEES(employee_id)
);

-- ADDRESSES Table 
CREATE TABLE ADDRESSES (
    address_id INT PRIMARY KEY,
    employee_id INT,
    address_type VARCHAR(20), 
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    postal_code VARCHAR(20),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    FOREIGN KEY (postal_code) REFERENCES POSTAL_CODES(postal_code)
);

-- EMERGENCY_CONTACTS Table
CREATE TABLE EMERGENCY_CONTACTS (
    emergency_contact_id INT PRIMARY KEY,
    employee_id INT,
    contact_name VARCHAR(100) NOT NULL,
    relationship VARCHAR(50),
    phone VARCHAR(20) NOT NULL,
    email VARCHAR(100),
    address TEXT,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id)
);

-- EDUCATION Table
CREATE TABLE EDUCATION (
    education_id INT PRIMARY KEY,
    employee_id INT,
    degree VARCHAR(100) NOT NULL,
    field_of_study VARCHAR(100),
    institution VARCHAR(150),
    passing_year INT,
    grade VARCHAR(10),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id)
);

-- PREVIOUS_EMPLOYMENT Table
CREATE TABLE PREVIOUS_EMPLOYMENT (
    prev_emp_id INT PRIMARY KEY,
    employee_id INT,
    company_name VARCHAR(150) NOT NULL,
    designation VARCHAR(100),
    from_date DATE,
    to_date DATE,
    last_salary DECIMAL(12, 2),
    reason_for_leaving TEXT,
    reference_name VARCHAR(100),
    reference_contact VARCHAR(20),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id)
);

-- BANK_DETAILS Table
CREATE TABLE BANK_DETAILS (
    bank_detail_id INT PRIMARY KEY,
    employee_id INT,
    bank_name VARCHAR(100) NOT NULL,
    account_title VARCHAR(100) NOT NULL,
    account_number VARCHAR(50) NOT NULL,
    iban_number VARCHAR(50),
    branch_name VARCHAR(100),
    tax_number VARCHAR(50),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id)
);


-- 3. SYSTEM & ACCESS SECURITY TABLES


-- USERS Table
CREATE TABLE USERS (
    user_id INT PRIMARY KEY,
    employee_id INT UNIQUE, 
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role VARCHAR(20), 
    status VARCHAR(20),
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id)
);


-- 4. PROCESS MANAGEMENT (Onboarding Verification & Tasks)


-- DOCUMENTS Verification Table
CREATE TABLE DOCUMENTS (
    document_id INT PRIMARY KEY,
    employee_id INT,
    document_type VARCHAR(50),
    document_name VARCHAR(150),
    file_path VARCHAR(255),
    upload_date DATE,
    verified_by INT,
    verification_status VARCHAR(20),
    remarks TEXT,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    FOREIGN KEY (verified_by) REFERENCES USERS(user_id)
);

-- ONBOARDING_TASKS Checklist Table
CREATE TABLE ONBOARDING_TASKS (
    task_id INT PRIMARY KEY,
    employee_id INT,
    task_name VARCHAR(150) NOT NULL,
    assigned_to INT,
    due_date DATE,
    status VARCHAR(20), 
    completed_date DATE,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    FOREIGN KEY (assigned_to) REFERENCES USERS(user_id)
);

-- ONBOARDING_FORMS Verification Table
CREATE TABLE ONBOARDING_FORMS (
    form_id INT PRIMARY KEY,
    employee_id INT,
    form_name VARCHAR(150) NOT NULL,
    submitted_date DATE,
    submitted_by INT,
    status VARCHAR(20),
    remarks TEXT,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    FOREIGN KEY (submitted_by) REFERENCES USERS(user_id)
);

-- 5. TRAINING MODULE (Operations & Analytics)


-- TRAINING_PROGRAMS Master Catalog
CREATE TABLE TRAINING_PROGRAMS (
    program_id INT PRIMARY KEY,
    program_name VARCHAR(150) NOT NULL,
    program_type VARCHAR(50),
    description TEXT,
    duration_days INT,
    is_mandatory BOOLEAN,
    status VARCHAR(20)
);

-- TRAINERS Master Table
CREATE TABLE TRAINERS (
    trainer_id INT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    department_id INT,
    designation_id INT,
    status VARCHAR(20),
    FOREIGN KEY (department_id) REFERENCES DEPARTMENTS(department_id),
    FOREIGN KEY (designation_id) REFERENCES DESIGNATIONS(designation_id)
);

-- TRAINING_BATCHES Table
CREATE TABLE TRAINING_BATCHES (
    batch_id INT PRIMARY KEY,
    program_id INT,
    trainer_id INT,
    batch_name VARCHAR(100) NOT NULL,
    start_date DATE,
    end_date DATE,
    location VARCHAR(100),
    status VARCHAR(20),
    FOREIGN KEY (program_id) REFERENCES TRAINING_PROGRAMS(program_id),
    FOREIGN KEY (trainer_id) REFERENCES TRAINERS(trainer_id)
);

-- TRAINING_ASSIGNMENTS Enrollment Table 
CREATE TABLE TRAINING_ASSIGNMENTS (
    assignment_id INT PRIMARY KEY,
    employee_id INT,
    batch_id INT,
    assigned_date DATE,
    status VARCHAR(30),
    remarks TEXT,
    FOREIGN KEY (employee_id) REFERENCES EMPLOYEES(employee_id),
    FOREIGN KEY (batch_id) REFERENCES TRAINING_BATCHES(batch_id)
);

-- TRAINING_SESSIONS Scheduling Table
CREATE TABLE TRAINING_SESSIONS (
    session_id INT PRIMARY KEY,
    batch_id INT,
    session_title VARCHAR(150) NOT NULL,
    session_date DATE,
    start_time TIME,
    end_time TIME,
    topics_covered TEXT,
    FOREIGN KEY (batch_id) REFERENCES TRAINING_BATCHES(batch_id)
);

-- TRAINING_ATTENDANCE Log Table
CREATE TABLE TRAINING_ATTENDANCE (
    attendance_id INT PRIMARY KEY,
    assignment_id INT,
    session_id INT,
    status VARCHAR(20), 
    remarks TEXT,
    FOREIGN KEY (assignment_id) REFERENCES TRAINING_ASSIGNMENTS(assignment_id),
    FOREIGN KEY (session_id) REFERENCES TRAINING_SESSIONS(session_id)
);

-- TRAINING_ASSESSMENTS Evaluation Table
CREATE TABLE TRAINING_ASSESSMENTS (
    assessment_id INT PRIMARY KEY,
    assignment_id INT,
    assessment_type VARCHAR(50), 
    max_score DECIMAL(5, 2),
    obtained_score DECIMAL(5, 2),
    assessment_date DATE,
    evaluated_by INT,
    remarks TEXT,
    FOREIGN KEY (assignment_id) REFERENCES TRAINING_ASSIGNMENTS(assignment_id),
    FOREIGN KEY (evaluated_by) REFERENCES USERS(user_id)
);

-- TRAINING_FEEDBACK Survey Table
CREATE TABLE TRAINING_FEEDBACK (
    feedback_id INT PRIMARY KEY,
    assignment_id INT,
    feedback_given_by VARCHAR(20), 
    feedback_text TEXT,
    feedback_date DATE,
    rating INT,
    FOREIGN KEY (assignment_id) REFERENCES TRAINING_ASSIGNMENTS(assignment_id)
);

-- TRAINING_CERTIFICATES Vault Table
CREATE TABLE TRAINING_CERTIFICATES (
    certificate_id INT PRIMARY KEY,
    assignment_id INT,
    certificate_name VARCHAR(150),
    issue_date DATE,
    file_path VARCHAR(255),
    issued_by INT,
    FOREIGN KEY (assignment_id) REFERENCES TRAINING_ASSIGNMENTS(assignment_id),
    FOREIGN KEY (issued_by) REFERENCES USERS(user_id)
);

-- TRAINING_REPORTS Executive Meta-Data Table
CREATE TABLE TRAINING_REPORTS (
    report_id INT PRIMARY KEY,
    report_name VARCHAR(150) NOT NULL,
    generated_by INT,
    generated_date DATE,
    parameters TEXT,
    FOREIGN KEY (generated_by) REFERENCES USERS(user_id)
);