drop database if exists data;
drop user if exists 'user01'@'localhost';
drop user if exists 'user01'@'%';
drop user if exists 'admin'@'localhost';
drop user if exists 'admin'@'%';

create database data;
  use data;
  create table album (
    id INT NOT NULL PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(50),
    artist VARCHAR(50),
    release_year VARCHAR(4));

CREATE USER 'admin'@'localhost' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON *.* to 'admin'@'localhost';

CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON *.* to 'admin'@'%';

CREATE USER 'user01'@'localhost' IDENTIFIED BY 'user01';
GRANT SELECT,INSERT,UPDATE,DELETE ON data.* to 'user01'@'localhost';

CREATE USER 'user01'@'%' IDENTIFIED BY 'user01';
GRANT SELECT,INSERT,UPDATE,DELETE ON data.* to 'user01'@'%';
