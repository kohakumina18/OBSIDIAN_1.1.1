---
type: decision
decision_id: DEC-20260925-EXPENSE-INVOICE-ONE-PROJECT
status: Resolved
source_event: PPJ-BOD-REVIEW-20260924-UPDATE
last_verified: 2026-09-25
---

# Expense invoices are one project

Question: the 35-item baseline lists `PPJ.ExpenseInvoices.v1.1` (shared expense invoice, UAT) and `LOG.EXPENSE.INVOICES.V1.2` (Logistics regional rollout) as two projects and warns against merging them. The vault registry had already mapped both to `LOG_ExpenseInvoiceProcessing_v1.2.2` on 2026-09-18 and left the mapping as an open decision.

Evidence: the 2026-09-24 BOD review recording describes one expense-invoice application used most by Finance and Logistics inbound, also by export / import and Administration, being expanded to the units that receive such invoices (see [[BOD_REVIEW_20260924_Madame_Phuong]]). One AI-written analysis of the same review said "do not merge"; the recording does not support that.

Resolution (2026-09-25, owner): **one project.** `PPJ.ExpenseInvoices.v1.1` and `LOG.EXPENSE.INVOICES.V1.2` are the same application, recorded as `LOG_ExpenseInvoiceProcessing_v1.2.2`. `LOG.EXPENSE.INVOICES.V1.2` is now an alias.

Still open: whether the earlier Export exclusion still applies.

Applied to: portfolio snapshot, `PPJ_PROJECT_ALIAS_MAP`, `PPJ_PROJECT_CANONICAL_NAMING_DICTIONARY`, the project memory card, root note, Project Home, local board and the update ledger. The ecosystem Canvas gap note is updated by its generator.
