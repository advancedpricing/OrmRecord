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

A base class and subclasses designed to 