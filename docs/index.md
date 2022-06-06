Raul Tabile

June 4, 2022

IT FDN 130 A Sp 22: Foundations of Databases & SQL Programming

Assignment 07

GitHub - https://github.com/rtabuw/DBFoundations-Module07


## Functions


### Introduction

In this Module we learned about various SQL Functions. I will define when to use SQL User Defined Function (UDF). I will also explain the differences between Scalar, Inline, and Multi-Statement Functions. 


### When to Use SQL User Defined Function (UDF)

The Microsoft Support site defines User Defined Functions (UDF) as, "...routines that accept parameters, perform an action, such as a complex calculation, and return the result of that action as a value. The return value can either be a single scalar value or a result set."

(https://docs.microsoft.com/en-us/sql/relational-databases/user-defined-functions/user-defined-functions?view=sql-server-ver16 - External Site)

I asked my coworker when he would use a User Defined Function and he said to use a UDF, “…when a calculation needs to be used multiple or numerous times.” He also said, from a network traffic standpoint, the caching properties of UDFs reduces network traffic. Being in IT operations, I can understand that.


### Differences Between Scalar, Inline, and Multi-Statement Functions

With much help from the listed online publications, the differences Between Scalar, Inline, and Multi-Statement Functions are as follows:

Scalar Functions

Scalar Functions return a single data value as an expression. The SQLServerTutorial site says, “SQL Server scalar function takes one or more parameters and returns a single value.”

(https://www.sqlservertutorial.net/sql-server-user-defined-functions/sql-server-scalar-functions - External Site)


Inline Functions

I found a great Inline Functions definition in the SQLSunday site. The site says, “If a table value function could be said to work like a stored procedure, an inline function is similar to a view. This means that an inline function can only contain a single SELECT statement, and the columns in the SELECT statement implicitly define the columns of the returned table set of the function.” Of the many definitions I found, this was one of the easiest for me to understand. 

(https://sqlsunday.com/2013/05/05/table-value-vs-inline-table-functions - External Site)
     
Multi-Statement Functions

When I was searching for information on Multi-Statement Functions, just about all my search results were for “Multi-Statement Table-Valued Functions”, or MSTVFs, so I am going to assume (maybe incorrectly) that the two are the same.

Here is how the SQLShack site defines Multi-Statement Table-Valued Functions, “Multi-statement table-valued function returns a table as output and this output table structure can be defined by the user. MSTVFs can contain only one statement or more than one statement. Also, we can modify and aggregate the output table in the function body.” The site also included a useful image showing the differences between a Multi-Statement Table-Valued Function and an Inline Table-Valued Function.

(https://www.sqlshack.com/sql-server-multi-statement-table-valued-functions - External Site)

 


### Summary

In this Module we learned about various SQL Functions. With help from my coworker and various online sites I attempted to state when to use a SQL User Defined Function (UDF). I also attempted to explain the differences between Scalar, Inline, and Multi-Statement Functions. Conceptually, this was a tough Module for me. Luckily, with many online videos and documentation, I have enough information to carefully review the Function  concepts and syntax again. My coworker said that I really need to understand Functions since it is used a lot for reporting purposes, end-user requests, and database administration.    

