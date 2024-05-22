CREATE TABLE "group" (
                         id SERIAL PRIMARY KEY,
                         group_number INT NOT NULL,
                         course_number INT NOT NULL
);

CREATE TYPE user_role AS ENUM ('TEACHER', 'ADMIN', 'STUDENT');

CREATE TABLE "user" (
                      id SERIAL PRIMARY KEY,
                      login VARCHAR(255) UNIQUE NOT NULL,
                      password VARCHAR(255),
                      name VARCHAR(50) NOT NULL,
                      surname VARCHAR(50) NOT NULL,
                      patronymic VARCHAR(50),
                      phone_number VARCHAR(20),
                      avatar_link TEXT,
                      role user_role NOT NULL,
                      group_id INT,
                      CONSTRAINT fk_group FOREIGN KEY (group_id) REFERENCES "group"(id) ON DELETE SET NULL
);

CREATE TABLE project (
                         id SERIAL PRIMARY KEY,
                         name VARCHAR(255) NOT NULL,
                         teacher_id INT NOT NULL,
                         description TEXT,
                         file_link TEXT,
                         start_date TIMESTAMP NOT NULL,
                         end_date TIMESTAMP,
                         CONSTRAINT fk_teacher FOREIGN KEY (teacher_id) REFERENCES "user"(id) ON DELETE CASCADE
);

CREATE TABLE project_answer (
                                id SERIAL PRIMARY KEY,
                                project_id INT NOT NULL,
                                submission_date TIMESTAMP NOT NULL,
                                teacher_commentary TEXT,
                                student_commentary TEXT,
                                grade INT,
                                file_link TEXT,
                                CONSTRAINT fk_project FOREIGN KEY (project_id) REFERENCES project(id) ON DELETE CASCADE
);

CREATE TABLE student_project (
                                 id SERIAL PRIMARY KEY,
                                 student_id INT NOT NULL,
                                 project_id INT NOT NULL,
                                 CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES "user"(id) ON DELETE CASCADE,
                                 CONSTRAINT fk_project FOREIGN KEY (project_id) REFERENCES project(id) ON DELETE CASCADE,
                                 CONSTRAINT UNIQ_STUDENT_PROJECT UNIQUE (student_id, project_id)
);

CREATE TABLE task (
                      id SERIAL PRIMARY KEY,
                      name VARCHAR(255) NOT NULL,
                      teacher_id INT NOT NULL,
                      group_id INT NOT NULL,
                      description TEXT,
                      file_link TEXT,
                      start_date TIMESTAMP NOT NULL,
                      end_date TIMESTAMP,
                      CONSTRAINT fk_teacher FOREIGN KEY (teacher_id) REFERENCES "user"(id) ON DELETE CASCADE,
                      CONSTRAINT fk_group FOREIGN KEY (group_id) REFERENCES "group"(id) ON DELETE CASCADE
);

CREATE TABLE task_answer (
                             id SERIAL PRIMARY KEY,
                             task_id INT NOT NULL,
                             student_id INT NOT NULL,
                             submission_date TIMESTAMP NOT NULL,
                             teacher_commentary TEXT,
                             student_commentary TEXT,
                             grade INT,
                             file_link TEXT,
                             CONSTRAINT fk_task FOREIGN KEY (task_id) REFERENCES task(id) ON DELETE CASCADE,
                             CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES "user"(id) ON DELETE CASCADE
);