CREATE TABLE complaint (
                           id SERIAL PRIMARY KEY,
                           complained_about_user_id INTEGER NOT NULL,
                           complaint_sender_user_id INTEGER NOT NULL,
                           FOREIGN KEY (complained_about_user_id) REFERENCES "user"(id),
                           FOREIGN KEY (complaint_sender_user_id) REFERENCES "user"(id)
);