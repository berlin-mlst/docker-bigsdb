insert into user_dbases(id, name, dbase_name, dbase_host, dbase_port, dbase_user, dbase_password, list_order, auto_registration, curator, datestamp) values (1, 'main', 'berlin_mlst_users', 'localhost', '5432', 'bigsdb', 'bigsdb', 1, TRUE, 0, now());

insert into users (id, user_name, user_db, date_entered, datestamp, curator) values (1, 'dberlin', 1, current_date, now(), 0);
