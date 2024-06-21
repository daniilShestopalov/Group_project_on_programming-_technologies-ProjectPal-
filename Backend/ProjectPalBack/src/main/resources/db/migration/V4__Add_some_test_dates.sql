INSERT INTO complaint (complained_about_user_id, complaint_sender_user_id)
VALUES (
           (SELECT id FROM "user" WHERE login = 'student1'),
           (SELECT id FROM "user" WHERE login = 'student2')
       );

INSERT INTO project (name, teacher_id, description, file_link, start_date, end_date)
VALUES (
           'Проект 1',
           (SELECT id FROM "user" WHERE login = 'teacher'),
           'Проект для общей работы',
           '',
           '2024-06-21 00:00:00',
           '2024-12-31 23:59:59'
       );

INSERT INTO student_project (student_id, project_id)
VALUES
    ((SELECT id FROM "user" WHERE login = 'student3'), (SELECT id FROM project WHERE name = 'Проект 1')),
    ((SELECT id FROM "user" WHERE login = 'student4'), (SELECT id FROM project WHERE name = 'Проект 1'));

DO $$
DECLARE
project_id INT;
BEGIN
SELECT id INTO project_id FROM project WHERE name = 'Проект 1';

INSERT INTO project_answer (project_id, submission_date, teacher_commentary, student_commentary, grade, file_link)
VALUES (
           project_id,
           '2024-06-21 00:00:00',
           '',
           '',
           0,
           ''
       );
END $$;


INSERT INTO task (name, teacher_id, group_id, description, file_link, start_date, end_date)
VALUES (
           'Задание для группы',
           (SELECT id FROM "user" WHERE login = 'teacher'),
           (SELECT id FROM "group" WHERE group_number = 101 AND course_number = 1),
           'Ознакомительное задание',
           '',
           '2024-06-21 00:00:00',
           '2024-07-21 23:59:59'
       );

INSERT INTO task (name, teacher_id, group_id, description, file_link, start_date, end_date)
VALUES (
           'Второе задание для группы',
           (SELECT id FROM "user" WHERE login = 'teacher'),
           (SELECT id FROM "group" WHERE group_number = 101 AND course_number = 1),
           'Описание второго задания...',
           '',
           '2024-06-22 00:00:00',
           '2024-07-13 23:59:59'
       );

DO $$
DECLARE
   task_id INT;
BEGIN
SELECT id INTO task_id FROM task WHERE name = 'Задание для группы';

INSERT INTO task_answer (task_id, student_id, submission_date, teacher_commentary, student_commentary, grade, file_link)
SELECT
    task_id,
    id,
    '2024-06-21 00:00:00',
    '',
    '',
    0,
    ''
FROM "user"
WHERE group_id = (SELECT id FROM "group" WHERE group_number = 101 AND course_number = 1);
END $$;

DO $$
DECLARE
task_id INT;
BEGIN
SELECT id INTO task_id FROM task WHERE name = 'Второе задание для группы';


INSERT INTO task_answer (task_id, student_id, submission_date, teacher_commentary, student_commentary, grade, file_link)
SELECT
    task_id,
    id,
    '2024-06-22 00:00:00',
    '',
    '',
    0,
    ''
FROM "user"
WHERE group_id = (SELECT id FROM "group" WHERE group_number = 101 AND course_number = 1);
END $$;