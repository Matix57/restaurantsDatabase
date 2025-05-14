-- Create the database 
CREATE DATABASE SiecRestauracji;
GO

USE SiecRestauracji;
GO

CREATE TABLE Address (
    -- Stores location information for both people and restaurants
    AddressID INT PRIMARY KEY,
    Country NVARCHAR(50) NOT NULL,
    ZipCode NVARCHAR(20) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    StreetAddress NVARCHAR(200),      
    BuildingNumber NVARCHAR(20), 
    CONSTRAINT CHK_ZipCode CHECK (LEN(ZipCode) >= 3)
);

-- Stores basic information about any individual in the system (employees, customers)
CREATE TABLE Person (
    PersonID INT PRIMARY KEY,
    FirstName NVARCHAR(100) NOT NULL,
    LastName NVARCHAR(100) NOT NULL,
    DateOfBirth DATE NOT NULL,
    AddressID INT,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID),
    CONSTRAINT CHK_DateOfBirth CHECK (DateOfBirth <= GETDATE())
);

-- Employee management tables
CREATE TABLE Employee (
    -- Links person records to employee-specific information
    PersonID INT PRIMARY KEY,
    EmployeeID INT UNIQUE NOT NULL,    -- Internal employee identifier
    NationalID CHAR(11) UNIQUE NOT NULL,
    HireDate DATE NOT NULL,
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
    CONSTRAINT CHK_HireDate CHECK (HireDate <= GETDATE())
);

-- Tracks all types of employee time off (sick leave, vacation, etc.)
CREATE TABLE EmployeeLeave (
    LeaveID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT,
    StartDate DATE NOT NULL,
    EndDate DATE,    -- NULL indicates ongoing leave
    LeaveType VARCHAR(20) NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    CONSTRAINT CHK_LeaveDates CHECK (EndDate IS NULL OR EndDate >= StartDate)
);

-- Defines available job positions and their salary ranges
CREATE TABLE JobPosition (
    JobID INT PRIMARY KEY,
    Title NVARCHAR(100) NOT NULL,
    SalaryRangeMax DECIMAL(10, 2) NOT NULL,
    SalaryRangeMin DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(MAX),
    CONSTRAINT CHK_SalaryRange CHECK (SalaryRangeMax >= SalaryRangeMin)
);

-- Stores information about restaurant locations
CREATE TABLE Restaurant (
    RestaurantID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    AddressID INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,    -- Allows soft deletion of restaurants
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

 -- Tracks employee job assignments and history
CREATE TABLE EmployeePosition (
    EmployeeID INT,
    JobID INT,
    RestaurantID INT,
    StartDate DATE NOT NULL,
    EndDate DATE,    -- NULL indicates current position
    Salary DECIMAL(10, 2) NOT NULL,
    PRIMARY KEY (EmployeeID, JobID, RestaurantID, StartDate),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (JobID) REFERENCES JobPosition(JobID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
    CONSTRAINT CHK_PositionDates CHECK (EndDate IS NULL OR EndDate >= StartDate),
    CONSTRAINT CHK_PositionSalary CHECK (Salary > 0)
);

-- Records all salary payments including bonuses
CREATE TABLE SalaryPayment (
    PaymentID INT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    PaymentDate DATE NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,    -- Base salary payment
    BonusAmount DECIMAL(10, 2),        -- Additional performance or incentive payments
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    CONSTRAINT CHK_PaymentAmount CHECK (Amount > 0)
);

-- Records past and future employee shifts
CREATE TABLE EmployeeShift (
    ShiftID INT PRIMARY KEY,
    EmployeeID INT NOT NULL,
    RestaurantID INT NOT NULL,
    StartTime DATETIME NOT NULL,
    EndTime DATETIME NOT NULL,
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
    CONSTRAINT CHK_ShiftTime CHECK (EndTime > StartTime)
);

-- Defines items available for purchase
CREATE TABLE MenuItem (
    ItemID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    Price DECIMAL(10, 2) NOT NULL,
    RewardPoints INT DEFAULT 0,
    IsActive BIT NOT NULL DEFAULT 1,    -- Allows seasonal or discontinued items
    CONSTRAINT CHK_ItemPrice CHECK (Price > 0),
    CONSTRAINT CHK_RewardPoints CHECK (RewardPoints >= 0)
);

-- Tracks ingredients used in menu items
CREATE TABLE Ingredient (
    IngredientID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    CaloriesPerUnit INT NOT NULL,
    UnitPrice DECIMAL(10, 2) NOT NULL,
    IsAllergen BIT NOT NULL DEFAULT 0,
    CONSTRAINT CHK_Calories CHECK (CaloriesPerUnit >= 0),
    CONSTRAINT CHK_UnitPrice CHECK (UnitPrice > 0)
);

-- Links menu items to their required ingredients
CREATE TABLE MenuItemRecipe (
    ItemID INT,
    IngredientID INT,
    Quantity DECIMAL(10, 2) NOT NULL,  
    PRIMARY KEY (ItemID, IngredientID),
    FOREIGN KEY (ItemID) REFERENCES MenuItem(ItemID),
    FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID),
    CONSTRAINT CHK_Quantity CHECK (Quantity > 0)
);

-- Records customer purchases
CREATE TABLE CustomerTransaction (
    TransactionID INT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    TransactionDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);

-- Stores individual items within each transaction
CREATE TABLE TransactionDetail (
    TransactionID INT,
    ItemID INT,
    Quantity INT NOT NULL,
    DiscountAmount DECIMAL(10, 2) DEFAULT 0,    -- Per-item discount
    PRIMARY KEY (TransactionID, ItemID),
    FOREIGN KEY (TransactionID) REFERENCES CustomerTransaction(TransactionID),
    FOREIGN KEY (ItemID) REFERENCES MenuItem(ItemID),
    CONSTRAINT CHK_TranQuantity CHECK (Quantity > 0),
    CONSTRAINT CHK_DiscountAmount CHECK (DiscountAmount >= 0)
);

-- Links person records to customer-specific information
CREATE TABLE Customer (
    PersonID INT PRIMARY KEY,
    CustomerID INT UNIQUE NOT NULL,    -- Internal customer identifier
    Username NVARCHAR(50) NOT NULL UNIQUE,
    JoinDate DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (PersonID) REFERENCES Person(PersonID)
);

-- Tracks all point earnings and deductions
CREATE TABLE CustomerRewardLog (
    LogID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    TransactionID INT NULL,    -- NULL for non-transaction point adjustments
    Points INT NOT NULL,    -- Positive for earnings, negative for redemptions
    LogDate DATETIME NOT NULL DEFAULT GETDATE(),
    SourceType NVARCHAR(50) NOT NULL,    -- e.g., 'Purchase', 'Promotion', 'Redemption'
    PointsBalance INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (TransactionID) REFERENCES CustomerTransaction(TransactionID),
    CONSTRAINT CHK_Points CHECK (Points != 0)
);

-- Defines available rewards for point redemption
CREATE TABLE RewardPrize (
    PrizeID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Description NVARCHAR(MAX),
    RequiredPoints INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,    -- Allows prizes to be discontinued
    CONSTRAINT CHK_RequiredPoints CHECK (RequiredPoints > 0)
);

-- Records when customers redeem points for prizes
CREATE TABLE PrizeRedemption (
    RedemptionID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    TransactionID INT NULL,
    PrizeID INT NOT NULL,
    RedemptionDate DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (PrizeID) REFERENCES RewardPrize(PrizeID),
    FOREIGN KEY (TransactionID) REFERENCES CustomerTransaction(TransactionID)
);

-- Supplier Table
CREATE TABLE Supplier (
    SupplierID INT PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    ContactInfo NVARCHAR(200),
    AddressID INT,
    FOREIGN KEY (AddressID) REFERENCES Address(AddressID)
);

-- Tracks inventory of each item per restraunt
CREATE TABLE Inventory (
    InventoryID INT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    IngredientID INT NOT NULL,
    Quantity DECIMAL(10, 2) NOT NULL,
    LastUpdated DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
    FOREIGN KEY (IngredientID) REFERENCES Ingredient(IngredientID),
    CONSTRAINT CHK_InventoryQuantity CHECK (Quantity >= 0)
);

-- Tracks customer feedback
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY,
    CustomerID INT NOT NULL,
    RestaurantID INT NOT NULL,
    TransactionID INT NOT NULL, -- Feedback must be linked with transaction
    Comment NVARCHAR(MAX),
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    DateSubmitted DATE NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
    FOREIGN KEY (TransactionID) REFERENCES CustomerTransaction(TransactionID)
);

-- Stores reservations for restraunts
CREATE TABLE RestaurantReservation (
    ReservationID INT PRIMARY KEY,
    RestaurantID INT NOT NULL,
    CustomerID INT NOT NULL,
    ReservationDate DATETIME NOT NULL,
    NumberOfPeople INT NOT NULL,
    SpecialRequests NVARCHAR(MAX),
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE(),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    CONSTRAINT CHK_NumberOfPeople CHECK (NumberOfPeople > 0)
);

-- Keeps a log of employee training
CREATE TABLE EmployeeTraining (
    TrainingID INT PRIMARY KEY IDENTITY(1,1),
    EmployeeID INT NOT NULL,
    CourseName NVARCHAR(200) NOT NULL,
    TrainingDate DATE NOT NULL,
    CompletionStatus NVARCHAR(50) NOT NULL, -- e.g., 'Completed', 'In Progress', 'Failed'
    CertificationDetails NVARCHAR(200) NULL, -- Optional extra details of the training or certification
    CONSTRAINT CHK_TrainingDate CHECK (TrainingDate <= GETDATE()),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);
-- Certificates table definition
CREATE TABLE Certificates (
    CertificateID INT PRIMARY KEY IDENTITY(1,1),
    TrainingID INT NOT NULL, -- Links certificate to a training record
    CertificateName NVARCHAR(200) NOT NULL,
    IssueDate DATE NOT NULL,
    ExpiryDate DATE NULL, -- If NULL, certificate does not expire
    CONSTRAINT CHK_CertificateDates CHECK (ExpiryDate IS NULL OR ExpiryDate > IssueDate),
    FOREIGN KEY (TrainingID) REFERENCES EmployeeTraining(TrainingID)
);