SET @OLD_UNIQUE_CHECKS = @@UNIQUE_CHECKS, UNIQUE_CHECKS = 0;
SET @OLD_FOREIGN_KEY_CHECKS = @@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS = 0;
SET @OLD_SQL_MODE = @@SQL_MODE, SQL_MODE = 'TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `signup_main`
  DEFAULT CHARACTER SET utf8
  COLLATE utf8_general_ci;
USE `signup_main`;

-- -----------------------------------------------------
-- Table `signup_main`.`school`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`school` (
  `school_id`   INT          NOT NULL AUTO_INCREMENT,
  `school_name` VARCHAR(128) NULL,
  `school_url`  VARCHAR(255) NULL,
  `phone_no`    VARCHAR(15)  NULL,
  `fax_no`      VARCHAR(15)  NULL,
  `email`       VARCHAR(255) NULL,
  PRIMARY KEY (`school_id`))
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`school_location`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`school_location` (
  `location_id`   INT          NOT NULL AUTO_INCREMENT,
  `school_id`     INT          NOT NULL,
  `location_name` VARCHAR(128) NULL,
  `address1`      VARCHAR(255) NULL,
  `address2`      VARCHAR(255) NULL,
  `city`          VARCHAR(128) NULL,
  `state`         VARCHAR(2)   NULL,
  `zip`           VARCHAR(5)   NULL,
  `is_primary`    TINYINT(1)   NULL,
  PRIMARY KEY (`location_id`),
  INDEX `fk_school_location_school1_idx` (`school_id` ASC),
  CONSTRAINT `fk_school_location_school1`
  FOREIGN KEY (`school_id`)
  REFERENCES `signup_main`.`school` (`school_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`class`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`class` (
  `class_id`     INT                                                 NOT NULL AUTO_INCREMENT,
  `class_name`   VARCHAR(255)                                        NULL,
  `school_id`    INT                                                 NOT NULL,
  `description`  BLOB                                                NULL,
  `default_cost` DECIMAL(10, 2)                                      NULL,
  `target_level` ENUM('Beginner', 'Intermediate', 'Advanced', 'All') NULL,
  `starting_age` INT                                                 NULL,
  PRIMARY KEY (`class_id`),
  INDEX `fk_class_school1_idx` (`school_id` ASC),
  CONSTRAINT `fk_class_school1`
  FOREIGN KEY (`school_id`)
  REFERENCES `signup_main`.`school` (`school_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`user`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`user` (
  `user_id`       INT                                     NOT NULL AUTO_INCREMENT,
  `user_login`    VARCHAR(45)                             NOT NULL,
  `user_password` VARCHAR(128)                            NOT NULL,
  `first_name`    VARCHAR(128)                            NOT NULL,
  `last_name`     VARCHAR(128)                            NOT NULL,
  `address1`      VARCHAR(128)                            NOT NULL,
  `address2`      VARCHAR(128)                            NULL,
  `student_city`  VARCHAR(128)                            NULL,
  `student_state` VARCHAR(2)                              NULL,
  `student_zip`   VARCHAR(5)                              NULL,
  `user_type`     SET('Student', 'Teacher', 'Admin')      NOT NULL,
  `email`         VARCHAR(45)                             NOT NULL,
  `phone1_no`     VARCHAR(15)                             NOT NULL,
  `phone1_type`   ENUM('Home', 'Work', 'Mobile', 'Other') NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE INDEX `user_login_UNIQUE` (`user_login` ASC))
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`class_instance`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`class_instance` (
  `instance_id`           INT                                                  NOT NULL,
  `school_location_id`    INT                                                  NOT NULL,
  `class_id`              INT                                                  NOT NULL,
  `cost`                  VARCHAR(45)                                          NULL,
  `start_date`            DATE                                                 NOT NULL,
  `end_date`              DATE                                                 NOT NULL,
  `days_of_week`          SET('Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat') NULL,
  `default_start_time`    TIME                                                 NULL,
  `default_end_time`      TIME                                                 NULL,
  `registration_deadline` DATE                                                 NOT NULL,
  `student_capacity`      INT                                                  NULL,
  PRIMARY KEY (`instance_id`),
  INDEX `fk_class_instance_class1_idx` (`class_id` ASC),
  INDEX `fk_class_instance_school_location1_idx` (`school_location_id` ASC),
  CONSTRAINT `fk_class_instance_class1`
  FOREIGN KEY (`class_id`)
  REFERENCES `signup_main`.`class` (`class_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_class_instance_school_location1`
  FOREIGN KEY (`school_location_id`)
  REFERENCES `signup_main`.`school_location` (`location_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`student` (
  `user_id`  INT            NOT NULL,
  `discount` DECIMAL(10, 2) NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_student_user1`
  FOREIGN KEY (`user_id`)
  REFERENCES `signup_main`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`teacher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`teacher` (
  `user_id`             INT           NOT NULL,
  `default_hourly_rate` DECIMAL(8, 2) NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_teacher_user1`
  FOREIGN KEY (`user_id`)
  REFERENCES `signup_main`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`student_registration`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`student_registration` (
  `student_user_id`   INT            NOT NULL,
  `class_instance_id` INT            NOT NULL,
  `payment_deadline`  DATE           NULL,
  `is_paid`           TINYINT(1)     NOT NULL,
  `payment_amount`    DECIMAL(10, 2) NULL,
  `cost`              DECIMAL(10, 2) NULL,
  `discount`          DECIMAL(10, 2) NULL,
  PRIMARY KEY (`student_user_id`, `class_instance_id`),
  INDEX `fk_student_registration_class_instance1_idx` (`class_instance_id` ASC),
  CONSTRAINT `fk_student_registration_student1`
  FOREIGN KEY (`student_user_id`)
  REFERENCES `signup_main`.`student` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_student_registration_class_instance1`
  FOREIGN KEY (`class_instance_id`)
  REFERENCES `signup_main`.`class_instance` (`instance_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`school_teacher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`school_teacher` (
  `school_school_id` INT NOT NULL,
  `teacher_user_id`  INT NOT NULL,
  PRIMARY KEY (`school_school_id`, `teacher_user_id`),
  INDEX `fk_school_teacher_teacher1_idx` (`teacher_user_id` ASC),
  CONSTRAINT `fk_school_teacher_school1`
  FOREIGN KEY (`school_school_id`)
  REFERENCES `signup_main`.`school` (`school_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_school_teacher_teacher1`
  FOREIGN KEY (`teacher_user_id`)
  REFERENCES `signup_main`.`teacher` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`teacher_registration`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`teacher_registration` (
  `class_instance_instance_id` INT            NOT NULL,
  `teacher_user_id`            INT            NOT NULL,
  `is_primary`                 TINYINT(1)     NOT NULL,
  `hourly_rate`                DECIMAL(10, 2) NULL,
  `fixed_rate`                 DECIMAL(10, 2) NULL,
  `is_hourly_rate`             TINYINT(1)     NOT NULL,
  PRIMARY KEY (`class_instance_instance_id`, `teacher_user_id`),
  INDEX `fk_teacher_registration_teacher1_idx` (`teacher_user_id` ASC),
  CONSTRAINT `fk_teacher_registration_class_instance1`
  FOREIGN KEY (`class_instance_instance_id`)
  REFERENCES `signup_main`.`class_instance` (`instance_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_teacher_registration_teacher1`
  FOREIGN KEY (`teacher_user_id`)
  REFERENCES `signup_main`.`teacher` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`class_day`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`class_day` (
  `class_instance_id` INT  NOT NULL,
  `class_date`        DATE NULL,
  `start_time`        TIME NULL,
  `end_time`          TIME NULL,
  `notes`             BLOB NULL,
  INDEX `fk_class_day_class_instance1_idx` (`class_instance_id` ASC),
  CONSTRAINT `fk_class_day_class_instance1`
  FOREIGN KEY (`class_instance_id`)
  REFERENCES `signup_main`.`class_instance` (`instance_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`admin` (
  `user_id`         INT           NOT NULL,
  `registration_pr` DECIMAL(8, 2) NULL,
  `payment_method`  VARCHAR(128)  NULL,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_teacher_user10`
  FOREIGN KEY (`user_id`)
  REFERENCES `signup_main`.`user` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`school_admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`school_admin` (
  `admin_user_id`      INT        NOT NULL,
  `school_school_id`   INT        NOT NULL,
  `is_billing_contact` TINYINT(1) NULL,
  PRIMARY KEY (`admin_user_id`, `school_school_id`),
  INDEX `fk_school_admin_school1_idx` (`school_school_id` ASC),
  CONSTRAINT `fk_school_admin_admin1`
  FOREIGN KEY (`admin_user_id`)
  REFERENCES `signup_main`.`admin` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_school_admin_school1`
  FOREIGN KEY (`school_school_id`)
  REFERENCES `signup_main`.`school` (`school_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `signup_main`.`location_admin`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `signup_main`.`location_admin` (
  `admin_user_id`               INT NOT NULL,
  `school_location_location_id` INT NOT NULL,
  PRIMARY KEY (`admin_user_id`, `school_location_location_id`),
  INDEX `fk_location_admin_school_location1_idx` (`school_location_location_id` ASC),
  CONSTRAINT `fk_location_admin_admin1`
  FOREIGN KEY (`admin_user_id`)
  REFERENCES `signup_main`.`admin` (`user_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_location_admin_school_location1`
  FOREIGN KEY (`school_location_location_id`)
  REFERENCES `signup_main`.`school_location` (`location_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
  ENGINE = InnoDB;


SET SQL_MODE = @OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS = @OLD_UNIQUE_CHECKS;
