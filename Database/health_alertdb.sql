-- phpMyAdmin SQL Dump
-- version 4.2.5
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Dec 07, 2014 at 11:50 AM
-- Server version: 5.5.38
-- PHP Version: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `health_alertdb`
--
CREATE DATABASE IF NOT EXISTS `health_alertdb` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `health_alertdb`;

-- --------------------------------------------------------

--
-- Table structure for table `bounds`
--

CREATE TABLE IF NOT EXISTS `bounds` (
  `patient_id` varchar(100) NOT NULL,
  `stat_id` int(11) NOT NULL,
  `statLowerBound` float NOT NULL,
  `statUpperBound` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE IF NOT EXISTS `contacts` (
`contact_id` int(11) NOT NULL,
  `contactName` varchar(100) NOT NULL DEFAULT 'Insert Name',
  `contactPhoneNumber` varchar(100) NOT NULL DEFAULT 'Insert Telephone Number'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=118 ;

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

CREATE TABLE IF NOT EXISTS `doctors` (
`doctor_id` int(11) NOT NULL,
  `doctorName` varchar(100) NOT NULL DEFAULT '',
  `doctorPhoneNumber` varchar(100) NOT NULL DEFAULT '',
  `doctorAddress` varchar(200) NOT NULL DEFAULT ''
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=50 ;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE IF NOT EXISTS `notifications` (
  `patient_id` varchar(100) NOT NULL,
  `contact_id` int(11) NOT NULL,
  `stat_id` int(11) NOT NULL,
  `callsOn` tinyint(1) NOT NULL DEFAULT '0',
  `textsOn` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

CREATE TABLE IF NOT EXISTS `patients` (
  `patient_id` varchar(100) NOT NULL,
  `patientName` varchar(100) NOT NULL DEFAULT 'Insert Name'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `patients_contacts`
--

CREATE TABLE IF NOT EXISTS `patients_contacts` (
  `patient_id` varchar(100) NOT NULL,
  `contact_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `patients_doctors`
--

CREATE TABLE IF NOT EXISTS `patients_doctors` (
  `patient_id` varchar(100) NOT NULL,
  `doctor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `stats`
--

CREATE TABLE IF NOT EXISTS `stats` (
`stat_id` int(11) NOT NULL,
  `statName` varchar(100) NOT NULL,
  `statUnit` varchar(100) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=10 ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bounds`
--
ALTER TABLE `bounds`
 ADD PRIMARY KEY (`patient_id`,`stat_id`), ADD KEY `stat_id` (`stat_id`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
 ADD PRIMARY KEY (`contact_id`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
 ADD PRIMARY KEY (`doctor_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
 ADD PRIMARY KEY (`patient_id`,`contact_id`,`stat_id`), ADD KEY `contact_id` (`contact_id`), ADD KEY `stat_id` (`stat_id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
 ADD PRIMARY KEY (`patient_id`);

--
-- Indexes for table `patients_contacts`
--
ALTER TABLE `patients_contacts`
 ADD PRIMARY KEY (`patient_id`,`contact_id`), ADD KEY `contact_id` (`contact_id`);

--
-- Indexes for table `patients_doctors`
--
ALTER TABLE `patients_doctors`
 ADD PRIMARY KEY (`patient_id`,`doctor_id`), ADD KEY `doctor_id` (`doctor_id`);

--
-- Indexes for table `stats`
--
ALTER TABLE `stats`
 ADD PRIMARY KEY (`stat_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
MODIFY `contact_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=118;
--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
MODIFY `doctor_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=50;
--
-- AUTO_INCREMENT for table `stats`
--
ALTER TABLE `stats`
MODIFY `stat_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=10;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `bounds`
--
ALTER TABLE `bounds`
ADD CONSTRAINT `bounds_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
ADD CONSTRAINT `bounds_ibfk_2` FOREIGN KEY (`stat_id`) REFERENCES `stats` (`stat_id`),
ADD CONSTRAINT `bounds_ibfk_3` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
ADD CONSTRAINT `bounds_ibfk_4` FOREIGN KEY (`stat_id`) REFERENCES `stats` (`stat_id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
ADD CONSTRAINT `notifications_ibfk_2` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`contact_id`),
ADD CONSTRAINT `notifications_ibfk_3` FOREIGN KEY (`stat_id`) REFERENCES `stats` (`stat_id`);

--
-- Constraints for table `patients_contacts`
--
ALTER TABLE `patients_contacts`
ADD CONSTRAINT `patients_contacts_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
ADD CONSTRAINT `patients_contacts_ibfk_2` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`contact_id`);

--
-- Constraints for table `patients_doctors`
--
ALTER TABLE `patients_doctors`
ADD CONSTRAINT `patients_doctors_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
ADD CONSTRAINT `patients_doctors_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
