# Formal Bug Reports (Failed UAT Test Scenarios)
**Project:** Northstar Support Operations System  
**Document Code:** QA-BUG-801  

---

## Overview
This document contains detailed, formal bug reports for all test cases that failed during User Acceptance Testing (`TC-004`, `TC-009`, `TC-014`, `TC-018`). Each report provides step-by-step reproduction instructions, diagnostic stack traces, business impact evaluations, and recommended engineering hotfix actions.

---

## BUG-001: Bulk User Importer Silently Drops Hyphenated Email Addresses

* **Bug ID:** `BUG-001`
* **Related Test Case:** `TC-004`
* **Related Requirement:** `FR-015` (CSV Export/Import)
* **Title:** Bulk User CSV Importer Regex Drops Email Addresses Containing Hyphens
* **Environment:** Staging & Production User Management Service (v2.3.8)
* **Severity:** High
* **Priority:** P2 - High
* **Business Impact:** High — Enterprise customers importing large user rosters silently lose accounts containing hyphens (e.g., `mary-jane@synergymedia.com`), generating immediate Tier 1 support tickets and user access friction.

### Preconditions
User CSV file prepared containing user records with hyphens in the email local-part.

### Steps to Reproduce
1. Log into Admin Portal as SaaS Admin.
2. Navigate to `User Management -> Bulk Import`.
3. Select `users_import_sample.csv` (containing 50 users, 4 of which possess hyphenated emails).
4. Click **Execute Bulk Import**.
5. Inspect import success summary count and database `users` table.

### Expected Behavior
All 50 users should be imported successfully with green confirmation banner stating '50 Users Provisioned'.

### Actual Behavior
Portal reports '46 Users Provisioned'. The 4 users with hyphenated emails are dropped silently with zero error logging or UI notification.

### Diagnostic Analysis & Stack Trace
Review of `UserImportService.java` line 84 reveals the email validation regular expression:
```java
// FLAWED REGEX PATTERN: Omits hyphen character in local part
private static final String EMAIL_REGEX = "^[a-zA-0-9._]+@[a-zA-0-9.]+$";
```

### Suggested Next Action
Update regular expression in `UserImportService.java` to explicitly allow hyphens in the email local-part:
```java
// CORRECTED REGEX PATTERN: Includes hyphen '-'
private static final String EMAIL_REGEX = "^[a-zA-0-9._\-]+@[a-zA-0-9.\-]+$";
```

---

## BUG-002: Expense Report CSV Export Generator Throws 500 Error on Null Categories

* **Bug ID:** `BUG-002`
* **Related Test Case:** `TC-009`
* **Related Requirement:** `FR-002` (Form Validation & Export)
* **Title:** Uncaught NullPointerException in Expense Report CSV String Formatter
* **Environment:** Staging Analytics Reporting Engine (v2.3.8)
* **Severity:** High
* **Priority:** P2 - High
* **Business Impact:** High — Enterprise financial analysts cannot export Q2 expense data to CSV format, blocking monthly ledger reconciliation workflows.

### Preconditions
Expense database table contains expense rows where `expense_category` column is `NULL`.

### Steps to Reproduce
1. Navigate to `Analytics -> Expense Reports`.
2. Select date range filter **Q2 2026**.
3. Select format **CSV**.
4. Click **Export Report**.

### Expected Behavior
CSV file downloads cleanly to user browser with empty string `""` representing NULL categories.

### Actual Behavior
Browser displays an HTTP 500 Internal Server Error page.

### Diagnostic Analysis & Stack Trace
Server application log displays the following stack trace:
```text
java.lang.NullPointerException: Cannot invoke "Object.toString()" because "category" is null
    at com.northstar.analytics.CsvExportService.formatRow(CsvExportService.java:142)
    at com.northstar.analytics.CsvExportService.generateCsv(CsvExportService.java:98)
```

### Suggested Next Action
Add null-safe string check in `CsvExportService.java` line 142:
```java
// CORRECTED NULL CHECK
String categoryStr = (row.getExpenseCategory() != null) ? row.getExpenseCategory().toString() : "";
```

---

## BUG-003: Inventory Sync Dashboard Renders Blank Screen on Safari Browsers

* **Bug ID:** `BUG-003`
* **Related Test Case:** `TC-014`
* **Related Requirement:** `FR-001` (Portal & UI Usability)
* **Title:** Webpack JS Bundle Private Class Field Syntax Crash on Safari 17.4
* **Environment:** Production Web Application Frontend (v2.3.8)
* **Severity:** Medium
* **Priority:** P3 - Medium
* **Business Impact:** Moderate — E-Commerce retail managers attempting to monitor inventory levels using Apple Safari on macOS encounter a non-functional blank screen.

### Preconditions
macOS Sonoma operating system running Apple Safari browser version 17.4.

### Steps to Reproduce
1. Open Safari browser.
2. Log into Northstar platform and navigate to `Inventory Sync Dashboard`.
3. Observe page container.

### Expected Behavior
Dashboard container loads React inventory table and telemetry charts.

### Actual Behavior
Widget container remains completely blank white. Safari Developer Console displays a JavaScript error.

### Diagnostic Analysis & Stack Trace
Safari Web Inspector Console output:
```text
SyntaxError: Private class fields (#privateMethod) are unsupported in this JavaScript engine
    at bundle.main.js:1408
```

### Suggested Next Action
Update `.babelrc` configuration file in frontend Webpack pipeline to target browser matrix including Safari 17+ and compile private ES class fields.

---

## BUG-004: Calendar Scheduling Widget Shifts Appointments During DST Transitions

* **Bug ID:** `BUG-004`
* **Related Test Case:** `TC-018`
* **Related Requirement:** `FR-002` (Application Configuration)
* **Title:** Calendar Date Parsing Omits IANA Timezone Offset During Daylight Saving Window
* **Environment:** Staging Calendar Microservice (v2.3.8)
* **Severity:** High
* **Priority:** P2 - High
* **Business Impact:** High — Healthcare customers (e.g., Beacon Health) scheduling patient appointments in November experience 1-hour appointment display shifts, creating scheduling conflicts.

### Preconditions
Appointment created for November 3, 2026 (Daylight Saving Time transition window).

### Steps to Reproduce
1. Open Patient Scheduling Calendar widget.
2. Create appointment for Nov 3, 2026 at **10:00 AM MT**.
3. Save appointment and refresh calendar view.

### Expected Behavior
Appointment displays at 10:00 AM MT.

### Actual Behavior
Appointment displays 1 hour earlier at 09:00 AM MT.

### Diagnostic Analysis & Stack Trace
API network payload inspection shows date string transmitted without explicit IANA timezone name:
```json
// FLAWED PAYLOAD: Missing IANA timezone string
{"appointment_time": "2026-11-03T10:00:00"}
```

### Suggested Next Action
Update API calendar serializer to enforce inclusion of full IANA timezone parameter (`America/Denver`):
```json
// CORRECTED PAYLOAD
{"appointment_time": "2026-11-03T10:00:00", "timezone": "America/Denver"}
```
