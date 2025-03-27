create database Marketing_Analysis
create table products
(Productid int,	Prd_name Varchar(max),	Category char(6),	Price decimal(10,2)) 

-- do the same for all datasets

-- countries

create table countries
(countryID int,	Country varchar(max),	City varchar(max))


create table engagement_data
(EngagementID int,	ContentID int,	ContentType varchar(max),	Likes int,	Eng_date date,
CampaignID int,	ProductID int,	View_s_clicks_comb varchar(max))


create table customers
(Custid int,	CustName varchar(max),	Email varchar(max),	Gender varchar(20),	Age int,	Locid int)


create table cust_review
(Reviewid int,	Custid int,	Productid int,	ReviewDate date,	Rating int,	Review_text text)

create table cust_journey
(Journeyid int,	custid int,	productid int,	Visitdate	 date,Stage varchar(max),	Action varchar(max),	Duration int)


select table_name from INFORMATION_SCHEMA.tables


--"C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\Countries.csv"
--"C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\Cust_review.csv"
--"C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\customer_journey.csv"
--"C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\Customers.csv"
--"C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\Engagement_data.csv"
--"C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\Products.csv"


bulk insert products
from /*path*/ 'C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\Products.csv'
--define parameter
with (
fieldterminator=',' , rowterminator='\n' , firstrow=2
)
select * from products


bulk insert countries
from /*path*/ 'C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\Countries.csv'
--define parameter
with (
fieldterminator=',' , rowterminator='\n' , firstrow=2
)
select * from countries


-- date format mismatch ( sql stores date in different format mismatch wont let tgis load)  we alter to load and later transform the dat type

alter table cust_review
alter column ReviewDate varchar(max)

bulk insert cust_review
from /*path*/ 'C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\Cust_review.csv'
--define parameter
with (
fieldterminator=',' , rowterminator='\n' , firstrow=2
)

select * from cust_review


-- same date format mismatch 

alter table cust_journey
alter column Visitdate varchar(max) 

alter table cust_journey
alter column Duration varchar(max)

bulk insert cust_journey
from /*path*/ 'C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\customer_journey.csv'
--define parameter
with (
fieldterminator=',' , rowterminator='\n' , firstrow=2
)

select * from cust_journey

select Duration,count(Duration) from cust_journey group by Duration


alter table engagement_data
alter column Eng_date varchar(max)

bulk insert engagement_data
from /*path*/ 'C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\Engagement_data.csv'
--define parameter
with (
fieldterminator=',' , rowterminator='\n' , firstrow=2
)
select * from engagement_data


bulk insert customers
from /*path*/ 'C:\Users\yash9\OneDrive\Desktop\project\MARKETING_ SQL project\Customers.csv'
--define parameter
with (
fieldterminator=',' , rowterminator='\n' , firstrow=2
)
select * from customers


--- DATA  loading completed  
--checking tables  



--- step 2   Data validation 

-- as we already converted date into varchar for loading we correct that data type and format 


select * from engagement_data

select Eng_date,convert(date,Eng_date,105) from engagement_data

-- also check if any of that dint get conerted ( if found unconverted alter will not work )


select Eng_date,convert(date,Eng_date,105) from engagement_data 
where convert(date,Eng_date,105)is null

-- all converted 

 -- so we first update the convert and then change the data type using alter 

 update engagement_data set Eng_date=convert(date,Eng_date,105)
 
 select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.columns where TABLE_NAME='engagement_data'

 alter table engagement_data
 alter column Eng_date date
 -- done 

 select * from cust_journey
  select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.columns where TABLE_NAME='cust_journey'
  

  select Visitdate,convert(date,Visitdate,105)	 from cust_journey
  where convert(date,Visitdate,105) is null  -- all converted 

  update cust_journey  set Visitdate=convert(date,Visitdate,105)

  alter table cust_journey 
  alter column Visitdate date

  -- fix   'NULL' value to actual  null to change the string into int
  
  update cust_journey set Duration = NUll where Duration='NULL'
   alter  table cust_journey
   alter column  Duration int

    select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.columns where TABLE_NAME='cust_journey'



	select* from cust_review
	select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.columns where TABLE_NAME='cust_review'


	select ReviewDate,convert(date,ReviewDate) from cust_review
	where convert(date, ReviewDate) is null

	update cust_review set  ReviewDate=convert(date, ReviewDate)


	alter table cust_review
	alter column ReviewDate date
		select COLUMN_NAME, DATA_TYPE from INFORMATION_SCHEMA.columns where TABLE_NAME='cust_review'


		--done  

select * from customers
select * from engagement_data
select * from cust_journey
select * from cust_review
select * from countries
select * from products

-- establishing relationship between tables 

-- fixing  nullable column for primary key

ALTER TABLE products
Alter column Productid int not null 

-- now converting to primary key 

ALTER TABLE products
ADD CONSTRAINT Primary_key PRIMARY KEY(Productid)


-- 
ALTER TABLE countries
Alter column countryID int not null 

-- now converting to primary key 

ALTER TABLE countries
ADD CONSTRAINT country_pk PRIMARY KEY(countryID)
 

 --

 ALTER TABLE customers
Alter column Custid int not null 

-- now converting to primary key 

ALTER TABLE customers
ADD CONSTRAINT customers_pk PRIMARY KEY(Custid)

-- creating foreign keys 

alter table engagement_data  -- done
add constraint fk1 foreign key (ProductID) references products(Productid)
---
alter table cust_journey -- 1 
add constraint fk7 foreign key (custid) references customers(Custid)

alter table cust_journey  --2  done 
add constraint fk3 foreign key (productid) references products(Productid)
---
alter table cust_review  --1
add constraint fk4 foreign key (productid) references products(Productid)

alter table cust_review  -- 2 done 
add constraint fk5 foreign key (custid) references customers(Custid)
--

ALTER TABLE customers
ADD CONSTRAINT fk6 foreign key(Locid) references countries(countryID)


--------

-- data cleaning 


select * from customers
select * from engagement_data
select * from cust_journey
select * from cust_review
select * from countries
select * from products

--  engagement_data table has a combined view and click column we need to sepereate it  (values ex 1000-1000 seperate by '-')


-- (        -----                concept section   

-- patindex to extract pattern index  and using sub string out for extracting character 

-- we ll change 2 row value adding symbol $@* to content type  and then use this above technique to clean it 

update  engagement_data set Contenttype='Blo$g' where EngagementID=1
update  engagement_data set Contenttype='*Blog' where EngagementID=2
update  engagement_data set Contenttype='Bl@og$' where EngagementID=3

select * from engagement_data

-- now we find the index value through patindex and then extract using substring 


select ContentType,patindex('%[@$*]%',ContentType) as position_index , substring(ContentType,patindex('%[@*$]%',ContentType),1) from engagement_data --1 is used for how many character including the pattern

-- as we extracted pattern 

update engagement_data set ContentType=replace(ContentType,substring(ContentType,PATINDEX('%[@$*]%',ContentType),1),'')   

-- as the 3rd  had 2 special chaaracter Bl@og$ , we run update again because the pattern is splited and  patindex returns the first match ( any @,$,*) index not second....

update engagement_data set ContentType=replace(ContentType,substring(ContentType,PATINDEX('%[@$*]%',ContentType),1),'')


select contenttype, charindex(ContentType,'blog',1), substring (ContentType,charindex(ContentType,'blog',1),4 ) from engagement_data



select contenttype, patindex('%Blog%',ContentType), substring (ContentType,patindex('%Blog%',ContentType),3 ) from engagement_data



----IMP   

-- parsename()  this is used to split column on basis of '.'    if your data is 5000 . 8000  this will split 5000 and 8000 
-- if your value has differnt character ( diliminator) replace with '.'


  -- concept end          -----)


  -- spliting 
  select* from engagement_data  -- we will be seperating views and click 

  -- creating columns 

  alter table engagement_data
  add  Viewss int 

   alter table engagement_data
  add  clicks int 

  --- Extracting data from views-clickscombo column


  select View_s_clicks_comb,parsename(replace(View_s_clicks_comb,'-','.'),1) as clicks ,
  parsename( replace(View_s_clicks_comb,'-','.'),2) as Viewss  from engagement_data                      --  1 is the right section and 2 is the left after deliminator


  -- now we update our new columns with this values


  update engagement_data set Viewss = parsename(replace(View_s_clicks_comb,'-','.'),2) -- done successfully 

    update engagement_data set Clicks = parsename(replace(View_s_clicks_comb,'-','.'),1)  -- error  updating  

	

	-- creating cte to check non numeric entry in our conversion 

	with Check_datatype as ( 
	select  View_s_clicks_comb, parsename(replace( View_s_clicks_comb,'-','.') ,2)  as vw ,
	parsename(replace( View_s_clicks_comb,'-','.') ,1)  as click      from engagement_data
	)
	select*from Check_datatype where  isnumeric(click)=0

	-- there are non numeric value present in the  clicks 
	--(  lets say if there is   data value   that is 26-02  this will be considered date sometimes which might have saved as key word 'feb' or date datatype ,
	-- therefore we will check for this in combo colum)


	-- updating original combo column (View_s_clicks_comb) -- case when


	update engagement_data set View_s_clicks_comb= case when View_s_clicks_comb like '%Feb%' then '02'    -- '02' string because the og table datatype is varchar bcz of '-' so cant change to int
	                                               when View_s_clicks_comb like '%Jan%' then '01' 
												   else View_s_clicks_comb end
 
 -- retry updating 
 update engagement_data set Clicks = parsename(replace(View_s_clicks_comb,'-','.'),1)

 -- success
 select* from engagement_data 


 -- the  cust_journey journey has duplicate data because its not allowing id as primary key 

 select * from cust_journey
 select count(Journeyid),count(distinct Journeyid) from cust_journey
 -- we have duplicates  
 -- now lets check what are they 


 with duplicates_ranked as ( select Journeyid,custid,productid, row_number()over (partition by Journeyid order by Journeyid) as Rankk   from cust_journey )

 select* from duplicates_ranked where rankk>1

-- now we delete  this duplicates


 with duplicates_ranked as ( select Journeyid,custid,productid, row_number()over (partition by Journeyid order by Journeyid) as Rankk   from cust_journey )

 delete from duplicates_ranked where rankk>1   -- done 


  select count(Journeyid),count(distinct Journeyid) from cust_journey  -- check if applied 

  -- now we create primary key 


alter table  cust_journey 
alter column  Journeyid int not null

 alter table  cust_journey 
 add constraint pk_custjourney primary key (Journeyid)


 ---- data distrubution ---

                     -- to check how customer is divided into on basis of certian feature like customer on bais of male female , or rating (1-5) or  action  (count with group by)
 -- this is to check customer behaviour , we work with joins here 

   select* from cust_journey
   select* from cust_review
   select* from customers

   select  Action,count(custid) from cust_journey group by Action
   select Rating, count (custid) from cust_review group by Rating order by Rating asc
      select count(Custid),Gender from customers group by Gender 
	  select  Stage,count(custid) from cust_journey group by Stage
	  -- ... more can be found out

	  -- so utilizing this we try to find 
	  --Q customer who take action purchase and give rating >3


	  select Action,rating,count(t1.Custid) from cust_journey t1
	  join  cust_review t2  on t1.Custid=t2.Custid where Action='Purchase' and Rating>=3  group by Action,Rating
