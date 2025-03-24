use mss;
DROP TABLE IF EXISTS `mss`.`movie_plan_availability`;
DROP TABLE IF EXISTS `mss`.`watch_history`;
DROP TABLE IF EXISTS `mss`.`ratings`;
DROP TABLE IF EXISTS `mss`.`movies`;
DROP TABLE IF EXISTS `mss`.`genres`;
DROP TABLE IF EXISTS `mss`.`reviewer`;
DROP TABLE IF EXISTS `mss`.`subscriptions`;
DROP TABLE IF EXISTS `mss`.`subscription_plans`;

DROP TABLE IF EXISTS `mss`.`users`;

CREATE TABLE `mss`.`genres` (
  `genre_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(300) NOT NULL,
  PRIMARY KEY (`genre_id`));

CREATE TABLE `mss`.`movies` (
  `movie_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `release_year` YEAR NOT NULL,
  `director` VARCHAR(45) NOT NULL,
  `duration` INT UNSIGNED NOT NULL,
  `genre_id` INT UNSIGNED NULL,
  `description` VARCHAR(45) NULL,
  PRIMARY KEY (`movie_id`),
  INDEX `genreFK_idx` (`genre_id` ASC) VISIBLE,
  CONSTRAINT `genreFK`
    FOREIGN KEY (`genre_id`)
    REFERENCES `mss`.`genres` (`genre_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);
    
CREATE TABLE `mss`.`users` (
  `user_id` INT UNSIGNED NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `region` VARCHAR(45) NOT NULL,
  `birthdate` DATE NOT NULL,
  PRIMARY KEY (`user_id`));

CREATE TABLE `mss`.`subscription_plans` (
  `plan_id` INT UNSIGNED NOT NULL,
  `plan_title` VARCHAR(45) NOT NULL,
  `plan_description` VARCHAR(400) NOT NULL,
  `default_monthly_price` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`plan_id`));
  
CREATE TABLE `mss`.`subscriptions` (
  `subscription_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `plan_id` INT UNSIGNED NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NOT NULL,
  `monthly_price` DECIMAL(5,2) NOT NULL,
  PRIMARY KEY (`subscription_id`),
  INDEX `user_sub_FK_idx` (`user_id` ASC) VISIBLE,
  INDEX `sub_plan_FK_idx` (`plan_id` ASC) VISIBLE,
  CONSTRAINT `user_sub_FK`
    FOREIGN KEY (`user_id`)
    REFERENCES `mss`.`users` (`user_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `sub_plan_FK`
    FOREIGN KEY (`plan_id`)
    REFERENCES `mss`.`subscription_plans` (`plan_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);

CREATE TABLE `mss`.`movie_plan_availability` (
  `movie_id` INT UNSIGNED NOT NULL,
  `plan_id` INT UNSIGNED NOT NULL,
  `mode` ENUM('restrict', 'permit', 'limit') NOT NULL,
  PRIMARY KEY (`movie_id`, `plan_id`),
  INDEX `plan_linkFK_idx` (`plan_id` ASC) VISIBLE,
  CONSTRAINT `movie_linkFK`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mss`.`movies` (`movie_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `plan_linkFK`
    FOREIGN KEY (`plan_id`)
    REFERENCES `mss`.`subscription_plans` (`plan_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);

CREATE TABLE `mss`.`reviewer` (
  `reviewer_id` INT UNSIGNED NOT NULL,
  `reviewer_name` VARCHAR(45) NOT NULL,
  `reviewer_phone` VARCHAR(25) NULL,
  PRIMARY KEY (`reviewer_id`));

CREATE TABLE `mss`.`ratings` (
  `reviewer_id` INT UNSIGNED NOT NULL,
  `movie_id` INT UNSIGNED NOT NULL,
  `rating_score` DECIMAL(4,2) NOT NULL,
  `blurb` VARCHAR(300) NULL,
  PRIMARY KEY (`reviewer_id`, `movie_id`),
  INDEX `movierating_FK_idx` (`movie_id` ASC) VISIBLE,
  CONSTRAINT `reviewer_FK`
    FOREIGN KEY (`reviewer_id`)
    REFERENCES `mss`.`reviewer` (`reviewer_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `movierating_FK`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mss`.`movies` (`movie_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);

CREATE TABLE `mss`.`watch_history` (
  `history_id` INT UNSIGNED NOT NULL,
  `movie_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED NOT NULL,
  `watch_date` DATETIME NOT NULL,
  PRIMARY KEY (`history_id`),
  INDEX `user_history_FK_idx` (`user_id` ASC) VISIBLE,
  INDEX `movie_history_FK_idx` (`movie_id` ASC) VISIBLE,
  CONSTRAINT `user_history_FK`
    FOREIGN KEY (`user_id`)
    REFERENCES `mss`.`users` (`user_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT,
  CONSTRAINT `movie_history_FK`
    FOREIGN KEY (`movie_id`)
    REFERENCES `mss`.`movies` (`movie_id`)
    ON DELETE RESTRICT
    ON UPDATE RESTRICT);