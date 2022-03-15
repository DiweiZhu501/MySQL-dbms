/* INSY 661 individual project
    part I.2 external table
*/
    
-- create Weather table
CREATE TABLE Weather (
  `year` int,
  `month` int,
  `day` int,
  `date` date,
  `max_temp` double,
  `min_temp` double,
  `rain` double,
  `snow` double,
  `precip` double,
  PRIMARY KEY (`date`),
  FOREIGN KEY (`date`) REFERENCES `Rides_tickets` (`date_access`),
  FOREIGN KEY (`date`) REFERENCES `Facility_ticket` (`date_access`)
);