# LogicTech Notion – Base de Datos

# Base de datos LogicTech

Esta base de datos modela un sistema de gestión de proyectos con usuarios, proyectos, carpetas, documentos, tareas, reuniones y logs de actividad. El diseño se divide en dos partes: creación de tablas sin ciclos y posterior agregado de llaves foráneas con reglas de cascada para mantener la integridad referencial.

## Objetivo general

- Gestionar usuarios y sus roles.  
- Controlar proyectos, tareas y reuniones asociadas.  
- Organizar documentos en carpetas (con jerarquía) ligadas a usuarios y proyectos.  
- Registrar en logs las acciones realizadas por los usuarios sobre proyectos y otros recursos.  

## Tablas del esquema

### Tabla `users`

Representa a los usuarios de la aplicación.  
Campos principales:

- `id`: clave primaria autoincremental (`SERIAL PRIMARY KEY`).  
- `email`: correo único y obligatorio (`UNIQUE NOT NULL`).  
- `password`: contraseña (normalmente se almacena en hash).  
- `role`: rol asociado al usuario (admin, user, etc.).  
- `created_at`: fecha y hora de creación con valor por defecto `NOW()`.  

Se crea el índice `idx_users_role` sobre `role` para optimizar consultas por rol.  

### Tabla `projects`

Almacena los proyectos del sistema.  
Campos principales:

- `id`: clave primaria del proyecto.  
- `name`: nombre obligatorio del proyecto.  
- `description`: descripción opcional.  
- `created_by`: id del usuario que creó el proyecto (después será FK a `users.id`).  
- `created_at`: momento de creación.  

Más adelante se añade la columna `folder_id` para vincular cada proyecto con su carpeta raíz.  

### Tabla `folders`

Modela carpetas para organizar documentos, con soporte de jerarquía.  
Campos principales:

- `id`: clave primaria de la carpeta.  
- `user_id`: usuario propietario (luego FK a `users.id`).  
- `parent_folder`: carpeta padre para crear subcarpetas (luego FK a `folders.id`).  
- `name`: nombre de la carpeta.  
- `created_at`: fecha de creación.  

Posteriormente se agrega la columna `project_id` para vincular carpetas a proyectos.  

### Tabla `tasks`

Representa tareas asociadas a proyectos.  
Campos principales:

- `id`: clave primaria de la tarea.  
- `project_id`: id del proyecto al que pertenece (después FK a `projects.id`).  
- `assigned_to`: usuario asignado (luego FK a `users.id`, puede ser nulo).  
- `title`: título de la tarea.  
- `description`: descripción de lo que se debe hacer.  
- `status`: estado de la tarea, con valor por defecto `'pending'`.  
- `start_date`, `end_date`: fechas de inicio y fin.  
- `comments`: comentarios adicionales.  
- `created_at`: fecha de creación.  

### Tabla `meetings`

Almacena reuniones relacionadas a proyectos.  
Campos principales:

- `id`: clave primaria de la reunión.  
- `project_id`: id del proyecto asociado (luego FK a `projects.id`).  
- `meeting_date`: fecha y hora de la reunión.  
- `attendees`: lista de asistentes como texto.  
- `notes`: notas de la reunión.  
- `comments`: comentarios extra.  

### Tabla `documents`

Guarda metadatos de los archivos subidos.  
Campos principales:

- `id`: clave primaria del documento.  
- `folder_id`: carpeta donde se ubica el documento (luego FK a `folders.id`).  
- `uploaded_by`: usuario que subió el archivo (luego FK a `users.id`).  
- `title`: título o nombre lógico del documento.  
- `file_path`: ruta al archivo en el sistema (disco, S3, etc.).  
- `file_type`: tipo de archivo (pdf, docx, etc.).  
- `uploaded_at`: fecha de subida.  

### Tabla `logs`

Registra acciones que suceden en el sistema.  
Campos principales:

- `id`: clave primaria del log.  
- `user_id`: usuario que realizó la acción (luego FK a `users.id`).  
- `project_id`: proyecto sobre el que se hizo la acción (luego FK a `projects.id`).  
- `action`: tipo de acción (crear, actualizar, descargar, etc.).  
- `description`: detalle de la acción.  
- `created_at`: fecha y hora del evento.  

## Relaciones y llaves foráneas

El segundo bloque de código agrega las llaves foráneas una vez creadas todas las tablas y las columnas necesarias. A continuación se describen las relaciones y el comportamiento de cascada definido:

### Relaciones entre entidades

- `projects.created_by` → `users.id`  
  - Si se elimina un usuario, se eliminan en cascada los proyectos que creó (`ON DELETE CASCADE`).  

- `folders.user_id` → `users.id`  
  - Si se elimina un usuario, se eliminan sus carpetas (`ON DELETE CASCADE`).  

- `folders.parent_folder` → `folders.id`  
  - Si se elimina una carpeta padre, el `parent_folder` de las hijas se pone en `NULL` (`ON DELETE SET NULL`).  

- `folders.project_id` → `projects.id`  
  - Una carpeta puede asociarse a un proyecto; al eliminar el proyecto se eliminan sus carpetas asociadas (`ON DELETE CASCADE`).  

- `projects.folder_id` → `folders.id`  
  - Un proyecto puede tener su carpeta raíz; si esa carpeta se elimina, el `folder_id` del proyecto se pone en `NULL` (`ON DELETE SET NULL`).  

- `tasks.project_id` → `projects.id`  
  - Al eliminar un proyecto se eliminan todas sus tareas (`ON DELETE CASCADE`).  

- `tasks.assigned_to` → `users.id`  
  - Si se elimina un usuario, las tareas que tenía asignadas quedan con `assigned_to = NULL` pero la tarea sigue existiendo (`ON DELETE SET NULL`).  

- `meetings.project_id` → `projects.id`  
  - Al eliminar un proyecto se eliminan también sus reuniones (`ON DELETE CASCADE`).  

- `documents.folder_id` → `folders.id`  
  - Al eliminar una carpeta se eliminan todos los documentos que contiene (`ON DELETE CASCADE`).  

- `documents.uploaded_by` → `users.id`  
  - Si se elimina un usuario, se eliminan los documentos que subió (`ON DELETE CASCADE`).  

- `logs.user_id` → `users.id`  
  - Si se elimina un usuario, los registros de log mantienen el evento pero con `user_id = NULL` (`ON DELETE SET NULL`).  

- `logs.project_id` → `projects.id`  
  - Al eliminar un proyecto se borran también los logs asociados a ese proyecto (`ON DELETE CASCADE`).  

En todas las llaves foráneas se usa `ON UPDATE CASCADE`, lo que hace que si cambia el valor de la clave primaria referenciada, se actualice automáticamente en las tablas hijas.

## Flujo para obtener un archivo específico

Cuando un usuario solicita un archivo específico, el flujo típico usando este esquema sería:

1. Verificar el usuario en `users` y su rol, si la lógica de la app lo requiere.  
2. Determinar el contexto del archivo: por ejemplo, un proyecto y su carpeta raíz (`projects.folder_id`) y/o una carpeta concreta (`folders`, incluyendo la jerarquía por `parent_folder`).  
3. Buscar en `documents` usando filtros como `folder_id`, `title` o `file_path` para localizar el documento exacto.  
4. Con el `file_path` obtenido, la aplicación recupera el archivo físico del almacenamiento.  
5. Insertar un registro en `logs` indicando que el usuario descargó ese documento, apuntando a `user_id` y `project_id` correspondiente.  

Esta combinación de tablas y llaves foráneas permite navegar desde el usuario y el proyecto hasta la carpeta y el documento, manteniendo consistencia y trazabilidad de todas las acciones.


---

## 🚀 Equipo
Proyecto desarrollado por W Logic Tech.
