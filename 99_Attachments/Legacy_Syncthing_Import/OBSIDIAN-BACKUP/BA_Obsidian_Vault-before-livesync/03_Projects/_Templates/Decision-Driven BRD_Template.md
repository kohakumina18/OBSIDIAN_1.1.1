

# 📄 Decision-Driven BRD – Template for AI/Automation Projects (PPJ Ready)

---

🧠 PURPOSE

This BRD is NOT to describe system.

```text
Goal = Enable decision making
```

---

🧠 EXECUTIVE SUMMARY

- What is the problem?
    
- What is the decision needed?
    
- What is the expected business outcome?
    

👉 Format:

```text
Problem → Root Cause → Decision → Outcome
```

---

🧠 1. BUSINESS CONTEXT

---

Problem:

- What is happening?
    
- Why does it matter?
    

---

Impact:

- Cost?
    
- Time?
    
- Risk?
    
- Opportunity lost?
    

---

👉 Example:

```text
Invoice processing takes 2–3 hours per batch
→ causing delay in GRN and payment cycle
```

---

🧠 2. OBJECTIVE (OUTCOME-DRIVEN)

---

```text
NOT:
Build automation system ❌
```

```text
BUT:
Reduce processing time from 3h → 10 minutes ✅
```

---

👉 Must include:

- KPI (measurable)
    
- baseline vs target
    

---

🧠 3. DECISION FRAME (CRITICAL SECTION)

---

👉 This is what makes it **decision-driven**

---

### Decision Needed:

- What must stakeholders decide?
    

---

### Options:

|Option|Description|
|---|---|
|A|Full automation|
|B|Semi-automation|
|C|Manual + AI assist|

---

### Comparison:

|Criteria|A|B|C|
|---|---|---|---|
|Cost|High|Medium|Low|
|Speed|Fast|Medium|Slow|
|Risk|Medium|Low|Low|

---

👉 Output:

```text
Recommended Option: B
```

---

🧠 4. USER & BEHAVIOR IMPACT

---

👉 Connect to AI framework

---

Users:

- Who is impacted?
    

---

Behavior change:

```text
Before → After
```

Example:

```text
Manual entry → Upload XML → Auto-processed
```

---

👉 Critical:

```text
If user does NOT change behavior → project FAIL
```

---

🧠 5. PROCESS (AS-IS / TO-BE)

---

### AS-IS

- Current workflow
    
- Pain points
    

---

### TO-BE

- New flow
    
- Automation points
    

---

👉 (you can insert Mermaid later)

---

🧠 6. DATA & INPUTS

---

Input:

- XML invoice
    
- PO data
    
- Supplier info
    

---

Output:

- Summary_1.xlsx
    
- GRN data
    
- Invoice records
    

---

---

🧠 7. AI / AUTOMATION DESIGN (PPJ CONTEXT)

---

Flow:

```text
Upload → Parse XML → Validate → Generate Summary → User Confirm → Post to WFX
```

---

Tools:

- n8n
    
- OCR / XML parser
    
- WFX UI automation
    

---

---

🧠 8. METRICS (VERY IMPORTANT)

---

Measure:

- Processing time
    
- Error rate
    
- Success rate
    

---

👉 Example:

```text
Processing time < 5s per invoice
Error rate < 2%
```

---

---

🧠 9. RISK & ASSUMPTIONS

---

Risks:

- XML format mismatch
    
- WFX UI changes
    
- data inconsistency
    

---

Assumptions:

- Supplier sends valid XML
    
- PO exists
    

---

---

🧠 10. IMPLEMENTATION PLAN

---

Phases:

1. Checking (Phase 1)
    
2. GRN creation (Phase 2)
    
3. Invoice creation (Phase 3)
    

---

---

🧠 11. OPEN QUESTIONS

---

- How to handle missing PO?
    
- How to validate currency mismatch?
    
- Who approves GRN auto-creation?
    

---

---

🧠 12. FINAL DECISION SUMMARY (IMPORTANT)

---

```text
Decision: Implement Semi-Automation (Option B)

Expected Outcome:
- Reduce processing time by 80%
- Reduce manual effort
- Improve accuracy

Next Step:
- Build Phase 1 (Invoice Checking)
```

---

---

🔗 Related Concepts  
[[Decision Driven Thinking]]  
[[Outcome Driven Thinking]]  
[[AI in Business Analysis]]  
[[Process Automation]]  
[[System Thinking]]

🔧 Methods  
[[Impact Analysis]]  
[[Decision Matrix]]  
[[Five Whys]]  
[[Process Mapping]]  
[[User Journey Mapping]]

📂 Projects  
[[SmartFlow Automation]]  
[[Ex-Im Automation]]  
[[Sourcing AI]]

📎 Deliverables  
[[Decision-Driven BRD_Template]]  
[[ERD_Template]]  
[[User_Manual_Template]]  
[[Automation Design]]

---

🧠 FINAL INSIGHT

> A normal BRD describes a system  
> A decision-driven BRD drives action

---

⚡ ONE LINE

> “If no decision is made → your BRD failed”

---

