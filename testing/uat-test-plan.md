# User Acceptance Testing (UAT) Master Test Plan
**Project:** Northstar Support Operations System  
**Document Code:** UAT-TP-701  
**Author:** Lead QA Analyst / Business Systems Analyst  

---

## 1. Executive Summary
This User Acceptance Testing (UAT) Plan defines the testing strategy, criteria, environmental setup, and test suite execution required to validate the Northstar Support Operations platform. The primary objective is to verify that the Jira Service Management portal, automated routing queues, SLA engines, SQL analytics warehouse, and knowledge base deflection perform in compliance with the Functional Requirements (`FR-001` through `FR-015`) and Business Requirements.

---

## 2. Testing Objectives & Scope

### In-Scope Functional Areas
1. **Customer Request Portal:** Submission validation across all 6 request types, mandatory field enforcement, real-time KB deflection.
2. **JSM Workflow State Machine:** State transitions (`Open` -> `In Progress` -> `Waiting for Customer` -> `Escalated` -> `Resolved`), SLA clock auto-pause/resume.
3. **Queue Auto-Routing:** Verification that tickets enter target functional queues based on metadata rules.
4. **Data Warehouse Integrity & Analytics:** Execution of 25 relational SQL queries against SQLite/PostgreSQL sample dataset.
5. **Role-Based Access Control (RBAC):** Isolation of customer ticket visibility and restricted queue privileges.

### Out-of-Scope
* Load testing above 50,000 concurrent web portal submission sessions.
* Live credit card processing against production Stripe endpoints.

---

## 3. Test Strategy & Execution Protocol
* **Test Case Methodology:** Black-box end-to-end scenario testing executed by cross-functional roles (QA Analysts, Support Agents, B2B Admins).
* **Defect Logging Protocol:** Any test resulting in an `Actual Result` that deviates from `Expected Result` must be marked as `FAIL` and logged as a formal Bug Report in `bug-reports.md`.

---

## 4. Entry and Exit Criteria

### UAT Entry Criteria
* [x] Jira Service Management project `NS` fully provisioned with request types, workflows, and SLA policies.
* [x] SQL schema DDL (`schema.sql`) and sample dataset (`sample-data.sql`) successfully deployed and verified.
* [x] Test environment seeded with fictional B2B customer accounts and user profiles.

### UAT Exit Criteria
* [x] 100% of defined 20 UAT Test Cases executed.
* [x] Minimum 80% test pass rate achieved (16/20 Passed).
* [x] 100% of critical P1/P2 failed test cases backed by formal Bug Reports (`BUG-001` through `BUG-004`) with engineering hotfix pathways.
