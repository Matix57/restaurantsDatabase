GO

-- Gives a full view of customers including current points balance
CREATE VIEW vw_CustomerFullInfo AS
SELECT 
    P.PersonID,
    P.FirstName, 
    P.LastName, 
    P.DateOfBirth,
    C.CustomerID, 
    C.Username, 
    C.JoinDate,
    ISNULL((SELECT TOP 1 PointsBalance
            FROM CustomerRewardLog
            WHERE CustomerID = C.CustomerID
            ORDER BY LogDate DESC), 0) AS CurrentPointsBalance,
    A.AddressID,
    A.Country, 
    A.ZipCode, 
    A.City, 
    A.StreetAddress, 
    A.BuildingNumber
FROM Person P
JOIN Customer C ON C.PersonID = P.PersonID
JOIN Address A ON A.AddressID = P.AddressID;
GO

-- Employee Full Info View including next shift and current position
CREATE VIEW vw_EmployeeFullInfo AS
WITH EmployeeShiftInfo AS ( -- Retrieves next shift
    SELECT ES.EmployeeID,
           ES.StartTime,
           ROW_NUMBER() OVER (PARTITION BY ES.EmployeeID ORDER BY ES.StartTime) AS ShiftRank  -- Rank by StartTime
    FROM EmployeeShift ES
    WHERE ES.StartTime >= GETDATE()  -- Filter for future start times
),
EmployeePositionInfo AS ( -- Retrieves current position
    SELECT EP.EmployeeID,
           EP.RestaurantID,
           EP.JobID,
           EP.Salary,
           ROW_NUMBER() OVER (PARTITION BY EP.EmployeeID ORDER BY EP.StartDate DESC) AS PositionRank
    FROM EmployeePosition EP
)
SELECT 
    P.PersonID,
    P.FirstName, 
    P.LastName, 
    P.DateOfBirth,
    P.AddressID,
    E.EmployeeID,
    E.NationalID,
    E.HireDate,
    ESI.StartTime AS NearestShiftStartTime,
    EPI.RestaurantID AS CurrentRestaurantID,
    EPI.JobID AS CurrentJobID,
    JP.Title AS CurrentJobTitle,
    EPI.Salary AS CurrentSalary
FROM Person P
JOIN Employee E ON E.PersonID = P.PersonID
LEFT JOIN EmployeeShiftInfo ESI ON ESI.EmployeeID = E.EmployeeID AND ESI.ShiftRank = 1
LEFT JOIN EmployeePositionInfo EPI ON EPI.EmployeeID = E.EmployeeID AND EPI.PositionRank = 1
LEFT JOIN JobPosition JP ON EPI.JobID = JP.JobID;
GO

-- Feedback by Restaurant View - Shows max, min and avg rating
CREATE VIEW vw_FeedbackByRestaurant AS
SELECT 
    R.RestaurantID, 
    R.Name, 
    COUNT(*) AS NumberOfFeedbacks, 
    AVG(CAST(F.Rating AS MONEY)) AS AverageRating, 
    MIN(F.Rating) AS LowestRating, 
    MAX(F.Rating) AS HighestRating 
FROM Feedback F
JOIN Restaurant R ON R.RestaurantID = F.RestaurantID
GROUP BY R.RestaurantID, R.Name;
GO

-- Feedback by Recipe View - Shows max, min and avg rating
CREATE VIEW vw_FeedbackByRecipe AS
SELECT 
    T.ItemID, 
    M.Name, 
    COUNT(*) AS NumberOfFeedbacks, 
    AVG(CAST(F.Rating AS MONEY)) AS AverageRating, 
    MIN(F.Rating) AS LowestRating, 
    MAX(F.Rating) AS HighestRating 
FROM TransactionDetail T
JOIN MenuItem M ON M.ItemID = T.ItemID
JOIN Feedback F ON F.TransactionID = T.TransactionID
GROUP BY T.ItemID, M.Name;
GO

-- Feedback by Customer View - Shows max, min and avg rating
CREATE VIEW vw_FeedbackByCustomer AS
SELECT 
    C.CustomerID, 
    P.FirstName, 
    P.LastName, 
    COUNT(*) AS NumberOfFeedbacks, 
    AVG(CAST(F.Rating AS MONEY)) AS AverageRating, 
    MIN(F.Rating) AS LowestRating, 
    MAX(F.Rating) AS HighestRating 
FROM Feedback F
JOIN Customer C ON C.CustomerID = F.CustomerID
JOIN Person P ON P.PersonID = C.PersonID
GROUP BY C.CustomerID, P.FirstName, P.LastName;
GO

-- Customer and Worker Demographics View - Shows how many employees and customers per city
CREATE VIEW vw_CustomerWorkerDemographics AS
SELECT 
    A.Country, 
    A.City,
    COUNT(DISTINCT C.CustomerID) AS NumberOfCustomers,
    COUNT(DISTINCT E.EmployeeID) AS NumberOfEmployees
FROM Address A
LEFT JOIN Person P ON A.AddressID = P.AddressID
LEFT JOIN Customer C ON P.PersonID = C.PersonID
LEFT JOIN Employee E ON P.PersonID = E.PersonID
GROUP BY A.Country, A.City;
GO

-- Allergens per Recipe View
CREATE VIEW vw_AllergensPerRecipe AS
SELECT
    MI.Name AS MenuItemName,
    I.Name AS AllergenName
FROM MenuItem MI
JOIN MenuItemRecipe MR ON MI.ItemID = MR.ItemID
JOIN Ingredient I ON MR.IngredientID = I.IngredientID
WHERE I.IsAllergen = 1; 
GO

-- Prize Stats View - Shows popularity of prizes
CREATE VIEW vw_PrizeStats AS
SELECT 
    R.PrizeID, 
    NAME, 
    COUNT(*) AS TimesRedeemed 
FROM PrizeRedemption P
JOIN RewardPrize R ON R.PrizeID = P.PrizeID
GROUP BY R.PrizeID, NAME;
GO

-- Active Restaurants View
CREATE VIEW vw_ActiveRestaurants AS
SELECT
    RestaurantID,
    Name,
    AddressID
FROM Restaurant
WHERE IsActive = 1;  -- Filter for active restaurants
GO

-- Monthly Sales Report View
CREATE VIEW vw_MonthlySalesReport AS
SELECT
    R.RestaurantID,
    R.Name AS RestaurantName,
    EOMONTH(CT.TransactionDate) AS SalesMonth,  -- Get the last day of the month
    SUM(TD.Quantity * MI.Price) AS TotalSalesAmount,
    COUNT(DISTINCT CT.TransactionID) AS NumberOfTransactions,
    AVG(TD.Quantity * MI.Price) AS AverageTransactionAmount 
FROM CustomerTransaction CT
JOIN Restaurant R ON CT.RestaurantID = R.RestaurantID
JOIN TransactionDetail TD ON CT.TransactionID = TD.TransactionID
JOIN MenuItem MI ON TD.ItemID = MI.ItemID
GROUP BY R.RestaurantID, R.Name, EOMONTH(CT.TransactionDate);
