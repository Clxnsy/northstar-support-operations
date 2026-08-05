# KB-005: Resolving Multi-Factor Authentication (MFA) Login Errors

## Overview
Multi-Factor Authentication (MFA) is required for all Enterprise and Professional Northstar accounts. This article covers resolving lost authenticator devices, time desynchronization, and backup code recovery.

---

## Lost or Replaced Authenticator Device

If you lost your mobile device or purchased a new phone and can no longer generate MFA codes:

### Option 1: Use Backup Recovery Codes
1. On the MFA entry screen, click **Use Backup Code**.
2. Enter one of the 8-digit single-use emergency recovery codes generated when you first configured MFA.
3. Once logged in, navigate to `Profile Settings -> Security` and click **Reconfigure MFA** to scan a new QR code.

### Option 2: Request Admin MFA Reset
If you do not have backup recovery codes:
1. Contact your internal Northstar SaaS Admin.
2. The Admin will navigate to `User Management -> Security` and click **Reset User MFA**.
3. Upon your next login attempt, you will be prompted to scan a fresh QR code with your authenticator app.
