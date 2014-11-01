-- phpMyAdmin SQL Dump
-- version 4.2.5
-- http://www.phpmyadmin.net
--
-- Host: localhost:3306
-- Generation Time: Nov 01, 2014 at 04:41 PM
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

DROP TABLE IF EXISTS `bounds`;
CREATE TABLE IF NOT EXISTS `bounds` (
  `patient_id` varchar(100) NOT NULL,
  `stat_id` int(11) NOT NULL,
  `statLowerBound` int(11) NOT NULL,
  `statUpperBound` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `doctors`
--

DROP TABLE IF EXISTS `doctors`;
CREATE TABLE IF NOT EXISTS `doctors` (
`doctor_id` int(11) NOT NULL,
  `doctorName` varchar(100) NOT NULL DEFAULT '',
  `doctorPhoneNumber` varchar(100) NOT NULL DEFAULT '',
  `doctorAddress` varchar(200) NOT NULL DEFAULT ''
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

DROP TABLE IF EXISTS `notifications`;
CREATE TABLE IF NOT EXISTS `notifications` (
  `patient_id` varchar(100) NOT NULL,
  `recipientName` varchar(100) NOT NULL,
  `recipientPhoneNumber` varchar(100) NOT NULL,
  `callsOn` tinyint(1) NOT NULL DEFAULT '1',
  `textsOn` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `patients`
--

DROP TABLE IF EXISTS `patients`;
CREATE TABLE IF NOT EXISTS `patients` (
  `patient_id` varchar(100) NOT NULL,
  `patientName` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `patients`
--

INSERT INTO `patients` (`patient_id`, `patientName`) VALUES
('12', 'bob');

-- --------------------------------------------------------

--
-- Table structure for table `patients_doctors`
--

DROP TABLE IF EXISTS `patients_doctors`;
CREATE TABLE IF NOT EXISTS `patients_doctors` (
  `patient_id` varchar(100) NOT NULL,
  `doctor_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `stats`
--

DROP TABLE IF EXISTS `stats`;
CREATE TABLE IF NOT EXISTS `stats` (
`stat_id` int(11) NOT NULL,
  `statName` varchar(100) NOT NULL,
  `statUnit` varchar(100) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6 ;

--
-- Dumping data for table `stats`
--

INSERT INTO `stats` (`stat_id`, `statName`, `statUnit`) VALUES
(1, 'weight', 'pound'),
(2, 'BAC', 'BAC'),
(3, 'footsteps', 'footsteps');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bounds`
--
ALTER TABLE `bounds`
 ADD KEY `patient_id` (`patient_id`), ADD KEY `stat_id` (`stat_id`);

--
-- Indexes for table `doctors`
--
ALTER TABLE `doctors`
 ADD PRIMARY KEY (`doctor_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
 ADD KEY `patient_id` (`patient_id`);

--
-- Indexes for table `patients`
--
ALTER TABLE `patients`
 ADD PRIMARY KEY (`patient_id`);

--
-- Indexes for table `patients_doctors`
--
ALTER TABLE `patients_doctors`
 ADD KEY `patient_id` (`patient_id`), ADD KEY `doctor_id` (`doctor_id`);

--
-- Indexes for table `stats`
--
ALTER TABLE `stats`
 ADD PRIMARY KEY (`stat_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `doctors`
--
ALTER TABLE `doctors`
MODIFY `doctor_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `stats`
--
ALTER TABLE `stats`
MODIFY `stat_id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `bounds`
--
ALTER TABLE `bounds`
ADD CONSTRAINT `bounds_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
ADD CONSTRAINT `bounds_ibfk_2` FOREIGN KEY (`stat_id`) REFERENCES `stats` (`stat_id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`);

--
-- Constraints for table `patients_doctors`
--
ALTER TABLE `patients_doctors`
ADD CONSTRAINT `patients_doctors_ibfk_1` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
ADD CONSTRAINT `patients_doctors_ibfk_2` FOREIGN KEY (`doctor_id`) REFERENCES `doctors` (`doctor_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
