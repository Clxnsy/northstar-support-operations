# KB-002: Troubleshooting Login & Authentication Issues

## Overview
Learn how to diagnose and resolve common login failures, single sign-on (SSO) errors, and account lockout conditions on the Northstar platform.

---

## Common Login Errors & Solutions

### 1. Error: `Invalid MFA Token (ERR-401)`
* **Cause:** Your authenticator app (Google Authenticator, Authy) time is out of sync with our authentication servers, or you entered an expired 30-second token.
* **Resolution:** 
  1. Open your authenticator app settings and select **Time Correction for Codes -> Sync Now**.
  2. Wait for a fresh 60-second code cycle before submitting.
  3. If the error persists, contact your Admin to perform a temporary MFA reset.

### 2. Error: `403 Forbidden - Account Locked`
* **Cause:** Five consecutive incorrect password attempts lock the account for 15 minutes to prevent brute-force intrusion.
* **Resolution:** Wait 15 minutes for the automated lockout counter to reset, or contact Northstar Support for immediate identity verification and lockout clearance.

### 3. Error: `SAML Assertion Signature Verification Failed`
* **Cause:** Your company's Identity Provider (Azure AD / Okta) updated its SAML signing certificate, but the public key stored in Northstar was not updated.
* **Resolution:** Have your IT Administrator navigate to `Settings -> Single Sign-On` and upload the renewed X.509 certificate string.
