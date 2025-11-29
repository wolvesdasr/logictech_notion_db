# LogicTech Notion – Base de Datos

Este repositorio contiene el `schema.sql` que define la estructura de la base de datos para la plataforma tipo Notion desarrollada por W Logic Tech.

El sistema permite organizar:
- Carpetas
- Proyectos
- Tareas
- Meetings
- Documentos
- Logs de actividades
- Usuarios

## 📦 Tablas del sistema

### 1. users
Almacena información de cada usuario.

| Campo       | Tipo            | Descripción |
|-------------|-----------------|-------------|
| id          | SERIAL PK       | Identificador |
| name        | VARCHAR(100)    | Nombre completo |
| email       | VARCHAR(150)    | Correo único |
| password    | VARCHAR(200)    | Contraseña cifrada |
| created_at  | TIMESTAMP       | Fecha de registro |

---

### 2. folders
Carpetas creadas por cada usuario.

| Campo     | Tipo      | Descripción |
|-----------|-----------|-------------|
| id        | SERIAL PK |
| user_id   | INT FK → users.id |
| name      | VARCHAR(100) |
| created_at| TIMESTAMP |

---

### 3. projects
Proyectos dentro de una carpeta.

| Campo     | Tipo |
|-----------|------|
| id        | SERIAL PK |
| folder_id | INT FK → folders.id |
| name      | VARCHAR(150) |
| description | TEXT |
| created_at | TIMESTAMP |

---

### 4. tasks
Tareas asociadas a un proyecto.

| Campo     | Tipo |
|-----------|------|
| id        | SERIAL PK |
| project_id | INT FK → projects.id |
| title     | VARCHAR(200) |
| description | TEXT |
| status    | VARCHAR(50) |
| due_date  | DATE |
| created_at | TIMESTAMP |

---

### 5. meetings
Reuniones relacionadas al proyecto.

| Campo | Tipo |
|-------|------|
| id | SERIAL PK |
| project_id | INT FK → projects.id |
| date | TIMESTAMP |
| attendees | TEXT |
| notes | TEXT |

---

### 6. documents
Documentos subidos a cada proyecto.

| Campo | Tipo |
|-------|------|
| id | SERIAL PK |
| project_id | INT FK → projects.id |
| title | VARCHAR(150) |
| file_path | TEXT |
| uploaded_at | TIMESTAMP |

---

### 7. logs
Registra acciones del usuario.

| Campo | Tipo |
|-------|------|
| id | SERIAL PK |
| user_id | INT FK → users.id |
| project_id | INT FK → projects.id |
| action | VARCHAR(200) |
| created_at | TIMESTAMP |

---

## 🔗 Relaciones principales

- Un **usuario** tiene varias **carpetas**  
- Una **carpeta** contiene **proyectos**  
- Un **proyecto** tiene:
  - tareas  
  - reuniones  
  - documentos  
  - logs  

Todo con cascada de borrado para mantener integridad.

---

## 📄 Archivos incluidos

- `schema.sql` — Estructura completa de la base de datos  
- `API-spec.md` — Recomendación de endpoints para el backend  
- `ERD.png` — Diagrama de entidad-relación  

---

## 🚀 Equipo
Proyecto desarrollado por W Logic Tech.
