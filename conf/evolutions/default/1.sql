# --- Created by Slick DDL
# To stop Slick DDL generation, remove this comment and start using Evolutions

# --- !Ups

create table "user" ("id" INTEGER GENERATED BY DEFAULT AS IDENTITY(START WITH 1) NOT NULL PRIMARY KEY,"user_login" VARCHAR NOT NULL,"user_password" VARCHAR NOT NULL,"email" VARCHAR NOT NULL,"address1" VARCHAR NOT NULL,"address2" VARCHAR NOT NULL,"city" VARCHAR NOT NULL,"state" VARCHAR NOT NULL,"zip" VARCHAR NOT NULL,"phone1_no" VARCHAR NOT NULL,"phone1_type" VARCHAR NOT NULL);

# --- !Downs

drop table "user";
