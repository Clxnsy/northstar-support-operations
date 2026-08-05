# KB-001: Resetting Passwords & Managing User Sessions

## Overview
This guide provides step-by-step instructions for B2B SaaS Admins and End Users to reset account passwords, unlock locked accounts, and manage active browser session timeouts in the Northstar Business Operations Platform.

---

## How to Reset Your Password

### Self-Service Password Reset
1. Navigate to the Northstar Login Portal (`https://app.northstar.com/login`).
2. Click the **Forgot Password?** link below the credential entry box.
3. Enter your corporate email address associated with your Northstar user profile.
4. Click **Send Reset Link**.
5. Check your inbox for an email from `noreply@northstar.com` titled **Reset Your Northstar Password**.
6. Click the secure button in the email. You will be directed to a landing page.
7. Click **Confirm Password Reset** and enter a new password meeting our security requirements.

> **Important Note on Email Scanners:** If clicking the password reset link immediately yields an 'Expired Link' error, your organization's email security gateway (e.g., Proofpoint or Mimecast) may be pre-scanning links. The secondary confirmation landing page prevents scanner consumption.

---

## Password Security Requirements
* Minimum **12 characters** in length.
* At least **one uppercase letter** (A-Z).
* At least **one lowercase letter** (a-z).
* At least **one number** (0-9).
* At least **one special character** (`!@#$%^&*`).

---

## Managing Session Timeouts
By default, Northstar user sessions remain active for **8 hours**. If your organization uses handheld web terminals or mobile devices and experiences unexpected 5-minute logouts:
1. Ensure your device is connected to a stable Wi-Fi network.
2. Request your Northstar SaaS Admin to verify that **Mobile Subnet Roaming** is enabled in `Settings -> Security Policies`.
