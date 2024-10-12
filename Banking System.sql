create schema Banking_system;
use banking_system;
create table customers(
Customer_id int primary key,
Name varchar(50),
Phone varchar(40),
Email varchar(50),
Address varchar(50),
Account_type varchar(40)
);
insert into customers 
values(101,"Vignesh","8179403608","vrvignesh0709@gmail.com","Nagari","Savings"),
	  (102,"Vijay","7672039245","vijay@gmail.com","EKM","Savings"),
      (103,"Praveena","7013340132","vrpraveena@gmail.com","Nagari","Checking"),
	  (104,"Hemakumar","6305540884","hemakumar@gamil.com","STW","Savings"),
      (105,"Selvam","9515314415","sellvam@gamil.com","STW","Checking"),
      (106,"Sangeetha","9826478746","sangeetha@gamil.com","PUT","Savings"),
      (107,"Sandhiya","7674638822","sandhiya@gmail.com","TPT","Checking"),
      (108,"Ravi","8763578264","ravitv@gmail.com","Chennai","Checking"),
      (109,"Jayaram","9874658373","jayaram@gmail.com","EKM","Savings"),
      (110,"Karthika","7873664784","karthika@gmail.com","STW","Savings");

create table Accounts(
Account_id int primary key,
customer_id int,
Account_Number varchar(50),
Account_type varchar(50),
Balance int,
Status varchar(40),
foreign key (customer_id) references customers(customer_id)
);
insert into accounts 
values(201,101,"232928327112","Savings",25000,"Active"),
      (202,105,"232895773647","Checking",10000,"Active"),
      (203,107,"234782784745","Checking",150000,"Active"),
      (204,106,"232945775467","Savings",100000,"Inactive"),
      (205,109,"232948747483","Savings",100938,"Active"),
      (206,108,"232948577446","Checking",10030,"Inactive"),
      (207,110,"232983746463","Savings",19000,"Active"),
      (208,102,"232948574644","Savings",150000,"Active"),
      (209,104,"232948457744","Savings",189000,"Inactive"),
      (210,103,"232947476547","Checking",10000,"Inactive"),
      (211,105,"338473837282","Savings",20000,"Active");

create table Transactions(
Transaction_id int primary key,
Account_id int,
Transaction_type varchar(50),
Amount int,
foreign key (Account_id) references Accounts(Account_id)
);
insert into Transactions 
values(301,201,"Deposit",1000),
	  (302,204,"Withdraw",20000),
      (303,209,"Deposit","15000"),
      (304,210,"Withdraw",2000),
      (305,205,"Deposit",5000),
      (306,206,"Withdraw",7000),
      (307,210,"Deposit",8000),
      (308,202,"Withdraw",6000),
      (309,203,"Withdraw",9000),
      (310,207,"Deposit",5000),
      (311,208,"Withdraw",3000),
      (312,205,"Deposit",5000),
      (313,208,"Deposit",8000),
      (314,203,"Withdraw",4000),
      (315,206,"Deposit",5000);

create table Loans(
Loan_id int primary key,
customer_id int,
Loan_type varchar(40),
Loan_Amount int,
Intrest_Rate varchar(20),
foreign key (customer_id) references customers(customer_id)
);
insert into Loans 
values(401,101,"Personal",100000,"5%"),
      (402,105,"Mortgage",50000,"6%"),
      (403,109,"Personal",45000,"4%"),
      (404,102,"Personal",30000,"3%"),
      (405,108,"Mortgage",25000,"8%");

create table Loan_Payments(
Payment_id int primary key,
Loan_id int,
Payment_Amount int,
Balance int,
foreign key (Loan_id) references Loans(loan_id)
);
insert into Loan_Payments 
values(501,401,100000,25000),
	  (502,405,2000,5000),
      (503,402,5000,10000),
      (504,404,9000,20000),
      (505,403,4000,5000);
      
-- 1. List all customers with their account details (account number, account type, balance).
select c.*,a.account_number,a.account_type,a.balance 
from customers c
join accounts a
on c.customer_id=a.customer_id;

-- 2. Display customer name, account number, and transaction type for all transactions.
select c.name,a.account_number,t.transaction_type,t.amount 
from customers c
join accounts a
on c.customer_id=a.customer_id
join transactions t
on a.account_id=t.account_id;

-- 3. Show customer name, loan type, and loan amount for customers with loans.
select c.customer_id,c.name,l.loan_type,l.loan_amount
from customers c 
join loans l
on c.customer_id=l.customer_id;

-- 4. Retrieve customer name, account number, and loan payment amount for customers with loan payments.
select c.name,a.account_number,lp.payment_amount
from customers c
join accounts a 
on c.customer_id=a.customer_id
join loans l 
on c.customer_id=l.customer_id
join loan_payments lp
on l.loan_id=lp.loan_id;

use banking_system;
-- 5. Find all customers with multiple accounts.
select c.name,count(a.account_id) as No_of_Accounts
from customers c 
join accounts a 
on c.customer_id=a.customer_id
group by c.name
having count(a.account_id)>1;

-- Subquries

-- 1.Find customers with accounts having balance > 50,000?

SELECT *
FROM Customers
WHERE Customer_id IN (
  SELECT Customer_id
  FROM Accounts
  WHERE Balance > 50000
);

-- 2.Retrieve accounts with transaction amount > 10,000.

SELECT * From accounts
where account_id 
in (select account_id from transactions
where amount > 10000);

-- 3.Find customers with accounts having highest balance.
SELECT *
FROM Customers c
WHERE c.Customer_id = (
  SELECT Customer_id
  FROM Accounts
  WHERE Balance = (
    SELECT MAX(Balance)
    FROM Accounts
  )
);

-- 4. Retrieve accounts with most transactions.

SELECT *
FROM Accounts a
WHERE a.Account_id = (
  SELECT Account_id
  FROM Transactions
  GROUP BY Account_id
  ORDER BY COUNT(*) DESC
  LIMIT 1
);

-- 5.Find customers with loan payments.
select * from customers
where customer_id in
(select customer_id from loans
where loan_id in (select loan_id from loan_payments)
 );
 
-- Exists and Not Exists

-- 11. Find customers with loan payments.

SELECT *
FROM Customers c
WHERE EXISTS (
  SELECT l.customer_id
  FROM Loan_Payments lp
  JOIN Loans l ON lp.Loan_id = l.Loan_id
  WHERE l.Customer_id = c.Customer_id
);


-- 12. Retrieve customers without loan payments.

SELECT *
FROM Customers c
WHERE NOT EXISTS (
  SELECT l.customer_id
  FROM Loan_Payments lp
  JOIN Loans l ON lp.Loan_id = l.Loan_id
  WHERE l.Customer_id = c.Customer_id
);
