/* INSY 661 individual project
    part I.1 La Ronde table
*/

USE indproj;

-- create tables
CREATE TABLE `Customer_address` (
  `address` text,
  `postal_code` varchar(7),
  PRIMARY KEY (`postal_code`)
);

CREATE TABLE `Facility` (
  `facility_ID` varchar(255),
  `facility_desc` varchar(255),
  `facility_type` varchar(255),
  `facility_capacity` int,
  `facility_subtype` varchar(255),
  `location` varchar(255),
  PRIMARY KEY (`facility_ID`)
);

CREATE TABLE `Customer` (
  `C_ID` varchar(255),
  `first_name` varchar(255),
  `last_name` varchar(255),
  `email` varchar(255),
  `mobile_number` varchar(255),
  `gender` varchar(255),
  `dob` date,
  `date_of_reg` date,
  `postal_code` varchar(7),
  PRIMARY KEY (`C_ID`),
  FOREIGN KEY (`postal_code`) REFERENCES `Customer_address` (`postal_code`)
);

CREATE TABLE `Payment_method` (
  `payment_meth_ID` int,
  `payment_meth_desc` text,
  PRIMARY KEY (`payment_meth_ID`)
);

CREATE TABLE `Ticket_category` (
  `category_of_ticket_ID` int,
  `category_of_ticket_desc` text,
  PRIMARY KEY (`category_of_ticket_ID`)
);

CREATE TABLE `Ride` (
  `ride_ID` varchar(255),
  `ride_name` varchar(255),
  `type_of_ride` varchar(255),
  `ride_capacity` int,
  `ride_height` int,
  `year_started` year,
  `description` varchar(255),
  `min_ride_height` float,
  `allow_adult` varchar(255),
  `manufacturer` varchar(255),
  `top_speed` float,
  `track_length` float,
  `additional_fees` varchar(255),
  PRIMARY KEY (`ride_ID`)
);

CREATE TABLE `Ticket` (
  `ticket_ID` int,
  `C_ID` varchar(255),
  `promo_applied` int,
  `price` int,
  `purchase_mode` varchar(255),
  `purchase_date` date,
  `payment_meth_ID` int,
  `category_of_ticket_ID` int,
  PRIMARY KEY (`ticket_ID`),
  FOREIGN KEY (`C_ID`) REFERENCES `Customer`(`C_ID`),
  FOREIGN KEY (`category_of_ticket_ID`) REFERENCES `Ticket_category` (`category_of_ticket_ID`),
  FOREIGN KEY (`payment_meth_ID`) REFERENCES `Payment_method` (`payment_meth_ID`)
);

CREATE TABLE `Ride_ticket` (
  `ride_ticket_ID` varchar(255),
  `ticket_ID` int,
  `ride_ID` varchar(255),
  `ride_access_time` datetime,
  PRIMARY KEY (`ride_ticket_ID`),
  FOREIGN KEY (`ticket_ID`) REFERENCES `Ticket` (`ticket_ID`),
  FOREIGN KEY (`ride_ID`) REFERENCES `Ride` (`ride_ID`)
);


CREATE TABLE `facilies_tickets` (
  `facility_ticket_ID` varchar(255),
  `facility_ID` varchar(255),
  `ticket_ID` int,
  `facility_access_time` datetime,
  PRIMARY KEY (`facility_ticket_ID`),
  FOREIGN KEY (`facility_ID`) REFERENCES `Facility` (`facility_ID`),
  FOREIGN KEY (`ticket_ID`) REFERENCES `Ticket` (`ticket_ID`)
);
