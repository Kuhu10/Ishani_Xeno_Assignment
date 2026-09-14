**APPROACH FOLLOWED**

Followed a Profile → Decompose → Reconcile → Validate approach.

**1. Profile the data**
Looked at the tables to get familiarized with structure, relationships, Parent-Child hierarchies, distinct values, date fields & status fields, and possible dupes.

**2. Decompose the problem**
Divided up the question that I had into smaller questions instead of one large query that would have to be issued to get the final number. From the naive population, I individually mapped out each business rule and eligibility condition to find out what, why, and how records change.

**3. Build the reconciliation**
Added one rule at a time and built a sort of bridge between the initial and the final population:
Naive Count → Rule 1 → Rule 2 → ... → Final Count
Each step was recorded in a dedicated SQL query with output metrics

**4. Validate the result**
Verified intermediate outputs, joins and the filtering logic at each stage to ensure that the number that was output by the query was not merely a query output but fully explainable.

**REPO STRUCTURE**

**Final Query** ➔ finalized_query.sql

**Reconciliation Bridge Table** ➔ reconciliation_bridge.md

**Step-by-Step Reconciliation Queries** ➔ reconciliation_queries/

**Raw Database** ➔ comm_log.db
