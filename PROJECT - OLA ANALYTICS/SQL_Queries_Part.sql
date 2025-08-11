USE OLA;

-- 1. Retrieve all successful bookings:
CREATE VIEW Successful_Bookings AS
SELECT * FROM Bookings 
WHERE Booking_status = "Success";
SELECT * FROM Successful_Bookings

-- 2. Find the average ride distance for each vehicle type:
CREATE VIEW Avg_Dist AS
SELECT ROUND(AVG(Ride_Distance),3) AS Avg_Dist, Vehicle_Type 
FROM Bookings GROUP BY Vehicle_Type;
SELECT * FROM Avg_Dist;

-- 3. Get the total number of cancelled rides by customers:
CREATE VIEW Cancelled_Ride_Customer AS
SELECT COUNT(*) FROM Bookings 
WHERE Booking_Status = "Canceled by Customer";
SELECT * FROM Cancelled_Ride_Customer;

-- 4. List the top 5 customers who booked the highest number of rides:
CREATE VIEW Top_Customers AS
SELECT Customer_ID, COUNT(Booking_ID) AS Total_rides 
FROM Bookings GROUP BY Customer_ID ORDER BY Total_rides DESC LIMIT 5;
SELECT * FROM Top_Customers;

-- 5. Get the number of rides cancelled by drivers due to personal and car-related issues:
CREATE VIEW Rides_Cancelled_Driver AS
SELECT COUNT(*) AS Cancelled_Rides FROM Bookings 
WHERE Booking_Status = "Canceled by Driver" 
AND Canceled_Rides_by_Driver = "Personal & Car related issue"; 
SELECT * FROM Rides_Cancelled_Driver;

-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
CREATE VIEW Max_Min_Rating AS
SELECT MAX(Customer_Rating) AS Maximum_Customer_Rating, 
MIN(Customer_Rating) AS Minimum_Customer_Rating
FROM Bookings WHERE Vehicle_Type = "Prime Sedan";
SELECT * FROM Max_Min_Rating;

-- 7. Retrieve all rides where payment was made using UPI:
CREATE VIEW Upi_Payment_Mode AS
SELECT * FROM Bookings 
WHERE Payment_Method = "UPI";
SELECT * FROM Upi_Payment_Mode;

-- 8. Find the average customer rating per vehicle type:
CREATE VIEW Avg_Cus_Rating AS
SELECT Vehicle_Type,
ROUND(AVG(Customer_Rating),3) AS Avg_Rating 
FROM Bookings GROUP BY Vehicle_Type;
SELECT * FROM Avg_Cus_Rating;

-- 9. Calculate the total booking value of rides completed successfully:
CREATE VIEW Total_Booking_Value AS
SELECT SUM(Booking_Value) AS Total_Booking_Value
FROM Bookings WHERE Booking_Status = "Success";
SELECT * FROM Total_Booking_Value;

-- 10. List all incomplete rides along with the reason:
CREATE VIEW Incomplete_Rides AS
SELECT Booking_Id, Incomplete_Rides_Reason FROM Bookings
WHERE Incomplete_Rides = "Yes";
SELECT * FROM Incomplete_Rides;

-------------------------------------------------------------------------------------------
-- 1. Retrieve all successful bookings:
SELECT * FROM Successful_Bookings

-- 2. Find the average ride distance for each vehicle type:
SELECT * FROM Avg_Dist;

-- 3. Get the total number of cancelled rides by customers:
SELECT * FROM Cancelled_Ride_Customer;

-- 4. List the top 5 customers who booked the highest number of rides:
SELECT * FROM Top_Customers;

-- 5. Get the number of rides cancelled by drivers due to personal and car-related issues:
SELECT * FROM Rides_Cancelled_Driver;

-- 6. Find the maximum and minimum driver ratings for Prime Sedan bookings:
SELECT * FROM Max_Min_Rating;

-- 7. Retrieve all rides where payment was made using UPI:
SELECT * FROM Upi_Payment_Mode;

-- 8. Find the average customer rating per vehicle type:
SELECT * FROM Avg_Cus_Rating;

-- 9. Calculate the total booking value of rides completed successfully:
SELECT * FROM Total_Booking_Value;

-- 10. List all incomplete rides along with the reason:
SELECT * FROM Incomplete_Rides;


