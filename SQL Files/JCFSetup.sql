# Drop the tables
set foreign_key_checks = 0 ;

drop table Name ;
drop table Person ;
drop table Address ;
drop table Witness ;
drop table Officer ;
drop table Actor ;
drop table Report ;
drop table Incident ;
drop table PhoneNumber ;

# Create the required tables
create table if not exists Name(
   id     integer       not null auto_increment,
   first  varchar(30)   not null, 
   middle varchar(100),
   last   varchar(50)   not null, 
   prefix varchar(10),
   suffix varchar(10),
   constraint pk_id primary key( id ) ) ;
create table if not exists Person(
   id        integer auto_increment not null,
   n_id      integer                not null ,
   birthDate date                   not null,
   height    double                 not null,
   weight    integer                not null,
   hairColor varchar(30),
   feature   varchar(200),
   constraint fk_nid   foreign key( n_id ) references Name( id ),
   constraint pk_id_bd primary key( id, birthDate ) ) ;   
create table if not exists Address(
   id       integer auto_increment not null,
   number   integer                not null,
   street   varchar(100)           not null,
   city     varchar(50)            not null,
   parish   varchar(50)            not null,
   district integer                not null,
   constraint pk_id_addr primary key( id, number, street, city, parish, district ) ) ;   
create table if not exists Witness(
   id        integer auto_increment not null,
   p_id      integer                not null,
   a_id      integer                not null,
   homePhone varchar(20),
   cellPhone varchar(20),
   workPhone varchar(20),
   constraint fk_pid  foreign key( p_id ) references Person( id ),
   constraint fk_addr foreign key( a_id ) references Address( id ),
   constraint pk_id   primary key( id ) ) ;   
create table if not exists Officer(
   id   integer auto_increment not null,
   p_id integer                not null,
   rank enum(
      'COMMISSIONER',
      'CHIEF',
      'SUPERINTENDENT',
      'INSPECTOR',
      'CAPTAIN',
      'LIEUTENANT',
      'SERGENT',
      'CORPORAL',
      'CONSTABLE' )            not null,
   precinct    integer(3)      not null,
   badgeNumber integer         not null,
   constraint fk_o_pid foreign key( p_id ) references Person( id ),
   constraint pk_id  primary key( id ) ) ;   
create table if not exists Actor(
   id        integer auto_increment not null,
   p_id      integer                not null,
   a_id      integer                not null,
   homePhone varchar(20),
   cellPhone varchar(20),
   workPhone varchar(20),
   constraint fk_a_pid foreign key( p_id ) references Person( id ),
   constraint fk_aid foreign key( a_id ) references Address( id ),
   constraint pk_id primary key( id ) ) ;
create table if not exists Report(
   id   integer       not null auto_increment,
   text varchar(2000) not null,
   constraint pk_id primary key( id ) ) ;   
create table if not exists Incident(
   id      integer not null auto_increment,
   o_id    integer not null,
   a_id    integer not null,
   w_id    integer,
   r_id    integer not null,
   addr_id integer not null,
   itime   time    not null,
   idate   date    not null,
   constraint fk_i_oid foreign key( o_id ) references Officer( id ),
   constraint fk_i_aid foreign key( a_id ) references Address( id ),
   constraint fk_i_wid foreign key( w_id ) references Witness( id ),
   constraint fk_i_rid foreign key( r_id ) references Report( id ),
   constraint fk_addrid foreign key( addr_id ) references Address( id ),
   constraint pk_id primary key( id ) ) ;
create table if not exists PhoneNumber(
   id       integer    not null auto_increment,
   areaCode integer(3) not null,
   prefix   integer(3) not null,
   suffix   integer(4) not null,
   constraint pk_id_aps primary key( id, areaCode, prefix, suffix ) ) ;
   
# Load tables with sample data located in the projects SampleData directory.
# The load command cannot take a variable as the input file name unfortunately
# so these file names must be hard coded. I will need to investigate whether
# there is some way of using a variable for the file name.
set @SampleDataDir = "/home/garfield/workspace/com.jcf.incidentreport/SampleData" ;

load data local infile '/home/garfield/workspace/com.jcf.incidentreport/SampleData/Names.txt' replace into table Name fields terminated by '|' ;
load data local infile '/home/garfield/workspace/com.jcf.incidentreport/SampleData/Persons.txt' replace into table Person fields terminated by '|' ;
load data local infile '/home/garfield/workspace/com.jcf.incidentreport/SampleData/Addresses.txt' replace into table Address fields terminated by '|' ;
load data local infile '/home/garfield/workspace/com.jcf.incidentreport/SampleData/Witnesses.txt' replace into table Witness fields terminated by '|' ;
load data local infile '/home/garfield/workspace/com.jcf.incidentreport/SampleData/Officers.txt' replace into table Officer fields terminated by '|' ;
load data local infile '/home/garfield/workspace/com.jcf.incidentreport/SampleData/Actors.txt' replace into table Actor fields terminated by '|' ;
load data local infile '/home/garfield/workspace/com.jcf.incidentreport/SampleData/Reports.txt' replace into table Report fields terminated by '|' ;
load data local infile '/home/garfield/workspace/com.jcf.incidentreport/SampleData/Incidents.txt' replace into table Incident fields terminated by '|' ;
load data local infile '/home/garfield/workspace/com.jcf.incidentreport/SampleData/PhoneNumbers.txt' replace into table PhoneNumber fields terminated by '|' ;