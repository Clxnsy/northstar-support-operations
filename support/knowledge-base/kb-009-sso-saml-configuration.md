# KB-009: Configuring SAML 2.0 & Active Directory Integrations

## Overview
Northstar Enterprise tier accounts support federated Single Sign-On (SSO) integration with SAML 2.0 Identity Providers, including Azure Active Directory, Okta, Ping Identity, and OneLogin.

---

## Prerequisites
* Active Northstar Enterprise Subscription.
* Identity Provider (IdP) administrative access.
* Public X.509 Signing Certificate string.

---

## Configuration Steps
1. Log into Northstar as a **SaaS Admin** and go to `Settings -> Single Sign-On`.
2. Copy the Northstar **Entity ID** and **Assertion Consumer Service (ACS) URL**:
   * **Entity ID:** `https://auth.northstar.com/saml/metadata`
   * **ACS URL:** `https://auth.northstar.com/saml/consume`
3. In your IdP (e.g., Azure AD), create a new Enterprise Application and paste the Entity ID and ACS URL.
4. Configure SAML User Attributes mapping:
   * `email` -> `user.mail`
   * `first_name` -> `user.givenname`
   * `last_name` -> `user.surname`
5. Download your IdP Federation Metadata XML and copy the **X.509 Public Key Certificate**.
6. Paste the certificate string into Northstar SSO settings and click **Enable SAML SSO**.
