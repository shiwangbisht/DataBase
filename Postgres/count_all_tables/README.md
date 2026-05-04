📊 PostgreSQL RDS Row Count Script
📌 Overview

This Bash script connects to a PostgreSQL RDS instance and retrieves the row count for every table across all non-template databases.

It is useful for:

Database analysis
Migration validation
Data auditing
Capacity planning
⚙️ Prerequisites
psql installed on your system
Network access to the PostgreSQL RDS instance
Valid database credentials with read access to all databases
📂 Script Functionality

The script performs the following steps:

Accepts RDS connection details as input
Connects to the default postgres database
Fetches all non-template databases (excluding rdsadmin)
Iterates through each database
Retrieves all user tables (excluding system schemas)
Executes COUNT(*) on each table
Prints row count per table
🚀 Usage
chmod +x row_count.sh

./row_count.sh <RDS_HOST> <RDS_USER> <RDS_PASSWORD> [PORT]
Example:
./row_count.sh mydb.xxxxxx.ap-south-1.rds.amazonaws.com admin password123 5432
🧾 Parameters
Parameter	Description	Required	Default
RDS_HOST	PostgreSQL RDS endpoint	✅	—
RDS_USER	Database username	✅	—
RDS_PASSWORD	Database password	✅	—
RDS_PORT	PostgreSQL port	❌	5432
📤 Sample Output
========================================
Starting Row Count on Server: mydb.xxx
========================================

----------------------------------------
Database: my_app_db
----------------------------------------
public.users --> 1050 rows
public.orders --> 5420 rows
public.products --> 230 rows

----------------------------------------
Database: analytics_db
----------------------------------------
public.events --> 104500 rows

Row count completed.
⚠️ Notes & Considerations
⚡ COUNT(*) on large tables can be slow and resource-intensive
🔒 Ensure minimal impact when running on production databases
🕒 Prefer running during off-peak hours
📉 For faster results, consider using pg_class.reltuples (approximate count)
🔐 Security Best Practices
Avoid passing passwords directly in CLI (can be exposed in history)
Use environment variables or .pgpass file for better security
Restrict database access using least privilege principle
🛠️ Enhancements (Future Scope)
Export results to CSV/JSON
Parallel execution for faster processing
Filter specific schemas or tables
Add logging & error handling
👨‍💻 Author

DevOps/SRE focused utility script for database introspection.
