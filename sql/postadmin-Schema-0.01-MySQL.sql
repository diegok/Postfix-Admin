-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Thu Feb  3 11:08:01 2011
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `admin`;

--
-- Table: `admin`
--
CREATE TABLE `admin` (
  `username` VARCHAR(255) NOT NULL DEFAULT '',
  `password` VARCHAR(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`username`)
) DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `domain`;

--
-- Table: `domain`
--
CREATE TABLE `domain` (
  `domain` VARCHAR(255) NOT NULL DEFAULT '',
  `description` VARCHAR(255) NOT NULL DEFAULT '',
  `aliases` integer(10) NOT NULL DEFAULT 0,
  `mailboxes` integer(10) NOT NULL DEFAULT 0,
  `maxquota` integer(10) NOT NULL DEFAULT 0,
  `transport` VARCHAR(255),
  `backupmx` TINYINT(1) NOT NULL DEFAULT 0,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`domain`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `domain_admins`;

--
-- Table: `domain_admins`
--
CREATE TABLE `domain_admins` (
  `username` VARCHAR(255) NOT NULL DEFAULT '',
  `domain` VARCHAR(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1
) DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `log`;

--
-- Table: `log`
--
CREATE TABLE `log` (
  `timestamp` datetime NOT NULL,
  `username` VARCHAR(255) NOT NULL DEFAULT '',
  `domain` VARCHAR(255) NOT NULL DEFAULT '',
  `action` VARCHAR(255) NOT NULL DEFAULT '',
  `data` VARCHAR(255) NOT NULL DEFAULT ''
) DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `vacation`;

--
-- Table: `vacation`
--
CREATE TABLE `vacation` (
  `email` VARCHAR(255) NOT NULL DEFAULT '',
  `subject` VARCHAR(255) NOT NULL DEFAULT '',
  `body` text NOT NULL,
  `cache` text NOT NULL,
  `domain` VARCHAR(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`email`)
) DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `alias`;

--
-- Table: `alias`
--
CREATE TABLE `alias` (
  `address` VARCHAR(255) NOT NULL DEFAULT '',
  `goto` text NOT NULL,
  `domain` VARCHAR(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  INDEX `alias_idx_domain` (`domain`),
  PRIMARY KEY (`address`),
  CONSTRAINT `alias_fk_domain` FOREIGN KEY (`domain`) REFERENCES `domain` (`domain`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `mailbox`;

--
-- Table: `mailbox`
--
CREATE TABLE `mailbox` (
  `username` VARCHAR(255) NOT NULL DEFAULT '',
  `password` VARCHAR(255) NOT NULL DEFAULT '',
  `name` VARCHAR(255) NOT NULL DEFAULT '',
  `maildir` VARCHAR(255) NOT NULL DEFAULT '',
  `quota` integer(10) NOT NULL DEFAULT 0,
  `domain` VARCHAR(255) NOT NULL DEFAULT '',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  INDEX `mailbox_idx_domain` (`domain`),
  PRIMARY KEY (`username`, `domain`),
  CONSTRAINT `mailbox_fk_domain` FOREIGN KEY (`domain`) REFERENCES `domain` (`domain`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

SET foreign_key_checks=1;

