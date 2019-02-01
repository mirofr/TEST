-- -----------------------------------------------------------Concurrency-------------------------------------------------------------

-- usp_BuildTable_tblCustomer
-- usp_GetCustomer
-- usp_InsertCustomer 
-- usp_UpdateCustomer
-- usp_lastcustomerid
-- ------------------------------------------------------------------------------------------

use wynk;

delimiter |
DROP PROCEDURE IF EXISTS usp_BuildTable_tblPath;
/*
CALL usp_BuildTable_tblPath();
SELECT * FROM wynk.tblpath;
.filename = oFile.name
.path = oFile.path
.apptype = oFile.type
.datearray = Array(oFile.DateCreated, oFile.DateLastAccessed, oFile.datelastmodified)
.ext = Mid(oFile.path, InStr(1, oFile.path, ".") + 1, Len(oFile.path))
.attributes = oFile.attributes
.size = oFile.size
                
*/
CREATE PROCEDURE usp_BuildTable_tblPath()
BEGIN
 DROP TABLE IF EXISTS `tblpath`;
  CREATE TABLE `tblpath` (
  `tblpath_pk` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `filename` varchar(125) DEFAULT NULL,
  `path` varchar(35) DEFAULT NULL,
  `apptype` varchar(125) DEFAULT NULL,
  `datearray` varchar(125) DEFAULT NULL,
  `ext` varchar(35) DEFAULT NULL,
  `attributes` varchar(35) DEFAULT NULL,
  `size` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`tblpath_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
end |
delimiter ;

-- ------------------------------------------------------------------------------------------

delimiter |
drop function if exists uf_lasttblfile_pk;
/*
select * from tblpath;
select uf_lasttblfile_pk()+1;

*/
create function uf_lasttblfile_pk () 
returns int
deterministic     
	begin
			declare rtnpk int;
			select tblpath_pk into rtnpk from tblpath order by tblpath_pk desc  limit 1 ;
			return rtnpk;
	end|
delimiter ;

-- ------------------------------------------------------------------------------------------

delimiter |
drop procedure if exists usp_Insert_tblpath;
/*
call usp_Insert_tblpath(1,"Newman","Paul","1 Johnson Place","Johnsville", "CO","80908","2345");
*/
create procedure usp_Insert_tblpath
(
  	in mytblpath_pk INT,
	in myfilename VARCHAR(125),
	in mypath VARCHAR(35),
	in myapptype VARCHAR(125),
	in mydatearray VARCHAR(125),
	in myext VARCHAR(35),
	in myattributes VARCHAR(35),
	in mysize VARCHAR(35)
)
begin
-- set @inp1:=myCustomerId;
set @inp1:=(select uf_lasttblfile_pk()+1);
set @inp2:=myfilename;
set @inp3:=mypath;
set @inp4:=myapptype;
set @inp5:=mydatearray;
set @inp6:=myext;
set @inp7:=myattributes;
set @inp8:=mysize;
prepare stmt from 'insert into tblpath (tblpath_pk, filename, path, apptype, datearray, ext, attributes, size) values (?,?,?,?,?,?,?,?)';
execute stmt using @inp1, @inp2, @inp3, @inp4, @inp5, @inp6, @inp7, @inp8;
deallocate prepare stmt;
end |
delimiter ;
 
-- ---------------------------------------------------------------------------------------------------------------------------------------
  `CustomerId` mediumint(8) NOT NULL AUTO_INCREMENT,
  `LastName` varchar(35) DEFAULT NULL,
  `FirstName` varchar(35) DEFAULT ' ',
  `Address` varchar(35) DEFAULT NULL,
  `City` varchar(35) DEFAULT NULL,
  `State` varchar(35) DEFAULT NULL,
  `ZipCode` varchar(5) DEFAULT NULL,
  `Phone` varchar(10) DEFAULT NULL,
  `Extension` varchar(35) DEFAULT NULL,
  `Notes` varchar(35) DEFAULT NULL,
  `ConcurrencyId` mediumint(8) DEFAULT '1',

delimiter |
drop procedure if exists usp_InsertCustomer;
/*
usp_InsertCustomer(1,french,michael,main street,aspen,co,80787,1458784512,ext 11,keep going)
*/
create procedure usp_InsertCustomer
(
  	in myCustomerId INT,
	in myLastName VARCHAR(35),
	in myFirstName VARCHAR(35),
	in myAddress VARCHAR(35),
	in myCity VARCHAR(35),
	in myState VARCHAR(35),
	in myZipCode VARCHAR(5),
	in myPhone VARCHAR(10),
	in myExtension VARCHAR(35),
	in myNotes VARCHAR(35)
)
begin
-- set @inp1:=myCustomerId;
set @inp1:=(select uf_lastcustomerid()+1);
set @inp2:=myLastName;
set @inp3:=myFirstName;
set @inp4:=myAddress;
set @inp5:=myCity;
set @inp6:=myState;
set @inp7:=myZipCode;
set @inp8:=myPhone;
set @inp9:=myExtension;
set @inp10:=myNotes;
prepare stmt from 'insert into tblCustomer (CustomerId, LastName, FirstName, Address, City, State, ZipCode, Phone, Extension, Notes) values (?,?,?,?,?,?,?,?,?,?)';
execute stmt using @inp1, @inp2, @inp3, @inp4, @inp5, @inp6, @inp7, @inp8, @inp9, @inp10;
deallocate prepare stmt;
end |
delimiter ;

-- ---------------------------------------------------------------------------------------------------------------------------------------
use wynk;
delimiter |
drop procedure if exists usp_BuildTable_tblCustomer;
/*
call usp_BuildTable_tblCustomer();

insert into wynk.tblCustomer(LastName, FirstName, Address, City, State, ZipCode, Phone, Extension, Notes, ConcurrencyId) 
select lastname, firstname, streetaddress, city, state, zip5, homephone, email, middlename, 1 from wynk.tblperson;

call usp_GetCustomer(672);

call usp_InsertCustomer(null,"ff","John","1 Johnson Place","Johnsville", "CO","80908","l","44","myf notes here");

select uf_LastCustomerId();

select *  FROM tblCustomer Where CustomerId =(select uf_lastcustomerid());

call usp_UpdateCustomer(672,41,"Boop","Betty","1 Pleasant Way","city", "state","80908","71920","44","myf notes here")
 
select tblperson_pk as CustomerId, lastname as LastName, firstname as FirstName, 
streetaddress as Address, city as City, state as State, zip5 as ZipCode, homephone as Phone, 
dob as Extension, utility1 as Notes, tblperson_pk as ConcurrencyId from tblperson where tblperson_pk= 1;

truncate table wynk.tblCustomer;

delete from tblCustomer Where CustomerId =1;

select *  FROM tblCustomer Where CustomerId =1 ORDER BY CustomerId DESC 

select *  FROM tblCustomer ORDER BY CustomerId DESC  Limit 1

update tblCustomer set ConcurrencyId = 1 where CustomerId =1

delete from tblCustomer Where CustomerId in(672);

explain tblCustomer;

SELECT CustomerId, count( * ) FROM tblCustomer GROUP BY CustomerId HAVING count( * ) >1

*/
create procedure usp_BuildTable_tblCustomer()
begin
drop table if exists `tblCustomer`;
create table `tblCustomer` (
  `CustomerId` mediumint(8) NOT NULL AUTO_INCREMENT,
  `LastName` varchar(35) DEFAULT NULL,
  `FirstName` varchar(35) DEFAULT ' ',
  `Address` varchar(35) DEFAULT NULL,
  `City` varchar(35) DEFAULT NULL,
  `State` varchar(35) DEFAULT NULL,
  `ZipCode` varchar(5) DEFAULT NULL,
  `Phone` varchar(10) DEFAULT NULL,
  `Extension` varchar(35) DEFAULT NULL,
  `Notes` varchar(35) DEFAULT NULL,
  `ConcurrencyId` mediumint(8) DEFAULT '1',
  PRIMARY KEY (`CustomerId`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
end|
delimiter ;

-- ---------------------------------------------------------------------------------------------------------------------------------------

delimiter |
drop procedure if exists usp_GetCustomer;
/*
call usp_GetCustomer (1)
*/
create procedure usp_GetCustomer
(
in p_CustomerId int -- should this be int unsigned ?
)
begin
select CustomerId, ConcurrencyId, LastName, FirstName, Address, City, State, ZipCode, Phone, Extension, Notes from tblCustomer
where CustomerId= p_CustomerId;
end |
delimiter ;

-- ---------------------------------------------------------------------------------------------------------------------------------------

delimiter |
drop procedure if exists usp_InsertCustomer;
/*
call usp_InsertCustomer(null,"ff","John","1 Johnson Place","Johnsville", "CO","80908","l","44","myf notes here");
call usp_InsertCustomer(null,"abc","John","1 Johnson Place","Johnsville", "CO","80908","l","44","myf notes here");
call usp_InsertCustomer(null,"def","John","1 Johnson Place","Johnsville", "CO","80908","l","44","myf notes here");
call usp_InsertCustomer(null,"ghi","John","1 Johnson Place","Johnsville", "CO","80908","l","44","myf notes here");
*/
create procedure usp_InsertCustomer
(
  	in myCustomerId INT,
	in myLastName VARCHAR(50),
	in myFirstName VARCHAR(50),
	in myAddress VARCHAR(50),
	in myCity VARCHAR(50),
	in myState VARCHAR(2),
	in myZipCode VARCHAR(10),
	in myPhone VARCHAR(10),
	in myExtension VARCHAR(5),
	in myNotes VARCHAR(100)
)
begin
-- set @inp1:=myCustomerId;
set @inp1:=(select uf_lastcustomerid()+1);
set @inp2:=myLastName;
set @inp3:=myFirstName;
set @inp4:=myAddress;
set @inp5:=myCity;
set @inp6:=myState;
set @inp7:=myZipCode;
set @inp8:=myPhone;
set @inp9:=myExtension;
set @inp10:=myNotes;
prepare stmt from 'insert into tblCustomer (CustomerId, LastName, FirstName, Address, City, State, ZipCode, Phone, Extension, Notes) values (?,?,?,?,?,?,?,?,?,?)';
execute stmt using @inp1, @inp2, @inp3, @inp4, @inp5, @inp6, @inp7, @inp8, @inp9, @inp10;
deallocate prepare stmt;
end |
delimiter ;

-- ---------------------------------------------------------------------------------------------------------------------------------------

delimiter |
drop procedure if exists usp_UpdateCustomer;
/*

 
*/
create procedure usp_UpdateCustomer

(
	in myCustomerId INT,
	in myConcurrencyId INT,
	in myLastName VARCHAR(50),
	in myFirstName VARCHAR(50),
	in myAddress VARCHAR(50),
	in myCity VARCHAR(50),
	in myState VARCHAR(2),
	in myZipCode VARCHAR(10),
	in myPhone VARCHAR(10),
	in myExtension VARCHAR(5),
	in myNotes VARCHAR(100)
)
begin
 select @myvar:=ConcurrencyId FROM tblCustomer WHERE CustomerId = myCustomerId;
 IF NOT(FOUND_ROWS() =0 or @myvar != myConcurrencyId)  THEN 
	  UPDATE tblCustomer
	  SET LastName = myLastName,
	  FirstName = myFirstName,
	  Address = myAddress,
	  City = myCity,
	  State = myState,
	  ZipCode = myZipCode,
	  Phone = myPhone,
	  Extension =myExtension,
	  Notes = myNotes,
	  ConcurrencyId = ConcurrencyId + 1
	  WHERE CustomerId = myCustomerId
	  AND ConcurrencyId = myConcurrencyId;
END IF;
end|
delimiter ;

-- ---------------------------------------------------------------------------------------------------------------------------------------

delimiter |
drop function if exists uf_LastCustomerId;
/*

select uf_LastCustomerId();

*/
create function uf_LastCustomerId () 
returns int
deterministic     
	begin
			declare rtnlastcustomerid int;
			select Customerid into rtnlastcustomerid from tblCustomer order by Customerid desc  limit 1 ;
			return rtnlastcustomerid;
	end|
delimiter ;
 
-- ---------------------------------------------------------------------------------------------------------------------------------------


 
-- ---------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------------------------------------------------

delimiter |
drop procedure if exists usp_searchzipcode;
/*
call usp_searchzipcode (80919)
*/
create procedure usp_searchzipcode
(
in myzip5 int -- should this be int unsigned ?
)
begin

select tblperson_pk, firstname, lastname, city, state, zip5 
from tblperson t
where zip5 = '51433';
end |
delimiter ;

-- ---------------------------------------------------------------------------------------------------------------------------------------
delimiter |
drop procedure if exists usp_SimpleSearch;
/*
call usp_simplesearch ("tblclient","lastname","oo")

call usp_simplesearch ("tblCustomer","FirstName","ca")

call usp_simplesearch ("tblCustomer","LastName","ee")
 select * from tblCustomer
select * from tblclient
select * from tblperson
select * from tblclient a inner join tblperson b on a.zip5=b.zip5
select count(*) from tblclient;
select count(*) from tblperson;
*/
create procedure usp_SimpleSearch
(
in tablename varchar(35), 
in fieldname varchar(35), 
in searchfor varchar(35)
)
begin
set @wildcardsearchfor = concat("%", searchfor, "%");      
set @sqlstatement= concat("select * from ", replace(tablename,'`',''), " where ", replace(fieldname,'`',''), " like ?");     
prepare stmt from @sqlstatement;    
execute stmt using @wildcardsearchfor;
deallocate prepare stmt;
end |
delimiter ;
   
-- ---------------------------------------------------------------------------------------------------------------------------------------
CALL CountOrderByStatus('Shipped',@total);

call usp_SearchProximity (80919,200,"tblperson","firstname","e",@output);
SELECT @output;

delimiter |
drop procedure if exists usp_SearchProximity;
/*
call usp_SearchProximity (78102,333,"tblCustomer","ZipCode","%")
call usp_SearchProximity (78102, 500, "tblCustomer", "LastName", "%")
call usp_SearchProximity (78102,1000,"tblperson","firstname","jeane")
call usp_SearchProximity (80919,200,"tblperson","firstname","e")
Call CreateSQLPackage(mycollection, "usp_SearchProximity", 
mysql_aws_wynk, "usp_SearchProximity", Array(80919, 200, "tblperson", "firstname", "e"))
*/
create procedure usp_SearchProximity
(
in myzip5 varchar(5),
in myproximity varchar(5),
in mytablename varchar(35), 
in myfieldname varchar(35),  
in mysearchstring varchar(35),
out myoutput varchar(255)
)
begin
set @sqlstatementpart = concat("dist_between_zip(uf_Lat(",myzip5,"), uf_Lon(", myzip5,"), uf_Lat(t1.zip5), uf_Lon(t1.zip5))<", myproximity," and ");
set @wildcardsearchstring = concat("%", mysearchstring, "%");      
set @sqlstatement= concat("select ", mytablename,"_pk", " , firstname, lastname, streetaddress, city, 
round(dist_between_zip(uf_Lat(",myzip5,"), uf_Lon(", myzip5,"), uf_Lat(t1.zip5), uf_Lon(t1.zip5)),0),
state, zip5, gender, homephone, dob, utility1, utility2 from ", replace(mytablename,'`','')," t1", " where ",
@sqlstatementpart, replace(myfieldname,'`',''), " like ?");

prepare stmt from @sqlstatement;    
execute stmt using @wildcardsearchstring;
deallocate prepare stmt;
select @sqlstatement into myoutput;
end |											
 
-- ---------------------------------------------------------------------------------------------------------------------------------------
 


 












delimiter |
drop function if exists  uf_Lat;
/*
select (true);
select uf_Lat('80908');
select uf_lon('80908');
*/
create function  uf_Lat (zip5 varchar(5))
returns float
deterministic     
    begin
        declare rtn_lat float;
        select latitude into rtn_lat from tblzip z where z.zip5 = zip5;
        return rtn_lat;
    end |
  delimiter ;
  
  -- ---------------------------------------------------------------------------------------------------------------------------------------
 
delimiter |
drop function if exists uf_Lon;
/*
select uf_Lat('80908');
select uf_Lon('80908');
*/
create function uf_Lon (zip5 varchar(5))
returns float
deterministic     
    begin
        declare rtn_lon float;
        select longitude into rtn_lon from tblzip z where z.zip5 = zip5;
        return rtn_lon;
    end |
  delimiter ;

 -- ------------------------------------------------------------------------------------------
 
delimiter |
drop function if exists  dist_between_zip;
/* 
    -- radius of earth
    -- 3959 mile
    -- 6371000 meter
    -- 6367 kilometer
 
select tblperson_pk, firstname, lastname, city, state, zip5, 
dist_between_zip(uf_Lat(80919), uf_Lon(80919), uf_Lat(t.zip5), uf_Lon(t.zip5)) 
from tblperson t
where state = 'co';

select tblperson_pk, firstname, lastname, city, state, zip5, round(dist_between_zip(uf_Lat(80919), uf_Lon(80919), uf_Lat(t.zip5), uf_Lon(t.zip5)),0)
from tblperson t
where dist_between_zip(uf_Lat(80919), uf_Lon(80919), uf_Lat(t.zip5), uf_Lon(t.zip5))<500
order by 7 desc;

select tblperson_pk, firstname, lastname, city, state, zip5, 
dist_between_zip(uf_Lat(80919), uf_Lon(80919), uf_Lat(t.zip5), uf_Lon(t.zip5)) 
from tblperson t
where dist_between_zip(uf_Lat(80919), uf_Lon(80919), uf_Lat(t.zip5), uf_Lon(t.zip5))<500
order by 7 desc;

select dist_between_zip(uf_Lat(80919), uf_Lon(80919), uf_Lat(t.zip5), uf_Lon(t.zip5));

select *,
dist_between_zip(uf_Lat(94705),  uf_Lon(94705), uf_Lat(t1.zip5), uf_Lon(t1.zip5))
from tblclient t1 where  
dist_between_zip(uf_Lat(94705),  uf_Lon(94705), uf_Lat(t1.zip5), uf_Lon(t1.zip5))<100
  
select tblzip_pk, zip5, city, state,
dist_between_zip(uf_Lat(80914),  uf_Lon(80914), uf_Lat(z.zip5), uf_Lon(z.zip5))
from tblzip z
where not true
or 
dist_between_zip(uf_Lat(80914),  uf_Lon(80914), uf_Lat(z.zip5), uf_Lon(z.zip5))<100
or
1=2;
 
select pi()
*/
create function  dist_between_zip (lat1 double, lon1 double, lat2 double, lon2 double)
returns double
deterministic     
    begin
        declare returnedvalue double;
        select
        acos(sin(lat1*pi()/180)*sin(lat2*pi()/180) + 
        cos(lat1*pi()/180)*cos(lat2*pi()/180)*
        cos(lon2*pi()/180-lon1*pi()/180) ) * 3959
        into returnedvalue;
        return returnedvalue;
end |
delimiter ;
  
 -- ------------------------------------------------------------------------------------------
 
delimiter |
drop procedure if exists usp_test;
/*
call usp_test();
usp_test()  
*/
create procedure usp_test()
begin
update tblskill set description = "a";
end |
delimiter ;

update  

select * from  tblskill 

select uf_LastCustomerId ()

delimiter |
drop procedure if exists usp_test;
/*
call usp_test (80919)
*/
create procedure usp_test
(
in var varchar(35) -- should this be int unsigned ?
)
begin
update tblskill set description = ?;
end |
delimiter ;















-- Public Function myqueries() As Collection
--  
-- 'collection of sql statements or stored procedures with optional parameter
-- 'my_connection , my_callname, my_sql, my_collection, my_parameter
-- 
--     Dim mycollection As New Collection
-- '
-- ''concurrency
-- '    Call sqlquery(mysql_aws_wynk, "lastid", "select usp_LastCustomerId ();", mycollection)
-- '    Call sqlquery(mysql_aws_wynk, "usp_InsertCustomer", "usp_InsertCustomer", mycollection, Array(2567, "Jones", "Mark", "123 Elm", "Colorado Springs", "CO", "80919", "7192008601", "ext", "notes"))
-- '    Call sqlquery(mysql_aws_wynk, "usp_UpdateCustomer", "usp_UpdateCustomer", mycollection, Array(1, 2, "Jones", "Mark", "123 Elm", "Colorado Springs", "CO", "80919", "7192008601", "ext", "notes"))
-- '    Call sqlquery(mysql_aws_wynk, "usp_GetCustomer", "call usp_GetCustomer(?)", mycollection, Array(3))
-- '
-- '
-- ''zip
--     Call sqlquery(mysql_aws_wynk, "getdistanceparam", "select dist_between_zip(uf_Lat(?), usp_Lon(?), uf_Lat(?), usp_Lon(?));", mycollection, Array(80919, 80919, 80905, 80905))
--     Call sqlquery(mysql_aws_wynk, "getdistance", "select dist_between_zip(uf_Lat(80919), usp_Lon(80919), uf_Lat(80908), usp_Lon(80908));", mycollection)
--     Call sqlquery(mysql_aws_wynk, "searchmorecapable", "usp_searchmorecapable", mycollection, Array(80919, 500, "tblperson", "city", "e"))
--     Call sqlquery(mysql_aws_wynk, "usp_simplesearch", "usp_simplesearch", mycollection, Array("tblclient", "lastname", "l"))
-- 
-- ''stored procedures
-- '    Call sqlquery(msss_aws__wynk, "usp_add_tblmodulepart", "usp_add_tblmodulepart", mycollection, Array("filename", "module", "procedure", "code", "unknown", "loc"))
-- '    Call sqlquery(mysql_aws_vbext, "usp_insertsqladolog", "usp_insertsqladolog", mycollection, Array("test", "strings", "entered", "logs"))
-- '    Call sqlquery(mysql_aws_vbext, "usp_insertmodulepart", "usp_insertmodulepart", mycollection, Array("fiilename", "module", "procedure", "code", "unknown", "loc"))
-- '
-- ''about mySQL
-- '    Call sqlquery(mysql_aws_wynk, "mysqltables", "SHOW TABLE STATUS;", mycollection)
-- '    Call sqlquery(mysql_aws_wynk, "explain", "Explain tblperson;", mycollection)
-- '
-- ' 'tblmodulepart
-- '    Call sqlquery(mysql_aws_vbext, "searchbetween", "select * from tblmodulepart where tblmodulepart_pk > ? and tblmodulepart_pk < ?;", mycollection, Array(1, 10000))
-- '    Call sqlquery(mysql_aws_vbext, "updatemysql", "update vbext.tblpath set name = ? where name <> ?;", mycollection, Array("denver", "denvver"))
-- '    Call sqlquery(access_____local, "localalltblmodulepart", "select * from tblmodulepart where tblmodulepart_pk > ? and tblmodulepart_pk < ?;", mycollection, Array(1, 10000))
-- '    Call sqlquery(access_____local, "ss", "select * from tblmodulepart where tblmodulepart_pk > ? and tblmodulepart_pk < ?;", mycollection, Array(1, 10000))
-- '    Call sqlquery(msss_aws__wynk, "axxx", "select * from tblmodulepart where tblmodulepart_pk > ? and tblmodulepart_pk < ?;", mycollection, Array(1, 10))
-- '    Call sqlquery(access_____local, "ml", "select * from tblmodulepart where tblmodulepart_pk > ? and tblmodulepart_pk < ?;", mycollection, Array(551, 10000))
-- '    Call sqlquery(mysql_aws_wynk, "usp_test", "usp_test", mycollection)
-- '    Call sqlquery(mysql_aws_wynk, "noparameter", "select * from wynk.tblclient where 1 = 1;", mycollection)
-- 
--     Set myqueries = mycollection
--     
-- End Function
delimiter |
drop function if exists test;
/*

select *  FROM tblCustomer ORDER BY CustomerId DESC  Limit 1

select *  FROM tblCustomer Where CustomerId >(select DELIMITER $$


select usp_lastcustomerid();

*/
create function test ()
returns int
deterministic     
	begin
			declare rtnlastcustomerid int;
			select Customerid into rtnlastcustomerid from tblCustomer order by Customerid desc  limit 1 ;
			return rtnlastcustomerid;
	end|
delimiter ;
-- ---------------------------------------------------------------------------------------------------------------------------------------

-- -----------------------------------------------------------Zip Code Search-------------------------------------------------------------
--  use wynk;
-- 
-- delete from tblCustomer Where CustomerId =6;
-- delete from tblCustomer Where CustomerId =11;
-- delete from tblCustomer Where CustomerId =12;
-- delete from tblCustomer Where CustomerId =13;
-- delete from tblCustomer Where CustomerId =90;
-- 
-- SELECT (t1.CustomerId + 1) as gap_starts_at,
-- (SELECT MIN(t3.CustomerId) -1 FROM tblCustomer t3 WHERE t3.CustomerId > t1.CustomerId) as gap_ends_at
--  FROM tblCustomer t1
--  WHERE NOT EXISTS (SELECT t2.CustomerId FROM tblCustomer t2 WHERE t2.CustomerId = t1.CustomerId + 1)
-- HAVING gap_ends_at IS NOT NULL
-- 
-- 
-- SELECT
-- CONCAT(z.expected, IF(z.got-1>z.expected, CONCAT(' thru ',z.got-1), '')) AS missing
-- FROM (
-- SELECT
-- @rownum:=@rownum+1 AS expected,
-- IF(@rownum=CustomerId, 0, @rownum:=CustomerId) AS got
-- FROM
-- (SELECT @rownum:=0) AS a
-- JOIN tblCustomer
-- ORDER BY CustomerId
-- ) AS z
-- WHERE z.got!=0;
-- 

  
-- use wynk;
-- delimiter |
-- drop procedure if exists usp_searchmorecapable;
-- /*
-- call usp_searchmorecapable (78102,25,"tblzip","zip5","%")
-- 
-- call usp_searchmorecapable (80919,50,"tblperson","city","e")
-- */
-- create procedure usp_searchmorecapable
-- (
-- in myzip5 varchar(5),
-- in myproximity varchar(5),
-- in mytablename varchar(35), 
-- in myfieldname varchar(35),  
-- in mysearchstring varchar(35)
-- )
-- begin
-- set @sqlstatementpart = concat("dist_between_zip(uf_Lat(",myzip5,"),  
-- usp_Lon(", myzip5,"), uf_Lat(t1.Zipcode), usp_Lon(t1.ZipCode))<", myproximity," and ");
-- set @wildcardsearchstring = concat("%", mysearchstring, "%");      
-- set @sqlstatement= concat("select * from ", replace(mytablename,'`','')," t1", " where ",
-- @sqlstatementpart, replace(myfieldname,'`',''), " like ?");
-- prepare stmt from @sqlstatement;    
-- execute stmt using @wildcardsearchstring;
-- deallocate prepare stmt;
-- end |


  
  

select * from tblzip where zip5 = '85253'
select * from tblzip where zip5 = '21056'
select * from tblzip where zip5 = '86366'
select * from tblzip where zip5 = '67232'
select * from tblzip where zip5 = '68520'
select * from tblzip where zip5 = '16155'
select * from tblzip where zip5 = '51526'
select * from tblzip where zip5 = '63073'
select * from tblzip where zip5 = '67223'
select * from tblzip where zip5 = '22646'
call usp_searchmorecapable (85253,25,"tblzip","zip5","%")
union
call usp_searchmorecapable (21056,25,"tblzip","zip5","%")
call usp_searchmorecapable (86366,25,"tblzip","zip5","%")
call usp_searchmorecapable (67232,25,"tblzip","zip5","%")
call usp_searchmorecapable (68520,25,"tblzip","zip5","%")
call usp_searchmorecapable (16155,25,"tblzip","zip5","%")
call usp_searchmorecapable (87501,25,"tblzip","city","%")
call usp_searchmorecapable (63073,25,"tblzip","city","%")
call usp_searchmorecapable (67223,25,"tblzip","zip5","%")
call usp_searchmorecapable (22646,25,"tblzip","zip5","%")
 -- ------------------------------------------------------------------------------------------
 
call usp_searchmorecapable (02630,25,"tblzip","city","%"); --  Barnstable

call usp_searchmorecapable (32135,25,"tblzip","city","%"); --  Palm Coast
 
call usp_searchmorecapable (34470,25,"tblzip","city","%"); --  Ocala
 
call usp_searchmorecapable (32960,25,"tblzip","city","%"); --  Vero Beach
 
call usp_searchmorecapable (34101,25,"tblzip","city","%"); --  Naples
 
call usp_searchmorecapable (34201,25,"tblzip","city","%"); --  Bradenton
 
call usp_searchmorecapable (33599,25,"tblzip","city","%");  --  Punta Gorda

 
 select * from wynk.tblutility
 
 CREATE TABLE new_table
call usp_searchmorecapable (34201,25,"tblzip","city","%");  --  Bradenton
union
call usp_searchmorecapable (33599,25,"tblzip","city","%");  --  Punta Gorda
 
 

  -- ------------------------------------------------------------------------------------------
 

 -- ------------------------------------------------------------------------------------------


 -- ------------------------------------------------------------------------------------------

delimiter |
drop procedure if exists usp_buildtable_tblmodulepart;
/*
explain tblmodulepart;
call usp_buildtable_tblmodulepart();
select * from tblmodulepart order by 1 desc;
*/
create procedure usp_buildtable_tblmodulepart()
begin
drop table if exists `tblmodulepart`;
create table `tblmodulepart` (
  `tblmodulepart_pk` mediumint(8) unsigned not null auto_increment,
  `filepath` varchar(255) default null,
  `module` varchar(255) default null,
  `procedure` varchar(255) default null,
  `code` varchar (2000) default null,
  `kind`  varchar(255) default null,
  `loc` varchar(255) default null,
  primary key (`tblmodulepart_pk`)
) engine=innodb auto_increment=1 default charset=latin1;
end |
delimiter ;

 -- ------------------------------------------------------------------------------------------

delimiter |
drop procedure if exists usp_insertmodulepart;
/*
call usp_insertmodulepart('gfgdcgf','modxxxname','procxxxname','procxxxcode','procxxxkind','h');

select * from tblmodulepart order by 1 desc limit 1;

truncate table tblmodulepart;
*/
create procedure usp_insertmodulepart(
in inp1 varchar(255),
in inp2 varchar(255),
in inp3 varchar(255),
in inp4 varchar(2000),
in inp5 varchar(255),
in inp6 varchar(255))
begin
set @inp1:=inp1;
set @inp2:=inp2;
set @inp3:=inp3;
set @inp4:=inp4;
set @inp5:=inp5;
set @inp6:=inp6;
prepare stmt from 'insert into tblmodulepart (filepath, module, `procedure`, `code`, kind, loc) values (?,?,?,?,?,?)';
execute stmt using @inp1, @inp2, @inp3, @inp4, @inp5, @inp6;
deallocate prepare stmt;
end|
delimiter ;




-- ---------------------------------------------------------------------------------------------------------------------------------------

 

-- ---------------------------------------------------------------------------------------------------------------------------------------








-- CREATE TABLE `tblzip` (
--   `tblzip_pk` int(11) NOT NULL AUTO_INCREMENT,
--   `zip5` int(11) DEFAULT NULL,
--   `city` text,
--   `state` text,
--   `latitude` double DEFAULT NULL,
--   `longitude` double DEFAULT NULL,
--   `timezone` int(11) DEFAULT NULL,
--   `dst` int(11) DEFAULT NULL,
--   PRIMARY KEY (`tblzip_pk`),
--   KEY `idx_tblzip_zip5` (`zip5`)
-- ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
-- 
-- select * from tblperson;
-- select * from tblclient;
-- 
-- SELECT firstname, middlename, lastname, streetaddress, city, state, zip5, zip4, country, gender, email, ssn, homephone, mobilephone, dob, usveteran, photo, voice, nextofkin, utility1, utility2 FROM tblperson
-- UNION ALL
-- SELECT firstname, middlename, lastname, streetaddress, city, state, zip5, zip4, country, gender, email, ssn, homephone, mobilephone, dob, usveteran, photo, voice, nextofkin, utility1, utility2 FROM tblclient;
-- 
-- SELECT * FROM tblzip;
-- SELECT * FROM tblclient;
-- SELECT * FROM tblperson;
-- 
-- INSERT INTO t (firstname, middlename, lastname, streetaddress, city, state, zip5, zip4, country, gender, email, ssn, homephone, mobilephone, dob, usveteran, photo, voice, nextofkin, unlity1, utility2)
-- 
-- SELECT `t`.`tblclient_pk`,
--     `t`.`firstname`,
--     `t`.`middlename`,
--     `t`.`lastname`,
--     `t`.`streetaddress`,
--     `t`.`city`,
--     `t`.`state`,
--     `t`.`zip5`,
--     `t`.`zip4`,
--     `t`.`country`,
--     `t`.`gender`,
--     `t`.`email`,
--     `t`.`ssn`,
--     `t`.`homephone`,
--     `t`.`mobilephone`,
--     `t`.`dob`,
--     `t`.`usveteran`,
--     `t`.`photo`,
--     `t`.`voice`,
--     `t`.`nextofkin`,
--     `t`.`utility1`,
--     `t`.`utility2`
-- FROM `wynk`.`t`;
-- 
-- SELECT * FROM wynk.tblperson order by 2;
-- SELECT * FROM wynk.tblclient order by 2;
-- delete  from tblclient where utility1 = "tblperson"
-- 
-- SELECT * FROM wynk.t order by 2;
--  
-- insert into tblclient(firstname,middlename, lastname, streetaddress, city, state, zip5, zip4, country, gender, email, ssn, homephone, mobilephone, dob, usveteran, photo, voice, nextofkin, utility1, utility2)
-- select firstname,middlename, lastname, streetaddress, city, state, zip5, zip4, country, gender, email, ssn, homephone, mobilephone, dob, usveteran, photo, voice, nextofkin, utility1, utility2 from t
-- where utility1 = "tblclient"
-- 
-- UPDATE t SET utility1 = "tblclient"
-- where utility1<>"tblperson"  -- order by rand() limit 672
-- 
-- UPDATE tblclient SET utility1 = "tblclient"
-- where  utility1 <> "tblperson"
-- 
-- CREATE TABLE `tblclient` (
--   `tblclient_pk` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
--   `firstname` varchar(35) DEFAULT ' ',
--   `middlename` varchar(35) DEFAULT ' ',
--   `lastname` varchar(35) DEFAULT NULL,
--   `streetaddress` varchar(35) DEFAULT NULL,
--   `city` varchar(35) DEFAULT NULL,
--   `state` varchar(35) DEFAULT NULL,
--   `zip5` varchar(5) DEFAULT NULL,
--   `zip4` varchar(4) DEFAULT NULL,
--   `country` varchar(35) DEFAULT NULL,
--   `gender` varchar(1) DEFAULT NULL,
--   `email` varchar(35) DEFAULT NULL,
--   `ssn` varchar(9) DEFAULT NULL,
--   `homephone` varchar(10) DEFAULT NULL,
--   `mobilephone` varchar(10) DEFAULT NULL,
--   `dob` varchar(35) DEFAULT NULL,
--   `usveteran` tinyint(1) DEFAULT NULL,
--   `photo` varchar(35) DEFAULT NULL,
--   `voice` varchar(35) DEFAULT NULL,
--   `nextofkin` varchar(35) DEFAULT NULL,
--   `utility1` varchar(35) DEFAULT NULL,
--   `utility2` varchar(35) DEFAULT NULL,
--   PRIMARY KEY (`tblclient_pk`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- 
--  CREATE TABLE `tblperson` (
--   `tblperson_pk` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
--   `firstname` varchar(35) DEFAULT ' ',
--   `middlename` varchar(35) DEFAULT ' ',
--   `lastname` varchar(35) DEFAULT NULL,CREATE TABLE `tblperson` (
  `tblperson_pk` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(35) DEFAULT ' ',
  `middlename` varchar(35) DEFAULT ' ',
  `lastname` varchar(35) DEFAULT NULL,
  `streetaddress` varchar(35) DEFAULT NULL,
  `city` varchar(35) DEFAULT NULL,
  `state` varchar(35) DEFAULT NULL,
  `zip5` varchar(5) DEFAULT NULL,
  `zip4` varchar(4) DEFAULT NULL,
  `country` varchar(35) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `email` varchar(35) DEFAULT NULL,
  `ssn` varchar(9) DEFAULT NULL,
  `homephone` varchar(10) DEFAULT NULL,
  `mobilephone` varchar(10) DEFAULT NULL,
  `dob` varchar(35) DEFAULT NULL,
  `usveteran` tinyint(1) DEFAULT NULL,
  `photo` varchar(35) DEFAULT NULL,
  `voice` varchar(35) DEFAULT NULL,
  `nextofkin` varchar(35) DEFAULT NULL,
  `utility1` varchar(35) DEFAULT NULL,
  `utility2` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`tblperson_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=1024 DEFAULT CHARSET=latin1;

--   `streetaddress` varchar(35) DEFAULT NULL,
--   `city` varchar(35) DEFAULT NULL,
--   `state` varchar(35) DEFAULT NULL,
--   `zip5` varchar(5) DEFAULT NCREATE TABLE `tblperson` (
  `tblperson_pk` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `firstname` varchar(35) DEFAULT ' ',
  `middlename` varchar(35) DEFAULT ' ',
  `lastname` varchar(35) DEFAULT NULL,
  `streetaddress` varchar(35) DEFAULT NULL,
  `city` varchar(35) DEFAULT NULL,
  `state` varchar(35) DEFAULT NULL,
  `zip5` varchar(5) DEFAULT NULL,
  `zip4` varchar(4) DEFAULT NULL,
  `country` varchar(35) DEFAULT NULL,
  `gender` varchar(1) DEFAULT NULL,
  `email` varchar(35) DEFAULT NULL,
  `ssn` varchar(9) DEFAULT NULL,
  `homephone` varchar(10) DEFAULT NULL,
  `mobilephone` varchar(10) DEFAULT NULL,
  `dob` varchar(35) DEFAULT NULL,
  `usveteran` tinyint(1) DEFAULT NULL,
  `photo` varchar(35) DEFAULT NULL,
  `voice` varchar(35) DEFAULT NULL,
  `nextofkin` varchar(35) DEFAULT NULL,
  `utility1` varchar(35) DEFAULT NULL,
  `utility2` varchar(35) DEFAULT NULL,
  PRIMARY KEY (`tblperson_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=1024 DEFAULT CHARSET=latin1;
ULL,
--   `zip4` varchar(4) DEFAULT NULL,
--   `country` varchar(35) DEFAULT NULL,
--   `gender` varchar(1) DEFAULT NULL,
--   `email` varchar(35) DEFAULT NULL,
--   `ssn` varchar(9) DEFAULT NULL,
--   `homephone` varchar(10) DEFAULT NULL,
--   `mobilephone` varchar(10) DEFAULT NULL,
--   `dob` varchar(35) DEFAULT NULL,
--   `usveteran` tinyint(1) DEFAULT NULL,
--   `photo` varchar(35) DEFAULT NULL,
--   `voice` varchar(35) DEFAULT NULL,
--   `nextofkin` varchar(35) DEFAULT NULL,
--   `utility1` varchar(35) DEFAULT NULL,
--   `utility2` varchar(35) DEFAULT NULL,
--   PRIMARY KEY (`tblperson_pk`)
-- ) ENGINE=InnoDB DEFAULT CHARSET=latin1;
-- ------------------------------------------------------------------------------------------
 
SHOW TABLES LIKE '%%';
 DELIMITER $$
 DROP PROCEDURE IF EXISTS  adhoc_storage;
/*



usp_InsertSQLActivity
usp_Build_Table_tblSQLActivity
usp_Build_Table_tblmodulepart
usp_Search
usp_InsertModulePart
usp_ExecSql


select @ReturnedLat=1;
select @ReturnedLat
select usp_Lon(80908,@ReturnedLon);
 
SELECT * from tblcaregiver c 
JOIN tblzip z ON(z.zip5 = c.Zip5) WHERE
z.latitude > @ReturnedLat -inputsecond and
z.latitude < @ReturnedLat+inputsecond  and
z.longitude >@ReturnedLon -inputsecond  and
z.longitude <@ReturnedLon +inputsecond 
ORDER by z.latitude;

CALL adhoc_storage;
SHOW TABLE STATUS;
SHOW TABLE STATUS FROM wynk;
SHOW DATABASES;
SHOW TABLES;
SHOW CREATE TABLE tblclient;
SHOW TABLES LIKE 'tbl%';

DESCRIBE tblclient;
SHOW TABLE STATUS FROM `wynk`;
 
show engine innodb status;

SELECT CONNECTION_ID();
     
LOCK TABLES tblskill READ;
UNLOCK TABLES;

SELECT * FROM tblclient WHERE FirstName Like '%ich%';
SELECT * FROM tblclient WHERE FirstName Like '%rich';
*/
CREATE PROCEDURE  adhoc_storage()
BEGIN
Select 0 as attribute1;
END$$
DELIMITER ;
CREATE DATABASE `ggfg` /*!40100 DEFAULT CHARACTER SET latin1 */;

-- ------------------------------------------------------------------------------------------
alter table ggfg.tblmodulepart rename vbext.tblmodulepart
alter table ggfg.tblpath rename vbext.tblpath
alter table ggfg.tblsqladolog rename vbext.tblsqladolog

 
DELIMITER $$
CREATE PROCEDURE mysum(IN par1 decimal(20,2),
                                 IN par2 decimal(20,2),
         OUT total decimal(20,2))
BEGIN
    SET total = par1 + par2;
END$$
DELIMITER ;

 
call mysum(10.5,25,@total);
select @total as t;
 
 call usp_search ("tblmodulepart","code","let",@total);
 select @total as t;
 
 delimiter $$
drop procedure if exists usp_search;
/*
--   select concat('select * from `', replace(tablename,'`',''),'`;') 
the whole point of using a prepared statement is to sanitize user input
use tmp;
use wynk;
use `vbextensibility`;

call usp_search ("tblmodulepart","code","dim");
call usp_search ("tblperson","lastname","oo",@output1, @output2);
select @output1, @output2  
call usp_search ("tblperson","lastname","oon");
*/
create procedure usp_search
(
in tablename varchar(35), 
in fieldname varchar(35), 
in searchfor varchar(35),
out  varchar(125),
out wild varchar(125)
)
begin
set @wildcardsearchfor = concat("%", searchfor, "%");      
set @sqlstatement= concat("select * from ", replace(tablename,'`',''), " where ", replace(fieldname,'`',''), " like ?");    
set sqlout=@sqlstatement;            
set wild=@wildcardsearchfor;
prepare stmt from @sqlstatement;    
execute stmt using @wildcardsearchfor;
deallocate prepare stmt;
end$$
delimiter ;
 
 



DELIMITER $$
DROP PROCEDURE IF EXISTS usp_BuildTable_tblmodulepart;
/*
CALL usp_BuildTable_tblmodulepart();
SELECT * FROM tblmodulepart order by 1 desc;
*/
CREATE PROCEDURE usp_BuildTable_tblmodulepart()
BEGIN
DROP TABLE IF EXISTS `tblmodulepart`;
CREATE TABLE `tblmodulepart` (
  `tblmodulepart_pk` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `FilePath` varchar(255) DEFAULT NULL,
  `Module` varchar(255) DEFAULT NULL,
  `Procedure` varchar(255) DEFAULT NULL,
  `Code` varchar (2000) DEFAULT NULL,
  `Kind`  varchar(255) DEFAULT NULL,
  `LOC` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`tblmodulepart_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
END $$
DELIMITER ;


DELIMITER $$
DROP PROCEDURE IF EXISTS usp_BuildTable_tblskill;
/*
CALL usp_BuildTable_tblskill();

Select * from tblskill;

INSERT INTO `tblskill` (`skill`) VALUES ('1 - Hand Hygiene');
INSERT INTO `tblskill` (`skill`) VALUES ('2 - Applies one knee-high elastic stocking');
INSERT INTO `tblskill` (`skill`) VALUES ('22-Transfers from Bed to Wheelchair using Transfter Belt');
INSERT INTO `tblskill` (`skill`) VALUES ('3 - Assists to ambulate using transfer belt');
INSERT INTO `tblskill` (`skill`) VALUES ('5 - Clean Upper or Lower Denture');
INSERT INTO `tblskill` (`skill`) VALUES ('6 - Counts and Records Radial Pulse');
INSERT INTO `tblskill` (`skill`) VALUES ('7 - Counts and Records Respirations');
INSERT INTO `tblskill` (`skill`) VALUES ('8 - Provides Foot Care on One Foot');
INSERT INTO `tblskill` (`skill`) VALUES ('20 - Provides Mouth Care');
INSERT INTO `tblskill` (`skill`) VALUES ('17 - Positions on side');
INSERT INTO `tblskill` (`skill`) VALUES ('16 - Performs Modified Passive Range of Motion (PROM) for One Shoulder');
INSERT INTO `tblskill` (`skill`) VALUES ('15 - Performs Modified Passive Range of Motion (PROM) for One Knee and Ankle');
INSERT INTO `tblskill` (`skill`) VALUES ('13 - Measures and Records Urinary Output');
INSERT INTO `tblskill` (`skill`) VALUES ('14 - Measures and Records Weight of Ambulatory Client');
INSERT INTO `tblskill` (`skill`) VALUES ('12 - Measures and Records Blood Pressure');
INSERT INTO `tblskill` (`skill`) VALUES ('4 - Assists with use of BedPan');
INSERT INTO `tblskill` (`skill`) VALUES ('21-Provides Peri-Care for female');

*/
CREATE PROCEDURE usp_BuildTable_tblskill()
BEGIN
 DROP TABLE IF EXISTS `tblskill`;
  CREATE TABLE `tblskill` (
  `tblskill_pk` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `level` varchar(125) DEFAULT NULL,
  `skill` varchar(125) DEFAULT NULL,
  `description` varchar(125) DEFAULT NULL,
  `undetermined` varchar(125) DEFAULT NULL,
  PRIMARY KEY (`tblskill_pk`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
END $$
DELIMITER ;
 



DELIMITER $$
DROP PROCEDURE IF EXISTS usp_ExecSql;
CREATE PROCEDURE usp_ExecSql (
                 IN sqlq VARCHAR(5000)) 
/*
SET @query_as_string = CONCAT('Select * FROM ', 'tblcaregiver', 
' WHERE firstname =', '''Alvin''');
select @query_as_string;
Call usp_ExecSql(@query_as_string) 
 
Set @x = '''587''';                       
SET @query_as_string = CONCAT('Select * FROM ', 'tblcaregiver', 
' WHERE id =', @x);
Call usp_ExecSql(@query_as_string);
Call usp_ExecSql('select * from tblzip limit 5');
*/
BEGIN
  SET @sqlv=sqlq;
  PREPARE stmt FROM @sqlv;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;  

-- ------------------------------------------------------------------------------------------

DELIMITER $$
DROP PROCEDURE IF EXISTS usp_insertsqladolog;
/*
CALL usp_insertsqladolog('c','c','c','c');
SELECT * FROM tblsqladolog Order by 1 desc;
truncate table tblsqladolog
41*/
CREATE PROCEDURE usp_insertsqladolog(
IN InP1 varchar(255),
IN InP2 varchar(255),
IN InP3 varchar(255),
IN InP4 varchar(10000))
BEGIN
SET @InP1:=InP1;
SET @InP2:=InP2;
SET @InP3:=InP3;
SET @InP4:=InP4;
PREPARE stmt FROM 'INSERT INTO tblsqladolog (Connection, Name, Construct, Parameter) VALUES (?,?,?,?)';
EXECUTE stmt USING @InP1, @InP2, @InP3, @InP4;
DEALLOCATE PREPARE stmt;
END$$
DELIMITER ;
 
-- ------------------------------------------------------------------------------------------
 
-- ------------------------------------------------------------------------------------------


DELIMITER $$
DROP PROCEDURE IF EXISTS usp_BuildTable_tblsqladolog;
/*
CALL usp_BuildTable_tblsqladolog();
SELECT * FROM tblsqladolog;
truncate table tblsqladolog
*/
CREATE PROCEDURE usp_BuildTable_tblsqladolog()
BEGIN
 DROP TABLE IF EXISTS `tblsqladolog`;
  CREATE TABLE `tblsqladolog` (
  `tblsqladolog_pk` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `Connection` varchar(125) DEFAULT NULL,
  `Name` varchar(125) DEFAULT NULL,
  `Construct` varchar(125) DEFAULT NULL,
  `Parameter` varchar(125) DEFAULT NULL,
PRIMARY KEY (`tblsqladolog_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
END $$
DELIMITER ;

-- ------------------------------------------------------------------------------------------

-- ------------------------------------------------------------------------------------------

delimiter $$
drop procedure if exists usp_insertmodulepart;
/*
call usp_insertmodulepart('filexxxpath','modxxxname','procxxxname','procxxxcode','procxxxkind','h');
select * from tblmodulepart;
truncate table tblmodulepart;
*/
create procedure usp_insertmodulepart(
in inp1 varchar(255),
in inp2 varchar(255),
in inp3 varchar(255),
in inp4 varchar(2000),
in inp5 varchar(255),
in inp6 varchar(255))
begin
set @inp1:=inp1;
set @inp2:=inp2;
set @inp3:=inp3;
set @inp4:=inp4;
set @inp5:=inp5;
set @inp6:=inp6;
prepare stmt from 'insert into tblmodulepart (filepath, module, `procedure`, `code`, kind, loc) values (?,?,?,?,?,?)';
execute stmt using @inp1, @inp2, @inp3, @inp4, @inp5, @inp6;
deallocate prepare stmt;
end$$
delimiter ;



DELIMITER $$
DROP PROCEDURE IF EXISTS usp_BuildTable_tblmodulepart;
/*
CALL usp_BuildTable_tblmodulepart();
SELECT * FROM wynk.tblmodulepart order by 1 desc;
*/
CREATE PROCEDURE usp_BuildTable_tblmodulepart()
BEGIN
DROP TABLE IF EXISTS `tblmodulepart`;
CREATE TABLE `tblmodulepart` (q	
  `tblmodulepart_pk` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `filepath` varchar(255) DEFAULT NULL,
  `module` varchar(255) DEFAULT NULL,
  `procedure` varchar(255) DEFAULT NULL,
  `code` varchar (2000) DEFAULT NULL,
  `kind`  varchar(255) DEFAULT NULL,
  `loc` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`tblmodulepart_pk`)
) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=latin1;
END $$
DELIMITER ;

-- ------------------------------------------------------------------------------------------

DELIMITER $$
DROP PROCEDURE IF EXISTS  usp_RtnCareGiver;
/*
select uf_Lat('80908');
select usp_Lon('80908');
 
CALL usp_RtnCareGiver(94705,1);
 
SELECT * FROM tblcaregiver;
SELECT * FROM tblclient;
 
DESCRIBE tblzip;
DESCRIBE tblcaregiver;
 
CALL rtnlat(94705,@ReturnedLat);
CALL rtnlon(94705,@ReturnedLon);
 
SELECT * FROM tblzip WHERE
latitude > @ReturnedLat -.25 and
latitude < @ReturnedLat+.25 and
longitude >@ReturnedLon -.25 and
longitude <@ReturnedLon +.25
order by latitude;
 
select * from tblzip where zip5 = 80919
  
*/
CREATE PROCEDURE  usp_RtnCareGiver
(IN input CHAR(5),
IN inputsecond CHAR(5))
DETERMINISTIC
BEGIN
 
CALL uf_Lat(input,@ReturnedLat); 
CALL usp_Lon(input,@ReturnedLon);
 
SELECT * from tblperson c 
JOIN tblzip z ON(z.zip5 = c.Zip5) WHERE
z.latitude > @ReturnedLat -inputsecond and
z.latitude < @ReturnedLat+inputsecond  and
z.longitude >@ReturnedLon -inputsecond  and
z.longitude <@ReturnedLon +inputsecond 
ORDER by z.latitude;
END$$
DELIMITER ;

-- ------------------------------------------------------------------------------------------


 -- ------------------------------------------------------------------------------------------
LOCK TABLES tblclient WRITE;

# Do other queries here

UNLOCK TABLES;

CALL rtnlat(78102,@ReturnedLat);
CALL rtnlon(78102,@ReturnedLon);
select @ReturnedLat, @ReturnedLon;
 
 -- ------------------------------------------------------------------------------------------
 
DELIMITER $$
DROP PROCEDURE IF EXISTS rtnlat;
/*

CALL usp_RtnCareGiver(94705,10);
 
CALL rtnlat(80908,@ReturnedLat);
CALL rtnlon(80908,@ReturnedLon);
 
 select @ReturnedLat, @ReturnedLon;
 
SELECT * FROM tblzip WHERE 
latitude > @ReturnedLat -.25 and
latitude < @ReturnedLat+.25 and
longitude >@ReturnedLon -.25 and
longitude <@ReturnedLon +.25
order by latitude;
 
*/
CREATE PROCEDURE rtnlat(
IN InputZip int,
OUT ReturnedLat Double)
BEGIN
SELECT latitude
INTO ReturnedLat
FROM tblzip
WHERE zip5 = InputZip;
END$$
DELIMITER ;


 -- ------------------------------------------------------------------------------------------
   
DELIMITER $$
DROP PROCEDURE IF EXISTS rtnlon;
/*
 
CALL sp_RtnCareGiver(94705,0);
  
 
CALL rtnlat(78102,@ReturnedLat);

CALL rtnlon(78102,@ReturnedLon);
 
SELECT @ReturnedLat;
SELECT @ReturnedLon;
 
SELECT * FROM tblzip WHERE 
latitude > @ReturnedLat -.50 and
latitude < @ReturnedLat+.50 and
longitude >@ReturnedLon -.50 and
longitude <@ReturnedLon +.50
order by latitude;
  
*/
CREATE PROCEDURE rtnlon(
IN InputZip int,
OUT ReturnedLon Double)
BEGIN
SELECT longitude
INTO ReturnedLon
FROM tblzip
WHERE zip5 = InputZip;
END$$
DELIMITER ;


 -- ------------------------------------------------------------------------------------------


DELIMITER $$
DROP PROCEDURE IF EXISTS  usp_rtnperson;
/*
 
 
CALL usp_rtnperson(78102,1);
 
SELECT * FROM tblperson;
SELECT * FROM tblclient;
 
DESCRIBE tblCustomer;
DESCRIBE tblCareGiver;
 
CALL rtnlat(80908,@ReturnedLat);
CALL rtnlon(80908,@ReturnedLon);
 
SELECT @ReturnedLat;
SELECT @ReturnedLon;
 
SELECT * FROM zipcode WHERE
latitude > @ReturnedLat -.25 and
latitude < @ReturnedLat+.25 and
longitude >@ReturnedLon -.25 and
longitude <@ReturnedLon +.25
order by latitude;
 
 
  
*/
CREATE PROCEDURE  usp_rtnperson
(IN input CHAR(5),
IN inputsecond CHAR(5))
DETERMINISTIC
BEGIN
 
CALL rtnlat(input,@ReturnedLat);
CALL rtnlon(input,@ReturnedLon);
 
SELECT * from tblperson c 
JOIN tblzip z ON(z.zip5 = c.Zip5) WHERE
z.latitude > @ReturnedLat -inputsecond and
z.latitude < @ReturnedLat+inputsecond  and
z.longitude >@ReturnedLon -inputsecond  and
z.longitude <@ReturnedLon +inputsecond 
ORDER by z.latitude;
END$$
DELIMITER ;

  -- ------------------------------------------------------------------------------------------

-- DELIMITER $$
-- DROP PROCEDURE IF EXISTS usp_AddModulePart;
-- /*
-- CALL usp_AddModulePart('filexxxpath','modxxxname','procxxxname','procxxxcode','procxxxkind','h');
-- SELECT * FROM tblmodulepart;
-- */
-- CREATE PROCEDURE usp_AddModulePart(
-- IN InP1 varchar(255),
-- IN InP2 varchar(255),
-- IN InP3 varchar(255),DELIMITER $$
-- CREATE DEFINER=`masterusername23`@`%` PROCEDURE `usp_search`(
-- in tablename varchar(35), 
-- in fieldname varchar(35), 
-- in searchfor varchar(35)
-- )
-- begin
-- set @wildcardsearchfor = concat("%", searchfor, "%");      
-- set @sqlstatement= concat("select * from ", replace(tablename,'`',''), " where ", replace(fieldname,'`',''), " like ?");     
-- prepare stmt from @sqlstatement;    
-- execute stmt using @wildcardsearchfor;
-- deallocate prepare stmt;
-- end$$
-- DELIMITER ;


IN InP4 varchar(2000),
IN InP5 varchar(255),
IN InP6 varchar(255))
BEGIN
SET @InP1:=InP1;
SET @InP2:=InP2;
SET @InP3:=InP3;
SET @InP4:=InP4;
SET @InP5:=InP5;
SET @InP6:=InP6;
PREPARE stmt FROM 'INSERT INTO tblmodulepart (FilePath, Module, `Procedure`, `Code`, Kind, LOC) VALUES (?,?,?,?,?,?)';
EXECUTE stmt USING @InP1, @InP2, @InP3, @InP4, @InP5, @InP6;
DEALLOCATE PREPARE stmt;
END $$
DELIMITER ;
 
  -- ------------------------------------------------------------------------------------------
  DELIMITER $$

CREATE TRIGGER `estatecat_piece`
AFTER INSERT ON `tblCustomer`
FOR EACH ROW
BEGIN
  UPDATE tblCustomer set ConcurrencyID = 1;
END$$

DELIMITER ;

  DROP TRIGGER IF EXISTS tr_fnninio_censopersona_ins;
DELIMITER $$estatecat_pieceestatecat_piece
CREATE TRIGGER tr_fnninio_censopersona_ins
    BEFORE INSERT ON `your_table` FOR EACH ROW
    BEGIN

         SET NEW.INSERTED= NOW();

    END$$
DELIMITER ;
  
    -- ------------------------------------------------------------------------------------------
  delete from customers where id =2;
DELIMITER $$
DROP TRIGGER IF EXISTS customers_preventdeletion;
CREATE TRIGGER customers_preventdeletion
BEFORE DELETE ON customers
FOR EACH ROW
BEGIN

  IF old.id IN (1,2) THEN -- Will only abort deletion for specified IDs
    SIGNAL SQLSTATE '45000' -- "unhandled user-defined exception"
      -- Here comes your custom error message that will be returned by MySQL
      SET MESSAGE_TEXT = 'This record is sacred! You are not allowed to remove it!!';
  END IF;

END$$

DELIMITER ;



CALL rtnlat(78102,@ReturnedLat);
CALL rtnlon(78102,@ReturnedLon);
select @ReturnedLat, @ReturnedLon;
 
 -- ------------------------------------------------------------------------------------------









  


