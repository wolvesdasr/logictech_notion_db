-- ======================================================
-- TABLAS SIN CICLOS
-- ======================================================

-- 1. USERS
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(200) NOT NULL,
    role VARCHAR(50),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_users_role ON users(role);


-- 2. PROJECTS (sin folder_id todavía)
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    created_by INT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);


-- 3. FOLDERS (sin project_id todavía)
CREATE TABLE folders (
    id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    parent_folder INT,
    name VARCHAR(150) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);


-- 4. TASKS
CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    project_id INT NOT NULL,
    assigned_to INT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    start_date DATE,
    end_date DATE,
    comments TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);


-- 5. MEETINGS
CREATE TABLE meetings (
    id SERIAL PRIMARY KEY,
    project_id INT NOT NULL,
    meeting_date TIMESTAMP NOT NULL,
    attendees TEXT,
    notes TEXT,
    comments TEXT
);


-- 6. DOCUMENTS (sin folder FK todavía)
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    folder_id INT,
    uploaded_by INT NOT NULL,
    title VARCHAR(150),
    file_path TEXT NOT NULL,
    file_type VARCHAR(50),
    uploaded_at TIMESTAMP DEFAULT NOW()
);


-- 7. LOGS
CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    user_id INT,
    project_id INT,
    action VARCHAR(200) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);