# ACICORP Finance, Beneficiary & HR Traceability Pack

## Objective
Create a transparent ERP/CRM structure where every dollar received, verified, allocated, spent, and reported can be traced from donor to program, beneficiary, expense, employee, and financial report.

Core principle:

```text
Donation / Funding Source
  -> Verification
  -> Allocation
  -> Expense / Distribution / Payroll
  -> Beneficiary or Employee
  -> Proof
  -> Financial Report
```

No money movement should exist without a record, status, owner, date, and proof.

---

# 1. Core financial traceability rule

Every financial movement must have:

- Transaction ID
- Funding Source
- Amount
- Currency
- Payment Method
- Verification Status
- Program / Project
- Branch / Department
- Responsible Officer
- Beneficiary or Employee when applicable
- Supporting document or proof
- Created By
- Verified By
- Date Created
- Date Verified
- Status
- Notes

Recommended global statuses:

- Draft
- Submitted
- Pending Verification
- Verified
- Allocated
- Partially Used
- Fully Used
- Reconciled
- Closed
- Rejected
- Needs Clarification

---

# 2. DocType: ACICORP Fund Source

Purpose: track money sources before spending or allocation.

Fields:

| Field Label | Fieldname | Type | Required |
|---|---|---|---|
| Fund Source Name | fund_source_name | Data | Yes |
| Source Type | source_type | Select | Yes |
| Donor / Partner | donor_partner | Data | No |
| Related Donation | related_donation | Link / ACICORP Donation | No |
| Amount Received | amount_received | Currency | Yes |
| Currency | currency | Select | Yes |
| Payment Method | payment_method | Select | No |
| Transaction Reference | transaction_reference | Data | No |
| Date Received | date_received | Date | Yes |
| Verified Amount | verified_amount | Currency | No |
| Available Balance | available_balance | Currency | Yes |
| Status | status | Select | Yes |
| Verified By | verified_by | Link / User | No |
| Verification Date | verification_date | Datetime | No |
| Proof / Receipt | proof_receipt | Attach | No |
| Notes | notes | Long Text | No |

Source Type options:

- Donation
- Grant
- Sponsorship
- Internal Contribution
- Partner Support
- Emergency Fund
- Other

---

# 3. DocType: ACICORP Fund Allocation

Purpose: assign verified money to a program, project, branch, beneficiary group, or operational need.

Fields:

| Field Label | Fieldname | Type | Required |
|---|---|---|---|
| Allocation ID | allocation_id | Data | Yes |
| Fund Source | fund_source | Link / ACICORP Fund Source | Yes |
| Program | program | Data | Yes |
| Project | project | Data | No |
| Branch | branch | Data | No |
| Department | department | Data | No |
| Allocation Purpose | allocation_purpose | Small Text | Yes |
| Allocated Amount | allocated_amount | Currency | Yes |
| Currency | currency | Select | Yes |
| Allocation Date | allocation_date | Date | Yes |
| Approved By | approved_by | Link / User | No |
| Status | status | Select | Yes |
| Notes | notes | Long Text | No |

Status options:

- Draft
- Submitted
- Approved
- Partially Used
- Fully Used
- Closed
- Cancelled

Rule: allocation cannot exceed available balance of the fund source.

---

# 4. DocType: ACICORP Expense Record

Purpose: record every expense paid from an allocation or fund source.

Fields:

| Field Label | Fieldname | Type | Required |
|---|---|---|---|
| Expense Title | expense_title | Data | Yes |
| Expense Category | expense_category | Select | Yes |
| Fund Source | fund_source | Link / ACICORP Fund Source | Yes |
| Fund Allocation | fund_allocation | Link / ACICORP Fund Allocation | No |
| Amount | amount | Currency | Yes |
| Currency | currency | Select | Yes |
| Payment Method | payment_method | Select | Yes |
| Payment Reference | payment_reference | Data | No |
| Expense Date | expense_date | Date | Yes |
| Vendor / Payee | vendor_payee | Data | No |
| Beneficiary | beneficiary | Link / ACICORP Beneficiary | No |
| Employee | employee | Link / Employee | No |
| Program | program | Data | No |
| Project | project | Data | No |
| Branch | branch | Data | No |
| Receipt / Proof | receipt_proof | Attach | No |
| Requested By | requested_by | Link / User | No |
| Approved By | approved_by | Link / User | No |
| Verified By | verified_by | Link / User | No |
| Status | status | Select | Yes |
| Notes | notes | Long Text | No |

Expense Category options:

- Beneficiary Support
- Food Support
- Education Support
- Medical Support
- Transportation
- Office Expense
- Communication
- Payroll
- Stipend
- Volunteer Support
- Training Expense
- Event Expense
- Prison Support
- Emergency Support
- Other

Status options:

- Draft
- Submitted
- Pending Approval
- Approved
- Paid
- Verified
- Reconciled
- Rejected
- Needs Clarification

Rules:

- No delete permission for financial records.
- Every paid expense must have proof or finance note.
- Expenses linked to a donation must be visible in donation reports.

---

# 5. DocType: ACICORP Beneficiary

Purpose: identify individuals, families, schools, churches, communities, institutions, or other recipients of support.

Fields:

| Field Label | Fieldname | Type | Required |
|---|---|---|---|
| Beneficiary Full Name | beneficiary_full_name | Data | Yes |
| Beneficiary Type | beneficiary_type | Select | Yes |
| Phone | phone | Data | No |
| Email | email | Data | No |
| Country | country | Data | No |
| Department | department | Data | No |
| City | city | Data | No |
| Address | address | Small Text | No |
| Need Category | need_category | Select | Yes |
| Vulnerability Level | vulnerability_level | Select | No |
| Related Program | related_program | Data | No |
| Related Project | related_project | Data | No |
| Related Branch | related_branch | Data | No |
| Status | status | Select | Yes |
| Verified By | verified_by | Link / User | No |
| Verification Date | verification_date | Date | No |
| Notes | notes | Long Text | No |
| Proof / Photo | proof_photo | Attach | No |

Beneficiary Type options:

- Individual
- Family
- Child
- Student
- School
- Church
- Community
- Prisoner
- Prison Group
- NGO
- Institution
- Other

Need Category options:

- Education
- Food
- Shelter
- Medical
- Displacement
- Prison Support
- Youth Support
- Community Recovery
- Emergency Relief
- Other

Vulnerability Level options:

- Low
- Medium
- High
- Critical

Status options:

- New
- Verified
- Active Support
- Support Completed
- Closed
- Ineligible
- Needs Review

---

# 6. DocType: ACICORP Beneficiary Support Record

Purpose: record each support action given to a beneficiary.

Fields:

| Field Label | Fieldname | Type | Required |
|---|---|---|---|
| Beneficiary | beneficiary | Link / ACICORP Beneficiary | Yes |
| Support Date | support_date | Date | Yes |
| Support Type | support_type | Select | Yes |
| Support Description | support_description | Small Text | Yes |
| Amount Value | amount_value | Currency | No |
| Currency | currency | Select | No |
| Fund Source | fund_source | Link / ACICORP Fund Source | No |
| Related Donation | related_donation | Link / ACICORP Donation | No |
| Related Expense | related_expense | Link / ACICORP Expense Record | No |
| Program | program | Data | No |
| Project | project | Data | No |
| Distributed By | distributed_by | Link / User | No |
| Verified By | verified_by | Link / User | No |
| Proof | proof | Attach | No |
| Status | status | Select | Yes |
| Notes | notes | Long Text | No |

Support Type options:

- Cash
- Food
- School Fees
- Medical Assistance
- Materials
- Clothing
- Transportation
- Training
- Spiritual / Chaplaincy Support
- Other

Status options:

- Planned
- Delivered
- Verified
- Reconciled
- Cancelled

---

# 7. Employee and HR tracking

ERPNext already has HR modules. Use standard ERPNext objects when available:

- Employee
- Employment Type
- Department
- Branch
- Attendance
- Salary Structure
- Salary Slip
- Payroll Entry
- Expense Claim
- Timesheet

If HR module is not fully enabled, create a simple custom DocType: `ACICORP Staff Profile`.

## 7.1 DocType: ACICORP Staff Profile

Fields:

| Field Label | Fieldname | Type | Required |
|---|---|---|---|
| Full Name | full_name | Data | Yes |
| Staff Type | staff_type | Select | Yes |
| Position | position | Data | Yes |
| Department | department | Data | No |
| Branch | branch | Data | No |
| Phone | phone | Data | No |
| Email | email | Data | No |
| Address | address | Small Text | No |
| Start Date | start_date | Date | Yes |
| End Date | end_date | Date | No |
| Contract Type | contract_type | Select | No |
| Salary / Stipend | salary_stipend | Currency | No |
| Currency | currency | Select | No |
| Supervisor | supervisor | Link / User | No |
| Status | status | Select | Yes |
| Contract File | contract_file | Attach | No |
| ID Document | id_document | Attach | No |
| Notes | notes | Long Text | No |

Staff Type options:

- Employee
- Volunteer
- Consultant
- Field Worker
- Chaplain
- Coordinator
- Intern
- Contractor

Contract Type options:

- Full Time
- Part Time
- Volunteer
- Contract
- Stipend
- Temporary
- Consultant

Status options:

- Active
- Suspended
- Inactive
- Ended
- Pending Documents

---

## 7.2 DocType: ACICORP Payroll / Staff Payment Record

Purpose: track salary, stipend, allowances, reimbursements, and staff payments even if full HR payroll is not activated.

Fields:

| Field Label | Fieldname | Type | Required |
|---|---|---|---|
| Staff Member | staff_member | Link / ACICORP Staff Profile | Yes |
| Payment Type | payment_type | Select | Yes |
| Period Start | period_start | Date | No |
| Period End | period_end | Date | No |
| Amount | amount | Currency | Yes |
| Currency | currency | Select | Yes |
| Payment Method | payment_method | Select | Yes |
| Payment Reference | payment_reference | Data | No |
| Payment Date | payment_date | Date | Yes |
| Fund Source | fund_source | Link / ACICORP Fund Source | No |
| Fund Allocation | fund_allocation | Link / ACICORP Fund Allocation | No |
| Related Expense | related_expense | Link / ACICORP Expense Record | No |
| Approved By | approved_by | Link / User | No |
| Verified By | verified_by | Link / User | No |
| Receipt / Proof | receipt_proof | Attach | No |
| Status | status | Select | Yes |
| Notes | notes | Long Text | No |

Payment Type options:

- Salary
- Stipend
- Allowance
- Reimbursement
- Per Diem
- Bonus
- Contract Payment
- Other

Status options:

- Draft
- Submitted
- Approved
- Paid
- Verified
- Reconciled
- Rejected

Rule: staff payments should also create or link to an `ACICORP Expense Record` with category `Payroll`, `Stipend`, or `Volunteer Support`.

---

# 8. Reports required

## Financial reports

- Donations Received by Month
- Donations by Theme
- Donations by Donor Type
- Donations by Payment Method
- Verified vs Pending Donations
- Fund Sources and Available Balance
- Fund Allocation by Program
- Expenses by Category
- Expenses by Program
- Expenses by Branch
- Expenses by Beneficiary
- Expenses by Employee
- Donation to Beneficiary Trace Report
- Donation to Expense Trace Report
- Unallocated Donations
- Unreconciled Expenses
- Receipts Pending
- Thank You Emails Pending

## Beneficiary reports

- Beneficiaries by Category
- Beneficiaries by Location
- Beneficiaries by Vulnerability Level
- Support Given by Date
- Support Given by Program
- Support Given by Donation Source
- Beneficiaries Awaiting Verification
- Delivered Support Pending Proof

## HR / Staff reports

- Active Staff List
- Staff by Branch
- Staff by Department
- Staff by Type
- Payroll by Month
- Staff Payments by Fund Source
- Stipends by Program
- Volunteer Support Payments
- Employee Expense Claims
- Contracts Expiring Soon
- Staff Without Required Documents

---

# 9. Dashboard model

## Finance Dashboard

Cards:

- Total Donations Received
- Total Verified Donations
- Total Allocated
- Total Expenses
- Available Balance
- Pending Verification
- Receipts Pending
- Thank You Emails Pending

Charts:

- Donations by Month
- Donations by Theme
- Expenses by Category
- Program Allocation
- Payment Methods

Lists:

- Latest Donations
- Pending Verification
- Unreconciled Expenses
- Large Transactions
- Missing Proof

## Beneficiary Dashboard

Cards:

- Total Beneficiaries
- Verified Beneficiaries
- Active Support Cases
- Support Delivered This Month
- Critical Cases

Charts:

- Beneficiaries by Need Category
- Support by Program
- Support by Location

## HR Dashboard

Cards:

- Active Staff
- Volunteers
- Payroll This Month
- Pending Staff Payments
- Contracts Expiring
- Missing HR Documents

Charts:

- Staff by Department
- Staff by Branch
- Payments by Month
- Staff Cost by Program

---

# 10. Security and audit rules

- No delete permission for finance, donation, beneficiary, payroll, or support records.
- Use Cancel/Amend or Status = Rejected instead of deletion.
- Every financial record must have Created By and Modified By.
- Every verified payment must have Verified By and Verification Date.
- Every expense must link to Fund Source or Fund Allocation.
- Every beneficiary support record must link to Beneficiary.
- Large transactions should require Director review.
- Export permission should be limited to Director, Finance Officer, and Auditor.
- Auditor Read Only role should have read/report/export but no write.
- API user should have minimal permissions only.
- API credentials must never be stored in frontend or public repo.

---

# 11. Minimum launch configuration

Before public launch, create or confirm:

1. Lead custom fields
2. ACICORP Donation
3. ACICORP Beneficiary
4. ACICORP Beneficiary Support Record
5. ACICORP Fund Source
6. ACICORP Fund Allocation
7. ACICORP Expense Record
8. ACICORP Staff Profile
9. ACICORP Staff Payment Record
10. Roles and permissions
11. Basic dashboards
12. Donation and expense reports
13. Backend ERP bridge

---

# 12. Accounting trace examples

## Donation to beneficiary

```text
Donation: $100 USD
  -> Fund Source: Donation from Donor X
  -> Allocation: Education Support
  -> Expense: School Fees Payment $75
  -> Beneficiary: Student A
  -> Proof: Receipt uploaded
  -> Remaining Balance: $25
```

## Donation to staff payment

```text
Donation: $500 USD
  -> Fund Source: Partner Support
  -> Allocation: Field Coordination
  -> Expense: Coordinator Stipend $100
  -> Staff Payment Record: Coordinator A
  -> Proof: Payment reference
  -> Remaining Balance: $400
```

## Donation to operational expense

```text
Donation: HTG 50,000
  -> Fund Source: General Donation
  -> Allocation: Humanitarian Response
  -> Expense: Transportation HTG 8,000
  -> Vendor / Payee: Driver X
  -> Proof: Receipt photo
  -> Remaining Balance: HTG 42,000
```

---

# 13. Priority for next implementation session

1. Fix Ludie IA -> ERPNext Lead creation.
2. Add minimal custom fields to Lead.
3. Create ACICORP Donation and Beneficiary DocTypes.
4. Create Fund Source and Expense Record DocTypes.
5. Create Staff Profile and Staff Payment Record.
6. Configure permissions with no delete access.
7. Build first finance dashboard.
8. Test donation-to-beneficiary trace.
9. Test staff payment trace.
10. Produce first financial report.
