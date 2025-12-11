-- ======================================================
-- AGREGAR FOREIGN KEYS
-- ======================================================

-- PROJECTS
ALTER TABLE projects
ADD CONSTRAINT fk_projects_created_by
FOREIGN KEY (created_by)
REFERENCES users(id)
ON DELETE CASCADE ON UPDATE CASCADE;

-- FOLDERS
ALTER TABLE folders
ADD CONSTRAINT fk_folders_user_id
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE folders
ADD CONSTRAINT fk_folders_parent
FOREIGN KEY (parent_folder)
REFERENCES folders(id)
ON DELETE SET NULL ON UPDATE CASCADE;

-- Ahora sí podemos agregar project_id en folders
ALTER TABLE folders
ADD COLUMN project_id INT;

ALTER TABLE folders
ADD CONSTRAINT fk_folders_project_id
FOREIGN KEY (project_id)
REFERENCES projects(id)
ON DELETE CASCADE ON UPDATE CASCADE;


-- PROJECTS ahora puede referenciar folders
ALTER TABLE projects
ADD COLUMN folder_id INT;

ALTER TABLE projects
ADD CONSTRAINT fk_projects_folder
FOREIGN KEY (folder_id)
REFERENCES folders(id)
ON DELETE SET NULL ON UPDATE CASCADE;


-- TASKS
ALTER TABLE tasks
ADD CONSTRAINT fk_tasks_project
FOREIGN KEY (project_id)
REFERENCES projects(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE tasks
ADD CONSTRAINT fk_tasks_assigned
FOREIGN KEY (assigned_to)
REFERENCES users(id)
ON DELETE SET NULL ON UPDATE CASCADE;


-- MEETINGS
ALTER TABLE meetings
ADD CONSTRAINT fk_meetings_project
FOREIGN KEY (project_id)
REFERENCES projects(id)
ON DELETE CASCADE ON UPDATE CASCADE;


-- DOCUMENTS
ALTER TABLE documents
ADD CONSTRAINT fk_documents_folder
FOREIGN KEY (folder_id)
REFERENCES folders(id)
ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE documents
ADD CONSTRAINT fk_documents_uploaded
FOREIGN KEY (uploaded_by)
REFERENCES users(id)
ON DELETE CASCADE ON UPDATE CASCADE;


-- LOGS
ALTER TABLE logs
ADD CONSTRAINT fk_logs_user
FOREIGN KEY (user_id)
REFERENCES users(id)
ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE logs
ADD CONSTRAINT fk_logs_project
FOREIGN KEY (project_id)
REFERENCES projects(id)
ON DELETE CASCADE ON UPDATE CASCADE;
