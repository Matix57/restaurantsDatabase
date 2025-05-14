-- Insert data into Address
INSERT INTO Address (AddressID, Country, ZipCode, City, StreetAddress, BuildingNumber) VALUES
(1, 'Poland', '30-059', 'Krakow', 'Rynek Główny', '1'),
(2, 'Poland', '00-001', 'Warsaw', 'Aleje Jerozolimskie', '1'),
(3, 'Poland', '80-800', 'Gdansk', 'Długa', '1'),
(4, 'Poland', '31-001', 'Krakow', 'Floriańska', '15'),
(5, 'Poland', '30-063', 'Krakow', 'Jana Pawła II', '2'),
(6, 'USA', '90210', 'Beverly Hills', 'Rodeo Drive', '100'),
(7, 'UK', 'SW1A 2AA', 'London', 'Buckingham Palace', '1');

-- Insert data into Person
INSERT INTO Person (PersonID, FirstName, LastName, DateOfBirth, AddressID) VALUES
(1, 'Jan', 'Kowalski', '1980-05-15', 1),
(2, 'Anna', 'Nowak', '1990-11-20', 2),
(3, 'Piotr', 'Wojciechowski', '1985-03-10', 3),
(4, 'Maria', 'Lewandowska', '1995-07-05', 4),
(5, 'Kamil', 'Stoch', '1986-06-25', 5),
(6, 'John', 'Smith', '1970-01-01', 6),
(7, 'Elizabeth', 'Windsor', '1926-04-21', 7);


-- Insert data into Employee
INSERT INTO Employee (PersonID, EmployeeID, NationalID, HireDate) VALUES
(1, 101, '12345678901', '2010-01-01'),
(2, 102, '98765432109', '2015-05-10'),
(3, 103, '55555555555', '2020-09-15'),
(4, 104, '11111111111', '2018-02-20');


-- Insert data into EmployeeLeave
INSERT INTO EmployeeLeave (EmployeeID, StartDate, EndDate, LeaveType) VALUES
(101, '2023-07-01', '2023-07-10', 'Vacation'),
(102, '2023-08-15', NULL, 'Sick Leave'); -- Employee hasn't returned back yet

-- Insert data into JobPosition
INSERT INTO JobPosition (JobID, Title, SalaryRangeMax, SalaryRangeMin, Description) VALUES
(1, 'Manager', 10000.00, 7000.00, 'Restaurant Manager'),
(2, 'Chef', 8000.00, 5000.00, 'Head Chef'),
(3, 'Waiter', 4000.00, 2500.00, 'Restaurant Waiter'),
(4, 'Cook', 6000.00, 4000.00, 'Restaurant Cook');

-- Insert data into Restaurant
INSERT INTO Restaurant (RestaurantID, Name, AddressID, IsActive) VALUES
(1, 'Wawel Restaurant', 1, 1),
(2, 'Royal Castle Restaurant', 2, 1),
(3, 'Neptun Restaurant', 3, 0), -- Example of an inactive restaurant
(4, 'Pierogi Masters', 4, 1);

-- Insert data into EmployeePosition
INSERT INTO EmployeePosition (EmployeeID, JobID, RestaurantID, StartDate, EndDate, Salary) VALUES
(101, 1, 1, '2020-01-01', NULL, 8000.00),  -- Current, Employee 101
(102, 2, 1, '2015-06-01', NULL, 6000.00),  -- Current, Employee 102
(103, 3, 2, '2020-10-01', NULL, 3000.00),  -- Current, Employee 103
(104, 4, 4, '2018-03-01', NULL, 5000.00),  -- Current, Employee 104
(101, 2, 2, '2018-06-01', '2019-12-31', 7000.00),  -- Past, Employee 101
(102, 3, 3, '2013-01-01', '2015-05-31', 5500.00);  -- Past, Employee 102

-- Insert data into SalaryPayment
INSERT INTO SalaryPayment (PaymentID, EmployeeID, PaymentDate, Amount, BonusAmount) VALUES
(1, 101, '2023-07-15', 8000.00, 1000.00),
(2, 102, '2023-07-15', 6000.00, 0.00),
(3, 103, '2023-07-15', 3000.00, 500.00),
(4, 102, '2023-07-15', 5000.00, 200.00),
(5, 101, '2023-08-15', 8000.00, 0.00); 

-- Insert data into EmployeeShift (including future shifts relative to 2025)
INSERT INTO EmployeeShift (ShiftID, EmployeeID, RestaurantID, StartTime, EndTime) VALUES
(1, 101, 1, '2025-07-20 10:00', '2025-07-20 18:00'),
(2, 102, 1, '2025-07-20 12:00', '2025-07-20 20:00'),
(3, 103, 2, '2025-07-20 11:00', '2025-07-20 19:00'),
(4, 101, 1, '2025-07-27 14:00', '2025-07-27 22:00'),  
(5, 102, 1, '2025-07-28 09:00', '2025-07-28 17:00'),  
(6, 103, 2, '2025-07-29 16:00', '2025-07-30 00:00'),  
(7, 101, 2, '2025-08-01 11:00', '2025-08-01 19:00');

-- Insert data into MenuItem
INSERT INTO MenuItem (ItemID, Name, Description, Price, RewardPoints, IsActive) VALUES
(1, 'Pierogi', 'Traditional Polish dumplings', 25.00, 5, 1),
(2, 'Stek', 'Grilled beef steak', 50.00, 10, 1),
(3, 'Pizza', 'Italian pizza', 30.00, 6, 1),
(4, 'Salad', 'Fresh green salad', 15.00, 3, 1),
(5, 'Spaghetti Carbonara', 'Pasta with bacon and eggs', 40.00, 8, 1),
(6, 'Sushi Platter', 'Assorted sushi rolls', 60.00, 12, 1),
(7, 'Chicken Curry', 'Indian chicken curry', 35.00, 7, 1),
(8, 'Vegetarian Burger', 'Plant-based burger', 20.00, 4, 0), -- Inactive Item
(9, 'Chocolate Cake', 'Delicious chocolate dessert', 25.00, 5, 1),
(10, 'Ice Cream', 'Various flavors', 10.00, 2, 1);

-- Insert data into Ingredient
INSERT INTO Ingredient (IngredientID, Name, CaloriesPerUnit, UnitPrice, IsAllergen) VALUES
(1, 'Flour', 350, 5.00, 0),
(2, 'Beef', 250, 20.00, 0),
(3, 'Cheese', 400, 15.00, 1),
(4, 'Tomatoes', 20, 3.00, 0),
(5, 'Pasta', 200, 4.00, 0),
(6, 'Bacon', 500, 12.00, 0),
(7, 'Eggs', 80, 2.00, 0),
(8, 'Rice', 150, 3.00, 0),
(9, 'Chicken', 200, 10.00, 0),
(10, 'Vegetable Patty', 180, 8.00, 0),
(11, 'Chocolate', 550, 25.00, 0),
(12, 'Milk', 100, 2.50, 1);

-- Insert data into MenuItemRecipe
INSERT INTO MenuItemRecipe (ItemID, IngredientID, Quantity) VALUES
(1, 1, 100.00), -- Pierogi: Flour
(1, 2, 20.00),  -- Pierogi: Beef
(2, 2, 200.00), -- Stek: Beef
(3, 1, 150.00), -- Pizza: Flour
(3, 3, 100.00), -- Pizza: Cheese
(4, 4, 150.00), -- Salad: Tomatoes
(5, 5, 200.00), -- Spaghetti Carbonara: Pasta
(5, 6, 50.00),  -- Spaghetti Carbonara: Bacon
(5, 7, 2.00),   -- Spaghetti Carbonara: Eggs
(6, 8, 100.00), -- Sushi Platter: Rice
(7, 8, 150.00), -- Chicken Curry: Rice
(7, 9, 150.00), -- Chicken Curry: Chicken
(8, 10, 1.00),  -- Vegetarian Burger: Vegetable Patty
(9, 11, 100.00), -- Chocolate Cake: Chocolate
(9, 1, 50.00),  -- Chocolate Cake: Flour
(9, 12, 100.00), -- Chocolate Cake: Milk
(10, 12, 100.00); -- Ice Cream: Milk

-- Insert data into CustomerTransaction
INSERT INTO CustomerTransaction (TransactionID, RestaurantID, TransactionDate) VALUES
(1, 1, '2023-07-20 13:00'),
(2, 1, '2023-07-20 19:30'),
(3, 2, '2023-07-20 14:45'),
(4, 1, '2023-07-21 12:15'),
(5, 2, '2023-07-21 18:00'),
(6, 3, '2023-07-22 15:30'),
(7, 1, '2023-07-22 20:45'),
(8, 2, '2023-07-23 11:00'),
(9, 4, '2023-07-23 17:20');

-- Insert data into TransactionDetail
INSERT INTO TransactionDetail (TransactionID, ItemID, Quantity, DiscountAmount) VALUES
(1, 1, 2, 0.00),
(1, 2, 1, 10.00),
(2, 1, 3, 0.00),
(3, 3, 1, 0.00),
(3, 4, 1, 0.00),
(4, 5, 1, 0.00),
(4, 6, 1, 5.00),
(5, 2, 1, 0.00),
(5, 7, 2, 0.00),
(6, 3, 2, 0.00),
(6, 8, 1, 0.00),
(7, 1, 4, 0.00),
(7, 9, 1, 2.00),
(8, 10, 3, 0.00),
(9, 4, 2, 0.00),
(9, 8, 1, 0.00);

-- Insert data into Customer
INSERT INTO Customer (PersonID, CustomerID, Username, JoinDate) VALUES
(5, 201, 'kamil.stoch', '2023-01-01'),
(6, 202, 'john.smith', '2023-02-15'),
(7, 203, 'queen.elizabeth', '2023-03-20');

-- Insert data into CustomerRewardLog
INSERT INTO CustomerRewardLog (LogID, CustomerID, TransactionID, Points, LogDate, SourceType, PointsBalance) VALUES
(1, 201, 1, 10, '2023-07-20 13:00', 'Purchase', 10),
(2, 201, 2, 15, '2023-07-20 19:30', 'Purchase', 25),
(3, 202, 3, 6, '2023-07-20 14:45', 'Purchase', 6),
(4, 202, NULL, 5, '2023-07-21 10:00', 'Promotion', 11),
(5, 201, NULL, -20, '2023-07-22 09:00', 'Redemption', 5),  -- Redeemed Free Dessert (20 points)
(6, 203, NULL, 20, '2023-07-23 14:00', 'Referral', 20),
(7, 202, NULL, -3, '2023-07-24 11:30', 'Adjustment', 8),
(8, 201, 4, 8, '2023-07-24 15:00', 'Purchase', 13),   
(9, 201, 5, 10, '2023-07-25 16:00', 'Purchase', 23),   
(10, 202, 6, 12, '2023-07-26 17:00', 'Purchase', 20),  
(11, 202, 7, 10, '2023-07-27 18:00', 'Purchase', 30),  
(12, 203, 8, 6, '2023-07-28 19:00', 'Purchase', 26),  
(13, 203, 9, 4, '2023-07-29 20:00', 'Purchase', 30);  


-- Insert data into RewardPrize
INSERT INTO RewardPrize (PrizeID, Name, Description, RequiredPoints, IsActive) VALUES
(1, 'Free Dessert', 'Any dessert from the menu', 20, 1),
(2, '10% off next meal', 'Discount on the entire bill', 30, 1),
(3, 'Free Appetizer', 'Choice of appetizer', 15, 1);

-- Insert data into PrizeRedemption
INSERT INTO PrizeRedemption (RedemptionID, CustomerID, TransactionID, PrizeID, RedemptionDate) VALUES
(1, 201, NULL, 1, '2023-07-22 15:00'); -- Redeemed Free Dessert (PrizeID 1, requires 20 points)


-- Insert data into Supplier
INSERT INTO Supplier (SupplierID, Name, ContactInfo, AddressID) VALUES
(1, 'Meat Masters', 'info@meatmasters.com', 1),
(2, 'Flour Power', 'sales@flourpower.com', 2),
(3, 'Dairy Delights', 'order@dairydelights.com', 3);


-- Insert data into Inventory
INSERT INTO Inventory (InventoryID, RestaurantID, IngredientID, Quantity, LastUpdated) VALUES
(1, 1, 1, 500.00, '2023-07-20'), -- 500kg of flour
(2, 1, 2, 200.00, '2023-07-20'), -- 200kg of beef
(3, 1, 3, 300.00, '2023-07-20'), -- 300kg of cheese
(4, 1, 4, 400.00, '2023-07-20'), -- 400kg of tomatoes
(5, 2, 1, 250.00, '2023-07-20'),
(6, 2, 3, 150.00, '2023-07-20');

INSERT INTO Feedback (FeedbackID, CustomerID, RestaurantID, TransactionID, Comment, Rating, DateSubmitted) VALUES
(1, 201, 1, 1, 'Excellent food and service!', 5, '2023-07-20'),
(2, 202, 1, 2, 'The pierogi were delicious.', 4, '2023-07-20'),
(3, 201, 2, 3, 'Great atmosphere.', 4, '2023-07-20'),
(4, 203, 1, 1, 'A bit pricey but worth it.', 4, '2023-07-21');

INSERT INTO RestaurantReservation (ReservationID, RestaurantID, CustomerID, ReservationDate, NumberOfPeople, SpecialRequests) VALUES
(1, 1, 201, '2023-07-15 19:30:00', 4, 'Window seat, Vegan menu if available'),
(2, 2, 202, '2023-08-20 20:00:00', 2, 'Birthday celebration'),
(3, 4, 203, '2023-09-05 18:45:00', 5, NULL);

INSERT INTO EmployeeTraining (EmployeeID, CourseName, TrainingDate, CompletionStatus, CertificationDetails) VALUES
(101, 'Food Safety Training', '2022-06-15', 'Completed', 'Basic Food Safety'),
(102, 'Customer Service Training', '2023-01-10', 'Completed', 'Excellence in Customer Service'),
(103, 'Restaurant Management Bootcamp', '2021-11-05', 'In Progress', 'Management Foundations');

INSERT INTO Certificates (TrainingID, CertificateName, IssueDate, ExpiryDate) VALUES
(1, 'Food Safety Certificate', '2022-06-20', '2025-06-20'),
(2, 'Customer Service Excellence Award', '2023-01-15', NULL),
(1, 'Advanced Food Handling Certificate', '2023-03-01', '2026-03-01');