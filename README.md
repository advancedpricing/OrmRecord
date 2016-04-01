# OrmRecord

## About

OrmRecord is a object relational mapping library for Xojo (http://www.xojo.com)
developed by Jeremy Cowgar and Kem Tekinay. Advanced Medical Pricing Solutions
(http://www.advancedpricing.com) has sponsored the initial development.

## Parts

There are several parts in the Orm Resources folder that are organized in order of dependency.

### Orm Field Subclasses

A collection of subclasses that can be used to specify field types with finer granularity. For example, there is `OrmDateTime`, a direct subclass of the `Date` class meant to hold a date and time, `OrmDate`, meant to hold only a date, `OrmTime`, meant to hold only a time. These will correspond to specific field types that might be defined in a SQL database and are used by the automatic binding in the database adapters.

### OrmHelpers

A supporting module with methods for other classes.

### Orm Database Adapters

A base class and subclasses designed to sit between your code and a database connection. Through a DbAdapter subclass, you can send the same basic SQL without regard to the underlying database* including creating dynamic prepared statements using the same syntax.

### Orm Database Pool

A class to maintain a minimum pool of database connections. Subclass and implement the `CreateDbAdapter` event to return a new `OrmDbAdapter`. The `OrmDbPool` will take care of the rest.

Set the MinimumInPool to determine the initial Pool and the number that will be maintained for the life of the `OrmDbPool`. Set the `MaximumAllowedAgeInMinutes` if you want database connections to expire after a certain amount of time.

Note: When using `Get` to retrieve a connection, hold onto the `OrmDbAdapter` while you are using it. Once it goes out of scope, it will be returned to the pool automatically.

### OrmRecord

A group of classes that will represent a database record. Subclass `OrmRecord`, create properties that correspond to your table, implement a few events that may be needed, and OrmRecord takes care of the rest.
