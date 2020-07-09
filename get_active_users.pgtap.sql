BEGIN;

SELECT plan(3);

SELECT has_function(
    'public',
    'get_all_active_users',
    ARRAY[''],
    'function get_all_active_users exisits'
);

SELECT function_returns(
    'public',
    'get_all_active_users',
    ARRAY[''],
    'setof user_records',
    'function get_all_active_users returns a setof user_records'
);

-- active users in the scenario are users who've logged in within the last week, and who have at least one file
INSERT INTO users (id, username, first_name, last_name, password, last_login) VALUES (100001, 'user1', 'User', 'One', 'blah', CURRENT_TIMESTAMP - '5 days'::interval);
INSERT INTO users (id, username, first_name, last_name, password, last_login) VALUES (100002, 'user2', 'User', 'Two', 'blah', CURRENT_TIMESTAMP - '5 days'::interval);
INSERT INTO files (filename, path, upload_date, user_id) VALUES ('blah.txt', '/home/blah/', NOW(), 100001);
INSERT INTO files (filename, path, upload_date, user_id) VALUES ('blah2.txt', '/home/blah/', NOW(), 100002);


SELECT set_has(
    'SELECT * FROM get_all_active_users()',
    $$VALUES (100001, 'user1', 'User', 'One', CURRENT_TIMESTAMP - '5 days'::interval), (100002, 'user2', 'User', 'Two', CURRENT_TIMESTAMP - '5 days'::interval)$$,
    'get_all_active_users should return User1 and User2'
);


SELECT * FROM finish();

ROLLBACK;
