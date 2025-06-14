CREATE DATABASE airline28;
USE airline28;

CREATE TABLE loyalty_programs (
    loyalty_program_id INT AUTO_INCREMENT PRIMARY KEY,
    program_name VARCHAR(255) NOT NULL,
    benefits TEXT);

CREATE TABLE passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_info VARCHAR(255),
    loyalty_program_id INT,
    travel_history TEXT,
    FOREIGN KEY (loyalty_program_id) REFERENCES loyalty_programs(loyalty_program_id)
    ON UPDATE CASCADE ON DELETE SET NULL);
    
CREATE TABLE routes (
    route_id INT AUTO_INCREMENT PRIMARY KEY,
    origin VARCHAR(255),
    destination VARCHAR(255));

CREATE TABLE aircrafts (
    aircraft_id INT AUTO_INCREMENT PRIMARY KEY,
    aircraft_type VARCHAR(255),
    capacity INT,
    maintenance_schedule TEXT,
    availability ENUM('available', 'unavailable'));

CREATE TABLE flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_number VARCHAR(50) NOT NULL,
    route_id INT,
    aircraft_id INT,
    departure_time DATETIME,
    arrival_time DATETIME,
    status ENUM('on-time', 'delayed', 'cancelled'),
    FOREIGN KEY (route_id) REFERENCES routes(route_id)
    ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (aircraft_id) REFERENCES aircrafts(aircraft_id)
    ON UPDATE CASCADE ON DELETE SET NULL);

CREATE TABLE reservations (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    reservation_date DATETIME,
    seat_number VARCHAR(10),
    fare DECIMAL(10, 2),
    ticket_status ENUM('booked', 'cancelled'),
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
    ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE crew_members (
    crew_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    role ENUM('pilot', 'flight_attendant', 'ground_staff'),
    contact_info VARCHAR(255),
    assigned_flight INT,
    FOREIGN KEY (assigned_flight) REFERENCES flights(flight_id)
    ON UPDATE CASCADE ON DELETE SET NULL);

CREATE TABLE airplane_inventory (
    inventory_id INT AUTO_INCREMENT PRIMARY KEY,
    aircraft_id INT,
    item VARCHAR(255),
    quantity INT,
    FOREIGN KEY (aircraft_id) REFERENCES aircrafts(aircraft_id)
    ON UPDATE CASCADE ON DELETE CASCADE);

CREATE TABLE onboard_supplies (
	supply_id INT AUTO_INCREMENT PRIMARY KEY,
    item VARCHAR(255),
    quantity INT);

CREATE TABLE financial_transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    transaction_type ENUM('income', 'expense'),
    amount DECIMAL(10, 2),
    description TEXT,
    date DATETIME);

CREATE TABLE security_compliance (
    compliance_id INT AUTO_INCREMENT PRIMARY KEY,
    regulation TEXT,
    compliance_status ENUM('compliant', 'non-compliant'),
    compliance_date DATETIME);

CREATE TABLE seats (
    seat_id INT AUTO_INCREMENT PRIMARY KEY,
    seat_number VARCHAR(255) NOT NULL UNIQUE,
    class ENUM('economy', 'business', 'first') NOT NULL,
    status ENUM('available', 'occupied') NOT NULL);


CREATE TABLE tickets (
    ticket_id INT AUTO_INCREMENT PRIMARY KEY,
    reservation_id INT,
    seat_id INT,
    ticket_number VARCHAR(50) NOT NULL UNIQUE,
    issue_date DATETIME,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (seat_id) REFERENCES seats(seat_id)
    ON UPDATE CASCADE ON DELETE SET NULL);
    
CREATE TABLE airports (
    airport_id INT AUTO_INCREMENT PRIMARY KEY,
    airport_name VARCHAR(255) NOT NULL,
    location VARCHAR(255) NOT NULL);

CREATE TABLE runways (
    runway_id INT AUTO_INCREMENT PRIMARY KEY,
    runway_code VARCHAR(10) NOT NULL UNIQUE,
    length INT,
    airport_id INT,
    FOREIGN KEY (airport_id) REFERENCES airports(airport_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE maintenance (
    maintenance_id INT AUTO_INCREMENT PRIMARY KEY,
    aircraft_id INT,
    description TEXT,
    maintenance_date DATETIME,
    FOREIGN KEY (aircraft_id) REFERENCES aircrafts(aircraft_id)
    ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE baggage (
    baggage_id INT AUTO_INCREMENT PRIMARY KEY,
    aircraft_id INT,
    baggage_tag VARCHAR(50) NOT NULL UNIQUE,
    weight DECIMAL(5, 2),
    passenger_id INT,
    FOREIGN KEY (aircraft_id) REFERENCES aircrafts(aircraft_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id)
    ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    reservation_id INT,
    amount DECIMAL(10, 2),
    payment_date DATETIME,
    payment_method ENUM('credit_card', 'debit_card', 'cash'),
    FOREIGN KEY (passenger_id) REFERENCES passengers(passenger_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (reservation_id) REFERENCES reservations(reservation_id)
    ON UPDATE CASCADE ON DELETE CASCADE);


CREATE TABLE flight_schedule (
    schedule_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_id INT,
    departure_time DATETIME,
    arrival_time DATETIME,
    FOREIGN KEY (flight_id) REFERENCES flights(flight_id)
    ON UPDATE CASCADE ON DELETE CASCADE);

INSERT INTO loyalty_programs (program_name, benefits) VALUES
('Gold Membership', 'Priority boarding, Lounge access, Extra baggage allowance'),
('Silver Membership', 'Priority boarding, Lounge access'),
('Bronze Membership', 'Lounge access');

INSERT INTO routes (origin, destination) VALUES
('Islamabad International Airport', 'Jinnah International Airport'),
('Jinnah International Airport', 'Sialkot International Airport'),
('Sialkot International Airport', 'Allama Iqbal International Airport'),
('Allama Iqbal International Airport', 'Bacha Khan International Airport'),
('Bacha Khan International Airport', 'Quetta International Airport'),
('Quetta International Airport', 'Multan International Airport'),
('Multan International Airport', 'Faisalabad International Airport'),
('Faisalabad International Airport', 'Islamabad International Airport'),
('Los Angeles International Airport', 'John F. Kennedy International Airport'),
('John F. Kennedy International Airport', 'Las Vegas McCarran International Airport'),
('Las Vegas McCarran International Airport', 'Boston Logan International Airport'),
('Boston Logan International Airport', 'Seattle-Tacoma International Airport'),
('Seattle-Tacoma International Airport', 'Hartsfield-Jackson Atlanta International Airport'),
('Hartsfield-Jackson Atlanta International Airport', 'Denver International Airport'),
('Denver International Airport', 'Phoenix Sky Harbor International Airport'),
('Phoenix Sky Harbor International Airport', 'Philadelphia International Airport'),
('Philadelphia International Airport', 'Minneapolis-Saint Paul International Airport'),
('Minneapolis-Saint Paul International Airport', 'Portland International Airport'),
('Portland International Airport', 'Charlotte Douglas International Airport'),
('Charlotte Douglas International Airport', 'Detroit Metropolitan Airport');

INSERT INTO aircrafts (aircraft_type, capacity, maintenance_schedule, availability) VALUES
('Boeing 737', 150, 'Monthly', 'available'),
('Airbus A320', 180, 'Quarterly', 'available'),
('Boeing 747', 300, 'Bi-Annually', 'available'),
('Airbus A380', 500, 'Annually', 'unavailable'),
('Embraer E190', 100, 'Monthly', 'available'),
('Bombardier CRJ200', 50, 'Monthly', 'available'),
('Boeing 777', 400, 'Bi-Annually', 'unavailable'),
('Airbus A350', 350, 'Quarterly', 'available'),
('Boeing 787', 250, 'Monthly', 'available'),
('Airbus A321', 200, 'Quarterly', 'available'),
('Boeing 737 Max', 160, 'Monthly', 'available'),
('Airbus A330', 270, 'Quarterly', 'available'),
('Airbus A380', 525, 'Monthly', 'available'),
('Airbus A319', 160, 'Bi-Annually', 'unavailable'),
('Airbus A350', 410, 'Quarterly', 'available'),
('Boeing 767', 375, 'Monthly', 'available'),
('Comac C919', 192, 'Quarterly', 'available'),
('Boeing 757', 160, 'Monthly', 'available'),
('Airbus A330 Neo', 291, 'Quarterly', 'available'),
('Boeing 747-400', 568, 'Monthly', 'available');

INSERT INTO flights (flight_number, route_id, aircraft_id, departure_time, arrival_time, status) VALUES
('PK001', 1, 1, '2024-07-01 08:00:00', '2024-07-01 14:00:00', 'on-time'),
('PK002', 2, 2, '2024-07-02 09:00:00', '2024-07-02 13:30:00', 'on-time'),
('PK003', 3, 3, '2024-07-03 07:00:00', '2024-07-03 10:00:00', 'delayed'),
('PK004', 4, 4, '2024-07-04 11:00:00', '2024-07-04 17:30:00', 'cancelled'),
('PK005', 5, 5, '2024-07-05 13:00:00', '2024-07-05 15:30:00', 'on-time'),
('PK006', 6, 6, '2024-07-06 15:00:00', '2024-07-06 19:00:00', 'on-time'),
('PK007', 7, 7, '2024-07-07 17:00:00', '2024-07-07 18:00:00', 'on-time'),
('PK008', 8, 8, '2024-07-08 06:00:00', '2024-07-08 07:45:00', 'on-time'),
('PK009', 9, 9, '2024-07-09 08:00:00', '2024-07-09 10:15:00', 'on-time'),
('PK010', 10, 10, '2024-07-10 12:00:00', '2024-07-10 14:45:00', 'delayed'),
('PK011', 11, 11, '2024-07-11 08:30:00', '2024-07-11 14:30:00', 'on-time'),
('PK012', 12, 12, '2024-07-12 10:00:00', '2024-07-12 13:00:00', 'on-time'),
('PK013', 13, 13, '2024-07-13 07:30:00', '2024-07-13 10:30:00', 'delayed'),
('PK014', 14, 14, '2024-07-14 11:30:00', '2024-07-14 17:00:00', 'cancelled'),
('PK015', 15, 15, '2024-07-15 13:30:00', '2024-07-15 15:00:00', 'on-time'),
('PK016', 16, 16, '2024-07-16 15:30:00', '2024-07-16 18:30:00', 'on-time'),
('PK017', 17, 17, '2024-07-17 17:30:00', '2024-07-17 19:00:00', 'on-time'),
('PK018', 18, 18, '2024-07-18 06:30:00', '2024-07-18 08:15:00', 'on-time'),
('PK019', 19, 19, '2024-07-19 08:30:00', '2024-07-19 10:45:00', 'on-time'),
('PK020', 20, 20, '2024-07-20 12:30:00', '2024-07-20 15:15:00', 'delayed');

INSERT INTO passengers (passenger_id, name, contact_info, loyalty_program_id, travel_history) VALUES
(1, 'Shayan Alam', 'shayan.alam@gmail.com', 1, '2023-05-10: Flight PK001'),
(2, 'Zain Shaikh', 'zain.shaikh@yahoo.com', 2, '2023-05-11: Flight PK002'),
(3, 'Abdul Rafay', 'abdul.rafay@gmail.com', 3, '2023-05-12: Flight PK003'),
(4, 'Muhummad Murtaza', 'muhummad.murtaza@yahoo.com', 1, '2023-05-13: Flight PK004'),
(5, 'Mir Balach', 'mir.balach@gmail.com', 2, '2023-05-14: Flight PK005'),
(6, 'Umer Shaikh', 'umer.shaikh@yahoo.com', 1, '2023-05-15: Flight PK006'),
(7, 'Mujtaba Zaidi', 'mujtaba.zaidi@gmail.com', 2, '2023-05-16: Flight PK007'),
(8, 'Sahil Kingrani', 'sahil.kingrani@yahoo.com', 3, '2023-05-17: Flight PK008'),
(9, 'Masood Ahmed', 'masood.ahmed@gmail.com', 2, '2023-05-18: Flight PK009'),
(10, 'Hussain Ali', 'hussain.ali@yahoo.com', 2, '2023-05-19: Flight PK010'),
(11, 'Hammad Zafar', 'hammad.zafar@gmail.com', 1, '2023-05-20: Flight PK011'),
(12, 'Haider Khan', 'haider.khan@yahoo.com', 2, '2023-05-21: Flight PK012'),
(13, 'Kamran Ali', 'kamran.ali@gmail.com', 1, '2022-04-08: Flight PK002, 2022-05-12: Flight PK003'),
(14, 'Sadaf Khan', 'sadaf.khan@yahoo.com', 2, '2022-03-15: Flight PK004'),
(15, 'Faisal Siddiqui', 'faisal.siddiqui@gmail.com', 1, '2022-02-18: Flight PK005, 2022-03-22: Flight PK006'),
(16, 'Hina Sheikh', 'hina.sheikh@yahoo.com', 3, '2022-01-05: Flight PK007, 2022-02-10: Flight PK008'),
(17, 'Saad Ahmed', 'saad.ahmed@gmail.com', 1, '2021-12-12: Flight PK009, 2022-01-20: Flight PK010'),
(18, 'Saima Khan', 'saima.khan@yahoo.com', 2, '2021-11-15: Flight PK011'),
(19, 'Haris Malik', 'haris.malik@gmail.com', 1, '2021-10-18: Flight PK012, 2021-11-22: Flight PK013'),
(20, 'Shayan Alam', 'shayan.alam@gmail.com', 1, '2023-05-10: Flight PK001'),
(21, 'Zain Shaikh', 'zain.shaikh@yahoo.com', 2, '2023-05-11: Flight PK002'),
(22, 'Abdul Rafay', 'abdul.rafay@gmail.com', 3, '2023-05-12: Flight PK003'),
(23, 'Muhummad Murtaza', 'muhummad.murtaza@yahoo.com', 2, '2023-05-13: Flight PK004'),
(24, 'Mir Balach', 'mir.balach@gmail.com', 3, '2023-05-14: Flight PK005'),
(25, 'Umer Shaikh', 'umer.shaikh@yahoo.com', 1, '2023-05-15: Flight PK006'),
(26, 'Mujtaba Zaidi', 'mujtaba.zaidi@gmail.com', 2, '2023-05-16: Flight PK007'),
(27, 'Sahil Kingrani', 'sahil.kingrani@yahoo.com', 3, '2023-05-17: Flight PK008'),
(28, 'Masood Ahmed', 'masood.ahmed@gmail.com', 1, '2023-05-18: Flight PK009'),
(29, 'Hussain Ali', 'hussain.ali@yahoo.com', 2, '2023-05-19: Flight PK010'),
(30, 'Hammad Zafar', 'hammad.zafar@gmail.com', 1, '2023-05-20: Flight PK011'),
(31, 'Haider Khan', 'haider.khan@yahoo.com', 2, '2023-05-21: Flight PK012'),
(32, 'Inaya', 'inaya@yahoo.com', 2, '2023-03-10: Flight PK303, 2023-04-12: Flight PK404'),
(33, 'Aryan', 'aryan@gmail.com', 3, '2023-05-05: Flight PK505, 2023-06-08: Flight PK606'),
(34, 'Anas', 'anas@yahoo.com', 1, '2023-07-25: Flight PK707, 2023-08-30: Flight PK808'),
(35, 'Ayat', 'ayat@gmail.com', 2, '2023-09-15: Flight PK909, 2023-10-18: Flight PK010'),
(36, 'Aaira', 'aaira@yahoo.com', 3, '2023-11-10: Flight PK111, 2023-12-12: Flight PK212'),
(37, 'Huzaifa', 'huzaifa@gmail.com', 1, '2024-01-05: Flight PK313, 2024-02-08: Flight PK414'),
(38, 'Azlan', 'azlan@yahoo.com', 2, '2024-03-20: Flight PK515, 2024-04-22: Flight PK616'),
(39, 'Neha', 'neha@gmail.com', 3, '2024-05-10: Flight PK717, 2024-06-12: Flight PK818'),
(40, 'Shayan', 'shayan@yahoo.com', 1, '2024-07-15: Flight PK919, 2024-08-18: Flight PK020'),
(41, 'Aayan', 'aayan@gmail.com', 2, '2024-09-05: Flight PK121, 2024-10-08: Flight PK222'),
(42, 'Maryam', 'maryam@yahoo.com', 3, '2024-11-15: Flight PK323, 2024-12-18: Flight PK424'),
(43, 'Saad', 'saad@gmail.com', 1, '2025-01-25: Flight PK525, 2025-02-28: Flight PK626'),
(44, 'Junaid', 'junaid@yahoo.com', 2, '2025-03-10: Flight PK727, 2025-04-12: Flight PK828'),
(45, 'Rohaan', 'rohaan@gmail.com', 3, '2025-05-05: Flight PK929, 2025-06-08: Flight PK030'),
(46, 'Eshaal', 'eshaal@yahoo.com', 1, '2025-07-25: Flight PK131, 2025-08-28: Flight PK232'),
(47, 'Umaima', 'umaima@gmail.com', 2, '2025-09-15: Flight PK333, 2025-10-18: Flight PK434'),
(48, 'Alina', 'alina@yahoo.com', 3, '2025-11-10: Flight PK535, 2025-12-12: Flight PK636'),
(49, 'Zonaira', 'zonaira@gmail.com', 1, '2026-01-05: Flight PK737, 2026-02-08: Flight PK838'),
(50, 'Husnain', 'husnain@yahoo.com', 2, '2026-03-20: Flight PK939, 2026-04-22: Flight PK040');


INSERT INTO baggage (aircraft_id, baggage_tag, weight, passenger_id) VALUES
(1, 'TAG12345', 25.5, 1),
(2, 'TAG23456', 30.0, 2),
(3, 'TAG34567', 22.8, 3),
(4, 'TAG45678', 27.2, 4),
(5, 'TAG56789', 29.5, 5),
(6, 'TAG67890', 26.1, 6),
(7, 'TAG78901', 28.3, 7),
(8, 'TAG89012', 24.7, 8),
(9, 'TAG90123', 26.9, 9),
(10, 'TAG01234', 23.4, 10),
(11, 'TAG12346', 28.2, 11),
(12, 'TAG23457', 26.5, 12),
(13, 'TAG34568', 29.8, 13),
(14, 'TAG45679', 24.3, 14),
(15, 'TAG56780', 27.6, 15),
(16, 'TAG67891', 25.9, 16),
(17, 'TAG78902', 23.7, 17),
(18, 'TAG89013', 21.5, 18),
(19, 'TAG90124', 22.8, 19),
(20, 'TAG01235', 25.1, 20);

INSERT INTO reservations (reservation_id,passenger_id, flight_id,reservation_date,seat_number, fare, ticket_status) VALUES
(1,1, 1, '2024-06-20 12:00:00', '1A', 350.00, 'booked'),
(2,2,2, '2024-06-21 15:00:00', '12C', 200.00, 'booked'),
(3, 3, 3, '2024-06-22 16:00:00', '5D', 150.00, 'booked'),
(4, 4, 4, '2024-06-23 17:00:00', '7F', 175.00, 'cancelled'),
(5, 5, 5, '2024-06-24 18:00:00', '10B', 180.00, 'booked'),
(6, 6, 6, '2024-06-25 19:00:00', '15E', 220.00, 'booked'),
(7, 7, 7, '2024-06-26 20:00:00', '20C', 300.00, 'booked'),
(8, 8, 8, '2024-06-27 21:00:00', '3A', 250.00, 'booked'),
(9, 9, 9, '2024-06-28 22:00:00', '8D', 400.00, 'booked'),
(10, 10, 10, '2024-06-29 23:00:00', '9F', 450.00, 'cancelled'),
(11, 11, 11, '2024-07-01 08:00:00', '12B', 175.00, 'booked'),
(12, 12, 12, '2024-07-02 09:00:00', '14E', 190.00, 'booked'),
(13, 13, 13, '2024-07-03 10:00:00', '18C', 210.00, 'booked'),
(14, 14, 14, '2024-07-04 11:00:00', '2A', 230.00, 'booked'),
(15, 15, 15, '2024-07-05 12:00:00', '6D', 250.00, 'booked'),
(16, 16, 16, '2024-07-06 13:00:00', '11F', 270.00, 'booked'),
(17, 17, 17, '2024-07-07 14:00:00', '17B', 290.00, 'booked'),
(18, 18, 18, '2024-07-08 15:00:00', '19E', 310.00, 'booked'),
(19, 19, 19, '2024-07-09 16:00:00', '21C', 330.00, 'booked'),
(20, 20, 20, '2024-07-10 17:00:00', '22A', 350.00, 'booked');

INSERT INTO crew_members (name, role, contact_info, assigned_flight) VALUES
('Ali Hassan', 'pilot', 'ali.hassan@gmail.com', 1),
('Saba Khan', 'flight_attendant', 'saba.khan@yahoo.com', 2),
('Ahmed Malik', 'ground_staff', 'ahmed.malik@gmail.com', 3),
('Farah Ahmed', 'pilot', 'farah.ahmed@yahoo.com', 4),
('Kashif Khan', 'flight_attendant', 'kashif.khan@gmail.com', 5),
('Ayesha Ali', 'pilot', 'ayesha.ali@yahoo.com', 6),
('Usman Khan', 'flight_attendant', 'usman.khan@gmail.com', 7),
('Sadia Akhtar', 'ground_staff', 'sadia.akhtar@yahoo.com', 8),
('Zainab Ahmed', 'pilot', 'zainab.ahmed@gmail.com', 9),
('Bilal Khan', 'flight_attendant', 'bilal.khan@yahoo.com', 10),
('Sana Aslam', 'pilot', 'sana.aslam@gmail.com', 11),
('Imran Ali', 'flight_attendant', 'imran.ali@yahoo.com', 12),
('Aisha Khan', 'ground_staff', 'aisha.khan@gmail.com', 13),
('Waqar Ahmed', 'pilot', 'waqar.ahmed@yahoo.com', 14),
('Hina Akram', 'flight_attendant', 'hina.akram@gmail.com', 15),
('Amir Khan', 'pilot', 'amir.khan@yahoo.com', 16),
('Nadia Asif', 'flight_attendant', 'nadia.asif@gmail.com', 17),
('Rizwan Malik', 'ground_staff', 'rizwan.malik@yahoo.com', 18),
('Sadaf Ali', 'pilot', 'sadaf.ali@gmail.com', 19),
('Kamran Khan', 'flight_attendant', 'kamran.khan@yahoo.com', 20);

INSERT INTO airplane_inventory (aircraft_id, item, quantity) VALUES
(1, 'Life Jackets', 150),
(2, 'First Aid Kits', 5),
(3, 'Oxygen Masks', 300),
(4, 'Seat Belts', 500),
(5, 'Emergency Lights', 100),
(6, 'Fire Extinguishers', 50),
(7, 'Escape Slides', 400),
(8, 'Life Rafts', 350),
(9, 'Portable Oxygen Bottles', 250),
(10, 'Survival Kits', 200);

INSERT INTO onboard_supplies (item, quantity) VALUES
('Food Packs', 200),
('Water Bottles', 300),
('Blankets', 150),
('Pillows', 180),
('Headphones', 100),
('Magazines', 250),
('Safety Cards', 300),
('Refreshments', 400),
('Amenity Kits', 150),
('Disposable Cups', 500),
('Snack Packs', 180),
('Juice Boxes', 200),
('Sanitizers', 50),
('Hand Wipes', 100),
('Earplugs', 60),
('Eye Masks', 90);

INSERT INTO financial_transactions (transaction_type, amount, description, date) VALUES
('income', 5000.00, 'Ticket Sales', '2023-06-15 10:00:00'),
('expense', 2000.00, 'Fuel Costs', '2023-06-16 11:00:00'),
('income', 3000.00, 'Cargo Services', '2023-06-17 12:00:00'),
('expense', 1500.00, 'Maintenance Costs', '2023-06-18 13:00:00'),
('income', 2500.00, 'Ticket Sales', '2023-06-19 14:00:00'),
('expense', 1000.00, 'Salaries', '2023-06-20 15:00:00'),
('income', 4000.00, 'Ticket Sales', '2023-06-21 16:00:00'),
('expense', 1200.00, 'Airport Fees', '2023-06-22 17:00:00'),
('income', 3500.00, 'Ticket Sales', '2023-06-23 18:00:00'),
('expense', 1800.00, 'Fuel Costs', '2023-06-24 19:00:00'),
('income', 4500.00, 'Ticket Sales', '2023-06-25 20:00:00'),
('expense', 2000.00, 'Ground Services', '2023-06-26 21:00:00'),
('income', 5500.00, 'Ticket Sales', '2023-06-27 22:00:00'),
('expense', 2200.00, 'Crew Salaries', '2023-06-28 23:00:00'),
('income', 3500.00, 'Cargo Services', '2023-06-29 08:00:00'),
('expense', 3000.00, 'Fuel Costs', '2023-06-30 09:00:00'),
('income', 4500.00, 'Ticket Sales', '2023-07-01 10:00:00'),
('expense', 1500.00, 'Airport Fees', '2023-07-02 11:00:00'),
('income', 5000.00, 'Ticket Sales', '2023-07-03 12:00:00'),
('expense', 2500.00, 'Maintenance Costs', '2023-07-04 13:00:00');

INSERT INTO security_compliance (regulation, compliance_status, compliance_date) VALUES
('FAA Regulation 123', 'compliant', '2023-06-14 09:00:00'),
('EASA Regulation 456', 'compliant', '2023-06-14 10:00:00'),
('CAA Regulation 789', 'compliant', '2023-06-15 11:00:00'),
('ICAO Regulation 321', 'compliant', '2023-06-16 12:00:00'),
('IATA Regulation 654', 'compliant', '2023-06-17 13:00:00'),
('FAA Regulation 987', 'compliant', '2023-06-18 14:00:00'),
('EASA Regulation 852', 'compliant', '2023-06-19 15:00:00'),
('CAA Regulation 147', 'compliant', '2023-06-20 16:00:00'),
('ICAO Regulation 258', 'compliant', '2023-06-21 17:00:00'),
('IATA Regulation 369', 'compliant', '2023-06-22 18:00:00'),
('FAA Regulation 112', 'compliant', '2023-06-23 09:00:00'),
('EASA Regulation 334', 'compliant', '2023-06-24 10:00:00'),
('CAA Regulation 556', 'compliant', '2023-06-25 11:00:00'),
('ICAO Regulation 778', 'compliant', '2023-06-26 12:00:00'),
('IATA Regulation 990', 'compliant', '2023-06-27 13:00:00'),
('FAA Regulation 223', 'compliant', '2023-06-28 14:00:00'),
('EASA Regulation 445', 'compliant', '2023-06-29 15:00:00'),
('CAA Regulation 667', 'compliant', '2023-06-30 16:00:00'),
('ICAO Regulation 889', 'compliant', '2023-07-01 17:00:00'),
('IATA Regulation 991', 'compliant', '2023-07-02 18:00:00');

INSERT INTO airports (airport_name, location) VALUES
('Islamabad International Airport', 'Islamabad, Pakistan'),
('Jinnah International Airport', 'Karachi, Pakistan'),
('Sialkot International Airport', 'Sialkot, Pakistan'),
('Allama Iqbal International Airport', 'Lahore, Pakistan'),
('Bacha Khan International Airport', 'Peshawar, Pakistan'),
('Quetta International Airport', 'Quetta, Pakistan'),
('Multan International Airport', 'Multan, Pakistan'),
('Faisalabad International Airport', 'Faisalabad, Pakistan'),
('Los Angeles International Airport', 'Los Angeles, CA'),
('John F. Kennedy International Airport', 'New York, NY'),
('Las Vegas McCarran International Airport', 'Las Vegas, NV'),
('Boston Logan International Airport', 'Boston, MA'),
('Seattle-Tacoma International Airport', 'Seattle, WA'),
('Hartsfield-Jackson Atlanta International Airport', 'Atlanta, GA'),
('Denver International Airport', 'Denver, CO'),
('Phoenix Sky Harbor International Airport', 'Phoenix, AZ'),
('Philadelphia International Airport', 'Philadelphia, PA'),
('Minneapolis-Saint Paul International Airport', 'Minneapolis, MN'),
('Portland International Airport', 'Portland, OR'),
('Charlotte Douglas International Airport', 'Charlotte, NC'),
('Detroit Metropolitan Airport', 'Detroit, MI'),
('San Diego International Airport', 'San Diego, CA');

INSERT INTO runways (runway_code, length, airport_id) VALUES
('ISB-1', 12000, 1),
('KHI-1', 11000, 2),
('LHE-1', 11000, 3),
('PEW-1', 9000, 4),
('UET-1', 9000, 5),
('MUX-1', 10000, 6),
('LYP-1', 10000, 7),
('SKT-1', 10000, 8),
('LAX-1', 12000, 9),
('JFK-1', 14500, 10),
('LHR-1', 12799, 11),
('CDG-1', 13523, 12),
('FRA-1', 13123, 13),
('AMS-1', 12467, 14),
('MAD-1', 14000, 15),
('BCN-1', 12700, 16),
('VIE-1', 11810, 17),
('ZRH-1', 12138, 18),
('BRU-1', 11711, 19),
('MUC-1', 13000, 20);

INSERT INTO seats (seat_number, class, status) VALUES
('1A', 'first', 'available'),
('12C', 'economy', 'available'),
('5D', 'business', 'occupied'),
('7F', 'economy', 'occupied'),
('10B', 'economy', 'available'),
('15E', 'economy', 'available'),
('20C', 'business', 'occupied'),
('3A', 'first', 'occupied'),
('8D', 'economy', 'available'),
('9F', 'economy', 'occupied'),
('12B', 'business', 'available'),
('14E', 'economy', 'available'),
('18C', 'economy', 'occupied'),
('2A', 'first', 'available'),
('6D', 'economy', 'occupied'),
('11F', 'business', 'available'),
('17B', 'economy', 'available'),
('19E', 'economy', 'occupied'),
('21C', 'business', 'available'),
('22A', 'first', 'occupied');

INSERT INTO maintenance (aircraft_id, description, maintenance_date) VALUES
(1, 'Engine check', '2024-06-20 10:00:00'),
(2, 'Landing gear inspection', '2024-06-21 11:00:00'),
(3, 'Cabin pressure test', '2024-06-22 12:00:00'),
(4, 'Avionics upgrade', '2024-06-23 13:00:00'),
(5, 'Engine check', '2024-06-24 14:00:00'),
(6, 'Landing gear inspection', '2024-06-25 15:00:00'),
(7, 'Cabin pressure test', '2024-06-26 16:00:00'),
(8, 'Avionics upgrade', '2024-06-27 17:00:00'),
(9, 'Engine check', '2024-06-28 18:00:00'),
(10, 'Landing gear inspection', '2024-06-29 19:00:00'),
(11, 'Cabin pressure test', '2024-06-30 10:00:00'),
(12, 'Avionics upgrade', '2024-07-01 11:00:00'),
(13, 'Engine check', '2024-07-02 12:00:00'),
(14, 'Landing gear inspection', '2024-07-03 13:00:00'),
(15, 'Cabin pressure test', '2024-07-04 14:00:00'),
(16, 'Avionics upgrade', '2024-07-05 15:00:00'),
(17, 'Engine check', '2024-07-06 16:00:00'),
(18, 'Landing gear inspection', '2024-07-07 17:00:00'),
(19, 'Cabin pressure test', '2024-07-08 18:00:00'),
(20, 'Avionics upgrade', '2024-07-09 19:00:00');

INSERT INTO payments (reservation_id,passenger_id,amount, payment_date, payment_method) VALUES
(1, 1, 199.99, '2024-06-21 12:00:00', 'credit_card'),
(2, 2, 149.99, '2024-06-21 14:30:00', 'debit_card'),
(3, 3, 179.99, '2024-06-22 10:45:00', 'credit_card'),
(4, 4, 159.99, '2024-05-22 16:00:00', 'cash'),
(5, 5, 189.99, '2024-06-23 08:15:00', 'credit_card'),
(6, 6, 169.99, '2024-06-23 13:30:00', 'debit_card'),
(7, 7, 209.99, '2024-06-24 09:00:00', 'credit_card'),
(8, 8, 199.99, '2024-04-24 15:45:00', 'cash'),
(9, 9, 179.99, '2024-06-20 11:20:00', 'credit_card'),
(10, 10, 189.99, '2024-06-05 14:00:00', 'debit_card'),
(11, 11, 179.99, '2024-06-24 10:00:00', 'credit_card'),
(12, 12, 159.99, '2024-03-23 16:30:00', 'cash'),
(13, 13, 169.99, '2024-06-22 12:15:00', 'credit_card'),
(14, 14, 199.99, '2024-06-27 18:45:00', 'debit_card'),
(15, 15, 189.99, '2024-02-28 08:30:00', 'credit_card'),
(16, 16, 209.99, '2024-06-28 14:00:00', 'cash'),
(17, 17, 179.99, '2024-06-29 09:45:00', 'credit_card'),
(18, 18, 159.99, '2024-06-29 17:00:00', 'debit_card'),
(19, 19, 199.99, '2024-06-30 11:30:00', 'credit_card'),
(20, 20, 169.99, '2024-06-30 15:45:00', 'cash');

INSERT INTO flight_schedule (flight_id, departure_time, arrival_time) VALUES
(1, '2024-06-25 14:00:00', '2024-06-25 18:00:00'),
(1, '2024-06-25 14:00:00', '2024-06-25 18:00:00'),
(2, '2024-06-26 08:30:00', '2024-06-26 12:30:00'),
(3, '2024-06-27 10:00:00', '2024-06-27 13:30:00'),
(4, '2024-06-28 11:15:00', '2024-06-28 15:30:00'),
(5, '2024-06-29 13:45:00', '2024-06-29 18:00:00'),
(6, '2024-06-30 07:00:00', '2024-06-30 11:00:00'),
(7, '2024-07-01 09:30:00', '2024-07-01 13:00:00'),
(8, '2024-07-02 12:00:00', '2024-07-02 16:15:00'),
(9, '2024-07-03 14:45:00', '2024-07-03 18:45:00'),
(10, '2024-07-04 08:15:00', '2024-07-04 12:00:00'),
(11, '2024-07-05 11:30:00', '2024-07-05 15:30:00'),
(12, '2024-07-06 09:00:00', '2024-07-06 13:00:00'),
(13, '2024-07-07 10:45:00', '2024-07-07 14:30:00'),
(14, '2024-07-08 12:15:00', '2024-07-08 16:45:00'),
(15, '2024-07-09 14:00:00', '2024-07-09 18:30:00'),
(16, '2024-07-10 07:30:00', '2024-07-10 11:15:00'),
(17, '2024-07-11 09:45:00', '2024-07-11 13:45:00'),
(18, '2024-07-12 12:30:00', '2024-07-12 16:00:00'),
(19, '2024-07-13 15:00:00', '2024-07-13 19:00:00'),
(20, '2024-07-14 08:45:00', '2024-07-14 12:45:00');


DELIMITER $$
CREATE PROCEDURE AddPassenger(
    IN p_name VARCHAR(255),
    IN p_contact_info VARCHAR(255),
    IN p_loyalty_program_id INT,
    IN p_travel_history TEXT)
BEGIN
    INSERT INTO passengers (name, contact_info, loyalty_program_id, travel_history)
    VALUES (p_name, p_contact_info, p_loyalty_program_id, p_travel_history);
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE UpdatePassenger(
    IN p_passenger_id INT,
    IN p_name VARCHAR(255),
    IN p_contact_info VARCHAR(255),
    IN p_loyalty_program_id INT,
    IN p_travel_history TEXT)
BEGIN
    UPDATE passengers
    SET name = p_name,
        contact_info = p_contact_info,
        loyalty_program_id = p_loyalty_program_id,
        travel_history = p_travel_history
    WHERE passenger_id = p_passenger_id;
END $$
DELIMITER ;


DELIMITER $$ 
CREATE PROCEDURE DeletePassenger(IN p_passenger_id INT)
BEGIN
    DELETE FROM passengers WHERE passenger_id = p_passenger_id;
END $$ 
DELIMITER ;


DELIMITER $$
CREATE TRIGGER UpdateTravelHistory
AFTER INSERT ON reservations
FOR EACH ROW
BEGIN
    DECLARE travel_entry TEXT;
    SET travel_entry = CONCAT(NEW.reservation_date, ': Flight ', NEW.flight_id);
    UPDATE passengers
    SET travel_history = CONCAT(travel_history, ',', travel_entry)
    WHERE passenger_id = NEW.passenger_id;
END $$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER LogFinancialTransaction
AFTER INSERT ON reservations
FOR EACH ROW
BEGIN
    INSERT INTO financial_transactions (transaction_type, amount, description, date)
    VALUES ('income', NEW.fare, CONCAT('Ticket Sale: Flight ', NEW.flight_id), NEW.reservation_date);
END $$
DELIMITER ;

INSERT INTO reservations (passenger_id, flight_id, reservation_date, seat_number, fare, ticket_status)
VALUES (1, 1, '2024-07-01 12:00:00', '1A', 350.00, 'booked');


SELECT travel_history FROM passengers WHERE passenger_id = 1;

SELECT * FROM financial_transactions;
