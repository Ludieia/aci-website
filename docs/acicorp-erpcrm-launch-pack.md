# ACICORP ERP/CRM Launch Pack

## Objective
Prepare ERPNext / CRM Ludienet to receive, structure, track, and verify all ACICORP public website submissions through Ludie IA.

Official pipeline:

```text
acicorpinc.com
  -> https://acicorpinc.com/api/signal
  -> Ludie IA Middleware
  -> ERPNext / CRM Ludienet
```

## Current validated status

- Website form submission: OK
- HTTPS same-origin proxy `/api/signal`: OK
- Ludie IA receives payload: OK
- Transaction ID and trace ID: OK
- ERPNext Lead creation: pending final API verification

---

# 1. Core ERPNext objects to create

## 1.1 Lead
Use ERPNext standard Lead as first intake record.

Recommended fields mapping:

| Website field | ERPNext Lead field |
|---|---|
| full_name | lead_name |
| email | email_id |
| phone | mobile_no |
| country | country |
| city | city |
| motivation | notes |
| form_name | custom_source_form |
| transaction_id | custom_transaction_id |
| trace_id | custom_trace_id |
| initial_status | custom_website_status |
| requested_object | custom_requested_object |

Custom fields to add to Lead:

- custom_source_channel: Data
- custom_source_form: Data
- custom_transaction_id: Data, unique recommended
- custom_trace_id: Data
- custom_requested_object: Data
- custom_website_status: Select
  - Submitted
  - Received
  - Under Review
  - Converted
  - Rejected
- custom_raw_payload: Long Text
- custom_ludie_ia_status: Select
  - Received
  - ERP Created
  - ERP Error
  - Needs Review
- custom_ludie_ia_error: Long Text

---

## 1.2 Chaplain Profile
Create custom DocType: `ACICORP Chaplain Profile`

Purpose: manage chaplain applications from website intake to review, training, ordination, and active status.

Fields:

| Field Label | Fieldname | Type | Required |
|---|---|---|---|
| Full Name | full_name | Data | Yes |
| First Name | first_name | Data | No |
| Last Name | last_name | Data | No |
| Date of Birth | date_of_birth | Date | No |
| Place of Birth | place_of_birth | Data | No |
| Phone | phone | Data | Yes |
| WhatsApp | whatsapp | Data | No |
| Email | email | Data | Yes |
| Address | address | Small Text | No |
| Country | country | Data | Yes |
| Department / State | department_state | Data | No |
| City | city | Data | No |
| Document Number | document_number | Data | No |
| Photo | photo | Attach Image | No |
| Application Status | application_status | Select | Yes |
| Training Level | training_level | Select | No |
| Chaplain Type | chaplain_type | Select | Yes |
| Application Date | application_date | Date | Yes |
| Validation Date | validation_date | Date | No |
| Ordination Date | ordination_date | Date | No |
| Related Branch / Organization | related_branch | Data | No |
| Emergency Contact | emergency_contact | Data | No |
| Administrative Notes | administrative_notes | Long Text | No |
| Website Transaction ID | transaction_id | Data | Yes |
| Trace ID | trace_id | Data | No |
| Source Lead | source_lead | Link / Lead | No |
| Raw Payload | raw_payload | Long Text | No |

Application Status options:

- Submitted
- New Application
- Under Review
- Missing Documents
- Approved
- Training
- Ordained
- Rejected
- Suspended

Training Level options:

- None
- Orientation
- Basic
- Intermediate
- Advanced
- Completed

Chaplain Type options:

- Community
- Hospital
- Prison
- Military
- Youth
- School
- International
- Other

---

## 1.3 ACICORP Donation
Create custom DocType: `ACICORP Donation`

Purpose: manage public donation confirmation, verification, receipt generation, thank-you follow-up, and allocation.

Key fields:

### Donor Information
- donor_full_name: Data, required
- first_name: Data
- last_name: Data
- organization_institution: Data
- donor_type: Select
  - Individual
  - Organization
  - Church
  - NGO
  - Business
  - Diaspora Supporter
  - Anonymous
- phone: Data
- whatsapp: Data
- email: Data
- country: Data
- city: Data
- address: Small Text

### Donation Information
- donation_theme: Select, required
  - Education Support
  - Humanitarian Response
  - Displaced Families
  - Prison Support
  - Youth & Peacebuilding
  - AMMI / Community Recovery
  - Chaplaincy Programs
  - General Donation
- amount: Currency, required
- currency: Select
  - USD
  - HTG
  - DOP
  - EUR
- payment_method: Select
  - MonCash
  - NatCash
  - Bank Transfer
  - Cash
  - Zelle
  - CashApp
  - Credit Card
  - Other
- transaction_reference: Data
- payment_date: Date
- receipt_upload: Attach
- donation_note: Long Text
- related_program: Data
- related_project: Data
- related_branch: Data
- related_department: Data

### Verification
- status: Select
  - Submitted
  - Pending Verification
  - Verified
  - Receipt Generated
  - Thank You Sent
  - Allocated
  - Closed
  - Rejected
  - Refunded
  - Duplicate
  - Needs Clarification
- verified_by: Link / User
- verification_date: Datetime
- finance_note: Long Text
- internal_note: Long Text

### Acknowledgment
- thank_you_email_sent: Check
- thank_you_email_date: Datetime
- receipt_number: Data
- receipt_generated: Check
- receipt_sent: Check
- donor_follow_up_needed: Check

### Traceability
- transaction_id: Data
- trace_id: Data
- source_channel: Data
- raw_payload: Long Text

---

## 1.4 Communication Log
Use ERPNext standard Communication or create custom `ACICORP Communication Log` if needed.

Fields:

- subject
- sender_name
- sender_email
- phone
- request_type
- message
- source_form
- transaction_id
- trace_id
- assigned_to
- status
  - New
  - In Review
  - Responded
  - Closed

---

# 2. Website form to ERP/CRM mapping

| Website Form | Ludie IA form_name | ERPNext Primary Object | Secondary Objects | Initial Status |
|---|---|---|---|---|
| Become a Chaplain | become_a_chaplain | Lead | ACICORP Chaplain Profile | Submitted |
| Contact | contact_request | Lead | Communication Log, Follow-up Task | New |
| Donation Confirmation | donation_confirmation | ACICORP Donation | Lead if donor has email | Submitted |
| Partner | partnership_request | Lead | Organization / Partner | New |
| Volunteer | volunteer_partner | Lead | Volunteer Profile | Submitted |
| Education Support | education_support | Lead | Support Request Record | Submitted |
| Human Rights & Prison Support | prison_support | Lead | Support Request Record | Submitted |
| Displaced Families Support | displaced_families_support | Lead | Support Request Record | Submitted |
| Donation Interest | donation_interest | ACICORP Donation | Follow-up Task | Submitted |
| Event Registration | event_registration | Event Registration | Lead | Submitted |
| Training Registration | training_registration | Training Enrollment | Lead | Submitted |

---

# 3. Roles to create

- ACICORP Director
- Admin Chaplaincy
- Chaplain Supervisor
- Chaplain
- Chaplain Applicant
- Finance Officer
- Donation Manager
- Program Manager
- Data Entry Officer
- Auditor Read Only

---

# 4. Permission matrix

| DocType | Role | Read | Write | Create | Submit | Cancel | Delete | Report | Export |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|
| Lead | Data Entry Officer | Yes | Yes | Yes | No | No | No | Yes | No |
| Lead | Admin Chaplaincy | Yes | Yes | Yes | No | No | No | Yes | Yes |
| Lead | ACICORP Director | Yes | Yes | Yes | Yes | Yes | No | Yes | Yes |
| Lead | Auditor Read Only | Yes | No | No | No | No | No | Yes | Yes |
| ACICORP Chaplain Profile | Chaplain Applicant | Own | No | No | No | No | No | No | No |
| ACICORP Chaplain Profile | Chaplain Supervisor | Yes | Yes | Yes | No | No | No | Yes | No |
| ACICORP Chaplain Profile | Admin Chaplaincy | Yes | Yes | Yes | Yes | No | No | Yes | Yes |
| ACICORP Chaplain Profile | ACICORP Director | Yes | Yes | Yes | Yes | Yes | No | Yes | Yes |
| ACICORP Donation | Finance Officer | Yes | Yes | Yes | Yes | No | No | Yes | Yes |
| ACICORP Donation | Donation Manager | Yes | Yes | Yes | No | No | No | Yes | Yes |
| ACICORP Donation | Program Manager | Yes | Limited | No | No | No | No | Yes | No |
| ACICORP Donation | Auditor Read Only | Yes | No | No | No | No | No | Yes | Yes |

Security rule: no role should receive Delete permission for ACICORP public intake records.

---

# 5. Workflows

## 5.1 Chaplain workflow

States:

1. Submitted
2. New Application
3. Under Review
4. Missing Documents
5. Approved
6. Training
7. Ordained
8. Rejected
9. Suspended

Rules:

- Website submissions start as Submitted.
- Admin Chaplaincy can move Submitted -> Under Review.
- Chaplain Supervisor can mark Missing Documents.
- Admin Chaplaincy or Director can approve.
- Ordained requires Director or Admin Chaplaincy.
- Suspended requires Director.
- No delete action in workflow.

## 5.2 Donation workflow

States:

1. Submitted
2. Pending Verification
3. Verified
4. Receipt Generated
5. Thank You Sent
6. Allocated
7. Closed
8. Needs Clarification
9. Duplicate
10. Rejected
11. Refunded

Rules:

- Website submissions start as Submitted.
- Finance Officer verifies payment.
- Donation Manager handles receipts and thank-you emails.
- Program Manager allocates donations to programs.
- Director can close or review exceptions.

---

# 6. ERPNext API bridge design

## 6.1 Required backend environment variables

Do not hardcode credentials in frontend.

Recommended server-only environment variables:

```bash
ERP_URL=https://crm.ludienet.com
ERP_API_KEY=xxx
ERP_API_SECRET=yyy
ERP_DEFAULT_OWNER=Administrator
ERP_ENABLE_LEAD_CREATE=true
ERP_ENABLE_CHAPLAIN_CREATE=true
ERP_ENABLE_DONATION_CREATE=true
```

## 6.2 Standard API headers

```python
headers = {
    "Authorization": f"token {ERP_API_KEY}:{ERP_API_SECRET}",
    "Content-Type": "application/json"
}
```

## 6.3 Lead payload minimal

```json
{
  "lead_name": "Full Name",
  "email_id": "email@example.com",
  "mobile_no": "+50900000000",
  "status": "Lead",
  "source": "Website"
}
```

## 6.4 Recommended fallback strategy

If custom DocType creation fails:

1. Always create Lead first.
2. Save full raw payload in Lead notes or custom_raw_payload.
3. Mark `custom_ludie_ia_status = ERP Error`.
4. Log error for manual follow-up.

---

# 7. Backend code target behavior

When `/signal` receives data:

1. Parse JSON.
2. Extract `form_name`, `transaction_id`, `trace_id`, `payload`.
3. Validate required fields.
4. Create Lead for all people-based submissions.
5. Create custom record based on form type.
6. Return structured response:

```json
{
  "status": "received",
  "transaction_id": "...",
  "trace_id": "...",
  "erp": {
    "lead_created": true,
    "lead_id": "CRM-LEAD-...",
    "custom_record_created": true,
    "custom_record_id": "..."
  }
}
```

---

# 8. UAT checklist

## Become a Chaplain

- Submit form from website.
- Confirm success message appears.
- Verify backend logs show POST /signal 200.
- Verify ERPNext Lead exists.
- Verify Chaplain Profile exists.
- Verify status = Submitted.
- Verify transaction_id saved.
- Verify raw payload saved.

## Contact

- Submit contact form.
- Verify Lead or Communication Log created.
- Verify assigned follow-up task if enabled.

## Donation

- Submit donation confirmation.
- Verify ACICORP Donation record created.
- Verify status = Submitted.
- Verify payment is not automatically verified.
- Verify finance queue can review.

---

# 9. Launch sequence

1. Keep backend running with systemd.
2. Confirm `/api/signal` works.
3. Confirm ERPNext API credentials.
4. Test Lead creation with curl.
5. Test Become a Chaplain.
6. Test Contact.
7. Test Donation.
8. Enable monitoring.
9. Announce controlled launch.

---

# 10. Tomorrow verification list

- Confirm latest frontend is live: `acicorp-forms.js?v=122` or higher.
- Confirm endpoint is HTTPS same-origin: `https://acicorpinc.com/api/signal`.
- Confirm backend receives payload.
- Confirm ERPNext Lead API accepts token.
- Confirm Lead is created.
- Confirm custom DocTypes exist or create them.
- Confirm no delete permissions are enabled.
- Confirm dashboard/reporting next steps.
