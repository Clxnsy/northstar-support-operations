# Technical Support Lab — 25 Detailed Troubleshooting Scenarios
**Project:** Northstar Support Operations System  
**Document Code:** TSL-501  

---

## Overview
This document contains 25 highly detailed, logically realistic troubleshooting scenarios covering the full spectrum of SaaS application support operations: authentication, permissions, database data corruption, software defects, API integrations, network security, and billing gateways.

---

## TS-001: MFA Code Rejection Loop on Primary Admin Account
**Category:** MFA / Authentication  

### 1. Reported Symptoms
Admin user enters valid TOTP authenticator code, but receives 'Invalid MFA Token (ERR-401)' error on every attempt.

### 2. Initial Diagnostic Questions
1. Has the device time changed recently? 2. Is this occurring across multiple browser sessions? 3. Are other admins on your tenant affected?

### 3. Troubleshooting & Investigation Process
Step 1: Check user identity in user management database. Step 2: Review auth server logs for `auth-prod-02`. Step 3: Run NTP sync diagnostic tool on server cluster. Step 4: Verify time drift offset.

### 4. Diagnostic Reasoning & Technical Analysis
TOTP algorithm relies on time-based HMAC calculation with a 30-second window. A 45-second clock drift on server node `auth-prod-02` invalidated generated tokens.

### 5. Identified Root Cause
**Infrastructure / Server Time Drift on Auth Cluster Node**

### 6. Corrective Action & Resolution
Resynced NTP daemon on auth server cluster node `auth-prod-02`. Reset user failed lockout counter in `users` table.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 Systems Operations if NTP resync fails or time drift recurs within 1 hour.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> NTP time drift of +45s observed on auth-prod-02. Resynced via `ntpdate pool.ntp.org`. Cleared lockout flag for john.doe@acme.com in DB.

### 9. Customer-Facing Response
```text
Dear John, We have resolved an internal server clock sync issue that affected multi-factor authentication codes. Please attempt to log in now with a fresh TOTP code.
```

### 10. Recommended Knowledge Base Article
* [KB-005: Resolving Multi-Factor Authentication (MFA) Login Errors](knowledge-base/)

---

## TS-002: Newly Provisioned Role Lacks Module Access Rights
**Category:** User Permissions / Account Access  

### 1. Reported Symptoms
User assigned 'Dispatch Manager' role in admin portal receives '403 Forbidden' screen when clicking Fleet Module.

### 2. Initial Diagnostic Questions
1. What exact role was assigned in the admin portal? 2. Has the user logged out and back in since role assignment?

### 3. Troubleshooting & Investigation Process
Step 1: Inspect `users` table for assigned role ID. Step 2: Query `role_permissions` join table in DB. Step 3: Identify missing permission record `FLEET_READ_WRITE`.

### 4. Diagnostic Reasoning & Technical Analysis
The admin portal UI sent the role update request, but a database lock during peak traffic caused the secondary mapping transaction to rollback silently.

### 5. Identified Root Cause
**Database State / Incomplete Role Mapping Transaction**

### 6. Corrective Action & Resolution
Executed manual permission sync macro in admin portal and refreshed user RBAC session cache.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 Application Support if database permission re-sync fails to grant module access.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Queried `role_permissions` for User s.connor@apexlogistics.com. Role ID 4 lacked FK join. Re-synced via admin CLI script `sync-rbac.sh`.

### 9. Customer-Facing Response
```text
Hi Sarah, Your role permissions for Fleet Tracking have been fully resynchronized in the system. Please log out and log back in to access the module.
```

### 10. Recommended Knowledge Base Article
* [KB-004: Managing User Roles & Module Permissions](knowledge-base/)

---

## TS-003: CSV Report Export Crashes with 500 Server Error
**Category:** Software Errors / Analytics  

### 1. Reported Symptoms
Navigating to Expense Analytics, selecting 'CSV Export', results in HTTP 500 error page.

### 2. Initial Diagnostic Questions
1. Does the error occur on all date ranges or only Q2 2026? 2. Does exporting as XLSX format work?

### 3. Troubleshooting & Investigation Process
Step 1: Replicate in staging environment with customer dataset. Step 2: Inspect application log for stack trace. Step 3: Identify `NullPointerException` at line 142 of `CsvExportService.java`.

### 4. Diagnostic Reasoning & Technical Analysis
Records in `expenses` table contained NULL in `expense_category`. The CSV string formatter lacked a null check before calling `.toString()`.

### 5. Identified Root Cause
**Software Defect / Unhandled Null Pointer Exception in CSV Formatter**

### 6. Corrective Action & Resolution
Provided immediate workaround (Export as XLSX format). Created bug report `BUG-001` for Tier 3 Engineering hotfix.

### 7. Escalation Criteria & Handover Protocol
Escalate immediately to Tier 3 Engineering for backend hotfix patch.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Replicated NullPointerException on null expense_category. Logged bug BUG-001. Advised customer to use XLSX export as temporary workaround.

### 9. Customer-Facing Response
```text
Hello Robert, We have identified a software defect in the CSV export generator when processing blank expense categories. Our engineering team is deploying a fix. In the meantime, please use 'Export as XLSX' which functions normally.
```

### 10. Recommended Knowledge Base Article
* [KB-007: Reporting Software Bugs & Workaround Procedures](knowledge-base/)

---

## TS-004: Duplicate Invoices Generated During Billing Run
**Category:** Data Discrepancies / Billing  

### 1. Reported Symptoms
Customer account displays two identical $4,500 monthly invoices generated within 2 seconds of each other.

### 2. Initial Diagnostic Questions
1. Were both invoices charged to the credit card? 2. What are the exact invoice numbers?

### 3. Troubleshooting & Investigation Process
Step 1: Query `accounts` and `invoices` tables for `CUST-004`. Step 2: Review billing cron worker job logs. Step 3: Identify network timeout retry triggering secondary insert.

### 4. Diagnostic Reasoning & Technical Analysis
The billing microservice retried a delayed payment API call without verifying whether the original database transaction had committed.

### 5. Identified Root Cause
**Software Defect / Lack of Billing Idempotency Key**

### 6. Corrective Action & Resolution
Voided duplicate invoice `INV-8802` in accounting ledger and issued credit memo. Submitted engineering request for idempotency key implementation.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 Application Analyst / Billing Lead for ledger adjustment.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Voided INV-8802 in production DB via `UPDATE invoices SET status = 'Void' WHERE invoice_id = 'INV-8802'`. Issued credit memo.

### 9. Customer-Facing Response
```text
Dear Emily, We have voided the duplicate invoice INV-8802. Your account balance accurately reflects a single charge. We apologize for the inconvenience.
```

### 10. Recommended Knowledge Base Article
* [KB-008: Reviewing Account Invoices & Payment History](knowledge-base/)

---

## TS-005: Credit Card Update Failing with Gateway Error ERR-PAY-902
**Category:** Integration Problems / Billing  

### 1. Reported Symptoms
Updating payment details fails with error 'Gateway Response: Invalid Payment Method Token (ERR-PAY-902)'.

### 2. Initial Diagnostic Questions
1. Are you using a corporate credit card? 2. Is browser ad-blocking or popup blocking active?

### 3. Troubleshooting & Investigation Process
Step 1: Inspect Stripe integration webhook logs. Step 2: Observe expired authorization token error. Step 3: Test credit card form in incognito window.

### 4. Diagnostic Reasoning & Technical Analysis
Stripe iframe token expired due to browser cache storing old session state or browser extension blocking Stripe token JS snippet.

### 5. Identified Root Cause
**External Dependency / Expired Stripe Session Token in Local Cache**

### 6. Corrective Action & Resolution
Instructed customer to clear browser cache and update payment method in an incognito window.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 if incognito submission fails with same token error.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Stripe token expiry error ERR-PAY-902 in logs. Advised customer on browser cache clearance and incognito update.

### 9. Customer-Facing Response
```text
Hi Michael, This error occurs when your browser stores an expired security token from our payment processor. Please try updating your payment details using an Incognito / Private browsing window.
```

### 10. Recommended Knowledge Base Article
* [KB-003: Clearing Browser Cache & Resolving Web Portal Errors](knowledge-base/)

---

## TS-006: SAML SSO Assertion Verification Failure
**Category:** Application Configuration / SSO  

### 1. Reported Symptoms
All users attempting SAML SSO receive 'SAML Assertion Signature Verification Failed' error screen.

### 2. Initial Diagnostic Questions
1. Did your IT department recently update your Identity Provider (Azure AD/Okta)? 2. Was a new signing certificate generated?

### 3. Troubleshooting & Investigation Process
Step 1: Inspect application SSO audit log. Step 2: Compare public key fingerprint in SAML assertion XML against stored certificate string. Step 3: Detect fingerprint mismatch.

### 4. Diagnostic Reasoning & Technical Analysis
Customer IT renewed their Azure AD SAML signing certificate but neglected to paste the updated X.509 public key into the Northstar SSO settings dashboard.

### 5. Identified Root Cause
**Customer Misconfiguration / Outdated Identity Provider X.509 Certificate**

### 6. Corrective Action & Resolution
Updated customer SSO configuration with new X.509 public key certificate string provided by customer IT.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 Application Support Analyst if certificate mismatch persists.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> SAML fingerprint mismatch logged. Uploaded renewed Azure AD X.509 cert to customer SSO config profile. Tested SSO login successfully.

### 9. Customer-Facing Response
```text
Dear Amanda, The SAML SSO failure occurred because the signing certificate stored in Northstar did not match your renewed Azure AD certificate. We have updated the certificate string, and SSO login is now fully restored.
```

### 10. Recommended Knowledge Base Article
* [KB-009: Configuring SAML 2.0 Single Sign-On (SSO)](knowledge-base/)

---

## TS-007: Bulk User Import Silently Dropping Hyphenated Emails
**Category:** Software Errors / Ingestion  

### 1. Reported Symptoms
CSV import of 50 users silently drops 4 records without displaying an error message.

### 2. Initial Diagnostic Questions
1. What common characteristics do the dropped user rows share? 2. Does the CSV contain special characters or hyphens?

### 3. Troubleshooting & Investigation Process
Step 1: Extract dropped user rows from customer CSV. Step 2: Test CSV parser in staging environment. Step 3: Inspect `UserImportService.java` regex validation code.

### 4. Diagnostic Reasoning & Technical Analysis
Email validation regex pattern `^[a-zA-0-9._]+@[a-zA-0-9.]+$` omitted the hyphen `-` character, causing silent validation rejection.

### 5. Identified Root Cause
**Software Defect / Overly Restrictive Regex Pattern in Import Validator**

### 6. Corrective Action & Resolution
Manually inserted dropped hyphenated users into database. Submitted bug report for regex patch deployment.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 3 Engineering for regex patch deployment.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Identified regex flaw in UserImportService regex pattern. Inserted dropped users manually via SQL `INSERT INTO users...`.

### 9. Customer-Facing Response
```text
Hello Mary, We discovered that our bulk import validator was rejecting email addresses containing hyphens. We have manually added the 4 dropped users to your tenant and submitted a patch to permanently fix the importer.
```

### 10. Recommended Knowledge Base Article
* [KB-007: Reporting Software Bugs & Workaround Procedures](knowledge-base/)

---

## TS-008: Password Reset Link Expiring Instantly Upon Generation
**Category:** Network / Security Integration  

### 1. Reported Symptoms
User receives 'Forgot Password' email, but clicking the link immediately shows 'Token Expired or Invalid'.

### 2. Initial Diagnostic Questions
1. Does your corporate email server utilize Proofpoint, Mimecast, or Microsoft Defender link-scanning?

### 3. Troubleshooting & Investigation Process
Step 1: Inspect password reset token audit table. Step 2: Observe token consumption timestamp matching email dispatch timestamp within 200ms. Step 3: Identify link-scanning bot IP address.

### 4. Diagnostic Reasoning & Technical Analysis
Corporate email security scanner pre-evaluated incoming links to check for phishing, consuming the single-use GET reset token before the user clicked it.

### 5. Identified Root Cause
**Customer Email Security Scanner (Link Pre-Fetching)**

### 6. Corrective Action & Resolution
Updated reset link architecture to require a secondary confirmation button click (POST request) before consuming token. Advised customer IT to bypass scanner for reset URL.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 Application Analyst for security architecture evaluation.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Proofpoint link pre-fetch consumed token on GET request. Configured POST landing page confirmation to prevent scanner consumption.

### 9. Customer-Facing Response
```text
Dear Emily, Your corporate email scanner was pre-visiting the password reset link to inspect it, consuming the single-use token. We have updated our reset process to require a confirmation click on the landing page to prevent this.
```

### 10. Recommended Knowledge Base Article
* [KB-002: Troubleshooting Login & Password Reset Issues](knowledge-base/)

---

## TS-009: Dashboard Telemetry Displaying Blank Zeroes for Specific Date
**Category:** Data Discrepancies / Pipeline  

### 1. Reported Symptoms
Fleet metrics dashboard displays 0 assets and 0 miles driven for entire date of July 14th.

### 2. Initial Diagnostic Questions
1. Are surrounding dates (July 13, July 15) displaying telemetry correctly?

### 3. Troubleshooting & Investigation Process
Step 1: Check Kafka pipeline consumer group status for July 14th. Step 2: Inspect dead-letter queue (DLQ) in data pipeline. Step 3: Identify 14,000 unparsed telemetry JSON messages.

### 4. Diagnostic Reasoning & Technical Analysis
A temporary Kafka broker partition rebalance stalled the consumer thread, redirecting telemetry payloads to the dead-letter queue.

### 5. Identified Root Cause
**Data Pipeline / Unprocessed Kafka Dead-Letter Queue**

### 6. Corrective Action & Resolution
Executed DLQ re-processing script `replay-dlq.py` to ingest July 14th telemetry into the reporting database view.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 Data Operations for pipeline queue replay.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Replayed 14,000 DLQ telemetry events for CUST-002. Verified database record counts for July 14th matched expected daily averages.

### 9. Customer-Facing Response
```text
Hi Sarah, The missing July 14th telemetry data was held in a processing queue following a brief system rebalance. We have reprocessed these records, and your dashboard now accurately reflects all activity.
```

### 10. Recommended Knowledge Base Article
* [KB-006: Checking System Status & Data Pipeline Operations](knowledge-base/)

---

## TS-010: Mobile App Session Timeout Logging Out Users Every 5 Minutes
**Category:** Application Configuration / Cookies  

### 1. Reported Symptoms
Warehouse supervisors using handheld devices are forced to re-authenticate every 5 minutes.

### 2. Initial Diagnostic Questions
1. Does this occur on desktop computers or only handheld mobile web terminals? 2. Are devices switching between Wi-Fi access points?

### 3. Troubleshooting & Investigation Process
Step 1: Inspect application session cookie headers. Step 2: Observe `SameSite=Strict` and IP binding enforcement. Step 3: Track IP changes as handhelds roam Wi-Fi zones.

### 4. Diagnostic Reasoning & Technical Analysis
Mobile devices changing IP addresses during Wi-Fi access point roaming invalidated session cookies bound by strict IP check policies.

### 5. Identified Root Cause
**Application Configuration / Overly Restrictive Mobile Cookie Policy**

### 6. Corrective Action & Resolution
Updated tenant session policy configuration to allow roaming IP session persistence for designated mobile user-agent profiles.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 Support Analyst for tenant policy configuration modification.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Modified session cookie security profile for CUST-002 mobile user-agent string. Set `SameSite=Lax` and enabled subnet session binding.

### 9. Customer-Facing Response
```text
Hello Sarah, We have adjusted the session persistence settings for your handheld mobile devices so that roaming between warehouse Wi-Fi access points will no longer force an immediate logout.
```

### 10. Recommended Knowledge Base Article
* [KB-001: Resetting Passwords & Managing User Sessions](knowledge-base/)

---

## TS-011: General Ledger Account Code Mapping Shifted by One Column
**Category:** Incorrect Database Records / Data Ingestion  

### 1. Reported Symptoms
Executive dashboard displays Revenue amounts under Expense accounts after nightly sync.

### 2. Initial Diagnostic Questions
1. Was a new GL code added to your ERP system yesterday? 2. Did the nightly sync complete with warnings?

### 3. Troubleshooting & Investigation Process
Step 1: Review raw incoming CSV file from customer nightly SFTP upload. Step 2: Identify unescaped comma in department string `'Marketing, East'`. Step 3: Observe array index offset during parse.

### 4. Diagnostic Reasoning & Technical Analysis
Unescaped comma inside quotes in customer raw data caused naive string splitting `.split(',')` to offset all subsequent array columns by 1 position.

### 5. Identified Root Cause
**Data Ingestion / Non-Compliant CSV Parsing without RFC-4180 Quote Escaping**

### 6. Corrective Action & Resolution
Updated ingestion service to use strict RFC-4180 quote-aware CSV parser. Executed SQL correction script to restore valid GL code mapping.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 Application Support Analyst for database data correction execution.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Re-parsed ingestion file using quote-aware parser. Updated `gl_account_mapping` table via correction script `fix-gl-codes.sql`.

### 9. Customer-Facing Response
```text
Dear Robert, An unescaped comma in a department description field caused our nightly file parser to misalign column values. We have corrected the parser and restored your GL account mapping.
```

### 10. Recommended Knowledge Base Article
* [KB-010: Exporting Audit Logs & Data Synchronization Guides](knowledge-base/)

---

## TS-012: Safari Browser Displays Blank White Screen on Inventory Dashboard
**Category:** Browser / Cache / Frontend Bug  

### 1. Reported Symptoms
Inventory Sync widget fails to load on macOS Safari 17.4, displaying blank white container.

### 2. Initial Diagnostic Questions
1. Does the dashboard work properly when accessed via Chrome or Firefox? 2. Are there JavaScript errors in the Safari developer console?

### 3. Troubleshooting & Investigation Process
Step 1: Open Safari Developer Console. Step 2: Inspect JS console log. Step 3: Identify `SyntaxError: Private class fields (#field) are unsupported in this Safari version`.

### 4. Diagnostic Reasoning & Technical Analysis
Webpack frontend build configuration omitted Babel polyfills for private ES class fields on older Safari JavaScript engines.

### 5. Identified Root Cause
**Software Defect / Uncompiled JavaScript Private Class Field Syntax**

### 6. Corrective Action & Resolution
Provided temporary workaround (use Chrome/Edge browser). Submitted bug report for Webpack Babel transpilation fix.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 3 Engineering for Webpack build hotfix patch.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Webpack JS transpilation error on Safari 17.4. Created bug report. Workaround: Chrome/Firefox.

### 9. Customer-Facing Response
```text
Hi Michael, We have isolated a JavaScript compatibility issue specific to Safari 17.4. Our engineering team is preparing a hotfix. In the meantime, accessing the dashboard via Google Chrome or Mozilla Firefox provides full functionality.
```

### 10. Recommended Knowledge Base Article
* [KB-003: Clearing Browser Cache & Resolving Web Portal Errors](knowledge-base/)

---

## TS-013: Calendar Appointments Shifted by 1 Hour During DST Transition Window
**Category:** Software Defects / Date Parsing  

### 1. Reported Symptoms
Appointments scheduled for November 2026 display 1 hour earlier on calendar widget.

### 2. Initial Diagnostic Questions
1. What timezone is set in your user profile? 2. Are appointments booked in UTC or local time?

### 3. Troubleshooting & Investigation Process
Step 1: Inspect API payload for calendar events. Step 2: Observe date string `'2026-11-03T10:00:00'` passed without explicit timezone offset. Step 3: Test date parsing logic.

### 4. Diagnostic Reasoning & Technical Analysis
Frontend date library parsed local ISO strings assuming current Daylight Saving Time offset rather than target date's Standard Time offset.

### 5. Identified Root Cause
**Software Defect / Timezone Parsing Discrepancy in Calendar Front-End Widget**

### 6. Corrective Action & Resolution
Updated calendar widget API call to strictly pass IANA timezone string (`America/New_York`). Hotfix v2.4.2 deployed.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 3 Engineering for date parsing patch.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Applied patch v2.4.2 enforcing explicit IANA timezone parsing on calendar widget.

### 9. Customer-Facing Response
```text
Dear Emily, We have deployed hotfix v2.4.2 which resolves the Daylight Saving Time timezone offset calculation on November appointments. All calendar events now display at their correct local time.
```

### 10. Recommended Knowledge Base Article
* [KB-007: Reporting Software Bugs & Workaround Procedures](knowledge-base/)

---

## TS-014: API Key Generation Tool Throws 500 Error for Non-Superadmin Users
**Category:** User Permissions / API Backend  

### 1. Reported Symptoms
Developer role users attempting to create API keys receive '500 Internal Server Error'.

### 2. Initial Diagnostic Questions
1. Does the issue occur when Superadmin generates an API key? 2. What exact role is assigned to the developer?

### 3. Troubleshooting & Investigation Process
Step 1: Check backend API server log for HTTP 500 event. Step 2: Observe SQL constraint violation error `NOT NULL constraint failed: api_keys_audit.created_by_user_id`.

### 4. Diagnostic Reasoning & Technical Analysis
The backend controller failed to pass the non-superadmin caller's `user_id` context variable when creating the API key audit log record.

### 5. Identified Root Cause
**Software Defect / Missing Audit Context Variable in API Key Controller**

### 6. Corrective Action & Resolution
Patched API controller logic to ensure caller user ID is extracted and passed to audit table constraint. Deployed patch v2.4.3.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 Application Analyst / Tier 3 Engineering.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Backend API controller fix applied. Verified API key generation for non-superadmin developer roles.

### 9. Customer-Facing Response
```text
Hello David, We have patched the API key generation tool to properly record audit logs for Developer role users. You can now generate API keys without error.
```

### 10. Recommended Knowledge Base Article
* [KB-004: Managing User Roles & Module Permissions](knowledge-base/)

---

## TS-015: Analytics Storage Quota Warning Triggered in Error
**Category:** Application Configuration / Cron Query  

### 1. Reported Symptoms
Account receives email warning 'Analytics Storage at 98% Capacity', but UI dashboard shows 42 GB / 500 GB used.

### 2. Initial Diagnostic Questions
1. Did your team recently execute large ad-hoc reporting queries?

### 3. Troubleshooting & Investigation Process
Step 1: Inspect SQL query in quota monitoring cron job. Step 2: Observe query target table `temp_analytics_scratch` instead of `production_analytics_storage`.

### 4. Diagnostic Reasoning & Technical Analysis
The monitoring cron job queried an un-cleared temporary scratch table used during nightly aggregations rather than the permanent tenant storage table.

### 5. Identified Root Cause
**Application Logic / Misconfigured Target Table in Storage Quota Cron Job**

### 6. Corrective Action & Resolution
Corrected storage quota cron query to target production tenant storage tables. Cleared temporary scratch table.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 1 Support Lead / Tier 2 Analyst.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Updated quota cron SQL query in production script `check-storage-quotas.sql`. Cleared false warning alert flag.

### 9. Customer-Facing Response
```text
Hi Mary, The storage quota alert was triggered in error due to a misconfigured monitoring script inspecting temporary reporting tables. Your account has used only 42 GB of your 500 GB quota.
```

### 10. Recommended Knowledge Base Article
* [KB-006: Checking System Status & Data Pipeline Operations](knowledge-base/)

---

## TS-016: LDAP Active Directory Sync Dropping New Store Manager Accounts
**Category:** Integration Problems / Authentication  

### 1. Reported Symptoms
Store managers added to local Active Directory group `Northstar-Users` cannot log in via LDAP integration.

### 2. Initial Diagnostic Questions
1. Are new store managers located in a newly created Organizational Unit (OU) in Active Directory?

### 3. Troubleshooting & Investigation Process
Step 1: Inspect LDAP sync diagnostic logs. Step 2: Identify error `LDAP Search Base String Truncated (Max 256 Chars)`.

### 4. Diagnostic Reasoning & Technical Analysis
The LDAP Base DN search string exceeded the 256-character length limit in Northstar configuration settings due to deep nested OUs.

### 5. Identified Root Cause
**Application Configuration / LDAP Search Path Character Limit Constraint**

### 6. Corrective Action & Resolution
Updated LDAP configuration string to use a broader parent DN search path, reducing total path string length.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 1 Support / Tier 2 Integration Analyst.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Shortened LDAP Base DN string in tenant config. Triggered manual LDAP directory sync. Verified store manager user imports.

### 9. Customer-Facing Response
```text
Dear Michael, Your Active Directory OU path exceeded the character limit in our LDAP integration configuration. We have simplified the search string, and all new store manager accounts are now synchronized.
```

### 10. Recommended Knowledge Base Article
* [KB-009: Configuring SAML 2.0 & Active Directory Integrations](knowledge-base/)

---

## TS-017: Sales Tax Incorrectly Applied to Tax-Exempt Account Invoice
**Category:** Billing / External Integration  

### 1. Reported Symptoms
Monthly invoice INV-9021 includes $380 state sales tax despite customer submitting tax-exempt certificate.

### 2. Initial Diagnostic Questions
1. Is the tax-exempt status checked in your customer profile? 2. What is your state tax exemption ID?

### 3. Troubleshooting & Investigation Process
Step 1: Query `accounts` table in database. Observe `is_tax_exempt = 1`. Step 2: Inspect AvaTax integration cache log. Step 3: Detect stale cached taxable entity status.

### 4. Diagnostic Reasoning & Technical Analysis
Third-party AvaTax integration cached the customer's previous non-exempt status and failed to flush tax table on invoice generation.

### 5. Identified Root Cause
**Third-Party Integration Cache / Tax Gateway Stale Cache**

### 6. Corrective Action & Resolution
Flushed AvaTax integration entity cache, voided taxable invoice, and reissued tax-exempt invoice INV-9021-REV.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 1 Support Operations Lead.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Flushed AvaTax API cache for CUST-001. Reissued tax-exempt invoice INV-9021-REV in database.

### 9. Customer-Facing Response
```text
Dear John, We have flushed the tax gateway cache and reissued invoice INV-9021-REV with state sales tax completely removed ($0.00 tax).
```

### 10. Recommended Knowledge Base Article
* [KB-008: Reviewing Account Invoices & Payment History](knowledge-base/)

---

## TS-018: Resource Allocation Report Displays Negative Hour Balances
**Category:** Data Discrepancies / Reporting  

### 1. Reported Symptoms
Resource allocation dashboard displays -14.5 hours for an employee on project reports.

### 2. Initial Diagnostic Questions
1. Were PTO hours booked concurrently with active project timecards?

### 3. Troubleshooting & Investigation Process
Step 1: Query `timecard_entries` table for employee Mark Davis. Step 2: Identify overlapping PTO entry (8 hrs) and Billable Project entry (8 hrs) on same date.

### 4. Diagnostic Reasoning & Technical Analysis
Timecard CSV importer lacked client-side validation preventing concurrent PTO and active project hour allocation.

### 5. Identified Root Cause
**Data Discrepancy / Overlapping Timecard Records in Ingestion Pipeline**

### 6. Corrective Action & Resolution
Executed SQL cleanup script to remove duplicate PTO entry and updated reporting aggregation view.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 2 Application Analyst for database adjustment.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Removed conflicting PTO record ID 8821 in `timecard_entries`. Re-aggregated resource view.

### 9. Customer-Facing Response
```text
Hi David, A duplicate PTO entry created a negative hour balance on Mark Davis's report. We have cleaned up the conflicting record, and your resource allocation report is now accurate.
```

### 10. Recommended Knowledge Base Article
* [KB-010: Exporting Audit Logs & Data Synchronization Guides](knowledge-base/)

---

## TS-019: User Seat Cap Limits Reached Despite Contract Addendum
**Category:** Account Access / Billing Sync  

### 1. Reported Symptoms
Admin attempting to invite 86th user receives error 'User Seat Limit Reached (85/85)' despite purchasing 100 seats.

### 2. Initial Diagnostic Questions
1. When was the sales contract addendum signed? 2. Do you have the sales order reference number?

### 3. Troubleshooting & Investigation Process
Step 1: Query `accounts` table. Observe `max_users = 85`. Step 2: Inspect CRM webhook sync logs. Step 3: Identify failed webhook event from CRM.

### 4. Diagnostic Reasoning & Technical Analysis
Sales CRM contract update failed to push the automated webhook notification to update `accounts.max_users` in production DB.

### 5. Identified Root Cause
**CRM Integration Sync / Webhook Delivery Failure**

### 6. Corrective Action & Resolution
Manually updated `max_users = 100` in database for `CUST-003` and re-triggered CRM sync.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 1 Support Lead.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Executed SQL: `UPDATE accounts SET max_users = 100 WHERE customer_id = 'CUST-003'`. Verified admin user invitation capability.

### 9. Customer-Facing Response
```text
Dear Robert, We have updated your account seat cap to 100 users in our production system. You may now immediately invite additional team members.
```

### 10. Recommended Knowledge Base Article
* [KB-004: Managing User Roles & Module Permissions](knowledge-base/)

---

## TS-020: Bulk Permission Revocation Script Times Out Midway
**Category:** Account Access / API Timeouts  

### 1. Reported Symptoms
Admin attempted to revoke Editor access for 30 contractors; script stopped after 12 users.

### 2. Initial Diagnostic Questions
1. Did the browser display a 504 Gateway Timeout error message?

### 3. Troubleshooting & Investigation Process
Step 1: Check API Gateway timeout logs. Observe 30-second execution limit. Step 2: Query `user_roles` table for remaining 18 contractor IDs.

### 4. Diagnostic Reasoning & Technical Analysis
Synchronous loop in API controller exceeded the HTTP gateway 30-second timeout when updating multiple permission records sequentially.

### 5. Identified Root Cause
**API Architecture Constraint / Synchronous Batch Execution Timeout**

### 6. Corrective Action & Resolution
Executed batch permission removal via backend CLI script. Submitted engineering request for asynchronous batch permission API.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 1 Support Lead / Tier 2 Analyst.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Executed CLI batch permission revocation for remaining 18 contractors. Verified zero active Editor roles for contractor list.

### 9. Customer-Facing Response
```text
Hi Mary, We have completed the role revocation for the remaining 18 contractors directly in our backend system. All 30 contractor accounts now have access revoked.
```

### 10. Recommended Knowledge Base Article
* [KB-004: Managing User Roles & Module Permissions](knowledge-base/)

---

## TS-021: Guest Tenant Account Upload Button Permanently Disabled
**Category:** Software Defects / Logic Bug  

### 1. Reported Symptoms
Guest tenant role cannot upload maintenance photos despite admin enabling photo permissions.

### 2. Initial Diagnostic Questions
1. Does the upload button work for standard tenant roles?

### 3. Troubleshooting & Investigation Process
Step 1: Inspect frontend React UI code for document button. Step 2: Identify flawed conditional `disabled={user.is_guest}` instead of `disabled={!permission.can_upload}`.

### 4. Diagnostic Reasoning & Technical Analysis
Hardcoded boolean check on `is_guest` overrode explicit tenant granular permission settings.

### 5. Identified Root Cause
**Software Defect / Hardcoded Logical Override in UI Component**

### 6. Corrective Action & Resolution
Deployed frontend hotfix v2.3.9 updating component conditional check.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 1 Support / Release Management.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Hotfix v2.3.9 deployed. Tested guest tenant photo upload button successfully.

### 9. Customer-Facing Response
```text
Dear Amanda, We deployed hotfix v2.3.9 which corrects the permission check for guest tenant accounts. Your guest users can now upload maintenance photos as configured.
```

### 10. Recommended Knowledge Base Article
* [KB-007: Reporting Software Bugs & Workaround Procedures](knowledge-base/)

---

## TS-022: Account Ownership Transfer Following Employee Departure
**Category:** Account Access / Security Verification  

### 1. Reported Symptoms
Customer requests transferring Primary Account Owner privileges from former IT Director to new lead.

### 2. Initial Diagnostic Questions
1. Can the company CISO or Security Officer provide a signed authorization letter? 2. Has identity callback verification been completed?

### 3. Troubleshooting & Investigation Process
Step 1: Request formal CISO authorization letter. Step 2: Perform phone callback verification to corporate directory number. Step 3: Update `accounts.owner_user_id`.

### 4. Diagnostic Reasoning & Technical Analysis
Strict security policy requires out-of-band verification before transferring primary administrative ownership.

### 5. Identified Root Cause
**Administrative Security Verification Procedure**

### 6. Corrective Action & Resolution
Verified CISO authorization letter and callback. Updated primary account owner record in database.

### 7. Escalation Criteria & Handover Protocol
Escalate to Tier 1 Support Lead.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Received CISO sign-off letter. Completed phone callback to Acme Corp security desk. Updated primary owner to Jane Smith.

### 9. Customer-Facing Response
```text
Hello Jane, Following security verification, we have officially transferred Primary Account Ownership privileges for Acme Corp to your account.
```

### 10. Recommended Knowledge Base Article
* [KB-004: Managing User Roles & Module Permissions](knowledge-base/)

---

## TS-023: Webhook Integration Request for ServiceNow Synchronization
**Category:** Feature Request / API Integration  

### 1. Reported Symptoms
Customer IT department requests outbound webhook alerts on ticket status updates to integrate with internal ServiceNow.

### 2. Initial Diagnostic Questions
1. What payload format does your ServiceNow instance expect? 2. What specific event triggers are required?

### 3. Troubleshooting & Investigation Process
Step 1: Review product roadmap with Product Manager (Marcus Vance). Step 2: Identify planned Q4 webhook feature (EPIC PROD-440). Step 3: Link ticket to product backlog.

### 4. Diagnostic Reasoning & Technical Analysis
Feature request aligns with existing product roadmap for enterprise integration capabilities.

### 5. Identified Root Cause
**Product Capability Gap / Feature Enhancement Request**

### 6. Corrective Action & Resolution
Linked customer ticket to Product Backlog EPIC PROD-440 and notified account Customer Success Manager.

### 7. Escalation Criteria & Handover Protocol
Escalate to Product Management.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Linked ticket to EPIC PROD-440 in Jira Product Discovery. Notified CSM of enterprise customer request.

### 9. Customer-Facing Response
```text
Hi David, Outbound webhook integration is a key feature scheduled on our Q4 Product Roadmap (EPIC PROD-440). We have added your organization to the early beta access list.
```

### 10. Recommended Knowledge Base Article
* [KB-010: Exporting Audit Logs & Data Synchronization Guides](knowledge-base/)

---

## TS-024: Tenant Client Portal Custom CSS Branding Request
**Category:** Feature Request / Portal Customization  

### 1. Reported Symptoms
Customer requests custom logo upload and CSS primary hex color customization for client-facing portal.

### 2. Initial Diagnostic Questions
1. Do you require full white-label domain customization or primary color accent customization?

### 3. Troubleshooting & Investigation Process
Step 1: Log enhancement details in Jira Product Discovery board (`JPD-112`). Step 2: Tag Product Owner for UX design evaluation.

### 4. Diagnostic Reasoning & Technical Analysis
Custom tenant branding requires UX design and CSS scoping isolation across tenant boundaries.

### 5. Identified Root Cause
**Product Capability Gap / Custom Branding Feature**

### 6. Corrective Action & Resolution
Captured feature requirements and submitted to Product Management.

### 7. Escalation Criteria & Handover Protocol
Escalate to Product Management.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Logged feature request JPD-112. Provided feedback to UX team regarding real estate client portal needs.

### 9. Customer-Facing Response
```text
Dear Amanda, We have documented your custom portal branding requirements and submitted them to our Product Design team for roadmap evaluation.
```

### 10. Recommended Knowledge Base Article
* [KB-010: Exporting Audit Logs & Data Synchronization Guides](knowledge-base/)

---

## TS-025: Automated HIPAA Audit Log Export to Secure S3 Bucket
**Category:** Feature Request / Compliance  

### 1. Reported Symptoms
Compliance Officer requests automated weekly PDF/CSV export of audit logs delivered directly to secure cloud storage.

### 2. Initial Diagnostic Questions
1. What cloud storage protocol (AWS S3, Azure Blob, SFTP) does your compliance policy require?

### 3. Troubleshooting & Investigation Process
Step 1: Evaluate compliance requirements with Lead Analyst and Security Officer. Step 2: Log requirement under Product Backlog `FEAT-881`.

### 4. Diagnostic Reasoning & Technical Analysis
Automated log export requires secure IAM role delegation and encryption in transit.

### 5. Identified Root Cause
**Product Capability Gap / Automated Compliance Export**

### 6. Corrective Action & Resolution
Logged requirement in Product Backlog for Q1 Security & Compliance release.

### 7. Escalation Criteria & Handover Protocol
Escalate to Product Security Lead.

### 8. Jira Internal Agent Note (Callout)
> **Internal Note (Yellow Box):**  
> Logged compliance feature request FEAT-881 for Q1 Product Security sprint planning.

### 9. Customer-Facing Response
```text
Dear Emily, Automated S3 audit log export has been added to our Product Security backlog (FEAT-881) for Q1 release planning. In the meantime, manual CSV audit exports remain available in your admin dashboard.
```

### 10. Recommended Knowledge Base Article
* [KB-010: Exporting Audit Logs & Data Synchronization Guides](knowledge-base/)

---

