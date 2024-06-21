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