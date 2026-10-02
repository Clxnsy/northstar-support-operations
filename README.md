# Northstar Support Operations System

A complete service desk, built from scratch as a portfolio case study. The scenario: Northstar Software Inc., a fictional B2B SaaS company whose support operation is drowning. Tickets arrive by unindexed email, nobody enforces SLAs, root causes go unrecorded, and there is zero operational reporting. This repo is the fix, end to end.

## What is in here
- **Jira Service Management configuration** (`jira/`): 6 request types, 5-state workflows, 8 JQL queues, SLA definitions, and escalation procedures
- **Relational database** (`database/`): a normalized 8-table SQL schema modeling tickets, customers, agents, SLAs, and knowledge base articles
- **25 analytical SQL queries**: ticket volume trends, workload distribution across agents, recurring-issue analysis, SLA compliance and breach reporting
- **Support documentation** (`support/`): knowledge-base articles written the way a real help center writes them
- **Requirements and UAT** (`requirements/`, `testing/`): business requirements, user acceptance test cases, and defect reports
- **Docs** (`docs/`): the full case study narrative, design decisions, and how each piece fits together

## How to use it
This is a build-and-study repo, not a deployable app. Two good ways in:

1. **Read the case study first** (`docs/`), then walk the Jira configuration and SQL schema alongside it.
2. **Run the analytics**: load the schema in `database/` into SQLite or PostgreSQL, seed it with the sample data, and run the queries to see the operational reports a support manager would actually look at.

## Why I built it
I wanted to prove I can think like a support operations analyst, not just close tickets. That means designing intake so nothing gets lost, writing JQL queues that route work to the right people, defining SLAs that match business priorities, and building the reporting that tells you whether the whole thing is working. The SQL layer exists because "the dashboard says so" is never an answer; being able to query your own ticket data is.

## What this project proves
Service-desk design (request types, workflows, queues, SLAs, escalation), Jira Service Management administration, JQL, relational data modeling, analytical SQL (joins, aggregations, window functions), technical writing across KB articles and UAT cases, and the habit of documenting decisions so the next person is not guessing.
