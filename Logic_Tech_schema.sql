-- ======================================================
-- SCHEMA COMPLETO PARA LOGICTECH_NOTION
-- Proyecto tipo Notion (carpetas, páginas, tareas, logs)
-- ======================================================

-- Crear tabla: USERS
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Crear tabla: FOLDERS (carpetas principales)
CREATE TABLE folders (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE CASCADE,
    name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Crear tabla: PROJECTS
CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    folder_id INT REFERENCES folders(id) ON DELETE CASCADE,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Crear tabla: TASKS
CREATE TABLE tasks (
    id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    status VARCHAR(50) DEFAULT 'pending',
    due_date DATE,
    created_at TIMESTAMP DEFAULT NOW()
);

-- Crear tabla: MEETINGS
CREATE TABLE meetings (
    id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(id) ON DELETE CASCADE,
    date TIMESTAMP NOT NULL,
    attendees TEXT,
    notes TEXT
);

-- Crear tabla: DOCUMENTS
CREATE TABLE documents (
    id SERIAL PRIMARY KEY,
    project_id INT REFERENCES projects(id) ON DELETE CASCADE,
    title VARCHAR(150),
    file_path TEXT NOT NULL,
    uploaded_at TIMESTAMP DEFAULT NOW()
);

-- Crear tabla: LOGS
CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    user_id INT REFERENCES users(id) ON DELETE SET NULL,
    project_id INT REFERENCES projects(id) ON DELETE CASCADE,
    action VARCHAR(200) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- FIN DEL SCHEMA
-- ============================================
