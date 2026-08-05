# KB-010: Exporting Audit Logs & Data Synchronization Guides

## Overview
Enterprise security and compliance policies often require tracking user logins, role modifications, data exports, and administrative actions. Northstar provides comprehensive audit logging and data export tools.

---

## Exporting System Audit Logs
1. Navigate to `Admin Console -> Security & Compliance -> Audit Logs`.
2. Select your desired date range filter (up to 365 days of historical logs).
3. Filter by Event Category:
   * **Authentication Events** (Logins, Logout, Password Resets, MFA)
   * **Permission Changes** (Role assignments, access revocations)
   * **Data Modification** (Bulk user imports, record updates)
4. Click **Export Audit Log (CSV)** to generate an itemized RFC-4180 compliant file.

---

## Automated Data Exports for Compliance
For organizations subject to HIPAA, SOC 2, or GDPR requiring automated log archiving, contact Northstar Support to configure automated scheduled log pushes to your secure AWS S3 bucket or Azure Blob storage.
