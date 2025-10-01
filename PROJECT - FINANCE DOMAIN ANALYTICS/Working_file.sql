use Bank_Load_DB;

select * from bank_load_data;

--determine the total count of loan applications
select count(distinct id) as total_loan_applications from bank_load_data;

----determine the recent total count of loan applications month to date
select count(distinct id) as MTD_total_loan_applications from bank_load_data
where MONTH(issue_date) = 12 and year(issue_date) = 2021;

----determine the post total count of loan applications month to date
select count(distinct id) as PMTD_total_loan_applications from bank_load_data
where MONTH(issue_date) = 11 and year(issue_date) = 2021;

-- determine the total funded amount month-to-date
select sum(loan_amount) as MTD_total_funded_amount from bank_load_data
where month(issue_date) = 12 and year(issue_date) = 2021;

-- determine the total funded amount post month-to-date
select sum(loan_amount) as PMTD_total_funded_amount from bank_load_data
where month(issue_date) = 11 and year(issue_date) = 2021;

-- determine the total amount received month-to-date
select sum(total_payment) as MTD_total_amount_recvd from bank_load_data
where month(issue_date) = 12 and year(issue_date) = 2021;

-- determine the total amount received post-month-to-date
select sum(total_payment) as PMTD_total_amount_recvd from bank_load_data
where month(issue_date) = 11 and year(issue_date) = 2021 ;

--determine the average interest rate month-to-date
select round(avg(int_rate)*100,3) as MTD_Avg_Interest_rate from bank_load_data
where month(issue_date) = 12 and year(issue_date) = 2021;

--determine the average interest rate post-month-to-date
select round(avg(int_rate)*100,3) as PMTD_Avg_Interest_rate from bank_load_data
where month(issue_date) = 11 and year(issue_date) = 2021;

-- determine average debt to income ratio month-to-date
select round(avg(dti),3)*100 as MTD_Avg_DTI_rate from bank_load_data
where MONTH(issue_date) = 12 and year(issue_date) = 2021;

-- determine average debt to income ratio post-month-to-date
select round(avg(dti),3)*100 as PMTD_Avg_DTI_rate from bank_load_data
where MONTH(issue_date) = 11 and year(issue_date) = 2021;

--determine good loan application percentage
select(count(case when loan_status = 'Fully Paid' or loan_status = 'Current' then id end)*100)/
	count(id) as good_loan_percentage from bank_load_data; 

--determine the number of good loan applications
select count(id) as total_good_loans from bank_load_data 
where loan_status = 'Fully Paid' or loan_status = 'Current';

--determine the good loan funded amount
select sum(loan_amount) as total_good_loan_amount from bank_load_data
where loan_status = 'Fully Paid' or loan_status = 'Current';

--determine the total good loan received amount
select sum(total_payment) as total_good_loan_received from bank_load_data
where loan_status = 'Fully Paid' or loan_status = 'Current';

--determine bad loan application percentage
select(count(case when loan_status = 'Charged Off' then id end)*100.0)/
	count(id) as bad_loan_percentage from bank_load_data; 

--determine the total bad loans
select count(id) as total_bad_loans from bank_load_data
where loan_status = 'Charged Off'

--determine the total bad loan funded amount
select sum(loan_amount) as total_bad_loan_amount from bank_load_data
where loan_status = 'Charged Off'

--determine the total bad loan received amount
select sum(total_payment) as bad_loan_received_amount from bank_load_data
where loan_status = 'Charged Off';

--loan status grid - 1
select 
loan_status,
count(id) as Total_Loan_Applications,
sum(total_payment) as total_amount_received,
sum(loan_amount) as total_loan_amount,
round(avg(int_rate * 100),3) as average_interest_rate,
round(avg(dti * 100),3) as DTI
from bank_load_data
group by loan_status;

--loan status grid - 2
select loan_status,
sum(total_payment) as total_amount_received,
sum(loan_amount) as total_loan_amount
from bank_load_data where month(issue_date) = 12 and year(issue_date) = 2021
group by loan_status;

--monthly trends by issue date
select month(issue_date) as month_num,datename(month,issue_date) as month_name, 
count(id) as total_loan_applications,
sum(loan_amount) as Total_Funded_Amount, sum(total_payment) as total_received_amount
from bank_load_data group by month(issue_date),datename(month,issue_date) order by month(issue_date);

--regional analysis by state
select address_state, count(id) as total_loan_applications,
sum(loan_amount) as Total_Funded_Amount, sum(total_payment) as total_received_amount
from bank_load_data group by address_state order by sum(loan_amount) desc;

--loan term analysis
select term, count(id) as total_loan_applications,
sum(loan_amount) as Total_Funded_Amount, sum(total_payment) as total_received_amount
from bank_load_data group by term order by sum(loan_amount) desc;

--employee length analysis
select emp_length, count(id) as total_loan_applications,
sum(loan_amount) as Total_Funded_Amount, sum(total_payment) as total_received_amount
from bank_load_data group by emp_length order by sum(loan_amount) desc;

--loan purpose breakdown
select purpose, count(id) as total_loan_applications,
sum(loan_amount) as Total_Funded_Amount, sum(total_payment) as total_received_amount
from bank_load_data group by purpose order by sum(loan_amount) desc;

--home ownership analysis 
select home_ownership, count(id) as total_loan_applications,
sum(loan_amount) as Total_Funded_Amount, sum(total_payment) as total_received_amount
from bank_load_data group by home_ownership order by sum(loan_amount) desc;

