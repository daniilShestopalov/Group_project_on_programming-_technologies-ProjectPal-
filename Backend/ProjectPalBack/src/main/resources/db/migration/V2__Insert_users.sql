INSERT INTO "group" (group_number, course_number)
VALUES (101, 1);

INSERT INTO "user" (login, password, name, surname, patronymic, phone_number, avatar_link, role)
VALUES
    ('admin', 'adminpass', 'Admin', 'Adminovich', 'Adminov', '1234567890', 'link_to_avatar', 'ADMIN'),
    ('teacher', 'teachpass', 'Teach', 'Teachovich', 'Teachov', '0987654321', 'link_to_teacher_avatar', 'TEACHER');

WITH new_group AS (
    SELECT id FROM "group" WHERE group_number = 101 AND course_number = 1
)

INSERT INTO "user" (login, password, name, surname, patronymic, phone_number, avatar_link, role, group_id)
SELECT 'student1', 'stud1pass', 'Stud', 'One', 'Studovich', '1111111111', 'link_to_stud1_avatar', 'STUDENT'::user_role, id FROM new_group UNION ALL
SELECT 'student2', 'stud2pass', 'Stud', 'Two', 'Studovich', '2222222222', 'link_to_stud2_avatar', 'STUDENT'::user_role, id FROM new_group UNION ALL
SELECT 'student3', 'stud3pass', 'Stud', 'Three', 'Studovich', '3333333333', 'link_to_stud3_avatar', 'STUDENT'::user_role, NULL UNION ALL
SELECT 'student4', 'stud4pass', 'Stud', 'Four', 'Studovich', '4444444444', 'link_to_stud4_avatar', 'STUDENT'::user_role, NULL;
